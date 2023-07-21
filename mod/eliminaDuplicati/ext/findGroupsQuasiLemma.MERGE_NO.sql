
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
-- ALTER TABLE groups ADD KEY (LiLaRef);
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
+------+------+------+-----+
| NoB1 | NoO1 | NoD1 | c   |
+------+------+------+-----+
| 0    | 0    | N    | 604 |
| 0    | N    | 0    |   2 |
| 1    | 0    | 1    | 292 |
| 1    | 0    | N    |  10 |
| 1    | 1    | 0    |   1 |
+------+------+------+-----+
*/
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

/* 
SELECT K.*, T.n_id Throw_n_id, T.lemma Throw_lemma, IF(A.lemma IS NULL, 'NO', 'OK') chk
FROM keep K
INNER JOIN throw T USING(codlem, gen, codmorf, LiLaRef)
LEFT  JOIN analysis A
     ON wf_input=T.lemma AND A.codlem=K.codlem AND  A.n_id=K.n_id AND A.gen=K.gen AND A.codmorf=K.codmorf
WHERE A.lemma IS NULL     
;
/* */
/* */
DROP TEMPORARY TABLE IF EXISTS deprMap;
CREATE TEMPORARY TABLE deprMap
SELECT  K.n_id n_idNEW, T.n_id n_idOLD, GROUP_CONCAT(DISTINCT CONCAT_WS('_',T.lemma, T.codlem, T.gen, T.codmorf, LiLaRef)) lemmata
FROM keep K
INNER JOIN throw T USING(codlem, gen, codmorf, LiLaRef)
LEFT  JOIN analysis A
     ON wf_input=T.lemma AND A.codlem=K.codlem AND  A.n_id=K.n_id AND A.gen=K.gen AND A.codmorf=K.codmorf
WHERE A.lemma IS NULL     
GROUP BY K.n_id, T.n_id
;

-- ====== CONTROLLI PRIMA DI MERGE. ========
--     ipotesi:
--             - una sola rige nel lessario
--             - coppia les, codles non già presenti nella clem

/*
SELECT n_idOLD, COUNT(*) c FROM deprMap INNER JOIN lessario ON n_id=n_idOLD GROUP BY n_idOLD HAVING c>1;
+---------+---+
| n_idOLD | c |
+---------+---+
| D6BBH   | 2 |
+---------+---+

SELECT * FROM lessario WHERE n_id='D6BBH';
+-------+-----+------+----+-----+-----+-------------+--------+-------+-------+-----+--------+------+-------+----+-------+-------+-------+--------+---------------------+-----+
| n_id  | gen | clem | si | smv | spf | les         | codles | lem   | s_omo | piu | codlem | type | codLE | pt | a_gra | gra_u | notes | pr_key | ts                  | src |
+-------+-----+------+----+-----+-----+-------------+--------+-------+-------+-----+--------+------+-------+----+-------+-------+-------+--------+---------------------+-----+
| D6BBH |     | v    |    | +   |     | fringul     | v4r    | -irre |       |     |        |      |       |    |       |       | NULL  | 170212 | 2018-07-30 16:21:07 | D   |
| D6BBH |     |      |    |     |     | fringulirre | fe     |       |       |     |        |      |       |    |       |       | NULL  | 170213 | 2018-07-24 18:16:39 | D   |
+-------+-----+------+----+-----+-----+-------------+--------+-------+-------+-----+--------+------+-------+----+-------+-------+-------+--------+---------------------+-----+

SELECT * FROM deprMap WHERE n_idOLD='D6BBH';
+---------+---------+----------------------------------+
| n_idNEW | n_idOLD | lemmata                          |
+---------+---------+----------------------------------+
| f1010   | D6BBH   | fringulirre_V4__VmL_lemma/103821 |
+---------+---------+----------------------------------+

FIX:
In questo caso, va portata nella clem della B [SOLO] la riga della clem del D con pr_key=‘170213’.

*/

