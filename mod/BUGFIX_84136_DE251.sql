-- LemLat_db 
/*

    Lessario: 

Modifica riga in cui n_id = DE251 in questo modo: 
LES = uar 
SMV togli + 
LEM = -e
GEN= n 
CodLE= 5
*/
UPDATE lemlat_db.lessario SET
les = 'uar',
codles= 'n3n' 
smv = '', 
lem = '-e',
gen = 'n', 
codLE = '5'
WHERE n_id = 'DE251';


/*

    tab_le: 

Aggiungi riga: 
Lemma = uare 
codLe= 5
les_id = 134617
*/

INSERT INTO lemlat_db.tab_le(lemma, codLE, les_id)
VALUE ('uare', '5', 134617);


/*
    Lemmario: 

id_lemma: 143223
lemma = uare 
codlem= N3B
gen = n 
codmorf= NcC
lemma_reduced = uare 
upostag = NOUN
*/

UPDATE lemlat_db.lemmario SET
lemma = 'uare', 
codlem= 'N3B',
gen = 'n', 
codmorf= 'NcC',
lemma_reduced = 'uare', 
upostag = 'NOUN'
WHERE n_id = 'DE251';

/*
Lila_db

    Lemma: 

Per id_lemma = 84136 
fl_cat = n3n
gen = n 
label = uare
upostag = NOUN

    lemma_wr: 

id_lemma = 84136 
wr = uare 

    lemma_ipolemma: cancella gli ipolemmi di id_lemma = 84136
*/
UPDATE lila_db.lemma SET
fl_cat = 'n3n',
gen = 'n', 
label = 'uare', 
upostag = 'NOUN'
WHERE id_lemma = 84136;

/*
+----------+-------------+
| id_lemma | id_ipolemma |
+----------+-------------+
|    84136 |       90057 |
|    84136 |       90058 |
|    84136 |       90059 |
+----------+-------------+
*/

CALL SP_deprecateHypo(90057, NULL, NULL);
CALL SP_deprecateHypo(90058, NULL, NULL);
CALL SP_deprecateHypo(90059, NULL, NULL);

