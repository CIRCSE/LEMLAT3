
DROP TABLE IF EXISTS lessarioDeprecated;
CREATE TABLE lessarioDeprecated LIKE lessario;

ALTER TABLE lemmario
ADD COLUMN IF NOT EXISTS `ts` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
AFTER `upostag_2`;

DROP TABLE IF EXISTS lemmarioDeprecated;
CREATE TABLE lemmarioDeprecated LIKE lemmario;

DROP TABLE IF EXISTS deprecationMap;
CREATE TABLE deprecationMap(
`n_idOLD` char(5) NOT NULL,
`n_idNEW` char(5) NOT NULL,
`ts` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
PRIMARY KEY (`n_idOLD`, `n_idNEW`)
) DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
