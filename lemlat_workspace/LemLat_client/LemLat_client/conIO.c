#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "lemlatLIB.h"

#include "lemmasDerivations.h"

//fornisce la descrizione dei codici morfologici
//int descr_cod_morf( const int pos, const char cod, char* field_descr,char* value_descr);

char area [255];
extern FILE * po /*, *pu*/;
FILE *lemfile=NULL;

short redirectToFile=0;

//LES SOURCE
extern int src;
//PAOLO
/*
void setLESsource(int src);
char getLESsource(int src);
*/
void setSource(int src);
char getSource(int src);
//OLOAP

void programBanner(){
	printf("***************************************\n");
	printf("LEMLAT: latin morphological lemmatizer *\n");
	printf("***************************************\n");
}

void interactiveModeBanner(){
	printf("***************************************\n");
	printf("*          interactive MODE            *\n");
	printf("***************************************\n");
}
void interactiveModeUsage(){
	printf("Enter a wordform \n");
    printf("OR one of the following commands: \n");
    printf("\t\\h to show this HELP \n");
    printf("\t\\q to QUIT \n");
    printf("\t\\B select BASE LES source \n");
    printf("\t\\O select ONOMASTICON LES source \n");
    printf("\t\\D select DU CANGE LES source \n");
    printf("\t\\A select ALL LES source \n");
    printf("\t\\a to output in 'lemresult' FILE \n");
    printf("\t\\d to output on SCREEN \n");
}


char *prompt(char *message)
{
static char phrase[64];
register int i;
while(1)
   {
   printf("\n%c%s",getSource(src),message);
   if (fgets(phrase,64,stdin)==NULL)   return NULL;
   i=strcspn(phrase,"\n");
   if (i>0) phrase[i]='\0';
   else return NULL;
   if (!strcmp(phrase,"end")) return NULL;
   if (*phrase == '\\')
      {
      switch(/*tolower(*/phrase[1]/*)*/)
         {
      case 'a': /* activate lemmafile */
         redirectToFile=1;
         if (lemfile == NULL) lemfile=fopen("lemresult","w");
		 po=lemfile;
         break;
      case 'd': /* deactivate lemmafile */
         redirectToFile=0;
         if (lemfile != NULL)
            {
            fclose(lemfile);
            lemfile=NULL;
			po=stdout;
            }
         break;
      case 'h':
    	  interactiveModeUsage();
          break;
      case 'B':
    	  setSource(0);
          break;
      case 'O':
    	  setSource(1);
          break;
      case 'D':
    	  setSource(2);
          break;
      case 'A':
    	  setSource(3);
          break;
      case 'q': /* end */
         return NULL;
      default:
    	  printf("UNKNOWN command!\n");
    	  interactiveModeUsage();
         }
      }
   else
      {
 
      for (i=0;i<80;i++) putchar('*');
      printf("\nForm=%s\n",phrase);

      return phrase;
      }
   }
}



 /*-------------------------------------------------------------------------*/
