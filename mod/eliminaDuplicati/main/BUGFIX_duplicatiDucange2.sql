/*
SELECT lemma, codlem, gen, codmorf,
       COUNT(*) NoLemLat, COUNT(DISTINCT IF(lila_id_ipolemma IS NULL, lila_id_lemma, NULL)) NoLiLaL,
       COUNT(DISTINCT lila_id_ipolemma) NoLiLaH,
       SUM(src='B') NoB,SUM(src='O') NoO, SUM(src='D') NoD,
       GROUP_CONCAT( CONCAT(id_lemma,'(',n_id,')' ) ) LemLatLST,
       GROUP_CONCAT( DISTINCT COALESCE(CONCAT('hypolemma/',lila_id_ipolemma),CONCAT('lemma/',lila_id_lemma))) LiLaLST
FROM lemmario LEFT JOIN lila_db.lemlat_lila ON id_lemma=lemlat_id_lemma WHERE src<>'F'
GROUP BY lemma, codlem, gen, codmorf
HAVING (NoD=1 AND NoLemLat>1 OR NoD>1) AND NoLiLaH+NoLiLaL=1
       -- filtro casi da trattare manualmente
       AND ( ( lemma IN ('cardo', 'inlex', 'ales', 'lar', 'merges', 'sanguis', 'uis')
       OR  lemma='mas' AND codlem='N3B' ) )
;
+---------+--------+-----+---------+----------+---------+---------+------+------+------+-----------------------------------------------------------------------+--------------+
| lemma   | codlem | gen | codmorf | NoLemLat | NoLiLaL | NoLiLaH | NoB  | NoO  | NoD  | LemLatLST                                                             | LiLaLST      |
+---------+--------+-----+---------+----------+---------+---------+------+------+------+-----------------------------------------------------------------------+--------------+
| ales    | N3B    | 2   | NcC     |        2 |       1 |       0 |    1 |    0 |    1 | 73455(D0BH3),1555(a1332)                                              | lemma/88292  |
| cardo   | N3B    | m   | NcC     |        3 |       1 |       0 |    1 |    0 |    2 | 5902(c0633),86303(D314B),86296(D314C)                                 | lemma/92844  |
| inlex   | N3A    | *   | Af-     |        2 |       1 |       0 |    0 |    0 |    2 | 111546(D808H),111550(D8090)                                           | lemma/106236 |
| lar     | N3B    | m   | NcC     |        3 |       1 |       0 |    0 |    0 |    3 | 113823(D889G),113821(D889H),113822(D88A0)                             | lemma/61370  |
| mas     | N3B    | m   | NcC     |        2 |       1 |       0 |    1 |    0 |    1 | 116450(D93E6),24188(m0417)                                            | lemma/111653 |
| merges  | N3B    | f   | NcC     |        3 |       1 |       0 |    1 |    0 |    2 | 118862(D9788),118863(D9789),24640(m0801)                              | lemma/112119 |
| sanguis | N3B    | m   | NcC     |        5 |       1 |       0 |    0 |    0 |    5 | 136073(DCD0F),136072(DCD0D),136071(DCD0G),136070(DCD0H),136069(DCD0E) | lemma/123363 |
| uis     | N3B    | f   | NcC     |        5 |       1 |       0 |    1 |    0 |    4 | 42448(u0804),143219(DE7D8),143220(DE7D7),143221(DE7D6),143218(DE7D5)  | lemma/130360 |
+---------+--------+-----+---------+----------+---------+---------+------+------+------+-----------------------------------------------------------------------+--------------+
*/


-- INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)

-- inlex	N3A	*	Af-	D808H	D8090
INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)
SELECT lemlat.lemma, 'D8090', lila.fl_cat, lila.upostag, lila.gen, lila.p, lila.grad
FROM lila_db.lemma lila
INNER JOIN lila_db.lemlat_lila ON lila_id_lemma=lila.id_lemma
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
WHERE lemma='inlex' AND codlem='N3A' AND lemlat.gen='*' AND codmorf='Af-' AND lemlat.n_id='D808H';
SELECT LAST_INSERT_ID() INTO @CUR_id_lemma;
UPDATE lila_db.lemlat_lila 
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
SET lila_id_lemma=@CUR_id_lemma
WHERE lemma='inlex' AND codlem='N3A' AND lemlat.gen='*' AND codmorf='Af-' AND lemlat.n_id='D8090';

-- cardo	N3B	m	NcC	c0633	D314B
INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)
SELECT lemlat.lemma, 'D314B', lila.fl_cat, lila.upostag, lila.gen, lila.p, lila.grad
FROM lila_db.lemma lila
INNER JOIN lila_db.lemlat_lila ON lila_id_lemma=lila.id_lemma
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
WHERE lemma='cardo' AND codlem='N3B' AND lemlat.gen='m' AND codmorf='NcC' AND lemlat.n_id='c0633';
SELECT LAST_INSERT_ID() INTO @CUR_id_lemma;
UPDATE lila_db.lemlat_lila 
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
SET lila_id_lemma=@CUR_id_lemma
WHERE lemma='cardo' AND codlem='N3B' AND lemlat.gen='m' AND codmorf='NcC' AND lemlat.n_id='D314B';

