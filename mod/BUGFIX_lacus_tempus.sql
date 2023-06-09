/*
"lacus"
Esistono due "lacus" nel lila_db, rispettivamente di quarta e seconda declinazione (110374, 110370).
Entrambi i lemmi vengono dalla base di lemlat. La flessione di seconda declinazione è menzionata dal OLD.
Proporrei di metterli in rapporto di LemmaVariant nel lila_db, ma prima di chiederlo @Paolo vorrei che tu verificassi la loro derivazione, perché, sulla base di WFL, appartengono a due Basi derivazionali diverse in lila_db (2034, 2035). E' giusto? Se lo fosse, non andrebbero messi in relazione di LemmaVariant.
==> OK. derivational modificato, mettere i lemmi in relazione e reimportare le i dati di derivazione
+----------+------------+---------------------+
| id_lemma | id_variant | updatedAt           |
+----------+------------+---------------------+
|   110370 | l0665NOUN  | 2023-02-24 12:56:16 |
|   110374 | l0668NOUN  | 2023-02-24 12:56:16 |
+----------+------------+---------------------+
*/
-- UPDATE lila_db.variant_group SET id_variant='l0665NOUN' WHERE id_lemma=110374;
/*
"tempus"
Esistono tre "tempus" (NOUN) nel lila_db:
- 127522 (da lemlat base), n3n: è il tempo cronologico -> ok
- 127796 (da lemlat base), n3n: è la tempia -> è linkato alla medesima entrata del L&S di "tempus" come tempo cronologico.
Per favore, segnala @Paolo l'id dell'entrata del L&S corretta (quella di "tempus" come "tempia"),
così che lui corregga il link

@Paolo: 132377, n2 (da lemlat Du Cange): è mal registrato in lemlat. Non è un nome di seconda declinazione, ma di terza.
Va corretto come segue.
#lemlat_db#
Tabella "lessario". Correggere la riga con pr_key='177865' sul modello di quella con pr_key ='59312' ->
e riportare il lemma eccezionale con il suo codice (5) in tab_le
Tabella "lemmario". Correggere la riga con id_lemma='153949' sul modello di quella con id_lemma='39877'.
Il lemma con id_lemma='153949' diventa dunque un doppione del lemmario di base e va, quindi, rimosso.
#lila_db#
Il lemma 132377 va deprecato. Le risorse ad esso collegato non dovrebbero essere spostate sugli altri lemmi, perché lo sono già (casi di token di "tempus" non disambiguati).
=> uso come deprecante il lemma 127522 (corrispondente al lemma di LemLat 39877)
*/
-- CALL SP_deprecateLemma(132377,127522, NULL);


-- LEMLAT
/*

+-------+-----+------+----+-----+-----+--------+--------+--------+-------+-----+--------+------+-------+----+-------+-------+-------+--------+---------------------+-----+
| n_id  | gen | clem | si | smv | spf | les    | codles | lem    | s_omo | piu | codlem | type | codLE | pt | a_gra | gra_u | notes | pr_key | ts                  | src |
+-------+-----+------+----+-----+-----+--------+--------+--------+-------+-----+--------+------+-------+----+-------+-------+-------+--------+---------------------+-----+
| t0008 | n   | v    |    |     |     | tempor | n3n1   | tempus | a     |     |        |      | 5     |    |       |       |       |  59312 | 2018-07-24 18:08:15 | B   |
| DEG62 | m   |      |    |     |     | temp   | n2     |        |       |     |        |      |       |    |       |       |       | 177865 | 2020-01-07 17:58:06 | D   |
+-------+-----+------+----+-----+-----+--------+--------+--------+-------+-----+--------+------+-------+----+-------+-------+-------+--------+---------------------+-----+

+--------+-------+--------+--------+
| lemma  | codLE | les_id | pr_key |
+--------+-------+--------+--------+
| tempus | 5     |  59312 |   3791 |
+--------+-------+--------+--------+

+----------+--------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
| id_lemma | lemma  | codlem | gen | codmorf | n_id  | lemma_reduced | upostag | upostag_2 | ts                  | src |
+----------+--------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
|    39877 | tempus | N3B    | n   | NcC     | t0008 | tempus        | NOUN    | NULL      | 2023-05-04 11:50:23 | B   |
|   153949 | tempus | N2     | m   | NcB     | DEG62 | tempus        | NOUN    | NULL      | 2023-05-04 11:50:23 | D   |
+----------+--------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+

*/
UPDATE lemlat_db.lessario SET gen='n', clem='v', les='tempor', codles='n3n1', lem='tempus', s_omo='a', codLE='5'
WHERE  pr_key=177865;

INSERT INTO lemlat_db.tab_le(lemma, codLE, les_id) VALUE('tempus','5',177865);

UPDATE lemlat_db.lemmario SET codlem='N3B', gen='n', codmorf='NcC' WHERE id_lemma =153949;
