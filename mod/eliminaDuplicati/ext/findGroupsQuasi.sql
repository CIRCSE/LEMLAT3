
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
FROM groupsUnCond G
GROUP BY NoL1, NoCL1, NoG1, NoCM1
ORDER BY N DESC;

/*
+------+-------+------+-------+------+
| NoL1 | NoCL1 | NoG1 | NoCM1 | N    |
+------+-------+------+-------+------+
| N    | 1     | 1    | 1     | 2046 | => groupsQuasi.soloLemma.tsv +....
| 1    | 1     | N    | 1     |  142 | => groupsQuasi.soloGen.tsv
| N    | 1     | N    | 1     |   87 | => groupsQuasi.LemmaGen.tsv
| 1    | 1     | 1    | N     |   20 | v. (B)
| 1    | N     | 1    | N     |   12 | v. (C)
| 1    | N     | N    | N     |    7 | v. (C)
| 1    | N     | 1    | 1     |    2 | v. (A)
| N    | 1     | 1    | N     |    2 | v. (C)
| N    | 1     | N    | N     |    1 | v. (C)
+------+-------+------+-------+------+
*/
/* 
-- gruppi con match imperfetto per il solo lemma
SELECT LiLaRef, LemLatLST, lemmaLST FROM groupsUnCond G
WHERE G.NoL>1  AND G.NoCL=1 AND G.NoG=1 AND G.NoCM=1;
/* */
/* 
-- gruppi difformi rimanenti
SELECT LiLaRef, LemLatLST, lemmaLST, codlemLST, genLST, codmorfLST FROM groupsUnCond G
WHERE NOT( G.NoL>1  AND G.NoCL=1 AND G.NoG=1 AND G.NoCM=1);
/* */


/*
+------+------+------+-----+
| NoB1 | NoO1 | NoD1 | c   |
+------+------+------+-----+
| 0    | 0    | N    |   2 |
| 0    | 1    | 1    |   5 |
| 0    | N    | 0    |   3 |
| 1    | 0    | 1    | 231 |
| 1    | 0    | N    |  19 |
| 1    | 1    | 0    |  11 |
| 1    | 1    | 1    |   1 |
| N    | 0    | N    |   1 |
+------+------+------+-----+
*/

-- ======= SOLO gen =====
/* 
SELECT LiLaRef, LemLatLST,  genLST FROM groupsUnCond G
WHERE G.NoL=1  AND G.NoCL=1 AND G.NoG>1 AND G.NoCM=1;
/* */
/*
SELECT genLST, COUNT(*) c FROM groupsUnCond G
WHERE G.NoL=1  AND G.NoCL=1 AND G.NoG>1 AND G.NoCM=1
GROUP BY genLST
;
/*
+--------+----+
| genLST | c  |
+--------+----+
| ,n     |  7 |
| 1,m    | 33 |
| 1,n    | 46 |
| 2,f    | 20 |
| 2,m    | 25 |
| 2,n    |  1 |
| 3,f    |  1 |
| 3,n    |  5 |
| f,m    |  4 |
+--------+----+
*/
/*
SELECT S.*, lem FROM
(
SELECT LiLaRef, LemLatLST,  genLST FROM groupsUnCond G
WHERE G.NoL=1  AND G.NoCL=1 AND G.NoG>1 AND G.NoCM=1 AND genLST IN ('1,m','1,n')
) S
LEFT JOIN (
    SELECT DISTINCT n_id,
                    COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef
    FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
    WHERE src<>'F' AND gen='1'
) T USING( LiLaRef )
LEFT JOIN lessario L ON L.n_id=T.n_id AND ( genLST='1,m' AND lem='-us/-um' OR  genLST='1,n' AND lem='-um/-us' )
WHERE lem IS NULL
;
/*
+--------------+----------------------------+--------+------+
| LiLaRef      | LemLatLST                  | genLST | lem  |
+--------------+----------------------------+--------+------+
| lemma/105849 | 109641(D7B2D),18540(h0730) | 1,m    | NULL |
| lemma/109634 | 113270(D86DB),22232(l0038) | 1,m    | NULL |
| lemma/115838 | 124127(DA7D6),28216(p0232) | 1,m    | NULL |
| lemma/115883 | 124395(DA83C),28259(p0268) | 1,m    | NULL |
| lemma/116020 | 124662(DA914),28390(p0382) | 1,m    | NULL |
| lemma/129058 | 156581(DF6G2),41190(t1421) | 1,m    | NULL |
| lemma/87978  | 72408(D083A),1230(a1057)   | 1,n    | NULL |
| lemma/93628  | 88395(D383H),6694(c1316)   | 1,m    | NULL |
| lemma/96624  | 93089(D465A),9845(c4055)   | 1,n    | NULL |
| lemma/97396  | 94997(D4C9A),10608(c4758)  | 1,m    | NULL |
+--------------+----------------------------+--------+------+
*/
/*
SELECT S.*, L1.gen, L2.gen FROM
(
SELECT LiLaRef, LemLatLST,  genLST FROM groupsUnCond G
WHERE G.NoL=1  AND G.NoCL=1 AND G.NoG>1 AND G.NoCM=1 AND genLST IN ('2,m','2,f')
) S
LEFT JOIN (
    SELECT DISTINCT gen,
                    COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef
    FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
    WHERE src='B' AND gen='2'
) L1 USING( LiLaRef )
LEFT JOIN (
    SELECT DISTINCT gen,
                    COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef
    FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
    WHERE src='D' AND gen IN ('m','f')
) L2 USING( LiLaRef )
WHERE  L1.gen IS NULL OR L2.gen IS NULL
;
*/
-- nessun caso

