-- ISSUE derivational_db: sostituzione lemmi ducange con corr.lemmi della base
/*
SELECT * FROM deprMap INNER JOIN lemmario L1 ON L1.n_id= WHERE n_idOLD
IN(SELECT DISTINCT i_n_id FROM derivational_db.wfr2_all UNION  SELECT DISTINCT o_n_id FROM derivational_db.wfr2_all);

SELECT L1.id_lemma id_lemmaNEW, L2.id_lemma id_lemmaOLD, D.*
FROM deprMap D INNER JOIN lemmario L1 ON L1.n_id=n_idNEW
               INNER JOIN lemmario L2 ON L2.n_id=n_idOLD 
WHERE n_idOLD
IN(SELECT DISTINCT i_n_id FROM derivational_db.wfr2_all UNION  SELECT DISTINCT o_n_id FROM derivational_db.wfr2_all);
*/

/*
+---------+---------+------------------------------+
| n_idNEW | n_idOLD | lemmata                      |
+---------+---------+------------------------------+
| c0021   | D2CAA   | cacabus_N2_m_NcB_lemma/92136 |
| c0308   | D2F02   | camera_N1_f_NcA_lemma/92457  |
| c0351   | D2FE4   | canapa_N1_f_NcA_lemma/92507  |
| c0351   | D2FFE   | canaua_N1_f_NcA_lemma/92507  |
| c4645   | D4B7H   | cuppa_N1_f_NcA_lemma/97275   |
| h0463   | DDCD9   | storia_N1_f_NcA_lemma/105561 |
| r1117   | DC12D   | refacio_V5__VmM_lemma/122501 |
| s2546   | DDCD9   | storia_N1_f_NcA_lemma/125767 |
+---------+---------+------------------------------+

+-------------+-------------+---------+---------+------------------------------+
| id_lemmaNEW | id_lemmaOLD | n_idNEW | n_idOLD | lemmata                      |
+-------------+-------------+---------+---------+------------------------------+
|        5166 |       84262 | c0021   | D2CAA   | cacabus_N2_m_NcB_lemma/92136 |
|        5510 |       85009 | c0308   | D2F02   | camera_N1_f_NcA_lemma/92457  |
|        5561 |       85251 | c0351   | D2FE4   | canapa_N1_f_NcA_lemma/92507  |
|        5561 |       85277 | c0351   | D2FFE   | canaua_N1_f_NcA_lemma/92507  |
|       10494 |       94698 | c4645   | D4B7H   | cuppa_N1_f_NcA_lemma/97275   |
|       18246 |      141424 | h0463   | DDCD9   | storia_N1_f_NcA_lemma/105561 | (*)
|       34042 |      151196 | r1117   | DC12D   | refacio_V5__VmM_lemma/122501 |
|       37984 |      141424 | s2546   | DDCD9   | storia_N1_f_NcA_lemma/125767 | (*)
+-------------+-------------+---------+---------+------------------------------+

(*) NB: ambigui scelgo s2546

SELECT * FROM derivational_db.wfr2_all WHERE i_n_id IN(SELECT n_idOLD FROM deprMap);
+------------+---------+----------+-------+-----------+--------+-------+------------+--------------+----------+-------+-----------+--------+---------+----------+-------------------+
| i_id_lemma | i_lemma | i_codlem | i_gen | i_codmorf | i_n_id | i_ord | o_id_lemma | o_lemma      | o_codlem | o_gen | o_codmorf | o_n_id | wfr_key | category | type              |
+------------+---------+----------+-------+-----------+--------+-------+------------+--------------+----------+-------+-----------+--------+---------+----------+-------------------+
|     151196 | refacio | V5       |       | VmM       | DC12D  |     1 |     132771 | refacimentum | N2       | n     | NcB       | DC12E  | 30      | V-To-N   | Derivation_Suffix |
|      85251 | canapa  | N1       | f     | NcA       | D2FE4  |     1 |      85259 | canaparius   | N2       | m     | NcB       | D2FE7  | 80      | N-To-N   | Derivation_Suffix |
|      85277 | canaua  | N1       | f     | NcA       | D2FFE  |     1 |      85281 | canauarius   | N2       | m     | NcB       | D2FFH  | 80      | N-To-N   | Derivation_Suffix |
|      94698 | cuppa   | N1       | f     | NcA       | D4B7H  |     1 |      94701 | cupparium    | N2       | n     | NcB       | D4B81  | 80      | N-To-N   | Derivation_Suffix |
|      84262 | cacabus | N2       | m     | NcB       | D2CAA  |     1 |      84272 | cacabulum    | N2       | n     | NcB       | D2CA9  | 98      | N-To-N   | Derivation_Suffix |
|      85009 | camera  | N1       | f     | NcA       | D2F02  |     1 |      85042 | camerula     | N1       | f     | NcA       | D2F21  | 98      | N-To-N   | Derivation_Suffix |
|     141424 | storia  | N1       | f     | NcA       | DDCD9  |     1 |     141436 | storula      | N1       | f     | NcA       | DDCE6  | 98      | N-To-N   | Derivation_Suffix |
+------------+---------+----------+-------+-----------+--------+-------+------------+--------------+----------+-------+-----------+--------+---------+----------+-------------------+

*/

