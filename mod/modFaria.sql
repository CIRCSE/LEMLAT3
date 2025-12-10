-- MODIFICA SOLO genere
/*
id_lemma	label	upostag	fl_cat	gen	p	grad	id_lemma	lemma	codlem	gen	codmorf	n_id	upostag
3227	cios	PROPN	n2e	m => 2	NULL	NULL	51192	cios	N2	1	NpB	16769	PROPN
3303	cius	PROPN	n2	m => 2	NULL	NULL	51254	cius	N2	m	NpB	17295	PROPN
3536	codrio	PROPN	n3	m => 2	NULL	NULL	51460	codrio	N3B	m	NpC	17967	PROPN
5134	aegissos	PROPN	n2e	m => 2	NULL	NULL	44937	aegissos	N2	1	NpB	2633	PROPN
14925	amorgos	PROPN	n2e	m => 2	NULL	NULL	46225	amorgos	N2	1	NpB	5308	PROPN
15672	neritos	PROPN	n2e	m => 2	NULL	NULL	61891	neritos	N2	1	NpB	54848	PROPN
16094	numistro	PROPN	n3	m => 2	NULL	NULL	62264	numistro	N3B	m	NpC	55832	PROPN
16790	anchialos	PROPN	n2e	m => 2	NULL	NULL	46487	anchialos	N2	1	NpB	5815	PROPN
17589	andros	PROPN	n2e	m => 2	NULL	NULL	46596	andros	N2	1	NpB	5972	PROPN
21090	apros	PROPN	n2e	m => 2	NULL	NULL	47131	apros	N2	m	NpB	7414	PROPN
5582	ebusus	PROPN	n2	f => 2	NULL	NULL	53124	ebusus	N2	f	NpB	27461	PROPN
24316	tyra	PROPN	n1	f => 2	NULL	NULL	69027	tyra	N1	f	NpA	86676	PROPN
*/
UPDATE lemlat_db.lemmario SET gen='2' WHERE id_lemma IN (51192,51254,51460,44937,46225,61891,62264,46487,46596,47131,53124,69027);
UPDATE lemlat_db.lessario SET gen='2' WHERE n_id IN ('16769','17295','17967','2633','5308','54848','55832','5815','5972','7414','27461','86676');

-- no-op
/*
97089	crystallus	NOUN	n2e	f => 2	NULL	NULL	10312	crystallum/-us	N2	3	NcB	c4479	NOUN
*/

/*
3392	addua	PROPN	n1	f => m	NULL	NULL	44646	addua	N1	f	NpA	1751	PROPN
*/
UPDATE lemlat_db.lemmario SET gen='m' WHERE id_lemma=44646;
UPDATE lemlat_db.lessario SET gen='m' WHERE n_id ='1751';

-- GEN + PT NB: pt già settato
/*
3489	clytidae	PROPN	n1	f => m	NULL => pt	NULL	51421	clytidae	N1	f	NpA	17741	PROPN
5069	aegeadae	PROPN	n1	f => m	NULL => pt	NULL	44890	aegeadae	N1	f	NpA	2578	PROPN
*/
UPDATE lemlat_db.lemmario SET gen='m' WHERE id_lemma IN (51421,44890);
UPDATE lemlat_db.lessario SET gen='m' WHERE n_id  IN ('17741', '2578');

-- PT. NB: già settato, nessuna modifica necessaria
/*
15870	niniuitae	PROPN	n1	2	NULL => pt	NULL	62071	niniuitae	N1	2	NpA	55188	PROPN
18583	phoenices	PROPN	n3	2	NULL => pt	NULL	64415	phoenices	N3B	2	NpC	63194	PROPN
4299	adryades	PROPN	n3	f	NULL => pt	NULL	44774	adryades	N3B	f	NpC	2255	PROPN
22679	syracusae	PROPN	n1	f	NULL => pt	NULL	67646	syracusae	N1	f	NpA	81863	PROPN
*/

-- PT
/*
7161	ferentinates	PROPN	n3	m	NULL => pt	NULL	54472	ferentinates	N3B	m	NpC	32769	PROPN
8737	harudes	PROPN	n3	m	NULL => pt	NULL	55869	harudes	N3B	m	NpC	37159	PROPN
*/
UPDATE lemlat_db.lessario SET pt='x' WHERE n_id  IN ('32769', '37159');



/*
9481	alabandeis => alabandis	ADJ	n6 => n7	*	NULL	Pos	45509	alabandeis	N2/1	*	Af-	3849	ADJ
lemma/9481 --> LEMMARIO: lemma[LEMLAT] = alabandis; codlem[lemlat] = N3A. LESSARIO: les=alaband, codles=n7, lem=NULL, codLE=NULL -->> vedi tabella tab_le
*/
UPDATE lemlat_db.lemmario SET lemma='alabandis', codlem = 'N3A' WHERE id_lemma=45509;
UPDATE lemlat_db.lessario SET les='alaband', codles='n7', lem='', codLE='' WHERE n_id='3849';
DELETE FROM lemlat_db.tab_le WHERE les_id IN (SELECT pr_key FROM lemlat_db.lessario  WHERE n_id='3849');

