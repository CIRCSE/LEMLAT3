#ifndef __LEMMASDERIVATIONS_H
#define __LEMMASDERIVATIONS_H

#include "lemma.h"  

#define WFR_KEY_LENGTH 10
#define CATEGORY_LENGTH 20
#define TYPE_LENGTH 30
#define AFFIX_LENGTH  20
#define MAX_N_COMP  4
#define MAX_N_WFR_INSTANCES 3

typedef struct WFR_Inst
{
	char wfr_key[WFR_KEY_LENGTH];
	char category[CATEGORY_LENGTH];
	char type[TYPE_LENGTH];
	char affix[AFFIX_LENGTH];
	short numComp;
	Lemma inLemma[MAX_N_COMP];
} WFR_Inst;

typedef struct Lemma_Derivations
{
	Lemma out_lemma;
	short numDerivations;
	WFR_Inst wfr_instances[MAX_N_WFR_INSTANCES];
} Lemma_Derivations;

int getLemmaDerivations( Lemma_Derivations* lemma_derivations );

#endif
