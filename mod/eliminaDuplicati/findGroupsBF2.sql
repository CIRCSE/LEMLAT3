
-- gruppi aggiuntivi non precedentemente individuati:
--  a) ulteriore normalizzazione del lemma: quantità delle vocali
-- Errato raggruppamento: è necessario usare il riferimento a LiLa
--                        per evitare l'esclusione dei gruppi ( lemma, codlem, gen, codmorf)
--                        che corrispondo a a due o più lilaRef
-- TODO: verificare se l'entrata doppia in LiLa è giustificata

DROP TEMPORARY TABLE IF EXISTS groups;
CREATE TEMPORARY TABLE groups
SELECT lemma, codlem, gen, codmorf, LiLaRef,
       COUNT(DISTINCT id_lemma) NoLemLat,
       COUNT(DISTINCT srcB) NoB, COUNT(DISTINCT srcO) NoO, COUNT(DISTINCT srcD) NoD,
       GROUP_CONCAT( DISTINCT CONCAT(id_lemma,'(',n_id,')' ) ORDER BY n_id ) LemLatLST
FROM (
    SELECT DISTINCT id_lemma, n_id,
--                    SUBSTRING_INDEX(lemma,'/', 1) lemma,
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


-- TOTALE gruppi aggiuntivi:  525 - POST: 601
-- dirtibuzione dei gruppi per sorgenti
/* 
SELECT CASE WHEN NoB=0 THEN '0' WHEN NoB=1 THEN '1' WHEN NoB>1 THEN 'N' END NoB1,
       CASE WHEN NoO=0 THEN '0' WHEN NoO=1 THEN '1' WHEN NoO>1 THEN 'N' END NoO1,
       CASE WHEN NoD=0 THEN '0' WHEN NoD=1 THEN '1' WHEN NoD>1 THEN 'N' END NoD1,
       COUNT(*) c
FROM groups
GROUP BY NoB1, NoO1, NoD1;
/*
+------+------+------+-----+
| NoB1 | NoO1 | NoD1 | c   |
+------+------+------+-----+
| 0    | 0    | N    |  66 |
| 0    | 1    | 1    |   3 |
| 0    | 1    | N    |   1 |
| 0    | N    | 0    |   2 |
| 1    | 0    | 1    | 327 |
| 1    | 0    | N    | 121 |
| 1    | 1    | 0    |   5 |
+------+------+------+-----+
POST normalizzazione 
+------+------+------+-----+
| NoB1 | NoO1 | NoD1 | c   |
+------+------+------+-----+
| 0    | 0    | N    |  26 |
| 0    | 1    | 1    |   3 |
| 0    | 1    | N    |   1 |
| 0    | N    | 0    |   2 |
| 1    | 0    | 1    | 400 |
| 1    | 0    | N    | 161 |
| 1    | 1    | 0    |   8 |
+------+------+------+-----+
*/

ALTER TABLE groups ADD KEY(lemma, codlem, gen, codmorf, LiLaRef);
ALTER TABLE groups MODIFY LemLatLST VARCHAR(256) NOT NULL;
ALTER TABLE groups ADD KEY (LemLatLST);

/* 
-- gruppi aggiuntivi
SELECT lemma, codlem, gen, codmorf, LiLaRef, LemLatLST  FROM groups;
/* */

/*  */
-- riferimenti nel derivational_db  (lemmi ducange e ono, eventualemte da eliminare)
DROP TEMPORARY TABLE IF EXISTS refWfr;
CREATE TEMPORARY TABLE refWfr
SELECT DISTINCT o_n_id n_id
FROM derivational_db.wfr2_all
WHERE o_id_lemma IN (SELECT id_lemma FROM lemlat_db.lemmario WHERE src IN('O','D'))
UNION
SELECT i_n_id n_id
FROM derivational_db.wfr2_all
WHERE i_id_lemma IN (SELECT id_lemma FROM lemlat_db.lemmario WHERE src IN('O','D'));

ALTER TABLE refWfr ADD UNIQUE KEY(n_id);
/* */
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
UNION
-- un solo lemma dell'onomasticon: 4
SELECT lemma, codlem, gen, codmorf, LiLaRef, n_id
FROM groups g
INNER JOIN (
            SELECT id_lemma, n_id,
                   REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                   COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                   codlem, gen, codmorf, src                   
            FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
            ) lm USING (lemma, codlem, gen, codmorf, LiLaRef)
WHERE NoB=0 AND NoO=1 AND src='O'
UNION
-- solo lemmi Onomasticon - Ducange(derivati):
SELECT lemma, codlem, gen, codmorf, LiLaRef, n_id
FROM groups g
INNER JOIN (
            SELECT id_lemma, n_id,
                   REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                   COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                   codlem, gen, codmorf, src                   
            FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
            ) lm USING (lemma, codlem, gen, codmorf, LiLaRef)
INNER JOIN refWfr USING(n_id)            
WHERE NoB=0 AND NoO>1 AND src='O' OR NoB=0 AND NoO=0  AND NoD>1 AND src='D'
;

INSERT INTO keep
-- solo lemmi Onomasticon - Ducange (NON derivati): 23
SELECT lemma, codlem, gen, codmorf, LiLaRef, MIN(lm.n_id) n_id
FROM groups g
INNER JOIN (
            SELECT id_lemma, n_id,
                   REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                   COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                   codlem, gen, codmorf, src                   
            FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
            ) lm USING (lemma, codlem, gen, codmorf, LiLaRef)
LEFT JOIN keep K USING (lemma, codlem, gen, codmorf, LiLaRef)          
WHERE (NoB=0 AND NoO>1 AND src='O' OR NoB=0 AND NoO=0  AND NoD>1 AND src='D') AND K.n_id IS NULL
GROUP BY lemma, codlem, gen, codmorf, LiLaRef
;

ALTER TABLE keep ADD KEY(lemma, codlem, gen, codmorf);
ALTER TABLE keep ADD KEY(n_id);

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


/* 

DROP TEMPORARY TABLE IF EXISTS checkMerge;
CREATE TEMPORARY TABLE checkMerge

   SELECT DISTINCT t.lemma, t.codlem, t.gen, t.codmorf, t.LiLaRef, t.n_id
   FROM (
        SELECT T.*,
               ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM throw T INNER JOIN lessario ls USING(n_id)
    ) t LEFT JOIN (
        SELECT K.*,
        ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM keep K INNER JOIN lessario ls USING(n_id)
    ) k ON k.lemma=t.lemma AND k.codlem=t.codlem AND k.gen=t.gen AND k.codmorf=t.codmorf AND k.LiLaRef=t.LiLaRef
              AND k.codlem =t.codlem
              AND k.ls_gen=t.ls_gen
              -- AND k.clem=t.clem 
              AND k.si=t.si
              AND k.smv=t.smv
              AND k.spf=t.spf
              AND k.les=t.les
              AND k.codles=t.codles
              AND  REPLACE( REPLACE(SUBSTRING_INDEX(k.lem,'/', 1),"'",""), '"','') = REPLACE( REPLACE(SUBSTRING_INDEX(t.lem,'/', 1),"'",""), '"','')
              AND k.ls_codlem=t.ls_codlem
              AND k.type=t.type
              AND k.codLE=t.codLE
              AND k.pt=t.pt
              AND k.a_gra=t.a_gra 
              AND k.gra_u=t.gra_u
    WHERE k.lemma IS NULL
;
*/

-- Merge: CHECK
/*  
SELECT lemma lemmaNorm, codlem, gen, codmorf, K.n_id keep, LiLaRef, GROUP_CONCAT(DISTINCT T.n_id) throwLst
FROM checkMerge I INNER JOIN groups G USING(lemma, codlem, gen, codmorf, LiLaRef)
INNER JOIN keep K USING(lemma, codlem, gen, codmorf, LiLaRef)
INNER JOIN throw T USING(lemma, codlem, gen, codmorf, LiLaRef)
GROUP BY lemma, codlem, gen, codmorf, LiLaRef, K.n_id
;
/* */
-- Merge: OK
/*
SELECT lemma lemmaNorm, codlem, gen, codmorf, K.n_id keep, LiLaRef, GROUP_CONCAT(DISTINCT T.n_id) throwLst
FROM groups G 
INNER JOIN keep K USING(lemma, codlem, gen, codmorf, LiLaRef)
INNER JOIN throw T USING(lemma, codlem, gen, codmorf, LiLaRef)
LEFT JOIN checkMerge I USING(lemma, codlem, gen, codmorf, LiLaRef)
WHERE I.lemma IS NULL
GROUP BY lemma, codlem, gen, codmorf, LiLaRef, K.n_id
;
*/

/* */
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

-- PRE: lessario 159369 | lemmario 137200

-- POST: lessario 158670 | lemmario 136552


