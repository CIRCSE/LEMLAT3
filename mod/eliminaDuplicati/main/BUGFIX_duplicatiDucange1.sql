
-- ============= Errori riscontrati in fase di eliminazione dei duplicati Ducange
-- ============= NB: lemlat_db ---> lila_db
/*
Per il gruppo
+---------+--------+-----+---------+----------+---------+---------+------+------+------+---------------------------+-------------+
| lemma   | codlem | gen | codmorf | NoLemLat | NoLiLaL | NoLiLaH | NoB  | NoO  | NoD  | LemLatLST                 | LiLaLST     |
+---------+--------+-----+---------+----------+---------+---------+------+------+------+---------------------------+-------------+
| bibleus | N2/1   | *   | Af-     |        2 |       1 |       0 |    0 |    0 |    2 | 81355(D2310),81356(D2311) | lemma/35355 |
+---------+--------+-----+---------+----------+---------+---------+------+------+------+---------------------------+-------------+

I  due lemmi fra cui operare la scelta sono entrambi citati in derivational_db:

+------------+------------+----------+-------+-----------+--------+-------+------------+----------+----------+-------+-----------+--------+---------+----------+-------------------+
| i_id_lemma | i_lemma    | i_codlem | i_gen | i_codmorf | i_n_id | i_ord | o_id_lemma | o_lemma  | o_codlem | o_gen | o_codmorf | o_n_id | wfr_key | category | type              |
+------------+------------+----------+-------+-----------+--------+-------+------------+----------+----------+-------+-----------+--------+---------+----------+-------------------+
|      81356 | bibleus    | N2/1     | *     | Af-       | D2311  |     1 |      81373 | biblosus | N2/1     | *     | Af-       | D2320  | 183     | A-To-A   | Derivation_Suffix |
|       4613 | biblus/-os | N2       | f     | NcB       | b0310  |     1 |      81355 | bibleus  | N2/1     | *     | Af-       | D2310  | 58      | N-To-A   | Derivation_Suffix |
+------------+------------+----------+-------+-----------+--------+-------+------------+----------+----------+-------+-----------+--------+---------+----------+-------------------+
i due lemmi 'bibleus' sono in effetti distinti?
MARCO:
- no. Non sono distinti.
Vanno unificati, scegliendo di tenere uno qualsiasi dei 2. La derivazione, dunque, è biblus/-os -> bibleus -> biblosus
NB: le regole gi accorpamento prevedono di tenere il lemma con id minore,perciò non serve altro
*/

UPDATE derivational_db.wfr_rel SET i_id_lemma=81355 WHERE i_id_lemma=81356;

