

-- ======= SOLO gen  =====
/*
ditribuzione delle difforimità:
#COMMENTI DI #MARCO DOPO ->
+--------+----+
| genLST | c  |
+--------+----+
| ,n     |  7 | -> ok rimuovere D
| 1,m    | 33 | -> ok rimuovere D se c'è lem='-us/-um' nella clem di B. C'è sempre? (v.)
| 1,n    | 46 | -> ok rimuovere D se c'è lem='-um/-us' nella clem di B. C'è sempre? (v.)
| 2,f    | 20 | -> ok rimuovere D se gen='2' nella clem di B e gen = 'f' nella clem di D (vv.)
| 2,m    | 25 | -> ok rimuovere D se gen='2' nella clem di B e gen = 'm' nella clem di D (vv.)
| 2,n    |  1 | -> ok rimuovere D
| 3,f    |  1 | -> ok rimuovere D
| 3,n    |  5 | -> ok rimuovere D
| f,m    |  4 | -> ok rimuovere D. Questi due da O vanno tenuti separati in lemlat: 63966(62196),63967(62197)
+--------+----+
(v.)
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
CONTROLLATI + bugfix su :
- p0382 gen='1' -> gen='2'
- c4758 gen='1' -> gen='2' ==> BUGFIX.sql

(vv.)
nessun caso...
*/




-- ======= SOLO lemma + gen  =====
/*
dettagli in: groupsQuasi.LemmaGen.tsv
#MARCO: ok rimuovere D
*/

-- ======= (A) SOLO codlem =====
/*
+--------------+----------------------------+-----------+
| LiLaRef      | LemLatLST                  | codlemLST |
+--------------+----------------------------+-----------+
| lemma/104197 | 101987(D638G),15842(f9350) | V,V3      |
| lemma/128895 | 156401(DF656),41027(t1273) | N,NY      |
+--------------+----------------------------+-----------+

#MARCO
- lemma/104197: ok rimuovere D
- lemma/128895: ok rimuovere D
*/



-- ======= (B) SOLO codmorf =====
/*
#COMMENTI DI #MARCO DOPO ->
+--------------+----------------------------+------------+
| LiLaRef      | LemLatLST                  | codmorfLST |
+--------------+----------------------------+------------+
| lemma/100257 | 53027(27166),13188(d2341)  | Af-,Ao-    | -> ok rimuovere D
| lemma/10266  | 45694(4136),45693(4136)    | NpB,NpC    | -> la label/wr di lemma/10266 va corretta in "alectus" (ora è "alecto"). Niente da modificare in lemlat
| lemma/10687  | 57533(44378),112584(D8494) | NcP,NpP    | -> ok rimuovere D
| lemma/10878  | 57322(44733),112416(D83H3) | NcP,NpP    | -> ok rimuovere D
| lemma/113508 | 62165(55479),26333(n0145)  | Af-,Ao-    | -> ok rimuovere D
| lemma/113886 | 122128(DA089),26401(n0574) | Ad-,Ao-    | -> ok rimuovere D
| lemma/114666 | 62413(56919),27121(o0458)  | Af-,Ao-    | -> ok rimuovere D
| lemma/121200 | 131602(DBECE),33483(q0229) | Ad-,Af-    | -> ok rimuovere D
| lemma/121214 | 131617(DBEDD),33496(q0243) | Ad-,Ao-    | -> ok rimuovere D
| lemma/121313 | 90416(DBEA5),43231(q9202)  | Pu-,Py-    | -> ok rimuovere D
| lemma/121488 | 133129(DC2C7),34220(r0123) | Af-,Au-    | -> ok rimuovere D
| lemma/123320 | 139303(DD5DD),37102(s0275) | Ad-,Af-    | -> ok rimuovere D
| lemma/124417 | 66685(75412),36613(s1305)  | Af-,Ao-    | -> ok rimuovere D
| lemma/124431 | 138404(DD2C6),36628(s1319) | Af-,Ao-    | -> ok rimuovere D
| lemma/127502 | 66516(74527),36177(s9990)  | Af-,Ao-    | -> ok rimuovere D
| lemma/127957 | 68077(83196),40050(t0413)  | Af-,Ao-    | -> ok rimuovere D
| lemma/2993   | 44598(1621),71701(D050E)   | NcP,NpP    | -> ok rimuovere D
| lemma/4578   | 52360(23046),95331(D4DA8)  | NcP,NpP    | -> ok rimuovere D
| lemma/97250  | 94616(D4B35),10471(c4623)  | Af-,Au-    | -> ok rimuovere D
| lemma/98867  | 52393(23260),10916(d0935)  | Af-,Ao-    | -> ok rimuovere D
+--------------+----------------------------+------------+
*/

