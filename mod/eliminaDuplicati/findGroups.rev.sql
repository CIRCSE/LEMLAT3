
/*
SELECT lemma, codlem, gen, codmorf,
       COUNT(*) NoLemLat, COUNT(DISTINCT IF(lila_id_ipolemma IS NULL, lila_id_lemma, NULL)) NoLiLaL,
       COUNT(DISTINCT lila_id_ipolemma) NoLiLaH,
       SUM(src='B') NoB,SUM(src='O') NoO, SUM(src='D') NoD,
       GROUP_CONCAT( CONCAT(id_lemma,'(',n_id,')' ) ) LemLatLST,
       GROUP_CONCAT( DISTINCT COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma))) LiLaLST
FROM lemmario LEFT JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma WHERE src<>'F'
GROUP BY lemma, codlem, gen, codmorf
HAVING (NoD=1 AND NoLemLat>1 OR NoD>1) AND NoLiLaH+NoLiLaL=1
;
*/

/* */
DROP TEMPORARY TABLE IF EXISTS groups;
CREATE TEMPORARY TABLE groups
SELECT lemma, codlem, gen, codmorf,
       COUNT(*) NoLemLat, COUNT(DISTINCT IF(lila_id_ipolemma IS NULL, lila_id_lemma, NULL)) NoLiLaL,
       COUNT(DISTINCT lila_id_ipolemma) NoLiLaH,
       SUM(src='B') NoB,SUM(src='O') NoO, SUM(src='D') NoD,
       GROUP_CONCAT( CONCAT(id_lemma,'(',n_id,')' ) ) LemLatLST,
       GROUP_CONCAT( DISTINCT COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma))) LiLaLST
FROM lemmario LEFT JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma WHERE src<>'F'
GROUP BY lemma, codlem, gen, codmorf
HAVING (NoD=1 AND NoLemLat>1 OR NoD>1) AND NoLiLaH+NoLiLaL=1
;

ALTER TABLE groups ADD KEY(lemma, codlem, gen, codmorf);
/* */
-- SELECT * FROM groups;
/*
SELECT NoB, NoO, NoD, COUNT(*) c
FROM (SELECT CASE WHEN NoB = 0 THEN 'zero' WHEN NoB = 1 THEN 'one' WHEN NoB > 1 THEN 'many' END NoB,
             CASE WHEN NoO = 0 THEN 'zero' WHEN NoO = 1 THEN 'one' WHEN NoO > 1 THEN 'many' END NoO,
             CASE WHEN NoD = 0 THEN 'zero' WHEN NoD = 1 THEN 'one' WHEN NoD > 1 THEN 'many' END NoD
      FROM groups
     ) G
GROUP BY NoB, NoO, NoD;

+------+------+------+------+
| NoB  | NoO  | NoD  | c    |
+------+------+------+------+
| many | zero | many |    1 | *
| one  | many | many |    1 |
| one  | one  | many |   10 |
| one  | one  | one  |   48 |
| one  | zero | many | 2080 |
| one  | zero | one  | 7657 |
| zero | many | one  |    2 | *
| zero | one  | many |   11 |
| zero | one  | one  |   77 |
| zero | zero | many | 3568 |
+------+------+------+------+
*/

/*
SELECT lemma, g.codlem, g.gen, codmorf, NoB, NoO, NoD,
       COUNT(DISTINCT CONCAT(ls.gen, clem, si, smv, spf, les, codles, lem, -- s_omo,
                             piu, ls.codlem, type, codLE, pt, a_gra, gra_u)
        ) NoLes
FROM groups g
INNER JOIN lemmario lm USING (lemma, codlem, gen, codmorf)
INNER JOIN lessario ls USING (n_id)
GROUP BY lemma, g.codlem, g.gen, codmorf, NoB, NoO, NoD
HAVING NoLes > 1;
*/

