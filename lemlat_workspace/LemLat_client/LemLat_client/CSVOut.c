#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "lemlatLIB.h"
//#include "lemlatDB.h"

extern FILE  *pcsv;



void CSVOut()
{
	int /*i,*/l,j,a;
	Lemma *curLemma;
	Analysis *curAnalysis;
	int numeroLemmi, numeroLemmi_agg;

/*
	if (analyses.numAnalysis == 0)
	{
		//forma non analizzata
		fprintf (pu,"%-30s \n",analyses.in_form);
		return;
	}
*/
	for (a=0;a<analyses.numAnalysis; a++)
	{
		curAnalysis=(analyses.analysis+a);
		//lemmi:
		for (l=0,numeroLemmi=0, numeroLemmi_agg=0;l<curAnalysis->lemmas.numL;l++)
			switch ((curAnalysis->lemmas.lems+l)->type)
			{
			case IPERLEMMA: case IPOLEMMA: case IPERLEMMA_INT:
				numeroLemmi++;
				break;
			case LEMMA_AGG:
				numeroLemmi_agg++;
				break;
			}
		for (l=0;l<curAnalysis->lemmas.numL;l++)
		{
			curLemma=(curAnalysis->lemmas.lems+l);
			if ((curLemma->type==IPERLEMMA)||(numeroLemmi==1))
			{
            	fprintf(pcsv,"%s,%s,",analyses.in_form, analyses.alt_in_form);
			    fprintf(pcsv,"%s,%s,%s,",
					curLemma->lemma,
					curLemma->codlem,
					curLemma->n_id);
				if (curLemma->gen)
			       fprintf(pcsv,"%c",curLemma->gen);
			    fprintf(pcsv,",");
				//codici morfologici
				for (j=0;j<3;j++)
					fprintf(pcsv,"%c",curLemma->codmorf[j]);
				fprintf(pcsv,"\n");
			}
		}

	}

}