/*
Problemi di ELIMINAZIONE:
=========================

Per i gruppi seguenti i lemmi da 'eliminare' sono riferiti in una o più regole di derivazione:

+----------+--------+-----+---------+----------+---------+---------+------+------+------+------------------------------------------+-------------+
| lemma    | codlem | gen | codmorf | NoLemLat | NoLiLaL | NoLiLaH | NoB  | NoO  | NoD  | LemLatLST                                | LiLaLST     |
+----------+--------+-----+---------+----------+---------+---------+------+------+------+------------------------------------------+-------------+
| lanius   | N2/1   | *   | Af-     |        2 |       1 |       0 |    0 |    1 |    1 | 113558(D882H),57974(45754)               | lemma/61275 |
| legius   | N2/1   | *   | Af-     |        2 |       1 |       0 |    0 |    1 |    1 | 114327(D8A7A),58285(46476)               | lemma/61771 |
| madius   | N2/1   | *   | Af-     |        3 |       1 |       0 |    0 |    1 |    2 | 116156(D8G87),116155(D8G86),59402(48988) | lemma/63100 |
| modius   | N2/1   | *   | Af-     |        3 |       1 |       0 |    0 |    1 |    2 | 61118(52549),119817(D9AF9),119818(D9AFA) | lemma/65979 |
| ponticus | N2/1   | *   | Af-     |        2 |       1 |       0 |    0 |    1 |    1 | 64935(64692),128439(DB3DE)               | lemma/72495 |
+----------+--------+-----+---------+----------+---------+---------+------+------+------+------------------------------------------+-------------+
MARCO:
- lanius: il lemma dell'Onomasticon va corretto in un nome proprio,
               perché è il nome di un console (fl_cat=n2; gen=m; upostag=PROPN)
          -> non va eliminato nessun lemma; va creato il PROPN in LiLa
- legius: il lemma dell'Onomasticon va corretto in un nome proprio,
          perché è il nome di una gens romana e non ha a che fare con il "legius" dell Du Cange (fl_cat=n2; gen=m; upostag=PROPN) ->
          non va eliminato nessun lemma; va creato il PROPN in LiLa
- madius: il lemma dell'Onomasticon va corretto in un nome proprio,
          perché è il nome di una gens romana (fl_cat=n2; gen=m; upostag=PROPN).
          Dei due lemmi del Du Cange, uno va corretto in un nome comune (fl_cat=n2; gen=m; upostag=NOUN). 
          -> non va eliminato nessun lemma; vanno creati il PROPN e il NOUN in LiLa
- modius: il lemma dell'Onomasticon va corretto in un nome proprio,
          perché è il nome di una console (fl_cat=n2; gen=m; upostag=PROPN).
          Dei due lemmi del Du Cange, uno va corretto in un nome comune (fl_cat=n2; gen=m; upostag=NOUN) e poi
          va eliminato (perché è un doppione con il nome comune "modius" della Base).
          -> va creato il PROPN in LiLa
- ponticus: probabile errore in WFL. Segnalo a Eleonora.
== OK : corretta refola deri che non contiene più il riderimento al duCange.
Ecco come intervenire sulle righe del lessario dei lemmi in questione:

--- aggiunta:
legius (n_id='46476'); lanius(n_id=''45754'); madius (n_id='48988'); modius (n_id='52549')
LESSARIO:
- gen= '*' -> m'
- codles= 'n6i' -> n2i'
- type='p'
LEMMARIO:
- codlem='N2/1' -> N2
- gen= '*' -> m'
- codmorf='Af-' -> 'NpB'
- upostag='ADJ' -> 'PROPN'

madius & modius (src='D' -> dei 2 'madius' e dei 2 'modius'
                 modificare quello che non è coinvolto in una regola di formazione da WFL)
LESSARIO:
- gen= '*' -> m'
- codles= 'n6i' -> n2i'
- type='p'
LEMMARIO:
- codlem='N2/1' -> N2
- gen= '*' -> m'
- codmorf='Af-' -> 'NcB'
- upostag='ADJ' -> 'NOUN'

=== NOTA: le modifiche dovrebbereo esssere tali da escludere alcun raggruppamemto
*/
UPDATE lessario SET gen='m', codles='n2i', type='p'
WHERE n_id IN ('46476','45754','48988','52549');

UPDATE lemmario SET gen='m', codlem='N2', codmorf='NcB', upostag='PROPN'
WHERE n_id IN ('46476','45754','48988','52549');

--  **************  lila_db ****************
INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag)
SELECT lemma, n_id, 'n2','PROPN'  FROM lemlat_db.lemmario
WHERE n_id IN ('46476','45754','48988','52549');

UPDATE
( SELECT id_lemma lemlat_id_lemma, n_id FROM lemlat_db.lemmario WHERE n_id IN ('46476','45754','48988','52549') AND  upostag='PROPN' ) L1
INNER JOIN lila_db.lemlat_lila USING(lemlat_id_lemma)
INNER JOIN 
( SELECT id_lemma, n_id FROM lila_db.lemma WHERE n_id IN ('46476','45754','48988','52549') AND  upostag='PROPN' ) L2
USING( n_id )
SET lila_id_lemma=L2.id_lemma;
--  **************  lila_db ****************


UPDATE lessario SET gen='m', codles='n2i', type='p'
WHERE n_id IN ('D9AFA','D8G87');

UPDATE lemmario SET gen='m', codlem='N2', codmorf='NcB', upostag='NOUN'
WHERE n_id IN ('D9AFA','D8G87');