-- Pproblemi SELEZIONE CANDIDATO:
-- A) 
-- SELECT * FROM groups WHERE NoB=0 AND NoO>1 OR NoB>1;
/*
+------------+--------+-----+---------+----------+---------+---------+------+------+------+---------------------------------------------------------------------+--------------+
| lemma      | codlem | gen | codmorf | NoLemLat | NoLiLaL | NoLiLaH | NoB  | NoO  | NoD  | LemLatLST                                                           | LiLaLST      |
+------------+--------+-----+---------+----------+---------+---------+------+------+------+---------------------------------------------------------------------+--------------+
| augustinus | N2/1   | *   | Af-     |        3 |       1 |       0 |    0 |    2 |    1 | 48429(10162),48430(10164),78796(D1CA9)                              | lemma/33193  |
| baebius    | N2/1   | *   | Af-     |        3 |       1 |       0 |    0 |    2 |    1 | 48741(10881),48742(10882),79471(D1EGC)                              | lemma/33767  |
| manna      | N1     | f   | NcA     |        5 |       1 |       0 |    2 |    0 |    3 | 24051(m0302),24052(m9981),117088(D9185),117087(D9184),117089(D9186) | lemma/113308 |
+------------+--------+-----+---------+----------+---------+---------+------+------+------+---------------------------------------------------------------------+--------------+
*/

-- B)
/*
due lemmi dello stesso gruppo citati con due n_id_diversi
+---------+--------+-----+---------+-------+---+
| lemma   | codlem | gen | codmorf | n_id  | c |
+---------+--------+-----+---------+-------+---+
| bibleus | N2/1   | *   | Af-     | D2310 | 2 |
+---------+--------+-----+---------+-------+---+

SELECT * FROM derivational_db.wfl_view_all WHERE o_lemma='bibleus' OR i_lemma='bibleus'; 
+------------+------------+----------+-------+-----------+--------+-------+------------+----------+----------+-------+-----------+--------+---------+----------+-------------------+
| i_id_lemma | i_lemma    | i_codlem | i_gen | i_codmorf | i_n_id | i_ord | o_id_lemma | o_lemma  | o_codlem | o_gen | o_codmorf | o_n_id | wfr_key | category | type              |
+------------+------------+----------+-------+-----------+--------+-------+------------+----------+----------+-------+-----------+--------+---------+----------+-------------------+
|      81356 | bibleus    | N2/1     | *     | Af-       | D2311  |     1 |      81373 | biblosus | N2/1     | *     | Af-       | D2320  | 183     | A-To-A   | Derivation_Suffix |
|       4613 | biblus/-os | N2       | f     | NcB       | b0310  |     1 |      81355 | bibleus  | N2/1     | *     | Af-       | D2310  | 58      | N-To-A   | Derivation_Suffix |
+------------+------------+----------+-------+-----------+--------+-------+------------+----------+----------+-------+-----------+--------+---------+----------+-------------------+
i due lemmi 'bibleus' sono in effetti distinti?
*/

DROP TEMPORARY TABLE IF EXISTS refDucange;
CREATE TEMPORARY TABLE refDucange
SELECT DISTINCT o_lemma lemma, o_codlem codlem, o_gen gen, o_codmorf codmorf, o_n_id n_id
FROM derivational_db.wfr2_all
WHERE LEFT(o_n_id,1)='D'
UNION
SELECT DISTINCT i_lemma lemma, i_codlem codlem, i_gen gen, i_codmorf codmorf, i_n_id n_id
FROM derivational_db.wfr2_all
WHERE LEFT(i_n_id,1)='D';

ALTER TABLE refDucange ADD KEY(lemma, codlem, gen, codmorf);
ALTER TABLE refDucange ADD UNIQUE KEY(n_id);

-- condidati non ambigui per gruppo
DROP TEMPORARY TABLE IF EXISTS keep;
CREATE TEMPORARY TABLE keep
SELECT lemma, codlem, gen, codmorf, n_id
FROM groups g
INNER JOIN lemmario lm USING (lemma, codlem, gen, codmorf)
WHERE NoB=1 AND src='B'
UNION
-- onomastiocon
SELECT lemma, codlem, gen, codmorf, n_id
FROM groups g
INNER JOIN lemmario lm USING (lemma, codlem, gen, codmorf)
WHERE NoB=0 AND NoO=1 AND src='O'
UNION
-- solo lemmi ducange (derivati): 577 
SELECT lemma, codlem, gen, codmorf, MIN(n_id) n_id -- , COUNT(DISTINCT n_id) c
FROM groups g
INNER JOIN refDucange D  USING (lemma, codlem, gen, codmorf)
WHERE NoB=0 AND NoO=0 
GROUP BY lemma, codlem, gen, codmorf
-- HAVING c>1
UNION 
-- solo lemmi ducange (NON derivati) : 2991
SELECT lemma, codlem, gen, codmorf, MIN(lm.n_id) n_id
FROM groups g
INNER JOIN lemmario lm USING (lemma, codlem, gen, codmorf)
LEFT JOIN refDucange D  USING (lemma, codlem, gen, codmorf)
WHERE NoB=0 AND NoO=0 AND LEFT(lm.n_id,1)<>'$' AND D.lemma IS NULL
GROUP BY lemma, codlem, gen, codmorf
;