-- ======= (C) resto =====
/*
#COMMENTI DI #MARCO DOPO ->
+--------------+-----------------------------------------------------+-----------------------------+-----------+--------+------------+
| LiLaRef      | LemLatLST                                           | lemmaLST                    | codlemLST | genLST | codmorfLST |
+--------------+-----------------------------------------------------+-----------------------------+-----------+--------+------------+
| lemma/101962 | 150584(D5G0G),14874(e1416)                          | exedo                       | V3,VA     |        | VmH,VmN    | -> ok rimuovere D
| lemma/103198 | 54515(32936),15949(f0444)                           | festus                      | N2,N2/1   | *,m    | Af-,NpB    | -> non apportare nessuna modifica a lemlat 
| lemma/105645 | 56544(38539),18329(h0538)                           | honestus                    | N2,N2/1   | *,m    | Af-,NpB    | -> non apportare nessuna modifica a lemlat 
| lemma/109275 | 57702(45050),22155(i3093)                           | iuuenalis                   | N3A,N3B   | *,m    | Af-,NpC    | -> non apportare nessuna modifica a lemlat 
| lemma/112616 | 119934(D9B25),25122(m1245)                          | molo                        | V1,V3     |        | VmF,VmH    | -> non apportare nessuna modifica a lemlat 
| lemma/113638 | 121770(D9H41),26122(n0261)                          | neuter                      | N2/1,PR   | *      | Af-,Pu-    | -> rimuovere la clem del DuCange
| lemma/113646 | 121779(D9H4D),26133(n0269)                          | nexo                        | V1,V3     |        | VmF,VmH    | -> rimuovere la clem del DuCange
| lemma/114081 | 122218(DA0DH),26481(n0776)                          | nullus                      | N2/1,PR   | *      | Af-,Pu-    | -> rimuovere la clem del DuCange
| lemma/121068 | 131213(DBD75),33348(q0113)                          | qualis                      | N3A,PR    | *      | Af-,P5-    | -> rimuovere la clem del DuCange
| lemma/121092 | 131228(DBD8F),33372(q0135)                          | quantus                     | N2/1,PR   | *      | Af-,P5-    | -> rimuovere la clem del DuCange
| lemma/121102 | 65366(68992),131595(DBEC7),33551(q0144)             | quinctus,quintus            | N2/1      | *      | Af-,Ao-    | -> rimuovere la clem del DuCange e quella dell'O
| lemma/122337 | 131768(DBF4C),33599(r0961)                          | rabio                       | V1,V5     |        | VmF,VmM    | -> rimuovere la clem del DuCange
| lemma/123932 | 135239(DD04F),138941(DD491),36126(s0844)            | se,sibi                     | PR        | ,*     | Px-,Py-    | -> rimuovere le clem del DuCange
| lemma/127165 | 141825(DE0AC),39452(s3894)                          | suus                        | N2/1,PR   | *      | Af-,Ps-    | -> rimuovere la clem del DuCange
| lemma/128689 | 68742(85245),40825(t1090)                           | transtiberinus              | N2,N2/1   | *,m    | Af-,NpB    | -> non apportare nessuna modifica a lemlat 
| lemma/14187  | 60599(51297),60598(51298)                           | menas                       | N1,N3B    | m      | NpA,NpC    | -> rimuovere la clem 51298
| lemma/46243  | 52397(23275),95421(D4E6D)                           | decius                      | N2,N2/1   | *,m    | Af-,NpB    | -> non apportare nessuna modifica a lemlat 
| lemma/63100  | 116155(D8G86),116156(D8G87)                         | madius                      | N2,N2/1   | *,m    | Af-,NcB    | -> non apportare nessuna modifica a lemlat 
| lemma/65979  | 119817(D9AF9),119818(D9AFA)                         | modius                      | N2,N2/1   | *,m    | Af-,NcB    | -> non apportare nessuna modifica a lemlat 
| lemma/88457  | 74139(D0E53),1750(a1483)                            | alter                       | N2/1,PR   | *      | Af-,P6-    | -> non apportare nessuna modifica a lemlat
| lemma/95041  | 90944(D3GB3),8138(c2588)                            | comitatus                   | N2,N4     | m      | NcB,NcD    | -> rimuovere le clem del DuCange
| lemma/98316  | 95720(D4F6G),95721(D4F76),11165(d0423),11164(d0423) | defretum,defructum,defrutum | N2        | n      | NcB,Y--    | -> rimuovere le clem del DuCange
+--------------+-----------------------------------------------------+-----------------------------+-----------+--------+------------+
*/

