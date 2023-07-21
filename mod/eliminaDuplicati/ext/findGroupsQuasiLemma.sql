
DROP TEMPORARY TABLE IF EXISTS groupsUnCond;
CREATE TEMPORARY TABLE groupsUnCond
SELECT LiLaRef,
       COUNT(DISTINCT id_lemma) NoLemLat,
       COUNT(DISTINCT srcB) NoB, COUNT(DISTINCT srcO) NoO, COUNT(DISTINCT srcD) NoD,
       -- GROUP_CONCAT( DISTINCT CONCAT(id_lemma,'(',n_id,')' ) ORDER BY n_id ) LemLatLST,
       COUNT( DISTINCT lemma) NoL, -- GROUP_CONCAT( DISTINCT lemma  ) lemmaLST,
       COUNT( DISTINCT codlem) NoCL, -- GROUP_CONCAT( DISTINCT codlem  ) codlemLST,
       COUNT( DISTINCT gen) NoG, -- GROUP_CONCAT( DISTINCT gen  ) genLST,
       COUNT( DISTINCT codmorf) NoCM -- , GROUP_CONCAT( DISTINCT codmorf  ) codmorfLST       
FROM (
    SELECT DISTINCT id_lemma, n_id,
                    REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                    codlem, gen, codmorf,
                    COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                    IF(src='B', id_lemma, NULL) srcB, IF(src='O', id_lemma, NULL) srcO, IF(src='D', id_lemma, NULL) srcD
    FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
    WHERE src<>'F'
) T
GROUP BY LiLaRef
HAVING NoLemLat>1 AND NoB<NoLemlat AND NoL>1  AND NoCL=1 AND NoG=1 AND NoCM=1
;

/* */
-- individuazione dei gruppi senza condizioni (solo corrispondenza ad un unica entrate lila)
DROP TEMPORARY TABLE IF EXISTS groups;
CREATE TEMPORARY TABLE groups
SELECT LiLaRef, codlem, gen, codmorf,
       COUNT(DISTINCT id_lemma) NoLemLat,
       COUNT(DISTINCT srcB) NoB, COUNT(DISTINCT srcO) NoO, COUNT(DISTINCT srcD) NoD,
       GROUP_CONCAT( DISTINCT CONCAT(id_lemma,'(',n_id,')' ) ORDER BY n_id ) LemLatLST,
       COUNT( DISTINCT lemma) NoL, GROUP_CONCAT( DISTINCT lemma  ) lemmaLST
FROM (
    SELECT DISTINCT id_lemma, n_id,
                    REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                    codlem, gen, codmorf,
                    COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                    IF(src='B', id_lemma, NULL) srcB, IF(src='O', id_lemma, NULL) srcO, IF(src='D', id_lemma, NULL) srcD
    FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
    WHERE src<>'F'
) T
WHERE LiLaRef IN (SELECT LiLaRef FROM groupsUnCond )
GROUP BY LiLaRef, codlem, gen, codmorf
HAVING NoLemLat>1 AND NoB<NoLemlat
;


ALTER TABLE groups MODIFY LiLaRef VARCHAR(256) NOT NULL;
ALTER TABLE groups ADD KEY (LiLaRef);
/* */

/* 
-- gruppi con match imperfetto per il solo lemma
SELECT LiLaRef, LemLatLST, lemmaLST FROM groups;
/* */
/* 
SELECT CASE WHEN NoB=0 THEN '0' WHEN NoB=1 THEN '1' WHEN NoB>1 THEN 'N' END NoB1,
       CASE WHEN NoO=0 THEN '0' WHEN NoO=1 THEN '1' WHEN NoO>1 THEN 'N' END NoO1,
       CASE WHEN NoD=0 THEN '0' WHEN NoD=1 THEN '1' WHEN NoD>1 THEN 'N' END NoD1,
       COUNT(*) c
FROM groups
GROUP BY NoB1, NoO1, NoD1;

/*
+------+------+------+------+
| NoB1 | NoO1 | NoD1 | c    |
+------+------+------+------+
| 0    | 0    | N    |  605 |
| 0    | N    | 0    |    2 |
| 1    | 0    | 1    | 1313 |
| 1    | 0    | N    |  113 |
| 1    | 1    | 0    |   10 |
| N    | 0    | 1    |    3 | <= rivedere a mano
+------+------+------+------+
--                     2046
*/
/*
SELECT * FROM groups WHERE NoB>1;
+--------------+--------+-----+---------+----------+-----+-----+-----+----------------------------------------------------+-----+------------------------+
| LiLaRef      | codlem | gen | codmorf | NoLemLat | NoB | NoO | NoD | LemLatLST                                          | NoL | lemmaLST               |
+--------------+--------+-----+---------+----------+-----+-----+-----+----------------------------------------------------+-----+------------------------+
| lemma/120402 | V1     |     | VmF     |        3 |   2 |   0 |   1 | 130669(DBB9A),32928(p4418),32926(p4418)            |   3 | pugillo,pugilo,pugilor |
| lemma/87112  | V3     |     | VmH     |        3 |   2 |   0 |   1 | 70976(D0286),282(a0268),320(a0268)                 |   3 | accado,accedo,accido   |
| lemma/97341  | V1     |     | VmF     |        4 |   3 |   0 |   1 | 93617(D47F7),10549(c4706),33592(c4706),9858(c4706) |   4 | coro,couro,curo,quro   |
+--------------+--------+-----+---------+----------+-----+-----+-----+----------------------------------------------------+-----+------------------------+
*/
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

