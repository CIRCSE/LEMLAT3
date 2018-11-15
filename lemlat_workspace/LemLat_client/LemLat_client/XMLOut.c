#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "lemlatLIB.h"
//#include "lemlatDB.h"
#include "lemmasDerivations.h"

extern FILE  *pxml;
/*
char* codes[10]={"PoS","Type","Flexional_category","Mood",
"Tense","Case","Gender","Number", "Person", "Degree"};
*/
void XMLheader()
{
	fprintf(pxml,"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n");
	fprintf(pxml,"<LEMLAT>\n");
}

void XMLending()
{
	fprintf(pxml,"</LEMLAT>\n");
}

// FARE ESCAPE per i lemmi 
// single-quote character (') "&apos;" 
// double-quote character (") "&quot;"
void XMLescape(char* lemma, char* esc_lemma) 
{
	char* p;
	char* q;
    for (p=lemma,q=esc_lemma;*p; p++) {
	    switch(*p) {
	      case '\"': 
	        strcpy(q,"&quot;");
	        q+=6;
	        break;
	      case '\'': 
	        strcpy(q,"&apos;");
	        q+=6;
	        break;
	      default:
	        *q = *p;
	        q++;
	     }
    }
    *q = '\0'; 	
}

void XMLOut()
{
	int i,l,j,a;
	Lemma *curLemma;
	Analysis *curAnalysis;
	int numeroLemmi, numeroLemmi_agg;
	
	Lemma_Derivations lemma_derivations;
	int isDerived;
	short w,c;
	char lemma_type_attr[31];
	char comp_type_attr[31];
	char lemma_gen_attr[9];
	char comp_gen_attr[9];
	char codmorf_comp[4];
	char codmorf_lemma[4];
	
	char xml_lemma[MAX_LEMMA_LENGTH*6];
	char xml_der_lemma[MAX_LEMMA_LENGTH*6];

    codmorf_comp[3]='\0';
	codmorf_lemma[3]='\0';

	//Analyses:
	fprintf(pxml,"\t<Analyses>\n");
	fprintf(pxml,"\t\t<input_worform>%s</input_worform>\n\t\t<analysed_worform>%s</analysed_worform>\n",
		        analyses.in_form, analyses.alt_in_form);
	for (a=0;a<analyses.numAnalysis; a++)
	{
		//Analysis:
		curAnalysis=(analyses.analysis+a);
		fprintf(pxml,"\t\t<Analysis>\n");

 		//enclitica:
		if (*(curAnalysis->segments[6]))
			fprintf(pxml,"\t\t\t<enc>%s</enc>\n",curAnalysis->segments[6]);

		//particella:
		if (curAnalysis->part)
			fprintf(pxml,"\t\t\t<part>%s</part>\n",curAnalysis->segments[5]);

		//segmentazione:
		fprintf(pxml,"\t\t\t<segmentation>\n");
		if (*(curAnalysis->segments[0])) 
			fprintf(pxml,"\t\t\t\t<alt>%s</alt>\n",(curAnalysis->segments)[0]);
		fprintf(pxml,"\t\t\t\t<les>%s</les>\n",(curAnalysis->segments)[1]);
		if (*(curAnalysis->segments[2]))
			fprintf(pxml,"\t\t\t\t<sm1>%s</sm1>\n",(curAnalysis->segments)[2]);
		if (*(curAnalysis->segments[3]))
			fprintf(pxml,"\t\t\t\t<sm2>%s</sm2>\n",(curAnalysis->segments)[3]);
		if (*(curAnalysis->segments[4]))
			fprintf(pxml,"\t\t\t\t<sf>%s</sf>\n",(curAnalysis->segments)[4]);
		if (!curAnalysis->part && *(curAnalysis->segments[5]) )
			fprintf(pxml,"\t\t\t\t<spf>%s</spf>\n",(curAnalysis->segments)[5]);
		fprintf(pxml,"\t\t\t</segmentation>\n");

		//sequenze di codici morfologici:
		fprintf(pxml,"\t\t\t<morphological_analyses>\n");
		for (i=0;i<curAnalysis->n_cod_morf; i++)
		{
/*
			fprintf(pxml,"\t\t\t\t<morphological_codes>\n");
			for (j=0;j<7;j++)
				if (curAnalysis->cod_morf_4_10[i][j]!='-')
					fprintf(pxml,"<%s>%c</%s>\n",codes[j+3],
					curAnalysis->cod_morf_4_10[i][j],codes[j+3]);
			fprintf(pxml,"</morphological_codes>\n");
		}
		fprintf(pxml,"</morphological_analyses>\n");
*/
			fprintf(pxml,"\t\t\t\t<morphological_feats>");
			for (j=0;j<7;j++)
					fprintf(pxml,"%c",curAnalysis->cod_morf_4_10[i][j]);
			fprintf(pxml,"</morphological_feats>\n");
		}
		fprintf(pxml,"\t\t\t</morphological_analyses>\n");
		
		//conta lemmi: per corretta classificazione iper/ipo
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
		
		//Lemmi:
		fprintf(pxml,"\t\t\t<Lemmas>\n");
		for (l=0;l<curAnalysis->lemmas.numL;l++)
		{
			curLemma=(curAnalysis->lemmas.lems+l);
           //XML escape 			
			XMLescape(curLemma->lemma,xml_lemma);
            //lemma type: attributo iper/ipo solo se piu' di un lemma
			switch ((curAnalysis->lemmas.lems+l)->type)
			{
			case IPERLEMMA: 
			    if (numeroLemmi>1)
			    strcpy(lemma_type_attr," type=\"iper\"");
			    else
			    strcpy(lemma_type_attr,"");
				break;
			case IPOLEMMA: 
			    if (numeroLemmi>1)
			    strcpy(lemma_type_attr," type=\"ipo\"");
			    else
			    strcpy(lemma_type_attr,"");
				break;
			case IPERLEMMA_INT:
			    if (numeroLemmi>1) 
			    strcpy(lemma_type_attr," type=\"intermediate\"");
			    else
			    strcpy(lemma_type_attr,"");
				break;
			case LEMMA_AGG:
			    strcpy(lemma_type_attr," type=\"additional\"");
				break;
			default:
			    strcpy(lemma_type_attr,"");
				break;
			}
			
			//codmorf
			memcpy(codmorf_lemma,curLemma->codmorf,3);
			
			//gen
			if (curLemma->gen)
			sprintf(lemma_gen_attr," gen=\"%c\"",curLemma->gen);
			else
			strcpy(lemma_gen_attr," gen=\"\"");
			
			if ((curLemma->type==IPERLEMMA)||(numeroLemmi==1))
			{
				//LEMMA PRINCIPALE
				
				//derivazione:
				strcpy(lemma_derivations.out_lemma.lemma,curLemma->lemma);
				strcpy(lemma_derivations.out_lemma.codlem,curLemma->codlem);
				strcpy(lemma_derivations.out_lemma.n_id,curLemma->n_id);
				memcpy(lemma_derivations.out_lemma.codmorf,curLemma->codmorf,3);							 
				lemma_derivations.out_lemma.gen=curLemma->gen;
				isDerived=getLemmaDerivations( &lemma_derivations);

				if ( isDerived>0 ) { //lemma derivato
					WFR_Inst* curDerivation;
					Lemma* curComp;					
					fprintf(pxml,
					"\t\t\t\t<Lemma%s is_derived=\"true\" lemma=\"%s\" codmorf=\"%s\" codlem=\"%s\"%s n_id=\"%s\">\n",
					lemma_type_attr,/*curLemma->lemma*/xml_lemma, codmorf_lemma, curLemma->codlem,lemma_gen_attr,curLemma->n_id);
					for (w=0;w<lemma_derivations.numDerivations; w++) {
						curDerivation=&lemma_derivations.wfr_instances[w];
						if (curDerivation->affix[0])
						fprintf(pxml,"\t\t\t\t\t<Rule id=\"%s\" type=\"%s\" category=\"%s\" affix=\"%s\">\n", 
						curDerivation->wfr_key, curDerivation->type, curDerivation->category, curDerivation->affix);
						else
						fprintf(pxml,"\t\t\t\t\t<Rule id=\"%s\" type=\"%s\" category=\"%s\">\n", 
						curDerivation->wfr_key, curDerivation->type, curDerivation->category);
						
	//					fprintf(po,"\tLexical Basis:\n");
						for (c=0; c<curDerivation->numComp; c++) {
							
							curComp=&curDerivation->inLemma[c];
                            //XML escape 			
			                XMLescape(curComp->lemma,xml_der_lemma);
							
							memcpy(codmorf_comp,curComp->codmorf,3);
							
							//comp type
							if (curComp->src=='F')
							strcpy(comp_type_attr, " type=\"fictional\"");
							else
							strcpy(comp_type_attr, "");
							
							//comp gen
							if (curComp->gen)
							sprintf(comp_gen_attr," gen=\"%c\"",curComp->gen);
							else
							strcpy(comp_gen_attr," gen=\"\"");
							
							fprintf(pxml,"\t\t\t\t\t\t<Lemma%s lemma=\"%s\" codmorf=\"%s\" codlem=\"%s\"%s n_id=\"%s\"/>\n",
							comp_type_attr,/*curComp->lemma*/xml_der_lemma, codmorf_comp, curComp->codlem,comp_gen_attr,curComp->n_id);
						}
						fprintf(pxml,"\t\t\t\t\t</Rule>\n");
					}
//					fprintf(pxml,"\t\t\t\t\t</Derivations>\n");
					fprintf(pxml,"\t\t\t\t</Lemma>\n");
				}
				else		    
					if ( isDerived==0 ) //lemma non derivato
					fprintf(pxml,
					"\t\t\t\t<Lemma%s is_derived=\"false\" lemma=\"%s\" codmorf=\"%s\" codlem=\"%s\"%s n_id=\"%s\"/>\n",
					lemma_type_attr,/*curLemma->lemma*/xml_lemma, codmorf_lemma, curLemma->codlem,lemma_gen_attr,curLemma->n_id);
					else	// derivazione indefinita	    
					fprintf(pxml,
					"\t\t\t\t<Lemma%s is_derived=\"UNDEFINED\" lemma=\"%s\" codmorf=\"%s\" codlem=\"%s\"%s n_id=\"%s\"/>\n",
					lemma_type_attr,/*curLemma->lemma*/xml_lemma, codmorf_lemma, curLemma->codlem,lemma_gen_attr,curLemma->n_id);
			}
			else // LEMMA SECONDARIO 
				fprintf(pxml,
				"\t\t\t\t<Lemma%s lemma=\"%s\" codmorf=\"%s\" codlem=\"%s\"%s n_id=\"%s\"/>\n",
				lemma_type_attr,/*curLemma->lemma*/xml_lemma, codmorf_lemma, curLemma->codlem,lemma_gen_attr,curLemma->n_id);						
		}		
		fprintf(pxml,"\t\t\t</Lemmas>\n");

		fprintf(pxml,"\t\t</Analysis>\n");
	}
	fprintf(pxml,"\t</Analyses>\n");
}

