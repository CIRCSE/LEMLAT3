#include <string.h>
#include "silset.h" 
#include "sillib.h" 
#include "lemlatDB.h"

#include "sillem.h"
#include "lemlatLIB.h"

char* getLE();

/*------------------------------------------------------------------*/

void de_hyphen_lemma()
{

char *p;
p = strchr(sil.lemma,'-');  
if (p)
	if ((*(p-1)) != '/') *p=' ';

}

/*------------------------------------------------------------------*/

void    lemsm1(LES_ROW *areal)
{
	strcpy(sil.lemma,areal->les);
	if ( isanySM(SM2) ) strcat(sil.lemma,getSM(SM2));
	strcat(sil.lemma,getSM(SM1));

	strcpy(sil.codice,getSM_cod_S());

	build_lemma(sil.lemma,sil.codice,sil.lemma);

	set_codlem3eagles(areal,sil.codice);
	areal->clem='\0';
	/*de_hyphen_lemma();*/
	pushLemma(areal,IPOLEMMA);
}

/*------------------------------------------------------------------*/

void    lemsm2(LES_ROW *areal)
{
	strcpy(sil.lemma,areal->les);
	strcat(sil.lemma,getSM(SM2));
	strcpy(sil.codice,getSM_cod_P());

	build_lemma(sil.lemma,sil.codice,sil.lemma);

	set_codlem3eagles(areal,sil.codice);
	areal->clem='\0';
	/*de_hyphen_lemma();*/ 
	pushLemma(areal,IPERLEMMA_INT);
}

/*------------------------------------------------------------------*/

int    lemtiz(LES_ROW *areal, LEM_TYPE lem_type)
{
  LES_ROW areal_add;

  if (!strcmp(areal->codles,"fe"))
	  if (*getEncFE(areal->les_id))
	  sil.segment[6]=getEncFE(areal->les_id);

  if (*areal->lem && *areal->lem!=' ') 
  {
	  if ( *areal->lem=='-' || *areal->lem=='=')
	  {
		  strcpy(sil.lemma,areal->les);
		  if (*(areal->lem+1))
			  strcat(sil.lemma,areal->lem+1);
	  }
	  else
		  strcpy(sil.lemma,areal->lem);
//n.b. nel caso di 'forme eccezionali questa chiamata è inutile:
//i tre codici vengono sovrascritti, vedi get3code_set_fe(...)
	  set_codlem3eagles(areal,"");
	  /*de_hyphen_lemma();*/ 
	  pushLemma(areal,lem_type);

//paolo 20-11-05
/*
	  if (!strcmp(areal->codles,"fe"))
		  if ( firstlemma(getAddLem(areal->les_id),KEY,&areal_add))
		  {
			  lemtiz(&areal_add,LEMMA_AGG);
			  nextlemma(getAddLem(areal->les_id),KEY,&areal_add);
		  }
*/
	  if (!strcmp(areal->codles,"fe"))
		  for ( getLESset(getAddLem(areal->les_id),BY_KEY); isanyLES(BY_KEY); nextLES(BY_KEY) )
		  {
			  getLES(&areal_add,BY_KEY);
			  lemtiz(&areal_add,LEMMA_AGG);
		  }
//oloap
	  return 1;
  }
  else
	  if (strcmp(areal->codles,"fe"))
	  {
		  if (sil.isLE)
		  {
			  strcpy( sil.lemma, getLE() );
			  strcpy( sil.codice,areal->codles );
		  }
		  else
		  {
			  strcpy(sil.lemma,areal->les);
		      strcpy(sil.codice,areal->codles);
	          build_lemma(sil.lemma,sil.codice,sil.lemma);
		  }

		  set_codlem3eagles(areal,"");
		  /*de_hyphen_lemma();*/
		  pushLemma(areal,lem_type);
		  return 1;
      }
  return 0;
}

/*------------------------------------------------------------------*/

void set_codlem3eagles(LES_ROW *areal, char* codice)
{
	if (*(areal->codlem))
	{
		strcpy(sil.codice,areal->codlem);
		get3eagles(areal->codlem,&sil.eagles3[0],&sil.eagles3[1],&sil.eagles3[2]);
	}
	else  
	{
		if (*codice)
			get_codlem3eagles( codice,
			sil.codice,&sil.eagles3[0],&sil.eagles3[1],&sil.eagles3[2]);
		else
			get_codlem3eagles(areal->codles,
			sil.codice,&sil.eagles3[0],&sil.eagles3[1],&sil.eagles3[2]);
	}
	if (areal->type) sil.eagles3[1]=areal->type;
}
