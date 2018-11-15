#include <string.h>
#include <stdio.h>
#include "silset.h" 
#include "sillib.h" 
#include "tabSM_def.h"
#include "tabSF_def.h"


char condition[MAX_Q_LEN];

/*------------------------------------------------------------------*/
void spferic()
{
int length;
	length=strlen(sil.form)-strlen(getSPF(SPF1));
	strncpy(sil.rad_spfe,sil.form,length);
	*(sil.rad_spfe+length)='\0';
}

/*------------------------------------------------------------------*/
void spfric()
{
int length;
	length=strlen(sil.rad_spfe)-strlen(getSPF(SPF2));
	strncpy(sil.rad_spf,sil.rad_spfe,length);
	*(sil.rad_spf+length)='\0';
}

/*------------------------------------------------------------------*/
void siric()
{
	strcpy(sil.rad_si,sil.rad_spf+strlen(getSI()));
}

/*------------------------------------------------------------------*/
void sfric()
{
	int diff;
	diff=strlen(sil.rad_si)-strlen( getSF() );
	strncpy( sil.rad_sf, sil.rad_si, diff );
	*(sil.rad_sf+diff)='\0';

}

/*------------------------------------------------------------------*/
void smric(char *radi, char *rado, int sm_n)
{
	int length;

	length=strlen(radi)-strlen(getSM(sm_n));
	strncpy(rado,radi,length);
	*(rado+length)='\0';
}

/*------------------------------------------------------------------*/
void analysis(char *rad)
{
strcpy(sil.radical,rad);

for ( getSAIset( sil.radical ); isanySAI(); nextSAI() )
{
	sairic();
	for ( getLESset(sil.rad_alt,BY_LES);isanyLES(BY_LES);nextLES(BY_LES) )
	{
		getLES(&areavs,BY_LES);
		comp();
	}
}

*sil.ind_alt='\0';
*sil.rad_alt='\0';

for ( getLESset(sil.radical,BY_LES);isanyLES(BY_LES);nextLES(BY_LES) )
{
	getLES(&areavs,BY_LES);
	comp();
}

}

/*------------------------------------------------------------------*/

void sairic()
{
	strcpy(sil.rad_sai,&sil.radical[ strlen( getSAI() ) ] );
    strcpy(sil.ind_alt, getSAI_cod() );
	strcpy(sil.rad_alt, getSAI_alt());
    strcat(sil.rad_alt,sil.rad_sai);
}

/*------------------------------------------------------------------*/

void comp()
{

if (*sil.ind_alt)
	if ( !compai() ) return;

if (isanySI() && *(getSI()))
   if ( !compsi() ) return;

if (isanySPF(SPF1) && *(getSPF(SPF1)) )
	if ( !compspfe() ) return;

if (isanySPF(SPF2) )
   if ( !compspf() ) return;

if (isanySM(SM2))
{
   compsm2();
   return;
}

if (isanySM(SM1))
{
   compsm1();
   return;
}

compsf();
}

/*------------------------------------------------------------------*/

int compai()
{
char buffer[64];

	if ( !strcmp(areavs.a_gra,getSAI_cod()) )
	{
		strcpy(buffer,getSI());
		strcat(buffer,areavs.les);
		strncpy(areavs.les,buffer,22);
		return 1;
    }

	return 0;
}

/*------------------------------------------------------------------*/

int compsi()
{
char buffer[64];

	if (areavs.si==(getSI_cod())[0])
    {
		strcpy(buffer,getSI());
        strcat(buffer,areavs.les);
        strncpy(areavs.les,buffer,22);
        return 1;
	}

	return 0;
}

/*------------------------------------------------------------------*/
void compsm2()
{
LES_ROW areal;
    if (areavs.smv=='-') return;
	if (areavs.smv=='+')
		sprintf(condition,"( %s=\'%s\' )",C_COD_P2,areavs.codles );
	else
		sprintf(condition,"( ( %s=\'%s\' ) AND ( %s!='+' ))",
			C_COD_P2,areavs.codles,PM2 );

	for (getSF_cod_set(condition,2);isanySF_cod();nextSF_cod())
	{
		areacp(&areal,&areavs);
		lemsm1(&areal);
		lemsm2(&areal);
		areacp(&areal,&areavs);
		lemtiz(&areal,IPERLEMMA);
		lemv(&areal,IPERLEMMA);
	}
	if ( isanySF_cod() )
		clearSF_cod_set();
}