ALTER TABLE keep ADD KEY(lemma, codlem, gen, codmorf);
ALTER TABLE keep ADD KEY(n_id);

-- Lemmi da accorpare ai relativi candidati
DROP TEMPORARY TABLE IF EXISTS throw;
CREATE TEMPORARY TABLE throw
SELECT lm.lemma, lm.codlem, lm.gen, lm.codmorf, lm.n_id
FROM groups g
INNER JOIN lemmario lm USING (lemma, codlem, gen, codmorf)
LEFT JOIN keep USING(n_id)
WHERE (NoB=1 OR NoB=0 AND NoO=1 OR NoB=0 AND NoO=0 )AND keep.n_id IS NULL;

ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf);
ALTER TABLE throw ADD KEY(lemma, codlem, gen, codmorf, n_id);


-- SELECT groups.* FROM  (SELECT t.* FROM throw t INNER JOIN refDucange USING(n_id) ) s INNER JOIN groups USING(lemma,codlem,gen,codmorf); 
-- ISSUE: lemmi da eleiminare ma riferiti in derivational_db
/*
+----------+--------+-----+---------+----------+---------+---------+------+------+------+------------------------------------------+-------------+
| lemma    | codlem | gen | codmorf | NoLemLat | NoLiLaL | NoLiLaH | NoB  | NoO  | NoD  | LemLatLST                                | LiLaLST     |
+----------+--------+-----+---------+----------+---------+---------+------+------+------+------------------------------------------+-------------+
| bibleus  | N2/1   | *   | Af-     |        2 |       1 |       0 |    0 |    0 |    2 | 81355(D2310),81356(D2311)                | lemma/35355 |
| lanius   | N2/1   | *   | Af-     |        2 |       1 |       0 |    0 |    1 |    1 | 113558(D882H),57974(45754)               | lemma/61275 |
| legius   | N2/1   | *   | Af-     |        2 |       1 |       0 |    0 |    1 |    1 | 114327(D8A7A),58285(46476)               | lemma/61771 |
| madius   | N2/1   | *   | Af-     |        3 |       1 |       0 |    0 |    1 |    2 | 116156(D8G87),116155(D8G86),59402(48988) | lemma/63100 |
| modius   | N2/1   | *   | Af-     |        3 |       1 |       0 |    0 |    1 |    2 | 61118(52549),119817(D9AF9),119818(D9AFA) | lemma/65979 |
| ponticus | N2/1   | *   | Af-     |        2 |       1 |       0 |    0 |    1 |    1 | 64935(64692),128439(DB3DE)               | lemma/72495 |
+----------+--------+-----+---------+----------+---------+---------+------+------+------+------------------------------------------+-------------+
*/

/* 
SELECT t.*
FROM
(
SELECT T.*,
ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
FROM throw T INNER JOIN lessario ls USING(n_id)
) t LEFT JOIN (
SELECT K.*,
ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
FROM keep K INNER JOIN lessario ls USING(n_id)
) k USING(lemma, codlem, gen, codmorf, 
          ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls_codlem, type, codLE, pt, a_gra, gra_u)
WHERE k.lemma IS NULL;
*/

