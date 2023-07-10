
-- gruppi aggiuntivi non precedentemente individuati:
--  a) mancata normalizzazione del lemma
--  b) non contenenti lemmi di ducange (solo onmasticon) 
DROP TEMPORARY TABLE IF EXISTS groups;
CREATE TEMPORARY TABLE groups
SELECT lemma, codlem, gen, codmorf,
       COUNT(*) NoLemLat, COUNT(DISTINCT IF(lila_id_ipolemma IS NULL, lila_id_lemma, NULL)) NoLiLaL,
       COUNT(DISTINCT lila_id_ipolemma) NoLiLaH,
       SUM(src='B') NoB,SUM(src='O') NoO, SUM(src='D') NoD,
       GROUP_CONCAT( CONCAT(id_lemma,'(',n_id,')' ) ) LemLatLST,
       GROUP_CONCAT( DISTINCT COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma))) LiLaLST
-- Normalizzazione del lemma:
FROM (SELECT id_lemma, n_id, SUBSTRING_INDEX(lemma,'/', 1) lemma, codlem, gen, codmorf, src FROM lemmario ) L
      LEFT JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
WHERE src<>'F'
GROUP BY lemma, codlem, gen, codmorf

-- HAVING (NoD=1 AND NoLemLat>1 OR NoD>1) AND NoLiLaH+NoLiLaL=1   -- duccange
-- HAVING (NoO=1 AND NoLemLat>1 OR NoO>1) AND NoLiLaH+NoLiLaL=1   -- onomasticon
HAVING NoLemLat>1 AND NoB<>NoLemlat AND NoLiLaH+NoLiLaL=1  -- tutti
;

-- SELECT NoB, NoO, NoD, COUNT(*) c FROM groups GROUP BY NoB, NoO, NoD
/*
+------+------+------+-----+
| NoB  | NoO  | NoD  | c   |
+------+------+------+-----+
|    0 |    2 |    0 | 221 |
|    1 |    0 |    1 | 110 |
|    1 |    1 |    0 | 235 |
|    1 |    2 |    0 |   2 |
+------+------+------+-----+
*/

ALTER TABLE groups ADD KEY(lemma, codlem, gen, codmorf);




DROP TEMPORARY TABLE IF EXISTS refWfr;
CREATE TEMPORARY TABLE refWfr
SELECT DISTINCT SUBSTRING_INDEX(o_lemma,'/', 1) lemma, o_codlem codlem, o_gen gen, o_codmorf codmorf, o_n_id n_id
FROM derivational_db.wfr2_all
WHERE o_id_lemma IN (SELECT id_lemma FROM lemlat_db.lemmario WHERE src='O')
UNION
SELECT DISTINCT SUBSTRING_INDEX(i_lemma,'/', 1) lemma, i_codlem codlem, i_gen gen, i_codmorf codmorf, i_n_id n_id
FROM derivational_db.wfr2_all
WHERE i_id_lemma IN (SELECT id_lemma FROM lemlat_db.lemmario WHERE src='O');

ALTER TABLE refWfr ADD KEY(lemma, codlem, gen, codmorf);
ALTER TABLE refWfr ADD UNIQUE KEY(n_id);

-- condidati non ambigui per gruppo
DROP TEMPORARY TABLE IF EXISTS keep;
CREATE TEMPORARY TABLE keep
-- un solo lemma della base: 347
SELECT lemma, codlem, gen, codmorf, n_id
FROM groups g
INNER JOIN (SELECT id_lemma, n_id, SUBSTRING_INDEX(lemma,'/', 1) lemma, codlem, gen, codmorf, src FROM lemmario ) lm USING (lemma, codlem, gen, codmorf)
WHERE NoB=1 AND src='B'
UNION
-- solo lemmi Onomasticon (derivati): 6
SELECT lemma, codlem, gen, codmorf, MIN(n_id) n_id -- , COUNT(DISTINCT n_id) c
FROM groups g
INNER JOIN refWfr D  USING (lemma, codlem, gen, codmorf)
WHERE NoB=0 AND NoO>1 
GROUP BY lemma, codlem, gen, codmorf
UNION 
-- solo lemmi Onomasticon (NON derivati): 215
SELECT lemma, codlem, gen, codmorf, MIN(lm.n_id) n_id
FROM groups g
INNER JOIN (SELECT id_lemma, n_id, SUBSTRING_INDEX(lemma,'/', 1) lemma, codlem, gen, codmorf, src FROM lemmario ) lm USING (lemma, codlem, gen, codmorf)
LEFT JOIN refWfr D  USING (lemma, codlem, gen, codmorf)
WHERE NoB=0 AND NoO>1 AND lm.src<>'F' AND D.lemma IS NULL
GROUP BY lemma, codlem, gen, codmorf
;

