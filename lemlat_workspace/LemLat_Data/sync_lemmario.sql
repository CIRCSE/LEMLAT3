-- SAFE UPDATE lemmas_wfr table
-- INSERT ***ONLY*** Fict lemmas
SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS lemlat_db.lemmas_wfr;


-- inserisco eventuali nuovi lemmi 'F'
INSERT IGNORE INTO lemlat_db.lemmario(lemma, codlem, gen, codmorf, n_id, lemma_reduced, src)
SELECT lemma, codlem, gen, codmorf, n_id, lemma_reduced, src FROM derivational_db.lemmario WHERE src='F';

-- tabella temporanea id da cambiare
DROP TEMPORARY TABLE IF EXISTS replace_id;
CREATE TEMPORARY TABLE replace_id
SELECT ld.id_lemma AS from_id, ll.id_lemma to_id
FROM derivational_db.lemmario ld INNER JOIN lemlat_db.lemmario ll USING(lemma, codlem, gen, codmorf, n_id, lemma_reduced, src)
WHERE ld.id_lemma <> ll.id_lemma;

-- cambio riferimenti wfr_rel
UPDATE derivational_db.wfr_rel INNER JOIN replace_id ON i_id_lemma=from_id
SET i_id_lemma = to_id;

UPDATE derivational_db.wfr_rel INNER JOIN replace_id ON o_id_lemma=from_id
SET o_id_lemma = to_id;

-- inserisco upostag per i lemmi F
-- UPDATE lemlat_db.lemmario
-- SET upostag = CASE 
            -- WHEN codlem IN ('I') THEN 'ADV'
            -- WHEN codlem IN ('N1','N2','N3B','N5') THEN 'NOUN'
            -- WHEN codlem IN ('N2/1','N3A') THEN 'ADJ'
            -- WHEN codlem IN ('V1','V2','V3','V4','V5','VA') THEN 'VERB'
        -- END 
-- WHERE src='F';        


-- sostituisco la versione aggiornata del lemmario
DROP TABLE IF EXISTS derivational_db.lemmario;
CREATE TABLE derivational_db.lemmario LIKE lemlat_db.lemmario;
INSERT INTO derivational_db.lemmario 
SELECT * FROM lemlat_db.lemmario;

 
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
ADD  CONSTRAINT `o_lemma_fk` FOREIGN KEY (`o_id_lemma`) REFERENCES `lemmario` (`id_lemma`) /*ON DELETE CASCADE*/ ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS=1;