/* REV:
- lemma che finisce in -io (codlem=N3B) [663 +158 casi] ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n31 e sulla riga di D/O il codles=n3,
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -tas (codlem=N3B) [264 casi] ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n31 e sulla riga di D/O il codles=n3,
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -or (codlem=N3B) [435 casi] ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n31 e sulla riga di D/O il codles=n3,
  si proceda pure alla eliminazione del lemma/i di D/O
- se la differenza tra le righe in questione del lessario consiste
      nella presenza del valore "+" nella colonna piu della clem di B e
      nell'assenza di un valore in piu della clem di O/D,
  si proceda pure alla eliminazione del lemma/i di D/O (esempio: abacus)
  ===> IGNORA campo piu (ha solo valori '' o '+')  
- se la differenza tra le righe in questione del lessario consiste
     nella presenza di un valore nella colonna a_gra della clem di B e
     nell'assenza di un valore in a_gra della clem di O/D,
  si proceda pure alla eliminazione del lemma/i di D/O (esempio: abstinentia)
  ===> = or t.a_gra=''
- se la differenza tra le righe in questione del lessario consiste
     nella presenza del valore "v" nella colonna clem della clem di B e
     nell'assenza di un valore in clem della clem di O/D,
  si proceda pure alla eliminazione del lemma/i di D/O (esempio: acceia)
  ===> k.clem='v' AND t.clem=''
      ==NOTA== da 'aberro' assumo che valga anche il viceversa
- se la differenza tra le righe in questione del lessario consiste
     nella presenza del valore "v*r" nella colonna codles della clem di B e
     nel valore "v*i" in codles della clem di O/D,
  si proceda pure alla eliminazione del lemma/i di D/O (esempio: aberro)
  ===> k.codles REGEXP '^v.*[ri]$' AND t.codles REGEXP '^v.*[ri]$'
      ==NOTA== da 'aberro' assumo che valga anche il viceversa
      ==NOTA== impongo restrizione: coincidenta della parte centrale eg, escludo v3i <-> v2r
- se il codlem=V* e la differenza tra i les in questione riguarda i campi clem e/o smv,
  l'eliminazione non dovrebbe sollevare problemi
  -> ma, prima di farla, fornire un report dei lemmi coinvolti
  ==NOTA== sarebbero comunque valide le altre cindizioni approssimate 
*/

-- checkMerge
/* */
DROP TEMPORARY TABLE IF EXISTS checkMerge;
CREATE TEMPORARY TABLE checkMerge
SELECT lemma, codlem, gen, codmorf, K.n_id keep, GROUP_CONCAT(T.n_id) throwLst
FROM (
   SELECT DISTINCT t.lemma, t.codlem, t.gen, t.codmorf
   FROM (
        SELECT T.*,
               ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM throw T INNER JOIN lessario ls USING(n_id)
    ) t LEFT JOIN (
        SELECT K.*,
        ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM keep K INNER JOIN lessario ls USING(n_id)
    ) k ON k.lemma=t.lemma AND k.codlem=t.codlem AND k.gen=t.gen AND k.codmorf=t.codmorf
              AND k.ls_gen=t.ls_gen
              -- AND k.clem=t.clem
              AND (k.clem=t.clem OR k.clem='v' AND t.clem='' OR k.clem='' AND t.clem='v')
              AND k.si=t.si AND k.smv=t.smv AND k.spf=t.spf AND k.les=t.les
              -- AND k.codles=t.codles
              AND (k.codles=t.codles OR k.codles='n31' AND t.codles='n3' AND k.codlem='N3B' AND k.lemma REGEXP '.+(io|tas|or)$'
                   OR k.codles REGEXP '^v.*[ri]$' AND t.codles REGEXP '^v.*[ri]$'
                      AND SUBSTRING(k.codles, 2, LENGTH(k.codles)-2)=SUBSTRING(t.codles, 2, LENGTH(t.codles)-2) )
              AND k.lem=t.lem
              -- AND k.piu=t.piu
              AND k.ls_codlem=t.ls_codlem AND k.type=t.type AND k.codLE=t.codLE AND k.pt=t.pt
              -- AND k.a_gra=t.a_gra
              AND (k.a_gra=t.a_gra OR t.a_gra='')
              AND k.gra_u=t.gra_u              
    WHERE k.lemma IS NULL
) I INNER JOIN groups G USING(lemma, codlem, gen, codmorf)
INNER JOIN keep K USING(lemma, codlem, gen, codmorf)
INNER JOIN throw T USING(lemma, codlem, gen, codmorf)
GROUP BY lemma, codlem, gen, codmorf, K.n_id
;