ALTER TABLE keep ADD KEY(lemma, codlem, gen, codmorf);
ALTER TABLE keep ADD KEY(n_id);


-- Lemmi da accorpare ai relativi candidati
DROP TEMPORARY TABLE IF EXISTS throw;
CREATE TEMPORARY TABLE throw
SELECT lm.lemma, lm.codlem, lm.gen, lm.codmorf, lm.n_id
FROM groups g
INNER JOIN (SELECT id_lemma, n_id, SUBSTRING_INDEX(lemma,'/', 1) lemma, codlem, gen, codmorf, src FROM lemmario) lm USING (lemma, codlem, gen, codmorf)
LEFT JOIN keep USING(n_id)
WHERE /*(NoB=1 OR NoB=0 AND NoO=1 OR NoB=0 AND NoO=0 ) AND*/ lm.src<>'F' AND keep.n_id IS NULL;

ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf);
ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf, n_id);



DROP TEMPORARY TABLE IF EXISTS checkMerge;
CREATE TEMPORARY TABLE checkMerge

   SELECT DISTINCT t.lemma, t.codlem, t.gen, t.codmorf, t.n_id
   FROM (
        SELECT T.*,
               ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM throw T INNER JOIN lessario ls USING(n_id)
    ) t LEFT JOIN (
        SELECT K.*,
        ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM keep K INNER JOIN lessario ls USING(n_id)
    ) k ON k.lemma=t.lemma AND k.codlem=t.codlem AND k.gen=t.gen AND k.codmorf=t.codmorf
              AND k.codlem =t.codlem
              AND k.ls_gen=t.ls_gen
              -- AND k.clem=t.clem 
              AND k.si=t.si
              AND k.smv=t.smv
              AND k.spf=t.spf
              AND k.les=t.les
              AND k.codles=t.codles
              AND  SUBSTRING_INDEX(k.lem,'/', 1) = SUBSTRING_INDEX(t.lem,'/', 1) -- k.lem=t.lem
              AND k.ls_codlem=t.ls_codlem
              AND k.type=t.type
              AND k.codLE=t.codLE
              AND k.pt=t.pt
              AND k.a_gra=t.a_gra 
              AND k.gra_u=t.gra_u
    WHERE k.lemma IS NULL
;

-- checkMerge
/* 
SELECT lemma, codlem, gen, codmorf, K.n_id keep, GROUP_CONCAT(T.n_id) throwLst
FROM checkMerge I INNER JOIN groups G USING(lemma, codlem, gen, codmorf)
INNER JOIN keep K USING(lemma, codlem, gen, codmorf)
INNER JOIN throw T USING(lemma, codlem, gen, codmorf)
GROUP BY lemma, codlem, gen, codmorf, K.n_id
;
/* */

INSERT INTO deprecationMap(n_idNEW, n_idOLD, lemmata)
SELECT  K.n_id n_idNEW, T.n_id n_idOLD, GROUP_CONCAT(CONCAT_WS('_',lemma, codlem, gen, codmorf)) lemmata
FROM keep K INNER JOIN throw T USING(lemma, codlem, gen, codmorf)
GROUP BY K.n_id, T.n_id
;


INSERT INTO lessarioDeprecated
SELECT *
FROM lessario WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

INSERT INTO lemmarioDeprecated
SELECT *
FROM lemmario WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

DELETE
FROM lessario WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

DELETE LL.* 
FROM lila_db.lemlat_lila LL INNER JOIN lemmario ON lemlat_id_lemma=id_lemma
WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

DELETE
FROM lemmario WHERE n_id IN( SELECT DISTINCT n_id FROM throw);