-- COPPIA les,codles già presente
/* 
SELECT deprMap.*
FROM deprMap INNER JOIN lessario L1 ON L1.n_id=n_idOLD
LEFT JOIN lessario L2 ON n_idNEW=L2.n_id AND L1.les=L2.les AND L1.codles=L2.codles
WHERE L2.les IS NOT NULL;
/*
+---------+---------+-----------------------------+
| n_idNEW | n_idOLD | lemmata                     |
+---------+---------+-----------------------------+
| 35723   | 35730   | gigas_N3B_m_NpC_lemma/8113  |
| D4F9G   | D4FA7   | degre_N1_f_NcA_lemma/46461  |
| D8F20   | D8F28   | ludix_N3B_f_NcC_lemma/62823 | ===> FIX: BUGFIX_lila2.sql
+---------+---------+-----------------------------+

#gigas
riga della clem da tenere con pr_key='90473': cambiare lem='gigas' -> lem ='gigas/gigans'

#degre
riga della clem da tenere con pr_key='161838': cambiare lem='-ae' -> lem ='-ae/-e'

*/

-- aggiunta di 'v' in campo clem in caso di aggiunta
UPDATE lessario INNER JOIN (
    SELECT n_id, COUNT(*) c
    FROM lessario WHERE n_id IN (
        SELECT n_idNEW
        FROM deprMap INNER JOIN lessario L1 ON L1.n_id=n_idOLD
        LEFT JOIN lessario L2 ON n_idNEW=L2.n_id AND L1.les=L2.les AND L1.codles=L2.codles
        WHERE L2.les IS NULL AND n_idOLD<>'D6BBH'
    )
    GROUP BY n_id
    HAVING c=1
) V1 USING(n_id)
SET clem='v' 
;

-- ecc.
UPDATE lessario SET lem ='gigas/gigans' WHERE pr_key='90473';
UPDATE lessario SET lem ='-ae/-e'       WHERE pr_key='161838';

-- INSERIMENTO NUOVI LES
INSERT INTO lessario( n_id,gen,clem,si,smv,spf,les,codles,lem, piu,codlem,type,codLE,pt,a_gra,gra_u, src)
SELECT n_idNEW,
L1.gen, L1.clem, L1.si, L1.smv, L1.spf, L1.les, L1.codles,
L1.lem, L1.piu, L1.codlem, L1.type, L1.codLE, L1.pt, L1.a_gra, L1.gra_u, L1.src
FROM deprMap INNER JOIN lessario L1 ON L1.n_id=n_idOLD
LEFT JOIN lessario L2 ON n_idNEW=L2.n_id AND L1.les=L2.les AND L1.codles=L2.codles
WHERE L2.les IS NULL AND n_idOLD<>'D6BBH'
;

INSERT INTO lessario( n_id,gen,clem,si,smv,spf,les,codles,lem, piu,codlem,type,codLE,pt,a_gra,gra_u, src)
SELECT 'f1010',
L1.gen, L1.clem, L1.si, L1.smv, L1.spf, L1.les, L1.codles,
L1.lem, L1.piu, L1.codlem, L1.type, L1.codLE, L1.pt, L1.a_gra, L1.gra_u, L1.src
FROM  lessario L1 WHERE pr_key=170213;

INSERT IGNORE INTO deprecationMap(n_idNEW, n_idOLD, lemmata)
SELECT n_idNEW, n_idOLD, lemmata FROM deprMap;

INSERT IGNORE INTO lessarioDeprecated
SELECT *
FROM lessario WHERE n_id IN( SELECT DISTINCT n_idOLD FROM deprMap);

INSERT IGNORE INTO lemmarioDeprecated
SELECT *
FROM lemmario WHERE n_id IN( SELECT DISTINCT n_idOLD FROM deprMap);

DELETE
FROM lessario WHERE n_id IN( SELECT DISTINCT n_idOLD FROM deprMap);

DELETE LL.* 
FROM lila_db.lemlat_lila LL INNER JOIN lemmario ON lemlat_id_lemma=id_lemma
WHERE n_id IN( SELECT DISTINCT n_idOLD FROM deprMap);

DELETE
FROM lemmario WHERE n_id IN( SELECT DISTINCT n_idOLD FROM deprMap );

