
-- NOTA esiste corrispondenza 1:1 fra lemmi e n_id eccetto in un caso:
/*
+-------+--------+-----+---------+----------+---------+---------+------+------+------+--------------------------------------------------------------------------------------------+--------------+
| lemma | codlem | gen | codmorf | NoLemLat | NoLiLaL | NoLiLaH | NoB  | NoO  | NoD  | LemLatLST                                                                                  | LiLaLST      |
+-------+--------+-----+---------+----------+---------+---------+------+------+------+--------------------------------------------------------------------------------------------+--------------+
| domus | N2     | f   | NcB     |        7 |       1 |       0 |    1 |    0 |    6 | 97443(D5566),97445(D5568),97447(D556A),97442(D5565),97446(D5569),97444(D5567),12994(d2164) | lemma/100070 |
| domus | N4     | f   | NcD     |        7 |       1 |       0 |    1 |    0 |    6 | 97453(D556A),97451(D5568),97452(D5569),97450(D5567),97449(D5566),97448(D5565),12996(d2164) | lemma/100071 |
+-------+--------+-----+---------+----------+---------+---------+------+------+------+--------------------------------------------------------------------------------------------+--------------+
*/
INSERT INTO deprecationMap(n_idNEW, n_idOLD, lemmata)
SELECT  K.n_id n_idNEW, T.n_id n_idOLD, GROUP_CONCAT(CONCAT_WS('_',lemma, codlem, gen, codmorf)) lemmata
FROM keep K INNER JOIN throw T USING(lemma, codlem, gen, codmorf)
GROUP BY K.n_id, T.n_id
;

/*
INSERIMENTO MANUALE:
=============================
1.
(*) per i gruppi seguenti esiste più di un candidato :
+------------+--------+-----+---------+----------+---------+---------+------+------+------+---------------------------------------------------------------------+--------------+
| lemma      | codlem | gen | codmorf | NoLemLat | NoLiLaL | NoLiLaH | NoB  | NoO  | NoD  | LemLatLST                                                           | LiLaLST      |
+------------+--------+-----+---------+----------+---------+---------+------+------+------+---------------------------------------------------------------------+--------------+
| augustinus | N2/1   | *   | Af-     |        3 |       1 |       0 |    0 |    2 |    1 | 48429(10162),48430(10164),78796(D1CA9)                              | lemma/33193  |
| baebius    | N2/1   | *   | Af-     |        3 |       1 |       0 |    0 |    2 |    1 | 48741(10881),48742(10882),79471(D1EGC)                              | lemma/33767  |
| manna      | N1     | f   | NcA     |        5 |       1 |       0 |    2 |    0 |    3 | 24051(m0302),24052(m9981),117088(D9185),117087(D9184),117089(D9186) | lemma/113308 |
+------------+--------+-----+---------+----------+---------+---------+------+------+------+---------------------------------------------------------------------+--------------+

Come eseguire il raggruppamento?
MARCO:
- augustinus: tieni 48429(10162). Rimuovi gli altri 2
- baebius: tieni 1 qualsiasi dei 2 lemmi dell'Onomasticon. Rimuovi gli altri 2
- manna: tieni i 2 lemmi della Base. Rimuovi i 3 lemmi dell'Onomasticon
*/

INSERT INTO deprecationMap(lemmata, n_idNEW, n_idOLD) VALUES
( 'augustinus_N2/1_*_Af-', '10162', '10164'),
( 'augustinus_N2/1_*_Af-', '10162', 'D1CA9'),
( 'baebius_N2/1_*_Af-', '10881', '10882'),
( 'baebius_N2/1_*_Af-', '10881', 'D1EGC'),
( 'manna_N1_f_NcA', 'm0302', 'D9185'),
( 'manna_N1_f_NcA', 'm0302', 'D9184'),
( 'manna_N1_f_NcA', 'm0302', 'D9186'),

/*
2. problemi di accorpamento automatico.
====== NOTA:
       per le entrate non accorpate è necessario creare corrispondenti entrate in LiLa 
--
inlex	N3A	*	Af-	D808H	D8090
non bisogna fare niente
--
cardo	N3B	m	NcC	c0633	D314B,D314C
D314B, che va mantenuto
*************  ????
--
ales	N3B	2	NcC	a1332	D0BH3
--
lar	N3B	m	NcC	D889G	D889H,D88A0
--
mas	N3B	m	NcC	m0417	D93E6
=NB= ha un omografo
--
merges	N3B	f	NcC	m0801	D9788,D9789
--
sanguis	N3B	m	NcC	DCD0D	DCD0G,DCD0H,DCD0E,DCD0F
Nel caso di "sanguis", il lemma da tenere è DCD0F (invece di DCD0D):
tutti gli altri sono da eliminare.
=NB= chedk derivational OK
--
uis	N3B	f	NcC	u0804	DE7D7,DE7D8,DE7D5,DE7D6
Nel caso di "uis", procedere all'eliminazione di tutti i candidati, tranne che di DE7D6 (che è da tenere)
vanno tutte eliminate (accorpate a quella della Base: u0804),
tranne quella indicata (DE7D6), che resta e non va accorpata a niente.
*/

('cardo_N3B_m_NcC', 'c0633', 'D314C'),
('sanguis_N3B_m_NcC', 'DCD0F', 'DCD0D'),
('sanguis_N3B_m_NcC', 'DCD0F', 'DCD0G'),
('sanguis_N3B_m_NcC', 'DCD0F', 'DCD0H'),
('sanguis_N3B_m_NcC', 'DCD0F', 'DCD0E'),
('uis_N3B_f_NcC', 'u0804', 'DE7D7'),
('uis_N3B_f_NcC', 'u0804', 'DE7D8'),
('uis_N3B_f_NcC', 'u0804', 'DE7D5')
;

