/*
 Nel database di lemlat, ho corretto nel lessario il genere del les "escubitor" (pr_key 22221), facendolo passare da "f" a "m". 
Andrebbe di conseguenza rimosso il lemma "excubitor" con genere "f" (id_lemma 43610) anche dal lemmario.
Tuttavia, un constraint mi impedisce di farlo, dal momento che tale lemma è indicato come output di una relazione derivazionale 
nella tabella wfr_rel del derivational_db. 
Chiederei dunque a Eleonora di intervenire sul database derivazionale, rimuovendo la relazione che ha come output il lemma con id 43610. 
Non vanno operate altre modifiche, dal momento che è già presente anche una relazione con lo stesso input e come output il corrispondente
 lemma maschile (id_lemma 14837).
Tale relazione andrà anche eliminata dal db di lemlat nella tabella lemmas_wfr - non so se questo competa sempre a Eleonora, 
se venga fatto in automatico, oppure se possa/debba farlo io: fatemi sapere.
Passando al database di lila, il lemma corrispondente (sempre quello con genere femminile, id_lemma 101927) 
va deprecato, indicando come deprecante il corrispondente lemma maschile (id_lemma 101928).
Tale lemma ha però allacciate sia delle risorse lessicali sia delle risorse testuali.
Per quanto riguarda le risorse testuali (CompHistSem), vanno spostate sul lemma deprecante (come credo già avvenga automaticamente).
Per quanto riguarda invece le risorse lessicali (WFL e LatinAffectus), le entrate allacciate attualmente al lemma 
deprecato vanno eliminate, in quanto si tratta di doppioni di entrate già presenti e allacciate al lemma maschile 
(come già spiegato nel dettaglio sopra per quanto riguarda WFL).
Chiederei dunque a Paolo di procedere a tale deprecazione e alle altre modifiche necessarie - 
compresa la rimozione del lemma con id_lemma 43610 dal lemmario, a valle della correzione di Eleonora sul database derivazionale.
*/
/*
SELECT * FROM lemmario WHERE lemma='excubitor';
+----------+-----------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
| id_lemma | lemma     | codlem | gen | codmorf | n_id  | lemma_reduced | upostag | upostag_2 | ts                  | src |
+----------+-----------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
|    14837 | excubitor | N3B    | m   | NcC     | e1381 | excubitor     | NOUN    | NULL      | 2023-05-12 10:56:08 | B   |
|    43610 | excubitor | N3B    | f   | NcC     | e1381 | excubitor     | NOUN    | NULL      | 2023-05-12 10:56:08 | B   |
|    54253 | excubitor | N3B    | m   | NpC     | 31006 | excubitor     | PROPN   | NULL      | 2023-05-12 10:56:08 | O   |
+----------+-----------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
*/
-- aggiorno lemmas_wfr mediante apposita query
DELETE FROM lila_db.lemlat_lila WHERE lemlat_id_lemma=43610;
DELETE  FROM lemmario WHERE id_lemma=43610;