--  === > Effettuare i raggruppamenti eccetto che nei seguenti casi (LiLaRef):
/*
| lemma/10266  | 45694(4136),45693(4136)    | NpB,NpC    | -> la label/wr di lemma/10266 va corretta in "alectus" (ora è "alecto"). Niente da modificare in lemlat

| lemma/103198 | 54515(32936),15949(f0444)                           | festus                      | N2,N2/1   | *,m    | Af-,NpB    | -> non apportare nessuna modifica a lemlat 
| lemma/105645 | 56544(38539),18329(h0538)                           | honestus                    | N2,N2/1   | *,m    | Af-,NpB    | -> non apportare nessuna modifica a lemlat 
| lemma/109275 | 57702(45050),22155(i3093)                           | iuuenalis                   | N3A,N3B   | *,m    | Af-,NpC    | -> non apportare nessuna modifica a lemlat 
| lemma/112616 | 119934(D9B25),25122(m1245)                          | molo                        | V1,V3     |        | VmF,VmH    | -> non apportare nessuna modifica a lemlat 
| lemma/128689 | 68742(85245),40825(t1090)                           | transtiberinus              | N2,N2/1   | *,m    | Af-,NpB    | -> non apportare nessuna modifica a lemlat 
| lemma/46243  | 52397(23275),95421(D4E6D)                           | decius                      | N2,N2/1   | *,m    | Af-,NpB    | -> non apportare nessuna modifica a lemlat 
| lemma/63100  | 116155(D8G86),116156(D8G87)                         | madius                      | N2,N2/1   | *,m    | Af-,NcB    | -> non apportare nessuna modifica a lemlat 
| lemma/65979  | 119817(D9AF9),119818(D9AFA)                         | modius                      | N2,N2/1   | *,m    | Af-,NcB    | -> non apportare nessuna modifica a lemlat 
| lemma/88457  | 74139(D0E53),1750(a1483)                            | alter                       | N2/1,PR   | *      | Af-,P6-    | -> non apportare nessuna modifica a lemlat

lemma/18115	63966(62196),63967(62197)	f,m
*/

DROP TEMPORARY TABLE IF EXISTS groups;
CREATE TEMPORARY TABLE groups
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
                    REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                    codlem, gen, codmorf,
                    COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                    IF(src='B', id_lemma, NULL) srcB, IF(src='O', id_lemma, NULL) srcO, IF(src='D', id_lemma, NULL) srcD
    FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
    WHERE src<>'F'
) T
WHERE LiLaRef NOT IN(
'lemma/10266',
'lemma/103198',
'lemma/105645',
'lemma/109275',
'lemma/112616',
'lemma/128689',
'lemma/46243',
'lemma/63100',
'lemma/65979',
'lemma/88457',
'lemma/18115'
)
GROUP BY LiLaRef
HAVING NoLemLat>1 AND NoB<NoLemlat AND NOT( NoL>1  AND NoCL=1 AND NoG=1 AND NoCM=1)
;

