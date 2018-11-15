#include <string.h>
#include "sillem.h"
#include "lemlatLIB.h"
#include "lemlatDB.h"

Analyses analyses;
Analysis* curAnalysis;
Lemma *curLemma;


/*------------------------------------------------------------------*/
/*			INPUT FUNCTIONS                                         */
/*------------------------------------------------------------------*/
int  initAnalyses( const char* forma_orig, const char* forma_alt)
{
	strcpy(analyses.in_form,forma_orig);
	strcpy(analyses.alt_in_form,forma_alt);
	analyses.numAnalysis=0;
	return 0;
}

/*------------------------------------------------------------------*/
int  newAnalysis()
{
	int i;
	curAnalysis=&analyses.analysis[analyses.numAnalysis++];
	for (i=0;i<NUM_SEGMENTS;i++)
		if (sil.segment[i])
			strcpy (curAnalysis->segments[i],sil.segment[i]);
		else
			strcpy (curAnalysis->segments[i],"");

	curAnalysis->part=sil.part;
		
	curAnalysis->n_cod_morf=0;

	initLemmas();
	
	return 0;
}

/*------------------------------------------------------------------*/
int  initLemmas()
{
	curAnalysis->lemmas.numL=0;
	return 0;
}

/*------------------------------------------------------------------*/
int newLemma(LES_ROW *a, LEM_TYPE lem_type)
{
	curLemma=&(curAnalysis->lemmas.lems[(curAnalysis->lemmas.numL)++]);
	curLemma->type=lem_type;

	strcpy( curLemma->n_id  , a->n_id);
	         curLemma->gen   = a->gen;
//	strcpy ( curLemma->codles,a->codles );

    strcpy ( curLemma->lemma, sil.lemma );
	strcpy ( curLemma->codlem, sil.codice);

	curLemma->les_id=a->les_id;

	return 1;
}

/*------------------------------------------------------------------*/
int  pushLemma(LES_ROW *a, LEM_TYPE lem_type)
{
	switch(lem_type)
	{
	case IPOLEMMA:
		if ( strcmp(areavs.codles,"fe")&&
			strcmp(areavs.codles,"n") &&
			strcmp(areavs.codles,"pr")&&
			strcmp(areavs.codles,"v") &&
			strcmp(areavs.codles,"p1") &&
			strcmp(areavs.codles,"p2") &&
			strcmp(areavs.codles,"p3") &&
			strcmp(areavs.codles,"p4") &&
			strcmp(areavs.codles,"p5") &&
			strcmp(areavs.codles,"p6") &&
			strcmp(areavs.codles,"p7") &&
			strcmp(areavs.codles,"p8") &&
			strcmp(areavs.codles,"p9") &&
			strcmp(areavs.codles,"p18") 
			)
		{
			newAnalysis();
			if (sil.isLE)
				for (getCod_morf_setLE( getCodLE() );
				isanyCod_morf(); nextCod_morf(),curAnalysis->n_cod_morf++)
					memcpy(curAnalysis->cod_morf_4_10[curAnalysis->n_cod_morf],getCod_morf(),7);
			else
				for (  getCod_morf_set( (sil.segment)[4], a->codles,a->gen,
					                    a->cod_noseg, a->pt=='x');
					   isanyCod_morf(); 
					   nextCod_morf(),curAnalysis->n_cod_morf++   )
					memcpy(curAnalysis->cod_morf_4_10[curAnalysis->n_cod_morf],getCod_morf(),7);

			newLemma(a,lem_type);
			memcpy(curLemma->codmorf,sil.eagles3,3);
		}
		else
			for ( get3code_set_fe(areavs.les_id);isany3code_fe(); 
			next3code_fe())
			{
				newAnalysis();

				for (getCod_morf_set_fe( areavs.les_id );
				isanyCod_morf_fe(); nextCod_morf_fe(),curAnalysis->n_cod_morf++)
					memcpy(curAnalysis->cod_morf_4_10[curAnalysis->n_cod_morf],getCod_morf_fe(),7);
				newLemma(a,lem_type);
				memcpy(curLemma->codmorf,get3code_fe(),3);
			}
	break;
	case IPERLEMMA:	case IPERLEMMA_INT: 
		if ( strcmp(areavs.codles,"fe")&&
			strcmp(areavs.codles,"n") &&
			strcmp(areavs.codles,"pr")&&
			strcmp(areavs.codles,"v") &&
			strcmp(areavs.codles,"p1") &&
			strcmp(areavs.codles,"p2") &&
			strcmp(areavs.codles,"p3") &&
			strcmp(areavs.codles,"p4") &&
			strcmp(areavs.codles,"p5") &&
			strcmp(areavs.codles,"p6") &&
			strcmp(areavs.codles,"p7") &&
			strcmp(areavs.codles,"p8") &&
			strcmp(areavs.codles,"p9") &&
			strcmp(areavs.codles,"p18") 
			)
		{
			newLemma(a,lem_type);
			memcpy(curLemma->codmorf,sil.eagles3,3);
		}
		else
			for ( get3code_set_fe(areavs.les_id);isany3code_fe(); 
			next3code_fe())
			{
				newLemma(a,lem_type);
				memcpy(curLemma->codmorf,get3code_fe(),3);
			}
		  break;

	case LEMMA_AGG:
		if ( strcmp(a->codles,"fe")&&
			strcmp(a->codles,"n") &&
			strcmp(a->codles,"pr")&&
			strcmp(a->codles,"v") &&
			strcmp(a->codles,"p1") &&
			strcmp(a->codles,"p2") &&
			strcmp(a->codles,"p3") &&
			strcmp(a->codles,"p4") &&
			strcmp(a->codles,"p5") &&
			strcmp(a->codles,"p6") &&
			strcmp(a->codles,"p7") &&
			strcmp(a->codles,"p8") &&
			strcmp(a->codles,"p9") &&
			strcmp(a->codles,"p18") 
			)
		{
			newLemma(a,lem_type);
			memcpy(curLemma->codmorf,sil.eagles3,3);
		}
		else
			for ( get3code_set_fe(areavs.les_id);isany3code_fe(); 
			next3code_fe())
			{
				newLemma(a,lem_type);
				memcpy(curLemma->codmorf,get3code_fe(),3);
			}
		  break;
	}

    return 0;
}

/*------------------------------------------------------------------*/
