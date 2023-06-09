--  UPDATE lemmas_wfr table

/*
DROP TABLE IF EXISTS lemlat_db.lemmas_wfr;
CREATE TABLE lemlat_db.lemmas_wfr AS
SELECT wfr_key, wfr_rel.o_id_lemma, wfr_rel.i_id_lemma, i_ord, category, wfr.type,
                                               CASE wfr.type
                                                  WHEN 'Derivation_Prefix' THEN prefix
                                                  WHEN 'Derivation_Suffix' THEN suffix
                                                  ELSE NULL 
                                               END AS affix 
FROM derivational_db.wfr_rel AS wfr_rel INNER JOIN derivational_db.wfr AS wfr USING(wfr_key)
             INNER JOIN lemlat_db.lemmario AS in_lemma ON(in_lemma.id_lemma=i_id_lemma)
             INNER JOIN lemlat_db.lemmario out_lemma ON (out_lemma.id_lemma = o_id_lemma) 
ORDER BY o_id_lemma, i_ord;

ALTER TABLE lemlat_db.lemmas_wfr
ADD  UNIQUE KEY `row_key` (`i_id_lemma`,`i_ord`,`o_id_lemma`,`wfr_key`),
ADD  KEY `idx_wfr_key` (`wfr_key`),
ADD  KEY `i_id_lemma` (`i_id_lemma`),
ADD  KEY `o_id_lemma` (`o_id_lemma`),
ADD  CONSTRAINT `i_lemma_fk` FOREIGN KEY (`i_id_lemma`) REFERENCES `lemmario` (`id_lemma`) ON UPDATE CASCADE,
ADD  CONSTRAINT `o_lemma_fk` FOREIGN KEY (`o_id_lemma`) REFERENCES `lemmario` (`id_lemma`) ON UPDATE CASCADE;
*/

TRUNCATE lemlat_db.lemmas_wfr;
INSERT INTO lemlat_db.lemmas_wfr
SELECT wfr_key, wfr_rel.o_id_lemma, wfr_rel.i_id_lemma, i_ord, category, wfr.type,
                                               CASE wfr.type
                                                  WHEN 'Derivation_Prefix' THEN prefix
                                                  WHEN 'Derivation_Suffix' THEN suffix
                                                  ELSE NULL 
                                               END AS affix 
FROM derivational_db.wfr_rel AS wfr_rel INNER JOIN derivational_db.wfr AS wfr USING(wfr_key)
             INNER JOIN lemlat_db.lemmario AS in_lemma ON(in_lemma.id_lemma=i_id_lemma)
             INNER JOIN lemlat_db.lemmario out_lemma ON (out_lemma.id_lemma = o_id_lemma) 
ORDER BY o_id_lemma, i_ord;