/*
SELECT CASE WHEN NoB=0 THEN '0' WHEN NoB=1 THEN '1' WHEN NoB>1 THEN 'N' END NoB1,
       CASE WHEN NoO=0 THEN '0' WHEN NoO=1 THEN '1' WHEN NoO>1 THEN 'N' END NoO1,
       CASE WHEN NoD=0 THEN '0' WHEN NoD=1 THEN '1' WHEN NoD>1 THEN 'N' END NoD1,
       COUNT(*) c
FROM groups G
GROUP BY NoB1, NoO1, NoD1;

/*
+------+------+------+-----+
| NoB1 | NoO1 | NoD1 | c   |
+------+------+------+-----+
| 0    | 1    | 1    |   4 |
| 0    | N    | 0    |   1 |
| 1    | 0    | 1    | 229 |
| 1    | 0    | N    |  19 |
| 1    | 1    | 0    |   7 |
| 1    | 1    | 1    |   1 |
| N    | 0    | N    |   1 |
+------+------+------+-----+
CASI amigui:
+-------------+----------+-----+-----+-----+-----------------------------------------------------+-----+-----------------------------+------+-----------+-----+--------+------+------------+
| LiLaRef     | NoLemLat | NoB | NoO | NoD | LemLatLST                                           | NoL | lemmaLST                    | NoCL | codlemLST | NoG | genLST | NoCM | codmorfLST |
+-------------+----------+-----+-----+-----+-----------------------------------------------------+-----+-----------------------------+------+-----------+-----+--------+------+------------+
| lemma/14187 |        2 |   0 |   2 |   0 | 60599(51297),60598(51298)                           |   1 | menas                       |    2 | N1,N3B    |   1 | m      |    2 | NpA,NpC    |
| lemma/98316 |        4 |   2 |   0 |   2 | 95720(D4F6G),95721(D4F76),11164(d0423),11165(d0423) |   3 | defretum,defructum,defrutum |    1 | N2        |   1 | n      |    2 | NcB,Y--    |
+-------------+----------+-----+-----+-----+-----------------------------------------------------+-----+-----------------------------+------+-----------+-----+--------+------+------------+

| lemma/98316  | 95720(D4F6G),95721(D4F76),11165(d0423),11164(d0423)  -> rimuovere le clem del DuCange
| lemma/14187  | 60599(51297),60598(51298)                            -> rimuovere la clem 51298

*/


-- condidati non ambigui per gruppo
DROP TEMPORARY TABLE IF EXISTS keep;
CREATE TEMPORARY TABLE keep

-- un solo lemma della base
SELECT lemma, codlem, gen, codmorf, LiLaRef, n_id
FROM groups g
INNER JOIN (
            SELECT id_lemma, n_id,
                   REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
                   COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
                   codlem, gen, codmorf, src                   
            FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
            ) lm USING (LiLaRef)
WHERE NoB=1 AND src='B' OR NoB=0 AND NoO=1 AND src='O'
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
           ) lm USING (LiLaRef)
LEFT JOIN keep USING(n_id)
WHERE  (NoB=1 AND src<>'B' OR NoB=0 AND NoO=1 AND src<>'O') AND keep.n_id IS NULL;

ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf, LiLaRef);
ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf, LiLaRef, n_id);


/*
CASI AMBIGUI:
| lemma/98316  | 95720(D4F6G),95721(D4F76),11165(d0423),11164(d0423)  -> rimuovere le clem del DuCange
| lemma/14187  | 60599(51297),60598(51298)                            -> rimuovere la clem 51298
*/
/* */
INSERT INTO keep
SELECT DISTINCT REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
       codlem, gen, codmorf,
       COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef,
       n_id                   
FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
WHERE lila_id_lemma=14187 AND n_id='51297' OR lila_id_lemma=98316 AND id_lemma=11164;

INSERT INTO throw
SELECT REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') lemma,
       codlem, gen, codmorf,
       n_id,
       COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma)) LiLaRef                          
FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
WHERE lila_id_lemma=14187 AND n_id='51298' OR lila_id_lemma=98316 AND n_id IN('D4F6G','D4F76');
/* */


INSERT IGNORE INTO deprecationMap(n_idNEW, n_idOLD, lemmata)
SELECT  K.n_id n_idNEW, T.n_id n_idOLD, GROUP_CONCAT(DISTINCT CONCAT_WS('_',T.lemma, T.codlem, T.gen, T.codmorf, LiLaRef)) lemmata
FROM keep K INNER JOIN throw T USING(LiLaRef)
GROUP BY K.n_id, T.n_id
;

/* */
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
