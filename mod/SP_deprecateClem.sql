DELIMITER $$
DROP PROCEDURE IF EXISTS SP_deprecateClem $$
CREATE PROCEDURE `SP_deprecateClem`(
    IN n_id_OLD char(5),
    IN n_id_NEW char(5)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
        BEGIN
            -- ROLLBACK;
            RESIGNAL;
        END;

    -- START TRANSACTION;

    INSERT INTO lemlat_db.deprecationMap(n_idNEW, n_idOLD, lemmata)
    SELECT  n_id_NEW, n_id_OLD, GROUP_CONCAT(CONCAT_WS('_',lemma, codlem, gen, codmorf)) lemmata
    FROM lemlat_db.lemmario WHERE n_id=n_id_OLD;
    
    INSERT INTO lemlat_db.lessarioDeprecated
    SELECT *
    FROM lemlat_db.lessario WHERE n_id=n_id_OLD;
    
    INSERT INTO lemlat_db.lemmarioDeprecated
    SELECT *
    FROM lemlat_db.lemmario WHERE n_id=n_id_OLD;
    
    DELETE
    FROM lemlat_db.lessario WHERE n_id=n_id_OLD;
    
    DELETE LL.* 
    FROM lila_db.lemlat_lila LL INNER JOIN lemlat_db.lemmario ON lemlat_id_lemma=id_lemma
    WHERE n_id=n_id_OLD;

    DELETE
    FROM lemlat_db.lemmario WHERE n_id=n_id_OLD;
    
    -- COMMIT;
END$$

DELIMITER ;
