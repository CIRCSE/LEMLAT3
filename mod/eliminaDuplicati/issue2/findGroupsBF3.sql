
-- gruppi aggiuntivi non precedentemente individuati in BF2 (non noto il motivo)
-- applico procedura una seconda volta
/*
+------------+--------+-----+---------+--------------+----------+-----+-----+-----+----------------------------+
| lemma      | codlem | gen | codmorf | LiLaRef      | NoLemLat | NoB | NoO | NoD | LemLatLST                  |
+------------+--------+-----+---------+--------------+----------+-----+-----+-----+----------------------------+
| ara        | N1     | f   | NcA     | lemma/89737  |        2 |   1 |   0 |   1 | 76490(D149E),3043(a2625)   |
| bacca      | N1     | f   | NcA     | lemma/91231  |        2 |   1 |   0 |   1 | 79322(D1E78),4263(b0038)   |
| beneficium | N2     | n   | NcB     | lemma/91483  |        2 |   1 |   0 |   1 | 81017(D2202),4542(b0266)   |
| bucula     | N1     | f   | NcA     | lemma/91961  |        2 |   1 |   0 |   1 | 83588(D2A71),5043(b0707)   |
| fala       | N1     | f   | NcA     | lemma/102824 |        2 |   1 |   0 |   1 | 101290(D6127),15572(f0106) |
| genus      | N3B    | n   | NcC     | lemma/104504 |        2 |   1 |   0 |   1 | 106069(D6HB4),17205(g0213) |
| hastula    | N1     | f   | NcA     | lemma/105205 |        2 |   1 |   0 |   1 | 108424(D7715),17891(h0145) |
| palo       | V1     |     | VmF     | lemma/115735 |        2 |   1 |   0 |   1 | 123831(DA670),28114(p0147) |
| palo       | V1     |     | VmF     | lemma/120306 |        2 |   1 |   0 |   1 | 123831(DA670),28115(p4330) |
| principium | N2     | n   | NcB     | lemma/119505 |        2 |   1 |   0 |   1 | 129723(DB852),31986(p3568) |
| scandula   | N1     | f   | NcA     | lemma/123619 |        2 |   1 |   0 |   1 | 136710(DCF1D),35802(s0554) |
| sors       | N3B    | f   | NcC     | lemma/125204 |        2 |   1 |   0 |   1 | 140015(DD820),37413(s2029) |
| stella     | N1     | f   | NcA     | lemma/125625 |        2 |   1 |   0 |   1 | 141107(DDBCH),37844(s2415) |
+------------+--------+-----+---------+--------------+----------+-----+-----+-----+----------------------------+
*/

DROP TEMPORARY TABLE IF EXISTS groups;
CREATE TEMPORARY TABLE groups
SELECT lemma, codlem, gen, codmorf, LiLaRef,
       COUNT(DISTINCT id_lemma) NoLemLat,
       COUNT(DISTINCT srcB) NoB, COUNT(DISTINCT srcO) NoO, COUNT(DISTINCT srcD) NoD,
       GROUP_CONCAT( DISTINCT CONCAT(id_lemma,'(',n_id,')' ) ORDER BY n_id ) LemLatLST
FROM (
    SELECT DISTINCT id_lemma, n_id,
                    REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                    codlem, gen, codmorf,
                    COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                    IF(src='B', id_lemma, NULL) srcB, IF(src='O', id_lemma, NULL) srcO, IF(src='D', id_lemma, NULL) srcD
    FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
    WHERE src<>'F'
) T
GROUP BY lemma, codlem, gen, codmorf, LiLaRef
HAVING NoLemLat>1 AND NoB<NoLemlat
;


ALTER TABLE groups ADD KEY(lemma, codlem, gen, codmorf, LiLaRef);
ALTER TABLE groups MODIFY LemLatLST VARCHAR(256) NOT NULL;
ALTER TABLE groups ADD KEY (LemLatLST);


-- condidati non ambigui per gruppo
DROP TEMPORARY TABLE IF EXISTS keep;
CREATE TEMPORARY TABLE keep

-- un solo lemma della base: 569
SELECT lemma, codlem, gen, codmorf, LiLaRef, n_id
FROM groups g
INNER JOIN (
            SELECT id_lemma, n_id,
                   REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                   COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                   codlem, gen, codmorf, src                   
            FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
            ) lm USING (lemma, codlem, gen, codmorf, LiLaRef)
WHERE NoB=1 AND src='B'
;

-- Lemmi da accorpare ai relativi candidati
DROP TEMPORARY TABLE IF EXISTS throw;
CREATE TEMPORARY TABLE throw
SELECT lm.lemma, lm.codlem, lm.gen, lm.codmorf, lm.n_id, lm.LiLaRef
FROM groups g
INNER JOIN (
            SELECT id_lemma, n_id,
                   REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                   COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                   codlem, gen, codmorf, src                   
            FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
            WHERE src <> 'F'
           ) lm USING (lemma, codlem, gen, codmorf, LiLaRef)
LEFT JOIN keep USING(n_id)
WHERE  keep.n_id IS NULL;

ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf, LiLaRef);
ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf, LiLaRef, n_id);



INSERT IGNORE INTO deprecationMap(n_idNEW, n_idOLD, lemmata)
SELECT  K.n_id n_idNEW, T.n_id n_idOLD, GROUP_CONCAT(CONCAT_WS('_',lemma, codlem, gen, codmorf, LiLaRef)) lemmata
FROM keep K INNER JOIN throw T USING(lemma, codlem, gen, codmorf, LiLaRef)
GROUP BY K.n_id, T.n_id
;


INSERT IGNORE INTO lessarioDeprecated
SELECT *
FROM lessario WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

INSERT IGNORE INTO lemmarioDeprecated
SELECT *
FROM lemmario WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

DELETE
FROM lessario WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

DELETE LL.* 
FROM lila_db.lemlat_lila LL INNER JOIN lemmario ON lemlat_id_lemma=id_lemma
WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

DELETE
FROM lemmario WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

/* */


-- PRE: lessario 158670 | lemmario 136552

-- POST: lessario 158658 | lemmario 136540