-- ======= SOLO lemma + gen  =====
/* 
SELECT LiLaRef, LemLatLST, lemmaLST,  genLST FROM groupsUnCond G
WHERE G.NoL>1  AND G.NoCL=1 AND G.NoG>1 AND G.NoCM=1;
/* */


-- ======= (A) SOLO codlem =====
/* 
SELECT LiLaRef, LemLatLST,  codlemLST FROM groupsUnCond G
WHERE G.NoL=1  AND G.NoCL>1 AND G.NoG=1 AND G.NoCM=1;

/* 
+--------------+----------------------------+-----------+
| LiLaRef      | LemLatLST                  | codlemLST |
+--------------+----------------------------+-----------+
| lemma/104197 | 101987(D638G),15842(f9350) | V,V3      |
| lemma/128895 | 156401(DF656),41027(t1273) | N,NY      |
+--------------+----------------------------+-----------+
*/

-- ======= (B) SOLO codmorf =====
/* 
SELECT LiLaRef, LemLatLST,  codmorfLST FROM groupsUnCond G
WHERE G.NoL=1  AND G.NoCL=1 AND G.NoG=1 AND G.NoCM>1;

/*
+--------------+----------------------------+------------+
| LiLaRef      | LemLatLST                  | codmorfLST |
+--------------+----------------------------+------------+
| lemma/100257 | 53027(27166),13188(d2341)  | Af-,Ao-    |
| lemma/10266  | 45694(4136),45693(4136)    | NpB,NpC    |
| lemma/10687  | 57533(44378),112584(D8494) | NcP,NpP    |
| lemma/10878  | 57322(44733),112416(D83H3) | NcP,NpP    |
| lemma/113508 | 62165(55479),26333(n0145)  | Af-,Ao-    |
| lemma/113886 | 122128(DA089),26401(n0574) | Ad-,Ao-    |
| lemma/114666 | 62413(56919),27121(o0458)  | Af-,Ao-    |
| lemma/121200 | 131602(DBECE),33483(q0229) | Ad-,Af-    |
| lemma/121214 | 131617(DBEDD),33496(q0243) | Ad-,Ao-    |
| lemma/121313 | 90416(DBEA5),43231(q9202)  | Pu-,Py-    |
| lemma/121488 | 133129(DC2C7),34220(r0123) | Af-,Au-    |
| lemma/123320 | 139303(DD5DD),37102(s0275) | Ad-,Af-    |
| lemma/124417 | 66685(75412),36613(s1305)  | Af-,Ao-    |
| lemma/124431 | 138404(DD2C6),36628(s1319) | Af-,Ao-    |
| lemma/127502 | 66516(74527),36177(s9990)  | Af-,Ao-    |
| lemma/127957 | 68077(83196),40050(t0413)  | Af-,Ao-    |
| lemma/2993   | 44598(1621),71701(D050E)   | NcP,NpP    |
| lemma/4578   | 52360(23046),95331(D4DA8)  | NcP,NpP    |
| lemma/97250  | 94616(D4B35),10471(c4623)  | Af-,Au-    |
| lemma/98867  | 52393(23260),10916(d0935)  | Af-,Ao-    |
+--------------+----------------------------+------------+
*/

