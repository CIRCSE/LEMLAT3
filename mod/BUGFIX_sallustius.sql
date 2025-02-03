
/*
Il lemma "sallustius" va cambiato di PoS. Da ADJ a  PROPN.

##DB lila_db##
TABELLA lila_db.lemma
LEMMA id_lemma='20618'
MODIFICHE:
fl_cat = 'n6i' -->> 'n2'
gen = '*' -->> 'm'
grad = 'Pos' -->> NULL
upostag = 'ADJ' -->> 'PROPN'
RIMUOVERE/DEPRECARE L'IPOLEMMA CONNESSO A QUESTO LEMMA (id_ipolemma = '49320')
+----------+--------------+--------------+-------+---------+------------+---------+--------+------+------+------+------------+------+---------------------+
| id_lemma | id_ipolemma0 | id_ipolemma1 | class | type    | label      | upostag | fl_cat | gen  | p    | grad | wrList     | src  | updatedAt           |
+----------+--------------+--------------+-------+---------+------------+---------+--------+------+------+------+------------+------+---------------------+
|    20618 |         NULL |         NULL |     0 | NULL    | sallustius | ADJ     | n6i    | *    | NULL | Pos  | sallustius | O    | 2025-01-09 18:34:48 |
|    20618 |        49320 |         NULL |     1 | POS_ADV | sallustie  | ADV     | i      | NULL | NULL | Pos  | sallustie  | O    | 2025-01-09 18:34:48 |
+----------+--------------+--------------+-------+---------+------------+---------+--------+------+------+------+------------+------+---------------------+
*/
UPDATE lila_db.lemma SET
fl_cat = 'n2',
gen = 'm',
grad =  NULL,
upostag = 'PROPN'
WHERE id_lemma=20618;
CALL SP_deprecateHypo(49320, NULL, NULL);

/*
##DB lemlat_db##
TABELLA lemlat_db.lemmario
LEMMA id_lemma = '66029'
MODIFICHE:
codlem = 'N2/1' -->> 'N2'
gen = '*' -->> 'm'
codmorf = 'Af-' --> 'NpB'
upostag = 'ADJ' -->> 'PROPN'

+----------+------------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
| id_lemma | lemma      | codlem | gen | codmorf | n_id  | lemma_reduced | upostag | upostag_2 | ts                  | src |
+----------+------------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
|    66029 | sallustius | N2/1   | *   | Af-     | 72655 | sallustius    | ADJ     | NULL      | 2023-05-12 10:56:08 | O   |
+----------+------------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+

TABELLA lemlat_db,lessario
CLEM n_id = '72655'
pr_key = '80753'
MODIFICHE:
gen = '*' -->> 'm'
codles = 'n6i' -->> 'n2i'
type = NULL -->> 'p'

+-------+-----+------+----+-----+-----+---------+--------+-----+-------+-----+--------+------+-------+----+-------+-------+-------+--------+---------------------+-----+
| n_id  | gen | clem | si | smv | spf | les     | codles | lem | s_omo | piu | codlem | type | codLE | pt | a_gra | gra_u | notes | pr_key | ts                  | src |
+-------+-----+------+----+-----+-----+---------+--------+-----+-------+-----+--------+------+-------+----+-------+-------+-------+--------+---------------------+-----+
| 72655 | *   |      |    |     |     | sallust | n6i    |     |       |     |        |      |       |    |       |       | NULL  |  80753 | 2018-07-24 18:08:15 | O   |
+-------+-----+------+----+-----+-----+---------+--------+-----+-------+-----+--------+------+-------+----+-------+-------+-------+--------+---------------------+-----+

*/

UPDATE lemlat_db.lemmario
SET
codlem = 'N2',
gen = 'm',
codmorf = 'NpB',
upostag = 'PROPN'
WHERE id_lemma = 66029;


UPDATE lemlat_db.lessario
SET
gen = 'm',
codles = 'n2i',
type = 'p'
WHERE pr_key = 80753;

