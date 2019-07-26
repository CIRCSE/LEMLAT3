-- SAFE UPDATE lemmas_wfr table
-- INSERT ***ONLY*** Fict lemmas


DROP TABLE IF EXISTS lemlat_db.lemmas_wfr;

-- NOOOO!!!!!
-- DROP TABLE IF EXISTS lemlat_db.lemmario;
-- CREATE TABLE lemlat_db.lemmario LIKE derivational_db.lemmario;

-- importa i soli lemmi fittizi
-- NB: nella versione corrente il lemmario di derivational db manca di upostag

INSERT IGNORE INTO lemlat_db.lemmario(id_lemma, lemma, codlem, gen, codmorf, n_id, lemma_reduced, src)
SELECT id_lemma, lemma, codlem, gen, codmorf, n_id, lemma_reduced, src FROM derivational_db.lemmario WHERE src='F';
 
CREATE TABLE lemlat_db.lemmas_wfr AS
SELECT wfr_key, wfr_rel.o_id_lemma, wfr_rel.i_id_lemma, i_ord, category, wfr.type,
                                               CASE wfr.type
                                                  WHEN 'Derivation_Prefix' THEN prefix
                                                  WHEN 'Derivation_Suffix' THEN suffix
                                                  ELSE NULL 
                                               END AS affix 
FROM derivational_db.wfr_rel AS wfr_rel INNER JOIN derivational_db.wfr AS wfr USING(wfr_key)
             INNER JOIN derivational_db.lemmario AS in_lemma ON(in_lemma.id_lemma=i_id_lemma)
             INNER JOIN derivational_db.lemmario out_lemma ON (out_lemma.id_lemma = o_id_lemma) 
ORDER BY o_id_lemma, i_ord;

ALTER TABLE lemlat_db.lemmas_wfr
ADD  UNIQUE KEY `row_key` (`i_id_lemma`,`i_ord`,`o_id_lemma`,`wfr_key`),
ADD  KEY `idx_wfr_key` (`wfr_key`),
ADD  KEY `i_id_lemma` (`i_id_lemma`),
ADD  KEY `o_id_lemma` (`o_id_lemma`),
ADD  CONSTRAINT `i_lemma_fk` FOREIGN KEY (`i_id_lemma`) REFERENCES `lemmario` (`id_lemma`) /*ON DELETE CASCADE*/ ON UPDATE CASCADE,
ADD  CONSTRAINT `o_lemma_fk` FOREIGN KEY (`o_id_lemma`) REFERENCES `lemmario` (`id_lemma`) /*ON DELETE CASCADE*/ ON UPDATE CASCADE