SELECT codlem, gen, codmorf, LiLaRef, n_id, lemma
FROM groups g
INNER JOIN (
            SELECT id_lemma, n_id,
                   REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                   COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                   codlem, gen, codmorf, src                   
            FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
            ) lm USING (codlem, gen, codmorf, LiLaRef)
WHERE NoB=1 AND src='B'
UNION
-- solo lemmi Onomasticon - Ducange(derivati):
SELECT codlem, gen, codmorf, LiLaRef, n_id, lemma 
FROM groups g
INNER JOIN (
            SELECT id_lemma, n_id,
                   REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                   COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                   codlem, gen, codmorf, src                   
            FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
            ) lm USING (codlem, gen, codmorf, LiLaRef)
INNER JOIN refWfr USING(n_id)            
WHERE NoB=0 AND NoO>1 AND src='O' OR NoB=0 AND NoO=0  AND NoD>1 AND src='D'
;

INSERT INTO keep
-- solo lemmi Onomasticon - Ducange (NON derivati):
SELECT codlem, gen, codmorf, LiLaRef, n_id, lemma
FROM
(
    SELECT codlem, gen, codmorf, LiLaRef, MIN(lm.n_id) n_id
    FROM groups g
    INNER JOIN (
                SELECT id_lemma, n_id,
                       REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                       COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                       codlem, gen, codmorf, src                   
                FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
                ) lm USING (codlem, gen, codmorf, LiLaRef)
    LEFT JOIN keep K USING ( codlem, gen, codmorf, LiLaRef)          
    WHERE (NoB=0 AND NoO>1 AND src='O' OR NoB=0 AND NoO=0  AND NoD>1 AND src='D') AND K.n_id IS NULL
    GROUP BY codlem, gen, codmorf, LiLaRef
) S INNER JOIN (
    SELECT DISTINCT n_id,
           REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
           COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
           codlem, gen, codmorf, src                   
    FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
) L USING( n_id, LiLaRef, codlem, gen, codmorf)
;

ALTER TABLE keep ADD KEY(codlem, gen, codmorf, LiLaRef);
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
           ) lm USING (codlem, gen, codmorf, LiLaRef)
LEFT JOIN keep USING(n_id)
WHERE  keep.n_id IS NULL;

ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf, LiLaRef);
ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf, LiLaRef, n_id);

-- CHECK lemmata:
-- SELECT DISTINCT lemma FROM throw;

-- verifica copertura lemmi 
DROP TEMPORARY TABLE IF EXISTS analysis;

CREATE TEMPORARY TABLE analysis (
  wf_input char(30) NOT NULL DEFAULT '',
  wf_analyzed char(30) NOT NULL DEFAULT '',
  lemma char(30) NOT NULL DEFAULT '',
  codmorf char(3) NOT NULL DEFAULT '',
  codlem char(5) NOT NULL DEFAULT '',
  gen char(1) NOT NULL DEFAULT '',
  n_id char(5) BINARY NOT NULL DEFAULT ''
);


LOAD DATA LOCAL INFILE 'delCandidates.out.csv' 
INTO TABLE analysis
FIELDS TERMINATED BY ',' 
( wf_input, wf_analyzed, lemma, codlem, n_id, gen, codmorf );


ALTER TABLE analysis 
ADD  KEY (`wf_input`),
ADD  KEY (`lemma`),
ADD KEY (`codlem`),
ADD  KEY (`n_id`),
ADD  KEY (`codmorf`),
ADD  KEY (`gen`);

UPDATE analysis SET lemma=REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','');

SELECT K.*, T.n_id Throw_n_id, T.lemma Throw_lemma, IF(A.lemma IS NULL, 'NO', 'OK') chk
FROM keep K
INNER JOIN throw T USING(codlem, gen, codmorf, LiLaRef)
LEFT JOIN analysis A
--     ON wf_input=T.lemma AND A.lemma=K.lemma AND A.codlem=K.codlem AND  A.n_id=K.n_id AND A.gen=K.gen AND A.codmorf=K.codmorf
--     ON wf_input=T.lemma AND A.lemma IN(K.lemma, T.lemma) AND A.codlem=K.codlem AND  A.n_id=K.n_id AND A.gen=K.gen AND A.codmorf=K.codmorf
--  NON CI SO SONO differenze con l'esclusione totale del lemma
     ON wf_input=T.lemma AND A.codlem=K.codlem AND  A.n_id=K.n_id AND A.gen=K.gen AND A.codmorf=K.codmorf
;

