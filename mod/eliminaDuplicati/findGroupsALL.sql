
/* */
-- individuazione dei gruppi senza condizioni (solo corrispondenza ad un unica entrate lila)
DROP TEMPORARY TABLE IF EXISTS groupsUnCond;
CREATE TEMPORARY TABLE groupsUnCond
SELECT LiLaRef,
       COUNT(DISTINCT id_lemma) NoLemLat,
       COUNT(DISTINCT srcB) NoB, COUNT(DISTINCT srcO) NoO, COUNT(DISTINCT srcD) NoD,
       GROUP_CONCAT( DISTINCT CONCAT(id_lemma,'(',n_id,')' ) ORDER BY n_id ) LemLatLST,
       COUNT( DISTINCT lemma) NoL, GROUP_CONCAT( DISTINCT lemma  ) lemmaLST,
       COUNT( DISTINCT codlem) NoCL, GROUP_CONCAT( DISTINCT codlem  ) codlemLST,
       COUNT( DISTINCT gen) NoG, GROUP_CONCAT( DISTINCT gen  ) genLST,
       COUNT( DISTINCT codmorf) NoCM, GROUP_CONCAT( DISTINCT codmorf  ) codmorfLST       
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
GROUP BY LiLaRef
HAVING NoLemLat>1 AND NoB<NoLemlat
;


ALTER TABLE groupsUnCond MODIFY LemLatLST VARCHAR(256) NOT NULL;
ALTER TABLE groupsUnCond ADD KEY (LemLatLST);
/* */

/* 

-- Distribuzione gruppi per difformità:
SELECT CASE WHEN NoL=0 THEN '0' WHEN NoL=1 THEN '1' WHEN NoL>1 THEN 'N' END NoL1,
       CASE WHEN NoCL=0 THEN '0' WHEN NoCL=1 THEN '1' WHEN NoCL>1 THEN 'N' END NoCL1,
       CASE WHEN NoG=0 THEN '0' WHEN NoG=1 THEN '1' WHEN NoG>1 THEN 'N' END NoG1,
       CASE WHEN NoCM=0 THEN '0' WHEN NoCM=1 THEN '1' WHEN NoCM>1 THEN 'N' END NoCM1,
       COUNT(*) N
FROM groupsUnCond G LEFT JOIN groups USING(LemLatLST)
WHERE groups.LiLaRef IS NULL
GROUP BY NoL1, NoCL1, NoG1, NoCM1
ORDER BY N DESC;

/*
+------+-------+------+-------+------+
| NoL1 | NoCL1 | NoG1 | NoCM1 | N    |
+------+-------+------+-------+------+
| N    | 1     | 1    | 1     | 2177 |
| 1    | 1     | N    | 1     |  144 |
| N    | 1     | N    | 1     |   87 |
| 1    | 1     | 1    | N     |   20 |
| 1    | N     | 1    | N     |   12 |
| 1    | N     | N    | N     |    8 |
| 1    | N     | 1    | 1     |    2 |
| N    | 1     | 1    | N     |    2 |
| N    | 1     | N    | N     |    1 |
| N    | N     | 1    | N     |    1 |
+------+-------+------+-------+------+
POST:
+------+-------+------+-------+------+
| NoL1 | NoCL1 | NoG1 | NoCM1 | N    |
+------+-------+------+-------+------+
| N    | 1     | 1    | 1     | 2066 |
| 1    | 1     | N    | 1     |  144 |
| N    | 1     | N    | 1     |   87 |
| 1    | 1     | 1    | N     |   20 |
| 1    | N     | 1    | N     |   13 |
| 1    | N     | N    | N     |    8 |
| 1    | N     | 1    | 1     |    2 |
| N    | 1     | 1    | N     |    2 |
| N    | 1     | N    | N     |    1 |
+------+-------+------+-------+------+

*/
/* 
-- gruppi con match imperfetto per il solo lemma
SELECT LiLaRef, LemLatLST, lemmaLST FROM groupsUnCond G LEFT JOIN groups USING(LiLaRef,LemLatLST)
WHERE groups.LiLaRef IS NULL AND G.NoL>1  AND G.NoCL=1 AND G.NoG=1 AND G.NoCM=1;
/* */
/* */
-- gruppi difformi rimanenti
SELECT LiLaRef, LemLatLST, lemmaLST, codlemLST, genLST, codmorfLST FROM groupsUnCond G LEFT JOIN groups USING(LiLaRef,LemLatLST)
WHERE groups.LiLaRef IS NULL AND NOT( G.NoL>1  AND G.NoCL=1 AND G.NoG=1 AND G.NoCM=1);
/* */