/*------------------------------------------------------------------*/
void compsm1()
{
LES_ROW areal;

	if (areavs.smv=='-') return;

	if (areavs.smv=='+')
		sprintf(condition,"( %s=\'%s\' ) ",C_COD_P,areavs.codles );
	else
		sprintf(condition,"( ( %s=\'%s\' ) AND ( %s!='+' )) ",
			C_COD_P,areavs.codles,PM );

    for (getSF_cod_set(condition,1);isanySF_cod();nextSF_cod())
	{
		areacp(&areal,&areavs);
		lemsm1(&areal);
		areacp(&areal,&areavs);
		lemtiz(&areal,areal.clem=='i'?IPERLEMMA_INT:IPERLEMMA);
		lemv(&areal,IPERLEMMA);
	}
}

/*------------------------------------------------------------------*/
void compsf()
{
LES_ROW areal;
int mode=0;

	if ( (areavs.codles)[0]=='v')
		sprintf(condition,"( LEFT(%s,%u) LIKE \'%s\' )",
		C_COD,strlen(areavs.codles),areavs.codles);
	else
	{
		if (areavs.cod_noseg)
		{
			if (areavs.pt=='x')
				mode=5;
			else 
				mode=3;
			sprintf( condition,
			"(%s=\'%c\') WHERE (%s=\'%s\') ",
			"cod_le.cod_LE",areavs.cod_noseg, C_COD,areavs.codles );
		}
		else
		{
			if (areavs.pt=='x') 
				mode=4;
			sprintf(condition,"(%s=\'%s\')",C_COD,areavs.codles);
		}

		switch (areavs.gen)
		{
		case 'm':case 'f':case 'n':
			sprintf(condition,"%s AND (%s=\'%c\')",condition,C07F,areavs.gen);
			break;
		case '1':
			sprintf(condition,"%s AND ( (%s=\'m\') OR (%s=\'n\') )",condition,C07F,C07F);
			break;
		case '2':
			sprintf(condition,"%s AND ( (%s=\'m\') OR (%s=\'f\') )",condition,C07F,C07F);
			break;
		case '3':
			sprintf(condition,"%s AND ( (%s=\'n\') OR (%s=\'f\') )",condition,C07F,C07F);
			break;
		}
	}

	if (getSF_cod_set(condition,mode))
    {
		areacp(&areal,&areavs);
        strcpy(sil.lemma,areal.les);
        strcpy(sil.codice,areavs.codles);
        if ( lemtiz(&areal,IPOLEMMA) )
			lemv(&areal, IPERLEMMA);
		else
			lemv(&areal, IPOLEMMA);
	}
	clearSF_cod_set();
}

/*------------------------------------------------------------------*/

int compspfe()
{
    if (!strcmp(getSPF(SPF1),"que") && (areavs.spf[0] == '3'))
		return 0;
	
	sil.segment[6]=getSPF(SPF1);
	return 1;
}

/*------------------------------------------------------------------*/

int compspf()
{
	sil.part=0;

	if ( !( *getSPF(SPF2) ) )
	{
		if ( areavs.spf[0] == 'p' ) return 0;
		else return 1;
	}	
	if ( !strcmp( areavs.spf, getSPF_cod(SPF2) ) ) 
	{
		if ( areavs.spf[0] != 'p' )
			sil.part=1;
		return 1;
	}

	return 0;
}

/*------------------------------------------------------------------*/

void areacp(register LES_ROW *t,register LES_ROW   *s)
{
	strcpy(t->n_id,s->n_id);
	t->gen=s->gen;
	t->clem=s->clem;
	t->si=s->si;
	t->smv=s->smv;
	strcpy(t->spf,s->spf);
	strcpy(t->codles,s->codles);
	strcpy(t->les,s->les);
	strcpy(t->lem,s->lem);
	strcpy(t->s_omo,s->s_omo);
	t->piu=s->piu;
	strcpy(t->codlem,s->codlem);
	t->type=s->type;
	t->cod_noseg=s->cod_noseg;
	t->pt=s->pt;
	strcpy(t->a_gra,s->a_gra);
	t->gra_u=s->gra_u;
	t->les_id=s->les_id;
}

/*------------------------------------------------------------------*/
void      lemv(LES_ROW *areal, LEM_TYPE lem_type)
{
	if ( (areavs.clem == 'v') || (areavs.clem == 'k') ) return;

	for ( getLESset(areavs.n_id, BY_CLEM); isanyLES(BY_CLEM); nextLES(BY_CLEM) )
	{
		getLES(areal,BY_CLEM);
		if (strcmp(areal->les,areavs.les) || strcmp(areal->codles,areavs.codles))
			lemtiz(areal,lem_type);
	}
}