-- ales	N3B	2	NcC	a1332	D0BH3
INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)
SELECT lemlat.lemma, 'D0BH3', lila.fl_cat, lila.upostag, lila.gen, lila.p, lila.grad
FROM lila_db.lemma lila
INNER JOIN lila_db.lemlat_lila ON lila_id_lemma=lila.id_lemma
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
WHERE lemma='ales' AND codlem='N3B' AND lemlat.gen='2' AND codmorf='NcC' AND lemlat.n_id='a1332';
SELECT LAST_INSERT_ID() INTO @CUR_id_lemma;
UPDATE lila_db.lemlat_lila 
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
SET lila_id_lemma=@CUR_id_lemma
WHERE lemma='ales' AND codlem='N3B' AND lemlat.gen='2' AND codmorf='NcC' AND lemlat.n_id='D0BH3';

-- lar	N3B	m	NcC	D889G	D889H,D88A0
INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)
SELECT lemlat.lemma, 'D889H', lila.fl_cat, lila.upostag, lila.gen, lila.p, lila.grad
FROM lila_db.lemma lila
INNER JOIN lila_db.lemlat_lila ON lila_id_lemma=lila.id_lemma
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
WHERE lemma='lar' AND codlem='N3B' AND lemlat.gen='m' AND codmorf='NcC' AND lemlat.n_id='D889G';
SELECT LAST_INSERT_ID() INTO @CUR_id_lemma;
UPDATE lila_db.lemlat_lila 
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
SET lila_id_lemma=@CUR_id_lemma
WHERE lemma='lar' AND codlem='N3B' AND lemlat.gen='m' AND codmorf='NcC' AND lemlat.n_id='D889H';

INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)
SELECT lemlat.lemma, 'D88A0', lila.fl_cat, lila.upostag, lila.gen, lila.p, lila.grad
FROM lila_db.lemma lila
INNER JOIN lila_db.lemlat_lila ON lila_id_lemma=lila.id_lemma
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
WHERE lemma='lar' AND codlem='N3B' AND lemlat.gen='m' AND codmorf='NcC' AND lemlat.n_id='D889G';
SELECT LAST_INSERT_ID() INTO @CUR_id_lemma;
UPDATE lila_db.lemlat_lila 
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
SET lila_id_lemma=@CUR_id_lemma
WHERE lemma='lar' AND codlem='N3B' AND lemlat.gen='m' AND codmorf='NcC' AND lemlat.n_id='D88A0';

-- mas	N3B	m	NcC	m0417	D93E6
INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)
SELECT lemlat.lemma, 'D93E6', lila.fl_cat, lila.upostag, lila.gen, lila.p, lila.grad
FROM lila_db.lemma lila
INNER JOIN lila_db.lemlat_lila ON lila_id_lemma=lila.id_lemma
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
WHERE lemma='mas' AND codlem='N3B' AND lemlat.gen='m' AND codmorf='NcC' AND lemlat.n_id='m0417';
SELECT LAST_INSERT_ID() INTO @CUR_id_lemma;
UPDATE lila_db.lemlat_lila 
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
SET lila_id_lemma=@CUR_id_lemma
WHERE lemma='mas' AND codlem='N3B' AND lemlat.gen='m' AND codmorf='NcC' AND lemlat.n_id='D93E6';

-- merges	N3B	f	NcC	m0801	D9788,D9789
INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)
SELECT lemlat.lemma, 'D9788', lila.fl_cat, lila.upostag, lila.gen, lila.p, lila.grad
FROM lila_db.lemma lila
INNER JOIN lila_db.lemlat_lila ON lila_id_lemma=lila.id_lemma
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
WHERE lemma='merges' AND codlem='N3B' AND lemlat.gen='f' AND codmorf='NcC' AND lemlat.n_id='m0801';
SELECT LAST_INSERT_ID() INTO @CUR_id_lemma;
UPDATE lila_db.lemlat_lila 
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
SET lila_id_lemma=@CUR_id_lemma
WHERE lemma='merges' AND codlem='N3B' AND lemlat.gen='f' AND codmorf='NcC' AND lemlat.n_id='D9788';

INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)
SELECT lemlat.lemma, 'D9789', lila.fl_cat, lila.upostag, lila.gen, lila.p, lila.grad
FROM lila_db.lemma lila
INNER JOIN lila_db.lemlat_lila ON lila_id_lemma=lila.id_lemma
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
WHERE lemma='merges' AND codlem='N3B' AND lemlat.gen='f' AND codmorf='NcC' AND lemlat.n_id='m0801';
SELECT LAST_INSERT_ID() INTO @CUR_id_lemma;
UPDATE lila_db.lemlat_lila 
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
SET lila_id_lemma=@CUR_id_lemma
WHERE lemma='merges' AND codlem='N3B' AND lemlat.gen='f' AND codmorf='NcC' AND lemlat.n_id='D9789';

-- uis	N3B	f	NcC	u0804	DE7D6
INSERT INTO lila_db.lemma (label, n_id, fl_cat, upostag, gen, p, grad)
SELECT lemlat.lemma, 'DE7D6', lila.fl_cat, lila.upostag, lila.gen, lila.p, lila.grad
FROM lila_db.lemma lila
INNER JOIN lila_db.lemlat_lila ON lila_id_lemma=lila.id_lemma
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
WHERE lemma='uis' AND codlem='N3B' AND lemlat.gen='f' AND codmorf='NcC' AND lemlat.n_id='u0804';
SELECT LAST_INSERT_ID() INTO @CUR_id_lemma;
UPDATE lila_db.lemlat_lila 
INNER JOIN lemlat_db.lemmario lemlat ON lemlat_id_lemma=lemlat.id_lemma
SET lila_id_lemma=@CUR_id_lemma
WHERE lemma='uis' AND codlem='N3B' AND lemlat.gen='f' AND codmorf='NcC' AND lemlat.n_id='DE7D6';
