DROP TEMPORARY TABLE IF EXISTS keep;
CREATE TEMPORARY TABLE IF NOT EXISTS keep
SELECT lemma, codlem, gen, codmorf, MIN(n_id) n_id -- , COUNT(DISTINCT n_id) c
FROM groups g
INNER JOIN refDucange D  USING (lemma, codlem, gen, codmorf)
WHERE NoB=0 AND NoO=0 
GROUP BY lemma, codlem, gen, codmorf
-- HAVING c>1
/*
UNION 
-- solo lemmi ducange (NON derivati) : 2991
SELECT lemma, codlem, gen, codmorf, MIN(lm.n_id) n_id
FROM groups g
INNER JOIN lemmario lm USING (lemma, codlem, gen, codmorf)
LEFT JOIN refDucange D  USING (lemma, codlem, gen, codmorf)
WHERE NoB=0 AND NoO=0 AND LEFT(lm.n_id,1)<>'$' AND D.lemma IS NULL
GROUP BY lemma, codlem, gen, codmorf
*/
;


ALTER TABLE keep ADD KEY(lemma, codlem, gen, codmorf);
ALTER TABLE keep ADD KEY(n_id);
