-- PROBLEMA: lemmi da eliminare riferiti in wfr
/*
 SELECT DISTINCT G.* FROM groups G INNER JOIN throw USING (lemma, codlem, gen, codmorf, LiLaRef)
 WHERE n_id IN(
               SELECT DISTINCT o_n_id
               FROM derivational_db.wfr2_all
               UNION
               SELECT DISTINCT i_n_id
               FROM derivational_db.wfr2_all
               );
+----------+--------+-----+---------+--------------+----------+-----+-----+-----+----------------------------+
| lemma    | codlem | gen | codmorf | LiLaRef      | NoLemLat | NoB | NoO | NoD | LemLatLST                  |
+----------+--------+-----+---------+--------------+----------+-----+-----+-----+----------------------------+
| ancillor | V1     |     | VmF     | lemma/88942  |        2 |   1 |   0 |   1 | 75062(D0H8G),2251(a1919)   |
| comitor  | V1     |     | VmF     | lemma/95051  |        2 |   1 |   0 |   1 | 90941(D3GA7),8148(c2595)   |
| decido   | V3     |     | VmH     | lemma/98059  |        2 |   1 |   0 |   1 | 95496(D4E5A),10902(d0188)  |
| decido   | V3     |     | VmH     | lemma/98060  |        2 |   1 |   0 |   1 | 95496(D4E5A),10901(d0189)  |
| fretum   | N2     | n   | NcB     | lemma/103788 |        2 |   1 |   0 |   1 | 104303(D6B71),16562(f0980) |
| funero   | V1     |     | VmF     | lemma/104027 |        2 |   1 |   0 |   1 | 104834(D6D39),16850(f1187) |
| nola     | N1     | f   | NcA     | lemma/113793 |        2 |   1 |   0 |   1 | 121982(D9HH3),26235(n0488) |
| nola     | N1     | f   | NcA     | lemma/114125 |        2 |   1 |   0 |   1 | 121982(D9HH3),26234(n9763) |
| sequor   | V3     |     | VmH     | lemma/124461 |        2 |   1 |   0 |   1 | 137797(DD2F3),36658(s1348) |
+----------+--------+-----+---------+--------------+----------+-----+-----+-----+----------------------------+
9 rows in set (0,017 sec)
*/
-- NOTA: i riferimenti compaiono solo come lemmi di ingresso

-- FIX: sostituzione dei lemmi di ducange con quelli della base.
--      Per i casi multipli:
--                          "i lemmi della base da usare [...] sono 26234 (no"la) e 10901 (deci"do)."

-- | ancillor | V1     |     | VmF     | lemma/88942  |        2 |   1 |   0 |   1 | 75062(D0H8G),2251(a1919)   |
UPDATE derivational_db.wfr_rel SET i_id_lemma=2251 WHERE i_id_lemma=75062;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=2251 WHERE i_id_lemma=75062;

-- | comitor  | V1     |     | VmF     | lemma/95051  |        2 |   1 |   0 |   1 | 90941(D3GA7),8148(c2595)   |
UPDATE derivational_db.wfr_rel SET i_id_lemma=8148 WHERE i_id_lemma=90941;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=8148 WHERE i_id_lemma=90941;

-- | decido   | V3     |     | VmH     | lemma/98059  |        2 |   1 |   0 |   1 | 95496(D4E5A),10902(d0188)  |
-- | decido   | V3     |     | VmH     | lemma/98060  |        2 |   1 |   0 |   1 | 95496(D4E5A),10901(d0189)  |
UPDATE derivational_db.wfr_rel SET i_id_lemma=10901 WHERE i_id_lemma=95496;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=10901 WHERE i_id_lemma=95496;

-- | fretum   | N2     | n   | NcB     | lemma/103788 |        2 |   1 |   0 |   1 | 104303(D6B71),16562(f0980) |
UPDATE derivational_db.wfr_rel SET i_id_lemma=16562 WHERE i_id_lemma=104303;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=16562 WHERE i_id_lemma=104303;

-- | funero   | V1     |     | VmF     | lemma/104027 |        2 |   1 |   0 |   1 | 104834(D6D39),16850(f1187) |
UPDATE derivational_db.wfr_rel SET i_id_lemma=16850 WHERE i_id_lemma=104834;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=16850 WHERE i_id_lemma=104834;

-- | nola     | N1     | f   | NcA     | lemma/113793 |        2 |   1 |   0 |   1 | 121982(D9HH3),26235(n0488) |
-- | nola     | N1     | f   | NcA     | lemma/114125 |        2 |   1 |   0 |   1 | 121982(D9HH3),26234(n9763) |
UPDATE derivational_db.wfr_rel SET i_id_lemma=26234 WHERE i_id_lemma=121982;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=26234 WHERE i_id_lemma=121982;

-- | sequor   | V3     |     | VmH     | lemma/124461 |        2 |   1 |   0 |   1 | 137797(DD2F3),36658(s1348) |
UPDATE derivational_db.wfr_rel SET i_id_lemma=36658 WHERE i_id_lemma=137797;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=36658 WHERE i_id_lemma=137797;
