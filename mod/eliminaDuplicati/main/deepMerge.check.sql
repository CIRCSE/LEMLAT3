/*
Lemma con codlem=V*
    -> se la differenza tra B e D/O è che il codles del les con clem='v' in B
        e quello del les con clem='v' in D/O hanno i primi due caratteri uguali (esempio: "v1*"),
        le due clem vanno collazionate e il lemma di D/O va eliminato.
       Se la clem di B ha una sola riga, questo confronto va fatto con quella riga
        (anche se non ha clem='v', proprio perché è l'unica riga della clem).
       Se il les di D con clem='v' differisce dal corrispondente di B solo per la presenza di una 'h'
       (in qualsiasi posizione del les),
    procedere pure: elminare la clem di D e fare la collazione dei les con quella di B (esempio: 'h0203';'D779A').

Cosa significa qui "collazionare":
     a parte la riga di cui sopra (quella con clem='v'),
     le righe della clem D/O non presenti nella clem B vanno riportate nella clem B
     se differiscono dalle righe della clem B nelle colonne les e/o codles.
     Queste nuove righe della clem B hanno l'n_id della clem B, ma hanno valore D/O (sarà sempre D) in campo 'src'.
     Ciò comporta che avremo clem che avranno sia righe di src B che righe di src D.
     Non cambia nulla in proposito alla src nel lemmario (resta B per le clem in questione).
     Quando si seleziona B o D nell'usare lemlat, queste clem "miste" sono attive in entrambi i casi.

Ad esempio:
- benefacio (V5: b9257; D21H1):
  la clem D21H1 viene eliminata
  (le due clem hanno riga con clem='v' che ha lo stesso les e codles che inizia con i medesimi primi due caratteri)
  e non c'è nessuna aggiunta di nuove righe nella clem b9257,
  perché tutte le coppie les-codles di D21H1 sono in b9257
- antecurro (V3: a2124; D113C):
  la clem D113C viene eliminata e si aggiunge la riga con les='antecucurr' e codles='v7s' nella clem a2124,
  perché questa coppia les-codles di D113C non c'è in a2124.Questa nuova riga ha n_id='a2124' e src='B'

Per favore, forniscimi un report di quanto avviene a valle di queste modifiche con:
- clem di D eliminate e nessuna modifica a corrispondente clem rimanente
- clem di D eliminate e almeno una modifica a corrispondente clem rimanente (se possibile: quale/i modifiche)
- clem di D non eliminate: da decidere una per una cosa fare
*/

-- ISSUE: più righe nel confronto
/*
SELECT I.*,n_id, SUM(L.clem='v') NoV, COUNT(*) Tot
FROM checkMerge I INNER JOIN keep K USING(lemma, codlem, gen, codmorf) INNER JOIN lessario L USING(n_id)
GROUP BY lemma, codlem, gen, codmorf, n_id
HAVING NOT( NoV=1 OR NoV=0 AND Tot=1 )
;
+-------+--------+-----+---------+-------+------+-----+
| lemma | codlem | gen | codmorf | n_id  | NoV  | Tot |
+-------+--------+-----+---------+-------+------+-----+
| uigeo | V2     |     | VmG     | u0636 |    2 |   3 |
+-------+--------+-----+---------+-------+------+-----+

SELECT I.*,n_id, SUM(L.clem='v') NoV, COUNT(*) Tot
FROM checkMerge I INNER JOIN  throw T USING(lemma, codlem, gen, codmorf) INNER JOIN lessario L USING(n_id)
GROUP BY lemma, codlem, gen, codmorf, n_id;
HAVING NOT( NoV=1 OR NoV=0 AND Tot=1 )
;

+----------+--------+-----+---------+-------+------+-----+
| lemma    | codlem | gen | codmorf | n_id  | NoV  | Tot |
+----------+--------+-----+---------+-------+------+-----+
| absum    | VA     |     | VmN     | D00C2 |    2 |  22 |
| insum    | VA     |     | VmN     | D7H02 |    2 |  22 |
| supersum | VA     |     | VmN     | DDH24 |    2 |  22 |
+----------+--------+-----+---------+-------+------+-----+

- D00C2 -> merge con a0200
- D7H02 -> merge con i2191
- DDH24 -> merge con s3704

keep:
+----------+--------+-----+---------+-------+
| lemma    | codlem | gen | codmorf | n_id  |
+----------+--------+-----+---------+-------+
| absum    | VA     |     | VmN     | a0200 |
| insum    | VA     |     | VmN     | i2191 |
| supersum | VA     |     | VmN     | s3704 |
| uigeo    | V2     |     | VmG     | u0636 |
+----------+--------+-----+---------+-------+
throw:
+----------+--------+-----+---------+-------+
| lemma    | codlem | gen | codmorf | n_id  |
+----------+--------+-----+---------+-------+
| absum    | VA     |     | VmN     | D00C2 |
| insum    | VA     |     | VmN     | D7H02 |
| supersum | VA     |     | VmN     | DDH24 |
| uigeo    | V2     |     | VmG     | DE67F |
+----------+--------+-----+---------+-------+


*/
DROP  TEMPORARY TABLE IF EXISTS doDeepMerge;
CREATE TEMPORARY TABLE doDeepMerge

