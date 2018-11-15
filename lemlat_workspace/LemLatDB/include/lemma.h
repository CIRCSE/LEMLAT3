#ifndef __LEMMA_H
#define __LEMMA_H

//PAOLO
//NOTA: è necessario sistemare lunghezza delle stringhe
/*
#define MAX_LEMMA_LENGTH 30
*/
#define MAX_LEMMA_LENGTH 487
//OLOAP
#define CODLEM_LENGTH  5
#define N_ID_LENGTH    6

typedef enum{IPOLEMMA,IPERLEMMA,IPERLEMMA_INT, LEMMA_AGG} LEM_TYPE;

typedef struct Lemma
{
    char lemma[MAX_LEMMA_LENGTH];
	char codlem[CODLEM_LENGTH];
	char codmorf[3];
	LEM_TYPE type;

	char n_id[N_ID_LENGTH];
	char gen;
//	char codles[CODLES_LENGTH];
    char src;
	int les_id;
} Lemma;

#endif