/*
4461	damascenus	ADJ	n2 => n6	m => *	NULL	NULL => Pos	52255	damascenus	N2	m	NpB	22856	PROPN
lemma/4461 -->> LEMMARIO: codlem[LEMLAT] = N2/1, gen[LEMLAT] = *, codmorf[LEMLAT] = Af-, upostag=ADJ. LESSARIO: gen=*, codles=n6, type=NULL
*/
UPDATE lemlat_db.lemmario SET codlem = 'N2/1', gen = '*', codmorf = 'Af-', upostag='ADJ' WHERE id_lemma=52255;
UPDATE lemlat_db.lessario SET gen='*', codles='n6', type='' WHERE n_id='22856';

/*
18916	pleiades	PROPN	n1e => n3e	f	NULL => pt	NULL	64723	pleiades	N1	f	NpA	64073	PROPN
lemma/18916 -->> LEMMARIO: codlem=N3B, codmorf=NpC. LESSARIO: codles=n3e, pt=x, codLE=NULL -->> vedi tabella tab_le
*/
UPDATE lemlat_db.lemmario SET codlem='N3B', codmorf='NpC' WHERE id_lemma=64723;
UPDATE lemlat_db.lessario SET codles='n3e', pt='x', codLE='' WHERE n_id='64073';
DELETE FROM lemlat_db.tab_le WHERE les_id IN (SELECT pr_key FROM lemlat_db.lessario  WHERE n_id='64073');

/*
5076	aegeates	PROPN	n3 => n1e	m	NULL	NULL	44892	aegeates	N3B	m	NpC	2580	PROPN
lemma/5076 -->> LEMMARIO: codlem=N1, codmorf=NpA. LESSARIO: codles=n1e
*/
UPDATE lemlat_db.lemmario SET codlem='N1', codmorf='NpA' WHERE id_lemma=44892;
UPDATE lemlat_db.lessario SET codles='n1e' WHERE n_id='2580';

/*
21450	seruilius	ADJ => PROPN	n6i => n2	* => m	NULL	Pos	66744	seruilius	N2/1	*	Af-	75710	ADJ
lemma/21450 -->> LEMMARIO: upostag[LEMLAT] = PROPN, codlem[LEMLAT] = N2, gen[LEMLAT] = m, codmorf[LEMLAT] = NpB. LESSARIO: gen=m, les=seruili, codles=n2
*/
UPDATE lemlat_db.lemmario SET upostag = 'PROPN', codlem = 'N2', gen = 'm', codmorf = 'NpB' WHERE id_lemma=66744;
UPDATE lemlat_db.lessario SET gen='m', les='seruili', codles='n2' WHERE n_id='75710';

/*
89066	anicetus	ADJ => PROPN	n6 => n2	* => m	NULL	Pos	2360	anicetus	N2/1	*	Af-	a2020	ADJ
lemma/89066 -->> LEMMARIO: upostag[LEMLAT] = PROPN, codlem[LEMLAT] = N2, gen[LEMLAT] = m, codmorf[LEMLAT] = NpB. LESSARIO: gen=m, codles=n2
*/
UPDATE lemlat_db.lemmario SET upostag = 'PROPN', codlem = 'N2', gen = 'm', codmorf = 'NpB' WHERE id_lemma=2360;
UPDATE lemlat_db.lessario SET gen='m', codles='n2' WHERE n_id='a2020';

/*
29951	amphimallus	NOUN => ADJ	n2 => n6	m => *	NULL	NULL => Pos	74781	amphimallus	N2	m	NcB	D0GAA	NOUN
lemma/29951 -->> LEMMARIO: upostag[LEMLAT] = ADJ, codlem[LEMLAT] = N2/1, gen[LEMLAT] = *, codmorf[LEMLAT] = Af-. LESSARIO: gen=*, codles=n6
*/
UPDATE lemlat_db.lemmario SET upostag = 'ADJ', codlem = 'N2/1', gen = '*', codmorf = 'Af-' WHERE id_lemma=74781;
UPDATE lemlat_db.lessario SET gen='*', codles='n6' WHERE n_id='D0GAA';

/*
58171	iamtum	NOUN => ADV	n2n => i	n => N	NULL	NULL	109783	iamtum	N2	n	NcB	D7BB0	NOUN
lemma/58171 -->> LEMMARIO: upostag[LEMLAT] = ADV, codlem[LEMLAT] = I, gen[LEMLAT] = NULL, codmorf[LEMLAT] = X--. LESSARIO: gen=NULL, les=iamtum, codles=i
*/
UPDATE lemlat_db.lemmario SET upostag = 'ADV', codlem = 'I', gen = '', codmorf = 'X--' WHERE id_lemma=109783;
UPDATE lemlat_db.lessario SET gen='', les='iamtum', codles='i' WHERE n_id='D7BB0';