-- ======= (C) resto =====

/* 
SELECT LiLaRef, LemLatLST, lemmaLST, codlemLST, genLST, codmorfLST FROM groupsUnCond G
WHERE NOT( G.NoL>1  AND G.NoCL=1 AND G.NoG=1 AND G.NoCM=1 OR
           G.NoL=1  AND G.NoCL=1 AND G.NoG>1 AND G.NoCM=1 OR
           G.NoL>1  AND G.NoCL=1 AND G.NoG>1 AND G.NoCM=1 OR
           G.NoL=1  AND G.NoCL>1 AND G.NoG=1 AND G.NoCM=1 OR
           G.NoL=1  AND G.NoCL=1 AND G.NoG=1 AND G.NoCM>1    
         );
/* */

/*
+--------------+-----------------------------------------------------+-----------------------------+-----------+--------+------------+
| LiLaRef      | LemLatLST                                           | lemmaLST                    | codlemLST | genLST | codmorfLST |
+--------------+-----------------------------------------------------+-----------------------------+-----------+--------+------------+
| lemma/101962 | 150584(D5G0G),14874(e1416)                          | exedo                       | V3,VA     |        | VmH,VmN    |
| lemma/103198 | 54515(32936),15949(f0444)                           | festus                      | N2,N2/1   | *,m    | Af-,NpB    |
| lemma/105645 | 56544(38539),18329(h0538)                           | honestus                    | N2,N2/1   | *,m    | Af-,NpB    |
| lemma/109275 | 57702(45050),22155(i3093)                           | iuuenalis                   | N3A,N3B   | *,m    | Af-,NpC    |
| lemma/112616 | 119934(D9B25),25122(m1245)                          | molo                        | V1,V3     |        | VmF,VmH    |
| lemma/113638 | 121770(D9H41),26122(n0261)                          | neuter                      | N2/1,PR   | *      | Af-,Pu-    |
| lemma/113646 | 121779(D9H4D),26133(n0269)                          | nexo                        | V1,V3     |        | VmF,VmH    |
| lemma/114081 | 122218(DA0DH),26481(n0776)                          | nullus                      | N2/1,PR   | *      | Af-,Pu-    |
| lemma/121068 | 131213(DBD75),33348(q0113)                          | qualis                      | N3A,PR    | *      | Af-,P5-    |
| lemma/121092 | 131228(DBD8F),33372(q0135)                          | quantus                     | N2/1,PR   | *      | Af-,P5-    |
| lemma/121102 | 65366(68992),131595(DBEC7),33551(q0144)             | quinctus,quintus            | N2/1      | *      | Af-,Ao-    |
| lemma/122337 | 131768(DBF4C),33599(r0961)                          | rabio                       | V1,V5     |        | VmF,VmM    |
| lemma/123932 | 135239(DD04F),138941(DD491),36126(s0844)            | se,sibi                     | PR        | ,*     | Px-,Py-    |
| lemma/127165 | 141825(DE0AC),39452(s3894)                          | suus                        | N2/1,PR   | *      | Af-,Ps-    |
| lemma/128689 | 68742(85245),40825(t1090)                           | transtiberinus              | N2,N2/1   | *,m    | Af-,NpB    |
| lemma/14187  | 60599(51297),60598(51298)                           | menas                       | N1,N3B    | m      | NpA,NpC    |
| lemma/46243  | 52397(23275),95421(D4E6D)                           | decius                      | N2,N2/1   | *,m    | Af-,NpB    |
| lemma/63100  | 116155(D8G86),116156(D8G87)                         | madius                      | N2,N2/1   | *,m    | Af-,NcB    |
| lemma/65979  | 119817(D9AF9),119818(D9AFA)                         | modius                      | N2,N2/1   | *,m    | Af-,NcB    |
| lemma/88457  | 74139(D0E53),1750(a1483)                            | alter                       | N2/1,PR   | *      | Af-,P6-    |
| lemma/95041  | 90944(D3GB3),8138(c2588)                            | comitatus                   | N2,N4     | m      | NcB,NcD    |
| lemma/98316  | 95720(D4F6G),95721(D4F76),11165(d0423),11164(d0423) | defretum,defructum,defrutum | N2        | n      | NcB,Y--    |
+--------------+-----------------------------------------------------+-----------------------------+-----------+--------+------------+
*/
