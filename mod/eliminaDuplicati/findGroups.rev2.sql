


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
  ==NOTA== Validate 


regole:
- lemma che finisce in -o (codlem=N3B) ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n31 e sulla riga di D/O il codles=n3 (OR codles=n3p),
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -x (codlem=N3B) ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n31 e sulla riga di D/O il codles=n3 (OR codles=n3p),
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -n (codlem=N3B) ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n3n1 e sulla riga di D/O il codles=n3n (OR codles=n3p),
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -a (codlem=N3B) ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n3n1 e sulla riga di D/O il codles=n3n (OR codles=n3p),
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -e (codlem=N3B) ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n3n2 e sulla riga di D/O il codles=n3n (OR codles=n3p),
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -us (codlem=N3B) ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n2e e sulla riga di D/O il codles=n2,
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -us (codlem=N2) ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n3n1 e sulla riga di D/O il codles=n3n (OR codles=n3p),
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -us (codlem=N2/1) ->
  se la differenza tra B e D/O è la presenza di un qualsiasi valore nei campi a_gra e/o lem in B e la sua assenza in D/O,
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -is (codlem=N3B) ->
  se la differenza tra B e D/O è che sulla riga di B il codles=n31 OR concles=n32 e sulla riga di D/O il codles=n3 (OR codles=n3p),
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -a (codlem=N1) ->
  se la differenza tra B e D/O è la presenza di un qualsiasi valore nei campi a_gra e/o lem in B e la sua assenza in D/O
  OPPURE è che sulla riga di B il codles=n1e e sulla riga di D/O il codles=n1,
  si proceda pure alla eliminazione del lemma/i di D/O
- lemma che finisce in -o (codlem=V3) ->
  se la differenza tra B e D/O è che tutte le righe della clem di D/O sono contenute anche nella clem di B (al netto del valore 'v' in clem),
  si proceda pure alla eliminazione del lemma/i di D/O

*/
-- checkMerge
DROP TEMPORARY TABLE IF EXISTS checkMerge;
CREATE TEMPORARY TABLE checkMerge
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
              AND (k.clem=t.clem OR k.clem='v' AND t.clem='' OR k.clem='' AND t.clem='v'
                   OR k.codlem REGEXP '^V.+' 
                  )
              AND k.si=t.si
              AND ( k.smv=t.smv
                   OR k.codlem REGEXP '^V.+' 
                   )
              AND k.spf=t.spf AND k.les=t.les
              AND (k.codles=t.codles
                   OR
                     k.codles='n31' AND t.codles='n3' AND k.codlem='N3B' AND k.lemma REGEXP '.+(io|tas|or)$'
                   OR
                     k.codles REGEXP '^v.*[ri]$' AND t.codles REGEXP '^v.*[ri]$'
                     AND SUBSTRING(k.codles, 2, LENGTH(k.codles)-2)=SUBSTRING(t.codles, 2, LENGTH(t.codles)-2) 
                   OR
                     k.codles='n31' AND t.codles IN ('n3','n3p') AND k.codlem='N3B' AND k.lemma REGEXP '.+(o|x)$'
                   OR
                     k.codles='n3n1' AND t.codles IN ('n3n','n3p') AND k.codlem='N3B' AND k.lemma REGEXP '.+(n|a|us)$'
                   OR
                     k.codles='n3n2' AND t.codles IN ('n3n','n3p') AND k.codlem='N3B' AND k.lemma REGEXP '.+e$'
                   OR
                     k.codles='n2e' AND t.codles ='n2' AND k.codlem='N3B' AND k.lemma REGEXP '.+us$'
                   OR
                     k.codles IN ('n31', 'n32') AND t.codles IN ('n3n','n3p') AND k.codlem='N3B' AND k.lemma REGEXP '.+is$'
                   OR
                     k.codles ='n1e' AND t.codles ='n1' AND k.codlem='N1' AND k.lemma REGEXP '.+a$'
                  )   
              AND (k.lem=t.lem
                   OR k.lem<>'' AND t.lem='' AND k.codlem='N2/1' AND k.lemma REGEXP '.+us$'
                   OR k.lem<>'' AND t.lem='' AND k.codlem='N1' AND k.lemma REGEXP '.+a$'
                 ) 
              AND k.ls_codlem=t.ls_codlem AND k.type=t.type AND k.codLE=t.codLE AND k.pt=t.pt
              AND (k.a_gra=t.a_gra OR t.a_gra=''
                  OR k.a_gra<>'' AND t.a_gra='' AND k.codlem='N2/1' AND k.lemma REGEXP '.+us$'
                  OR k.a_gra<>'' AND t.a_gra='' AND k.codlem='N1' AND k.lemma REGEXP '.+a$'
                  )
              AND k.gra_u=t.gra_u              
    WHERE k.lemma IS NULL
;

/*
SELECT lemma, codlem, gen, codmorf, K.n_id keep, GROUP_CONCAT(T.n_id) throwLst
FROM checkMerge I INNER JOIN groups G USING(lemma, codlem, gen, codmorf)
INNER JOIN keep K USING(lemma, codlem, gen, codmorf)
INNER JOIN throw T USING(lemma, codlem, gen, codmorf)
GROUP BY lemma, codlem, gen, codmorf, K.n_id
;
*/

-- doMerge
/* */
SELECT lemma, codlem, gen, codmorf, K.n_id keep, GROUP_CONCAT(T.n_id) throwLst
FROM groups G 
INNER JOIN keep K USING(lemma, codlem, gen, codmorf)
INNER JOIN throw T USING(lemma, codlem, gen, codmorf)
LEFT JOIN checkMerge I USING(lemma, codlem, gen, codmorf)
WHERE I.lemma IS NULL
GROUP BY lemma, codlem, gen, codmorf, K.n_id
;
/* */

