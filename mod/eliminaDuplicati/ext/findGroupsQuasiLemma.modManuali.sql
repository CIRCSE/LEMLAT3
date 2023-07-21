
-- =========== AMBIGUI ============
/*
(*) Casi  NON trattabili automaticamnete :
+--------------+--------+-----+---------+----------+-----+-----+-----+----------------------------------------------------+-----+------------------------+
| LiLaRef      | codlem | gen | codmorf | NoLemLat | NoB | NoO | NoD | LemLatLST                                          | NoL | lemmaLST               |
+--------------+--------+-----+---------+----------+-----+-----+-----+----------------------------------------------------+-----+------------------------+
| lemma/120402 | V1     |     | VmF     |        3 |   2 |   0 |   1 | 130669(DBB9A),32928(p4418),32926(p4418)            |   3 | pugillo,pugilo,pugilor |
| lemma/87112  | V3     |     | VmH     |        3 |   2 |   0 |   1 | 70976(D0286),282(a0268),320(a0268)                 |   3 | accado,accedo,accido   |
| lemma/97341  | V1     |     | VmF     |        4 |   3 |   0 |   1 | 93617(D47F7),10549(c4706),33592(c4706),9858(c4706) |   4 | coro,couro,curo,quro   |
+--------------+--------+-----+---------+----------+-----+-----+-----+----------------------------------------------------+-----+------------------------+
#MARCO:
#- lemma/120402: rimuovere il lemma del D (DBB9A).
#      Nel campo lem della riga del lessario con pr_key='48289' scrivere il valore lem='-o/-or'
#- lemma/87112: rimuovere il lemma del D (D0286).
#      Aggiungere alla clem della B (a0268)
#      le righe del lessario originariamente della clem di D che hanno pr_key: 139521, 139522, 139523
#- lemma/97341: rimuovere il lemma del D (D47F7)
*/
-- SELECT * FROM derivational_db.wfr_all WHERE o_n_id IN('DBB9A','D0286','D47F7') OR i_n_id IN('DBB9A','D0286','D47F7');
INSERT INTO lessarioDeprecated
SELECT *
FROM lessario WHERE n_id IN('DBB9A','D0286','D47F7');

INSERT INTO lemmarioDeprecated
SELECT *
FROM lemmario WHERE n_id IN('DBB9A','D0286','D47F7');

INSERT IGNORE INTO deprecationMap(n_idNEW, n_idOLD, lemmata)
SELECT  'p4418', 'DBB9A',
        CONCAT_WS('_', 
                  REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') ,
                  codlem, gen, codmorf,
                  COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma))
        ) lemmata                          
FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
WHERE lila_id_lemma=120402 AND n_id='DBB9A'
UNION
SELECT  'a0268', 'D0286',
        CONCAT_WS('_', 
                  REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') ,
                  codlem, gen, codmorf,
                  COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma))
        ) lemmata                          
FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
WHERE lila_id_lemma=87112 AND n_id='D0286'
UNION
SELECT  'c4706', 'D47F7',
        CONCAT_WS('_', 
                  REPLACE( REPLACE(SUBSTRING_INDEX(lemma,'/', 1),"'",""), '"','') ,
                  codlem, gen, codmorf,
                  COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma))
        ) lemmata                          
FROM lemmario INNER JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma
WHERE lila_id_lemma=97341 AND n_id='D47F7';



UPDATE lemlat_db.lessario SET lem='-o/-or' WHERE pr_key=48289;
UPDATE lemlat_db.lessario SET n_id='a0268' WHERE pr_key IN(139521, 139522, 139523);

DELETE
FROM lessario WHERE n_id IN('DBB9A','D0286','D47F7');

DELETE LL.* 
FROM lila_db.lemlat_lila LL INNER JOIN lemmario ON lemlat_id_lemma=id_lemma
WHERE n_id IN('DBB9A','D0286','D47F7');

DELETE
FROM lemmario WHERE n_id IN('DBB9A','D0286','D47F7');

