#ifndef __LEMLATLIB_H
#define __LEMLATLIB_H
#include <stdio.h>

#include "lemma.h"

#ifdef LL_EMB
#define APP_DEFAULT_NAME "lemlat_EMB"
#else
#define APP_DEFAULT_NAME "lemlat_CLIENT"
#endif

//PAOLO
//NOTA: è necessario sistemare lunghezza delle stringhe

#define MAX_N_LEMS 50
#define MAX_N_COD_MORF 20

#define MAX_FORM_LENGTH 163
#define CODLES_LENGTH  5
#define NUM_SEGMENTS   7
#define MAX_SEG_LENGTH 21

#define MAX_N_ANALYSIS 100

typedef struct Lemmas
{
	short numL;
	Lemma lems[MAX_N_LEMS];
} Lemmas;

typedef struct Analysis
{
	char segments[NUM_SEGMENTS][MAX_SEG_LENGTH];
	short part;

	short n_cod_morf;
	char cod_morf_4_10[MAX_N_COD_MORF][7];

	Lemmas lemmas;
} Analysis;

typedef struct Analyses
{
	char  in_form[MAX_FORM_LENGTH];
	char  alt_in_form[MAX_FORM_LENGTH];

	short numAnalysis;
	Analysis analysis[MAX_N_ANALYSIS];
} Analyses;

extern Analyses analyses;
extern Analysis* curAnalysis;
extern Lemma *curLemma;

int descr_cod_morf( const int pos, const char cod, 
				    char* field_descr, char* value_descr );
void initial(const char*,const char*, const int,
			 FILE* lf, FILE* ef);
int silcall(const char*);
void finalize( const int);

//PAOLO
/*--------------definizione dinamica tabella lessario---------------*/
void setLESsource(const char* source);
//OLOAP

#endif
