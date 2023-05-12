
/*
@Eleonora

"lacus"
Esistono due "lacus" nel lila_db, rispettivamente di quarta e seconda declinazione (110374, 110370).
Entrambi i lemmi vengono dalla base di lemlat. La flessione di seconda declinazione è menzionata dal OLD.
Proporrei di metterli in rapporto di LemmaVariant nel lila_db,
ma prima di chiederlo @Paolo vorrei che tu verificassi la loro derivazione,
perché, sulla base di WFL, appartengono a due Basi derivazionali diverse in lila_db (2034, 2035).
E' giusto?
Se lo fosse, non andrebbero messi in relazione di LemmaVariant.

"tempus"
Esistono tre "tempus" (NOUN) nel lila_db:
- 127522 (da lemlat base), n3n: è il tempo cronologico -> ok
- 127796 (da lemlat base), n3n: è la tempia -> è linkato alla medesima entrata del L&S di "tempus" come tempo cronologico.
Per favore, segnala @Paolo l'id dell'entrata del L&S corretta (quella di "tempus" come "tempia"),
così che lui corregga il link

@Paolo: 132377, n2 (da lemlat Du Cange): è mal registrato in lemlat.
Non è un nome di seconda declinazione, ma di terza. Va corretto come segue.
#lemlat_db#
Tabella "lessario".
Correggere la riga con pr_key='177865' sul modello di quella con pr_key ='59312' ->
 e riportare il lemma eccezionale con il suo codice (5) in tab_le
Tabella "lemmario".
Correggere la riga con id_lemma='153949' sul modello di quella con id_lemma='39877'.
Il lemma con id_lemma='153949' diventa dunque un doppione del lemmario di base e va, quindi, rimosso.
#lila_db#
Il lemma 132377 va deprecato.
Le risorse ad esso collegato non dovrebbero essere spostate sugli altri lemmi,
perché lo sono già (casi di token di "tempus" non disambiguati).

*/
