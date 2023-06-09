
INSERT INTO lessarioDeprecated
SELECT *
FROM lessario WHERE n_id IN( SELECT DISTINCT n_idOLD FROM deprecationMap);

INSERT INTO lemmarioDeprecated
SELECT *
FROM lemmario WHERE n_id IN( SELECT DISTINCT n_idOLD FROM deprecationMap);

DELETE
FROM lessario WHERE n_id IN( SELECT DISTINCT n_idOLD FROM deprecationMap);

DELETE
FROM lemmario WHERE n_id IN( SELECT DISTINCT n_idOLD FROM deprecationMap);