void conOutLemmas()
{
	short w,c;
	int i,l,j,a;
	Lemma *curLemma;
	Analysis *curAnalysis;
	int numeroLemmi, numeroLemmi_agg;

	char buffer1[31];
	char buffer2[31];
	
	Lemma_Derivations lemma_derivations;
	int isDerived;
	char codmorf[4];
	codmorf[3]='\0';

/*
	if (analyses.numAnalysis == 0) 
	{
		//forma non analizzata
		fprintf (pu,"%-30s \n",analyses.in_form);
		return;
	}
*/

	fprintf(po,"Input    wordform : %s\nAnalysed wordform : %s\n",
		        analyses.in_form, analyses.alt_in_form);

	for (a=0;a<analyses.numAnalysis; a++)
	{
		curAnalysis=(analyses.analysis+a);
		if (analyses.numAnalysis>1)
		fprintf(po,"\n============================ANALYSIS %u==================================\n",a+1);
		else
		fprintf(po,"\n============================ANALYSIS   ==================================\n");
		//segmentazione
		if (*(curAnalysis->segments[6]))
		{
			fprintf(po,"enclitica : %s\n",curAnalysis->segments[6]);
			fprintf(po,"-------------------------------------------------------------------------\n");
		}
		
		if (curAnalysis->part)
		{
			fprintf(po,"particella : %s\n",curAnalysis->segments[5]);
			fprintf(po,"-------------------------------------------------------------------------\n");
		}
		
		fprintf(po,"\nSEGMENTATION:\t");
		if (*(curAnalysis->segments[0])) 
			fprintf(po,"%s%c",(curAnalysis->segments)[0],'*');
		fprintf(po,"%s",(curAnalysis->segments)[1]);
		for (i=2;i<5;i++) 
			if (*(curAnalysis->segments[i]))
				fprintf(po," %c%s",'-',(curAnalysis->segments)[i]);
		if (!curAnalysis->part && *(curAnalysis->segments[5]) )
			fprintf(po," %c%s",'-',(curAnalysis->segments)[5]);

		fprintf(po,"\n\n");
		//codici morfologici
		for (i=0;i<curAnalysis->n_cod_morf; i++)
		{
			if (curAnalysis->n_cod_morf>1)
				fprintf(po,"---------------------morphological feats %u ----------------------------\n",i+1);
			else
				fprintf(po,"---------------------morphological feats   -----------------------------\n",i+1);

			for (j=0;j<7;j++)
				fprintf(po,"%c",curAnalysis->cod_morf_4_10[i][j]);
			fprintf(po,"\n\n");
			for (j=0;j<7;j++)
				if (curAnalysis->cod_morf_4_10[i][j]!='-')
				{
					descr_cod_morf(j+4,curAnalysis->cod_morf_4_10[i][j],buffer1,buffer2);
					fprintf(po,"%s:\t%s\n",buffer1,buffer2);
				}
		}

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
		
		if (numeroLemmi>1)
			fprintf(po,"\nLEMMI:\n");

		for (l=0;l<curAnalysis->lemmas.numL;l++)
		{
			curLemma=(curAnalysis->lemmas.lems+l);

			if ((curLemma->type==IPERLEMMA)|| (curLemma->type==IPOLEMMA)||
				(curLemma->type==IPERLEMMA_INT) )
			{
			if (numeroLemmi>1)
				if (curLemma->type==IPERLEMMA)
					fprintf(po,"\t============================LEMMA %u: IPER==========================\n",l+1);
				else
					fprintf(po,"\t============================LEMMA %u: IPO ==========================\n",l+1);
			else
				fprintf(po,"\t============================LEMMA =================================\n");
			
			if (curLemma->gen)
				fprintf(po,"\t%-30s%-5s%-6s%c\n",
						curLemma->lemma,
						curLemma->codlem,
						curLemma->n_id,
						curLemma->gen);
			else
				fprintf(po,"\t%-30s%-5s%-6s\n",
						curLemma->lemma,
						curLemma->codlem,
						curLemma->n_id);

			if ((curLemma->type==IPERLEMMA)||(numeroLemmi==1))
			{
				//codici morfologici
				fprintf(po,"\t-----------------------morphological feats-------------------------\n\t");
				for (j=0;j<3;j++)
					fprintf(po,"%c",curLemma->codmorf[j]);
				fprintf(po,"\n\n");
				for (j=0;j<3;j++)
					if (curLemma->codmorf[j]!='-')
					{
						descr_cod_morf(j+1,curLemma->codmorf[j],buffer1,buffer2);
						fprintf(po,"\t%s:\t%s\n",buffer1,buffer2);
					}
				//derivazione:
				strcpy(lemma_derivations.out_lemma.lemma,curLemma->lemma);
				strcpy(lemma_derivations.out_lemma.codlem,curLemma->codlem);
				strcpy(lemma_derivations.out_lemma.n_id,curLemma->n_id);
				memcpy(lemma_derivations.out_lemma.codmorf,curLemma->codmorf,3);				 
				lemma_derivations.out_lemma.gen=curLemma->gen;
				isDerived=getLemmaDerivations( &lemma_derivations);
				fprintf(po,"\t-----------------------derivational info---------------------------\n");
				if ( isDerived>0 ) {
					WFR_Inst* curDerivation;
					Lemma* curComp;
					fprintf(po,"\tIS DERIVED: YES\n");
					for (w=0;w<lemma_derivations.numDerivations; w++) {
						curDerivation=&lemma_derivations.wfr_instances[w];
						fprintf(po,"\t-----------------------rule id: %s---------------------------------\n", 
						curDerivation->wfr_key);
						fprintf(po,"\tLexical Basis:\n");
						for (c=0; c<curDerivation->numComp; c++) {
							curComp=&curDerivation->inLemma[c];
							memcpy(codmorf,curComp->codmorf,3);
							if (curLemma->gen)
								fprintf(po,"\t\t%-30s%-5s%-6s%c%4s",
										curComp->lemma,
										curComp->codlem,
										curComp->n_id,
										curComp->gen,
										codmorf);
							else
								fprintf(po,"\t\t%-30s%-5s%-6s %4s",
										curComp->lemma,
										curComp->codlem,
										curComp->n_id,
										codmorf);
							if (curComp->src=='F')
								fprintf(po," (fictional)\n");
							else
								fprintf(po,"\n");
						}
						fprintf(po,"\tDerivational Type: %s\n", curDerivation->type);
						fprintf(po,"\tDerivational Category: %s\n", curDerivation->category);
						if (curDerivation->affix[0])
						fprintf(po,"\tAffix: %s\n", curDerivation->affix);
					}
				}
				else		    
					if ( isDerived==0 )
						fprintf(po,"\tIS DERIVED: NO\n");
					else		    
						fprintf(po,"\tIS DERIVED: UNDEF\n");
			}
			
			

			}
		}		

		if ( numeroLemmi_agg>= 1)
		for (l=0;l<curAnalysis->lemmas.numL;l++)
		{
			curLemma=(curAnalysis->lemmas.lems+l);

			if (curLemma->type==LEMMA_AGG) 
			{
				fprintf(po,"\t============================LEMMA ===============================\n");
			
				if (curLemma->gen)
					fprintf(po,"\t%-30s%-5s%-6s%c\n",
							curLemma->lemma,
							curLemma->codlem,
							curLemma->n_id,
							curLemma->gen);
				else
					fprintf(po,"\t%-30s%-5s%-6s\n",
							curLemma->lemma,
							curLemma->codlem,
							curLemma->n_id);
	
				//codici morfologici
				fprintf(po,"\t-----------------------morphological feats-----------------------\n\t");
				for (j=0;j<3;j++)
					fprintf(po,"%c",curLemma->codmorf[j]);
				fprintf(po,"\n\n");
				for (j=0;j<3;j++)
					if (curLemma->codmorf[j]!='-')
					{
						descr_cod_morf(j+1,curLemma->codmorf[j],buffer1,buffer2);
						fprintf(po,"\t%s:\t%s\n",buffer1,buffer2);
					}
			}
		}
		
	}
	
}