UPDATE derivational_db.wfr_rel SET i_id_lemma=5166 WHERE i_id_lemma=84262;
UPDATE derivational_db.wfr_rel SET i_id_lemma=5510 WHERE i_id_lemma=85009;
UPDATE derivational_db.wfr_rel SET i_id_lemma=5561 WHERE i_id_lemma=85251;
UPDATE derivational_db.wfr_rel SET i_id_lemma=5561 WHERE i_id_lemma=85277;
UPDATE derivational_db.wfr_rel SET i_id_lemma=10494 WHERE i_id_lemma=94698;
UPDATE derivational_db.wfr_rel SET i_id_lemma=34042 WHERE i_id_lemma=151196;
UPDATE derivational_db.wfr_rel SET i_id_lemma=37984 WHERE i_id_lemma=141424;

UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=5166 WHERE i_id_lemma=84262;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=5510 WHERE i_id_lemma=85009;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=5561 WHERE i_id_lemma=85251;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=5561 WHERE i_id_lemma=85277;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=10494 WHERE i_id_lemma=94698;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=34042 WHERE i_id_lemma=151196;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=37984 WHERE i_id_lemma=141424;

/*
+---------+---------+-----------------------------------+
| n_idNEW | n_idOLD | lemmata                           |
+---------+---------+-----------------------------------+
| h0294   | D7620   | haereditas_N3B_f_NcC_lemma/105374 |
| h0295   | D761B   | haeredito_V1__VmF_lemma/105375    |
+---------+---------+-----------------------------------+

+------------+------------+----------+-------+-----------+--------+-------+------------+-----------------+----------+-------+-----------+--------+---------+----------+-------------------+
| i_id_lemma | i_lemma    | i_codlem | i_gen | i_codmorf | i_n_id | i_ord | o_id_lemma | o_lemma         | o_codlem | o_gen | o_codmorf | o_n_id | wfr_key | category | type              |
+------------+------------+----------+-------+-----------+--------+-------+------------+-----------------+----------+-------+-----------+--------+---------+----------+-------------------+
|     108129 | haeredito  | V1       |       | VmF       | D761B  |     1 |     108124 | haereditamentum | N2       | n     | NcB       | D7619  | 32      | V-To-N   | Derivation_Suffix |
|     108132 | haereditas | N3B      | f     | NcC       | D7620  |     1 |     108125 | haereditarium   | N2       | n     | NcB       | D761H  | 80      | N-To-N   | Derivation_Suffix |
+------------+------------+----------+-------+-----------+--------+-------+------------+-----------------+----------+-------+-----------+--------+---------+----------+-------------------+

+----------+-----------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
| id_lemma | lemma     | codlem | gen | codmorf | n_id  | lemma_reduced | upostag | upostag_2 | ts                  | src |
+----------+-----------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+
|    18061 | hereditas | N3B    | f   | NcC     | h0294 | hereditas     | NOUN    | NULL      | 2023-05-12 10:56:08 | B   |
|    18062 | heredito  | V1     |     | VmF     | h0295 | heredito      | VERB    | NULL      | 2023-05-12 10:56:08 | B   |
+----------+-----------+--------+-----+---------+-------+---------------+---------+-----------+---------------------+-----+

*/
UPDATE derivational_db.wfr_rel SET i_id_lemma=18062 WHERE i_id_lemma=108129;
UPDATE derivational_db.wfr_rel SET i_id_lemma=18061 WHERE i_id_lemma=108132;

UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=18062 WHERE i_id_lemma=108129;
UPDATE lemlat_db.lemmas_wfr SET i_id_lemma=18061 WHERE i_id_lemma=108132;
