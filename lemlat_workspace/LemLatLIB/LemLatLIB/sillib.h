#include "lemlatLIB.h"


void spfric();
void spferic();
void siric();
void sfric();
void smric(char *radi, char *rado,int sm_n);
void sairic();

void de_hyphen_lemma();

void areacp(register LES_ROW *t, register LES_ROW   *s);
void analysis(char *rad);

void comp();
int compai();
int compsi();
int compspf();
int compspfe();
void compsm2();
void compsm1();
void compsf();

void lemsm1(LES_ROW *areal);
void lemsm2(LES_ROW *areal);
int lemtiz(LES_ROW *areal, LEM_TYPE lem_type);
void lemv(LES_ROW *areal, LEM_TYPE lem_type);

//paolo 11-11-05
/*
void part();
*/
//oloap
void set_codlem3eagles(LES_ROW *areal, char* codice);

int lemmi_ecc(const char* str);

void finalize();

