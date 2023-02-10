
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
142977,
122168,
130485,
128268,
124246,
122641,
123211,
125646,
122015,
129580,
122293,
122903,
130354,
125666,
125659,
126381,
130623,
129117,
128249,
126916,
122798,
126137,
131915,
127889,
122565,
131650,
120976,
132226,
124159,
128096,
126797,
128562,
129969,
123888,
122395,
131849,
125902
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
142977,
122168,
130485,
128268,
124246,
122641,
123211,
125646,
122015,
129580,
122293,
122903,
130354,
125666,
125659,
126381,
130623,
129117,
128249,
126916,
122798,
126137,
131915,
127889,
122565,
131650,
120976,
132226,
124159,
128096,
126797,
128562,
129969,
123888,
122395,
131849,
125902
)
);
/* */


/*
PER TUTTI I VERBI CHE VANNO TRASFORMATI IN AGGETTIVI: 

TAB LESSARIO:
A partire dal pr_key di tutti i verbi che vanno trasformati in aggettivi, modifica: 
Gen 		NULL -> *
Codles 		v3d -> n6 
Lem 		-or -> -i 
Pt 		NULL -> x 

s_omo: se a fronte delle modifiche apportate nella tabella lessario la riga della tab lessario
        risultante è identica (al netto di n_id e pr_key) a una o più altre righe del lessario,
        popolare la colonna s_omo con il codice alfabetico progressivo di omografia.

I pr_key sono i seguenti:

Lemmi che vanno trasformati in  ADJ
*/

/* */
-- SELECT * FROM lessario
UPDATE lessario
SET gen='*', codles='n6', lem='-i', pt='x'
WHERE pr_key IN(
130836,
130630,
124759,
125092,
124337,
123660,
132102,
126863,
129552,
126273,
130127,
126430
)
;
/* */

/*
TAB LEMMARIO: 
Prendere nella tabella lessario l’n_id delle righe che abbiano un pr key tra quelli riportati sopra. Nella tabella lemmario modificare come segue le righe che hanno un valore nella colonna n_id tra quelli presi dal lessario: 

lemma: 	.*or -> .*i
lemma_reduced: 	.*or -> .*i
codlem 	V3 -> N2/1
gen 		NULL -> m 
codmorf 	VmH -> Af- 
upostag 	VERB -> ADJ

*/
-- NB: è sbagliato il genere?
/* */
UPDATE lemmario
SET lemma=CONCAT(LEFT(lemma,LENGTH(lemma)-2),'i'),
    lemma_reduced=CONCAT(LEFT(lemma_reduced,LENGTH(lemma_reduced)-2),'i'),
    codlem='N2/1', gen='*', codmorf='Af-', upostag='ADJ'
WHERE n_id IN (
SELECT n_id FROM lessario
WHERE pr_key IN(
130836,
130630,
124759,
125092,
124337,
123660,
132102,
126863,
129552,
126273,
130127,
126430
)
)
;
/* */

-- SISETMO s_omo
/*
+---------------+-----------+
| pr_keyList    | s_omoList |
+---------------+-----------+
| 83845,126430  | ,         |
| 83977,129552  | ,a        |
| 84523,126863  | ,         |
| 84132,126273  | ,         |
| 84478,130127  | ,         |
| 4500,123211   | ,         |
| 129580,170206 | a,c       |
| 122015,164851 | b,a       |
| 122641,165449 | a,b       |
+---------------+-----------+
*/

-- | 83845,126430  | ,         |
UPDATE lessario SET s_omo='a' WHERE pr_key=83845;
UPDATE lessario SET s_omo='b' WHERE pr_key=126430;

-- | 83977,129552  | ,a        |
UPDATE lessario SET s_omo='b' WHERE pr_key=83977;

-- | 84523,126863  | ,         |
UPDATE lessario SET s_omo='a' WHERE pr_key=84523;
UPDATE lessario SET s_omo='b' WHERE pr_key=126863;

-- | 84132,126273  | ,         |
UPDATE lessario SET s_omo='a' WHERE pr_key=84132;
UPDATE lessario SET s_omo='b' WHERE pr_key=126273;

-- | 84478,130127  | ,         |
UPDATE lessario SET s_omo='a' WHERE pr_key=84478;
UPDATE lessario SET s_omo='b' WHERE pr_key=130127;

-- | 4500,123211   | ,         |
UPDATE lessario SET s_omo='a' WHERE pr_key=4500;
UPDATE lessario SET s_omo='b' WHERE pr_key=123211;
