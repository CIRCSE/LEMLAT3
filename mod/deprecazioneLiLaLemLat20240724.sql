
/*
PIUS

lemma deprecato http://lila-erc.eu/data/id/lemma/71730 (pos ADJ, fl_cat n6i) source D
lemma deprecante http://lila-erc.eu/data/id/lemma/117996 (pos ADJ, fl_cat n6) source B

+----------+--------+------+------+------+-------+-------+---------+---------------------+
| id_lemma | fl_cat | gen  | p    | grad | label | n_id  | upostag | updatedAt           |
+----------+--------+------+------+------+-------+-------+---------+---------------------+
|    71730 | n6i    | *    | NULL | Pos  | pius  | DB078 | ADJ     | 2023-02-24 12:55:57 |
|   117996 | n6     | *    | NULL | Pos  | pius  | p2206 | ADJ     | 2023-02-24 12:55:57 |
+----------+--------+------+------+------+-------+-------+---------+---------------------+

NOTA: il lemma del Ducange è già stato deprecato in favore del lemma dell'onomasticon:
+---------+---------+-----------------------------+---------------------+
| n_idOLD | n_idNEW | lemmata                     | ts                  |
+---------+---------+-----------------------------+---------------------+
| DB078   | 63843   | pius_N2/1_*_Af-_lemma/71730 | 2023-07-10 13:33:19 |
+---------+---------+-----------------------------+---------------------+

+----------+-------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
| id_lemma | lemma | codlem | gen | codmorf | n_id  | lemma_reduced | upostag | upostag_2 | ts                  | src |
+----------+-------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
|    64675 | pius  | N2/1   | *   | Af-     | 63843 | pius          | ADJ     | NULL      | 2023-05-12 10:56:08 | O   |
+----------+-------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+

a cui è collegato il deprecante
+-----------------+---------------+------------------+---------------------+
| lemlat_id_lemma | lila_id_lemma | lila_id_ipolemma | updatedAt           |
+-----------------+---------------+------------------+---------------------+
|           64675 |         71730 |             NULL | 2023-02-24 12:55:56 |
+-----------------+---------------+------------------+---------------------+

+----------+--------+------+------+------+-------+-------+---------+---------------------+
| id_lemma | fl_cat | gen  | p    | grad | label | n_id  | upostag | updatedAt           |
+----------+--------+------+------+------+-------+-------+---------+---------------------+
|    71730 | n6i    | *    | NULL | Pos  | pius  | DB078 | ADJ     | 2023-02-24 12:55:57 |
+----------+--------+------+------+------+-------+-------+---------+---------------------+

accorpare onomasticon e base?
*/
CALL SP_deprecateClem('63843', 'p2206');

/*
PLURITER 

hypolemma deprecato http://lila-erc.eu/data/id/hypolemma/110317 (source D)
hypolemma deprecante http://lila-erc.eu/data/id/hypolemma/33754 (source B)

PLURITER http://lila-erc.eu/data/id/hypolemma/33754 va reso ipolemma anche di PLUS http://lila-erc.eu/data/id/lemma/118209
*/

/*
PLUS
lemma deprecato http://lila-erc.eu/data/id/lemma/72134 (pos ADJ, fl_cat n71) source D
lemma deprecante http://lila-erc.eu/data/id/lemma/118209 (pos ADJ, fl_cat n7p) source B

+----------+--------+------+------+------+-------+-------+---------+---------------------+
| id_lemma | fl_cat | gen  | p    | grad | label | n_id  | upostag | updatedAt           |
+----------+--------+------+------+------+-------+-------+---------+---------------------+
|    72134 | n71    | *    | NULL | Pos  | plus  | DB251 | ADJ     | 2023-02-24 12:55:57 |
|   118209 | n7p    | *    | NULL | NULL | plus  | p2389 | DET     | 2024-03-14 10:15:29 |
+----------+--------+------+------+------+-------+-------+---------+---------------------+


+----------+--------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
| id_lemma | lemma  | codlem | gen | codmorf | n_id  | lemma_reduced | upostag | upostag_2 | ts                  | src |
+----------+--------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
|   127977 | plus   | N3A    | *   | Af-     | DB251 | plus          | ADJ     | NULL      | 2023-05-12 10:56:08 | D   |
|    30660 | plus   | N3B    | n   | NcC     | p2389 | plus          | NOUN    | NULL      | 2023-05-12 10:56:08 | B   |
|    43757 | plures | N3A    | *   | Au-     | p2389 | plures        | ADJ     | NULL      | 2023-05-12 10:56:08 | B   |
+----------+--------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+

*/

CALL SP_deprecateClem('DB251', 'p2389');