-- BUGFIX:
/*
| lemma/10266  | 45694(4136),45693(4136)    | NpB,NpC    | -> la label/wr di lemma/10266 va corretta in "alectus" (ora è "alecto"). Niente da modificare in lemlat
*/

UPDATE lila_db.lemma SET label="alectus" WHERE id_lemma=10266;
DELETE FROM lila_db.lemma_wr WHERE id_lemma=10266 AND wr="alecto";

-- sdoppiare i lemmi 
/*
SELECT * FROM lemlat_lila INNER JOIN lemlat_db.lemmario ON lemlat_id_lemma=id_lemma WHERE n_id IN('D8F20','D8F28');
+-----------------+---------------+------------------+---------------------+----------+---------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
| lemlat_id_lemma | lila_id_lemma | lila_id_ipolemma | updatedAt           | id_lemma | lemma   | codlem | gen | codmorf | n_id  | lemma_reduced | upostag | upostag_2 | ts                  | src |
+-----------------+---------------+------------------+---------------------+----------+---------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
|          115782 |         62823 |             NULL | 2023-02-24 12:55:56 |   115782 | ludices | N3B    | f   | NcC     | D8F20 | ludices       | NOUN    | NULL      | 2023-05-12 10:56:08 | D   |
|          115781 |         62823 |             NULL | 2023-02-24 12:55:56 |   115781 | ludix   | N3B    | f   | NcC     | D8F28 | ludix         | NOUN    | NULL      | 2023-05-12 10:56:08 | D   |
+-----------------+---------------+------------------+---------------------+----------+---------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
2 rows in set (0,001 sec)

MariaDB [lila_db]> SELECT * FROM lilaLU WHERE id_lemma=62823;
+----------+--------------+--------------+-------+------+---------+---------+--------+------+------+------+---------+------+---------------------+
| id_lemma | id_ipolemma0 | id_ipolemma1 | class | type | label   | upostag | fl_cat | gen  | p    | grad | wrList  | src  | updatedAt           |
+----------+--------------+--------------+-------+------+---------+---------+--------+------+------+------+---------+------+---------------------+
|    62823 |         NULL |         NULL |     0 | NULL | ludices | NOUN    | n3     | f    | pt   | NULL | ludices | D    | 2023-07-07 14:03:13 |
+----------+--------------+--------------+-------+------+---------+---------+--------+------+------+------+---------+------+---------------------+
1 row in set (0,007 sec)

SELECT * FROM variant_group WHERE id_lemma=62823;
+----------+------------+---------------------+
| id_lemma | id_variant | updatedAt           |
+----------+------------+---------------------+
|    62823 | D8F20NOUN  | 2023-02-24 12:56:16 |
+----------+------------+---------------------+

*/

INSERT INTO lila_db.lemma(label,upostag, fl_cat, gen) VALUE('ludix', 'NOUN', 'n3', 'f');
SELECT LAST_INSERT_ID() INTO @ludix;
UPDATE lila_db.variant_group SET id_variant='D8F20NOUN' WHERE id_lemma=@ludix;
UPDATE lila_db.lemlat_lila SET lila_id_lemma=@ludix WHERE lemlat_id_lemma=115781;