SELECT lemma, codlemI codlem, genI gen, codmorf, K.n_id n_id_Keep, K.pr_key refK, T.n_id n_id_Throw, T.pr_key refT
FROM
(
    SELECT lemma, K1.codlem codlemI, K1.gen genI, codmorf, L.*
    FROM (
        SELECT I.*,n_id, SUM(L.clem='v') NoV, COUNT(*) Tot
        FROM checkMerge I INNER JOIN keep K USING(lemma, codlem, gen, codmorf) INNER JOIN lessario L USING(n_id)
        GROUP BY lemma, codlem, gen, codmorf, n_id
        HAVING NoV=1
    ) K1 INNER JOIN lessario L USING(n_id) WHERE clem='v'
    UNION
    SELECT lemma, K2.codlem codlemI, K2.gen genI, codmorf, L.*
    FROM (
        SELECT I.*,n_id, SUM(L.clem='v') NoV, COUNT(*) Tot
        FROM checkMerge I INNER JOIN keep K USING(lemma, codlem, gen, codmorf) INNER JOIN lessario L USING(n_id)
        GROUP BY lemma, codlem, gen, codmorf, n_id
        HAVING NoV=0 AND Tot=1
    ) K2 INNER JOIN lessario L USING(n_id)
) K
INNER JOIN
(
    SELECT lemma, T1.codlem codlemI, T1.gen genI, codmorf, L.*
    FROM (
        SELECT I.*,n_id, SUM(L.clem='v') NoV, COUNT(*) Tot
        FROM checkMerge I INNER JOIN throw T  USING(lemma, codlem, gen, codmorf) INNER JOIN lessario L USING(n_id)
        GROUP BY lemma, codlem, gen, codmorf, n_id
        HAVING NoV=1
    ) T1 INNER JOIN lessario L USING(n_id) WHERE clem='v'
    UNION
    SELECT lemma, T2.codlem codlemI, T2.gen genI, codmorf, L.*
    FROM (
        SELECT I.*,n_id, SUM(L.clem='v') NoV, COUNT(*) Tot
        FROM checkMerge I INNER JOIN throw T  USING(lemma, codlem, gen, codmorf) INNER JOIN lessario L USING(n_id)
        GROUP BY lemma, codlem, gen, codmorf, n_id
        HAVING NoV=0 AND Tot=1
    ) T2 INNER JOIN lessario L USING(n_id)
) T
USING(lemma, codlemI, genI, codmorf)
-- WHERE LEFT(K.codles,2) <> LEFT(K.codles,2) -- NESSUNA riga è esclusa
;

DROP  TEMPORARY TABLE IF EXISTS addLes;
CREATE TEMPORARY TABLE addLes

SELECT A.lemma, A.codlem, A.gen, A.codmorf, A.n_id_Keep, A.refK, A.n_id_Throw, A.refT,
       GROUP_CONCAT( CONCAT_WS('-',A.les, A.codles,A.pr_key)) addList 
FROM
(
SELECT D.*, les, codles, pr_key
FROM doDeepMerge D INNER JOIN lessario ON n_id_Throw=n_id AND pr_key<>refT
) A
LEFT JOIN
(
SELECT D.*, les, codles, pr_key
FROM doDeepMerge D INNER JOIN lessario ON n_id_Keep=n_id AND pr_key<>refK
) B USING(les, codles)
WHERE B.pr_key IS NULL
GROUP BY A.lemma, A.codlem, A.gen, A.codmorf, A.n_id_Keep, A.refK, A.n_id_Throw, A.refT
;

SELECT * FROM addLes;
/*
SELECT D.lemma, D.codlem, D.gen, D.codmorf, D.n_id_Keep, D.refK,
       GROUP_CONCAT( CONCAT_WS('-',D.n_id_Throw, D.refT)) mergeList
FROM doDeepMerge D NATURAL LEFT JOIN addLes
WHERE addLes.lemma IS NULL
GROUP BY D.lemma, D.codlem, D.gen, D.codmorf, D.n_id_Keep, D.refK
;
*/