-- doMerge
/* 
SELECT lemma, codlem, gen, codmorf, K.n_id keep, GROUP_CONCAT(T.n_id) throwLst
FROM groups G 
INNER JOIN keep K USING(lemma, codlem, gen, codmorf)
INNER JOIN throw T USING(lemma, codlem, gen, codmorf)
LEFT JOIN
( 
   SELECT DISTINCT t.lemma, t.codlem, t.gen, t.codmorf
   FROM (
        SELECT T.*,
               ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM throw T INNER JOIN lessario ls USING(n_id)
    ) t LEFT JOIN (
        SELECT K.*,
        ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM keep K INNER JOIN lessario ls USING(n_id)
    ) k ON k.lemma=t.lemma AND k.codlem=t.codlem AND k.gen=t.gen AND k.codmorf=t.codmorf
              AND k.ls_gen=t.ls_gen
              -- AND k.clem=t.clem
              AND (k.clem=t.clem OR k.clem='v' AND t.clem='' OR k.clem='' AND t.clem='v')
              AND k.si=t.si AND k.smv=t.smv AND k.spf=t.spf AND k.les=t.les
              -- AND k.codles=t.codles
              AND (k.codles=t.codles OR k.codles='n31' AND t.codles='n3' AND k.codlem='N3B' AND k.lemma REGEXP '.+(io|tas|or)$'
                   OR k.codles REGEXP '^v.*[ri]$' AND t.codles REGEXP '^v.*[ri]$'
                      AND SUBSTRING(k.codles, 2, LENGTH(k.codles)-2)=SUBSTRING(t.codles, 2, LENGTH(t.codles)-2) )
              AND k.lem=t.lem
              -- AND k.piu=t.piu
              AND k.ls_codlem=t.ls_codlem AND k.type=t.type AND k.codLE=t.codLE AND k.pt=t.pt
              -- AND k.a_gra=t.a_gra
              AND (k.a_gra=t.a_gra OR t.a_gra='')
              AND k.gra_u=t.gra_u              
    WHERE k.lemma IS NULL
) I USING(lemma, codlem, gen, codmorf)
WHERE I.lemma IS NULL
GROUP BY lemma, codlem, gen, codmorf, K.n_id
;
*/


-- checkMerge_1
/* */
DROP TEMPORARY TABLE IF EXISTS checkMerge_1;
CREATE TEMPORARY TABLE checkMerge_1
SELECT lemma, codlem, gen, codmorf, K.n_id keep, GROUP_CONCAT(T.n_id) throwLst
FROM (
   SELECT DISTINCT t.lemma, t.codlem, t.gen, t.codmorf
   FROM (
        SELECT T.*,
               ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM throw T INNER JOIN lessario ls USING(n_id)
    ) t LEFT JOIN (
        SELECT K.*,
        ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM keep K INNER JOIN lessario ls USING(n_id)
    ) k ON k.lemma=t.lemma AND k.codlem=t.codlem AND k.gen=t.gen AND k.codmorf=t.codmorf
              AND k.ls_gen=t.ls_gen
              -- AND k.clem=t.clem
              -- AND (k.clem=t.clem OR k.clem='v' AND t.clem='' OR k.clem='' AND t.clem='v')
              AND k.si=t.si
              -- AND k.smv=t.smv
              AND k.spf=t.spf AND k.les=t.les
              -- AND k.codles=t.codles
              AND (k.codles=t.codles OR k.codles='n31' AND t.codles='n3' AND k.codlem='N3B' AND k.lemma REGEXP '.+(io|tas|or)$'
                   OR k.codles REGEXP '^v.*[ri]$' AND t.codles REGEXP '^v.*[ri]$'
                      AND SUBSTRING(k.codles, 2, LENGTH(k.codles)-2)=SUBSTRING(t.codles, 2, LENGTH(t.codles)-2) )
              AND k.lem=t.lem
              -- AND k.piu=t.piu
              AND k.ls_codlem=t.ls_codlem AND k.type=t.type AND k.codLE=t.codLE AND k.pt=t.pt
              -- AND k.a_gra=t.a_gra
              AND (k.a_gra=t.a_gra OR t.a_gra='')
              AND k.gra_u=t.gra_u                          

    WHERE  k.lemma IS NOT NULL AND k.codlem REGEXP '^V.+' AND NOT((k.clem=t.clem OR k.clem='v' AND t.clem='' OR k.clem='' AND t.clem='v')
                                      AND k.smv=t.smv )

/* 
    WHERE  k.lemma IS NULL OR NOT ( t.codlem REGEXP '^V.+'
                                    OR ( k.clem=t.clem OR k.clem='v' AND t.clem='' OR k.clem='' AND t.clem='v')
                                        AND k.smv=t.smv )
*/
) I INNER JOIN groups G USING(lemma, codlem, gen, codmorf)
INNER JOIN keep K USING(lemma, codlem, gen, codmorf)
INNER JOIN throw T USING(lemma, codlem, gen, codmorf)
GROUP BY lemma, codlem, gen, codmorf, K.n_id
;

-- checkMerge_1
SELECT checkMerge.* FROM checkMerge LEFT JOIN checkMerge_1  USING(lemma, codlem, gen, codmorf) WHERE  checkMerge_1.lemma IS NOT  NULL;
-- checkMerge_2
-- SELECT checkMerge.* FROM checkMerge LEFT JOIN checkMerge_1  USING(lemma, codlem, gen, codmorf) WHERE  checkMerge_1.lemma IS  NULL;
