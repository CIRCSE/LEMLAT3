
/*
##lemlat_db##
*Tabella lessario: WHERE pr_key=124040
gen=n -->> gen=NULL
les=nobisc -->> les=nobiscum
codles=n2n -->> codles=i
*Tabella lemmario: WHERE id_lemma=121902
codlem=N2 -->> codlem=I
gen=n -->> gen=NULL
codmorf=NcB -->> codmorf=X--
upostag=NOUN -->> upostag=INTJ
*/

UPDATE lemlat_db.lessario
SET gen=DEFAULT,
    les='nobiscum',
    codles='i'
WHERE pr_key=124040;

UPDATE lemlat_db.lemmario
SET codlem='I',
    gen=DEFAULT,
    codmorf='X--',
    upostag='INTJ'
WHERE id_lemma=121902;

/*
#lila_db##
*tabella lemma: WHERE id_lemma=67510
fl_cat=n2n -->> fl_cat=i
gen=n -->> gen=NULL
upostag=NOUN -->> upostag=INTJ
*/


UPDATE lila_db.lemma
SET fl_cat='i',
    gen=NULL,
    upostag='INTJ'
WHERE id_lemma=67510;
