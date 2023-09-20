#include <stdio.h>
#include <string.h>
//#include "tabLES_def.h"

#define MAX_Q_LEN 300

/*--------------------Connessione al DataBase----------------------*/

int ll_connect(const char * app_name, const char * cnfFile,const int startServer,
			 FILE* lf, FILE* ef);
void ll_disconnect(const int stopServer);


//PAOLO
/*--------------definizione dinamica tabella lessario---------------*/
// BUGFIX definizione multipla!!
#ifndef __LESSARIO
#define __LESSARIO
extern char* LESSARIO;
#endif
void initLESsource(const char* source);
void setLESsource(const char* source);
//OLOAP

/*--------------Interrogazione della tabella lessario---------------*/

//fields length (1 otherwise):
#define lN_ID   5
#define lI_SPF  4
#define lLES    22
#define lCODLES 4
//#define lLEM    20
#define lLEM    30
#define lS_OMO  3
#define lCODLEM 4
#define lA_GRA   3

#ifndef __LES_ROW
#define __LES_ROW
typedef struct
   {
   char n_id[lN_ID+1];
   char gen;
   char clem;
   char si;
   char smv;
   char spf[lI_SPF+1];
   char les[lLES+1];
   char codles[lCODLES+1];
   char lem[lLEM+1];
   char s_omo[lS_OMO+1];
   char piu;
   char codlem [lCODLEM+1];
   char type;
   char cod_noseg;
   char pt;
   char a_gra [lA_GRA];
   char gra_u;
   int  les_id;
} LES_ROW;
#endif


#ifndef __LES_Q_MODE
#define __LES_Q_MODE
#define NUM_LES_Q_MODE 3
typedef enum{BY_LES=0,BY_CLEM=1, BY_KEY=2} LES_Q_MODE;
#endif
int getLESset(const char *value, const LES_Q_MODE q_mode);
int isanyLES(const LES_Q_MODE q_mode);
int nextLES(const LES_Q_MODE q_mode);
void  getLES(LES_ROW* rec,const LES_Q_MODE q_mode);


/*--------Interrogazione della tabella dei segmenti finali-----------*/

int getSFset( const char *str);
int  nextSF();
int isanySF();
char*  getSF();

int getSF_cod_set( const char *condition,/**/int mode);
int  nextSF_cod();
int isanySF_cod();
void clearSF_cod_set();

int getCod_morf_set( const char *seg,const char* cod, const char gen, 
					const char cod_noseg, const int isPT);
int  nextCod_morf();
int isanyCod_morf();
char *getCod_morf();

int descr_cod_morf( const int pos, const char cod, char* field_descr,char* value_descr);

int getCod_morf_set_fe( int les_id);
int  nextCod_morf_fe();
int isanyCod_morf_fe();
char *getCod_morf_fe();


#define SM1 0
#define SM2 1

int getSMset( const char *str, int sm_n);
int  nextSM(int sm_n);
int isanySM(int sm_n);
char *getSM(int sm_n);
char *getSM_cod_P();
char *getSM_cod_S();

int getSIset( const char *str );
int  nextSI();
int isanySI( );
char *getSI( );
char *getSI_cod();


#define SPF1 0
#define SPF2 1
int getSPFset( const char *str ,int spf_n);
int  nextSPF(int spf_n);
int isanySPF( int spf_n);
char *getSPF( int spf_n);
char *getSPF_cod(int spf_n);

int getSAIset( const char *str );
int  nextSAI();
int isanySAI( );
char *getSAI( );
char *getSAI_cod();
char *getSAI_alt();

int get3eagles( const char* codlem, char* c01, char* c02, char* c03);
int get_codlem3eagles( const char* codles, char codlem[],char* c01, char* c02, char* c03);

int get3code_set_fe(int les_id);
int isany3code_fe();
int next3code_fe();
char* get3code_fe();

int getCod_morf_setLE( const char cod );

char* getEncFE(int les_id);
char* getAddLem(int les_id);

int build_lemma( const char* in_str, const char* cod, char* out_str);

int getLEset( const char *str );
int nextLE();
int isanyLE();
char* getLE_LESid();
char getCodLE();
char* getLE();
