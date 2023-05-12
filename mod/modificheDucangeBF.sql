
/*
MODIFICHE IN LEMLAT

PER TUTTI I VERBI CHE VANNO TRASFORMATI IN NOMI: 

TAB LESSARIO:
A partire dal pr_key dei les di tutti i lemmi che vanno trasformati in nomi, modifica: 

Gen 		NULL -> m 
Codles 		v3d -> n2 
Lem 		-or -> -i 
Pt 		NULL -> x

s_omo: se a fronte delle modifiche apportate nella tabella lessario la riga della tab lessario
      risultante è identica (al netto di n_id e pr_key) a una o più altre righe del lessario,
      popolare la colonna s_omo con il codice alfabetico progressivo di omografia.

I pr_key sono i seguenti: 
*/
/* */
-- SELECT * FROM lessario
UPDATE lessario
SET gen='m', codles='n2', lem='-i', pt='x'
WHERE pr_key IN(
125700
)
;
/* */

/*
TAB LEMMARIO: 
Prendere nella tabella lessario l’n_id delle righe che abbiano un pr key tra quelli riportati sopra.
Nella tabella lemmario modificare come segue le righe che hanno un valore nella colonna n_id tra quelli presi dal lessario: 

lemma: 	.*or -> .*i
lemma_reduced: 	.*or -> .*i
codlem 	V3  -> N2 
gen 		NULL -> m 
codmorf 	VmH -> NcB 
upostag 	VERB -> NOUN
*/
/* */
UPDATE lemmario
SET lemma=CONCAT(LEFT(lemma,LENGTH(lemma)-2),'i'),
    lemma_reduced=CONCAT(LEFT(lemma_reduced,LENGTH(lemma_reduced)-2),'i'),
    codlem='N2', gen='m', codmorf='NcB', upostag='NOUN'
WHERE n_id IN (
SELECT n_id FROM lessario
WHERE pr_key IN(
125700
)
);
/* */

