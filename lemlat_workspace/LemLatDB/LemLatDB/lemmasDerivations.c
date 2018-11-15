#include <stdio.h>
#include <string.h>

#include "lemlatDB.h"
#include "lemmasDerivations.h"
#include "mysqlUtil.h"
#include "tabLemmasWFR_def.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *curDERIset;
static MYSQL_ROW curDERI;
static int anyDERI;

/*
SELECT wfr_key,category,type,affix,i_ord,in_lemma.lemma, in_lemma.codlem,in_lemma.gen,in_lemma.codmorf,in_lemma.n_id  
FROM lemmario AS out_lemma  
LEFT JOIN lemmas_wfr ON out_lemma.id_lemma=o_id_lemma  
LEFT JOIN lemmario AS in_lemma ON in_lemma.id_lemma=i_id_lemma  
WHERE out_lemma.lemma='mentula' AND out_lemma.codlem='N1' AND out_lemma.gen='f' AND out_lemma.codmorf='NcA' AND out_lemma.n_id='m0764' 
ORDER BY wfr_key,i_ord;
*/
int getLemmasDerivationsset(const Lemma out_lemma)
{
	
	char selectRec[MAX_Q_LEN*2];
	char esc_out_lemma[MAX_LEMMA_LENGTH*2];
	int i,j;
	
	//escape lemma: puo' contenera quotes
    for (i=0,j=0;i<strlen(out_lemma.lemma); i++) {
	    switch(out_lemma.lemma[i]) {
	      case '\"': 
	        esc_out_lemma[j++] = '\\';
	        esc_out_lemma[j++] = '\"';
	        break;
	      case '\'': 
	        esc_out_lemma[j++] = '\\';
	        esc_out_lemma[j++] = '\'';
	        break;
	      default:
	        esc_out_lemma[j++] = out_lemma.lemma[i];
	     }
    }
    esc_out_lemma[j] = '\0'; 
    //escape lemma
    
	if (out_lemma.gen)
	sprintf(selectRec,
	"SELECT %s,%s,%s,%s,in_lemma.%s, in_lemma.%s,in_lemma.%s,in_lemma.%s,in_lemma.%s,in_lemma.%s  \
     FROM %s AS out_lemma  \
     LEFT JOIN %s ON out_lemma.%s=%s \
     LEFT JOIN %s AS in_lemma ON in_lemma.%s=%s \
     WHERE out_lemma.%s=\'%s\' AND out_lemma.%s=\'%s\' AND out_lemma.%s=\'%c\' AND out_lemma.%s=\'%c%c%c\' AND out_lemma.%s=\'%s\' \
    ORDER BY wfr_key, i_ord;",
            WFR_KEY, CATEGORY, WFR_TYPE, AFFIX, L_LEMMA, L_CODLEM, L_GEN, L_CODMORF, L_N_ID, L_SRC,
            LEMMARIO, LEMMAS_WFR, L_ID_LEMMA, O_ID_LEMMA,
            LEMMARIO, L_ID_LEMMA, I_ID_LEMMA, 
//            L_LEMMA, out_lemma.lemma, 
            L_LEMMA, esc_out_lemma, 
            L_CODLEM, out_lemma.codlem, 
            L_GEN, out_lemma.gen, 
            L_CODMORF, out_lemma.codmorf[0],out_lemma.codmorf[1],out_lemma.codmorf[2],
            L_N_ID, out_lemma.n_id,
            WFR_KEY, I_ORD );
	else
		sprintf(selectRec,
		"SELECT %s,%s,%s,%s,in_lemma.%s, in_lemma.%s,in_lemma.%s,in_lemma.%s,in_lemma.%s,in_lemma.%s  \
	     FROM %s AS out_lemma  \
	     LEFT JOIN %s ON out_lemma.%s=%s \
	     LEFT JOIN %s AS in_lemma ON in_lemma.%s=%s \
	     WHERE out_lemma.%s=\'%s\' AND out_lemma.%s=\'%s\' AND out_lemma.%s=\'\' AND out_lemma.%s=\'%c%c%c\' AND out_lemma.%s=\'%s\' \
	    ORDER BY wfr_key, i_ord;",
	            WFR_KEY, CATEGORY, WFR_TYPE, AFFIX, L_LEMMA, L_CODLEM, L_GEN, L_CODMORF, L_N_ID, L_SRC,
	            LEMMARIO, LEMMAS_WFR, L_ID_LEMMA, O_ID_LEMMA,
	            LEMMARIO, L_ID_LEMMA, I_ID_LEMMA,
//	            L_LEMMA, out_lemma.lemma,
	            L_LEMMA, esc_out_lemma,
	            L_CODLEM, out_lemma.codlem,
	            L_GEN,
	            L_CODMORF, out_lemma.codmorf[0],out_lemma.codmorf[1],out_lemma.codmorf[2],
	            L_N_ID, out_lemma.n_id,
	            WFR_KEY, I_ORD );

	return( anyDERI=first_row(h_lemlat_db,selectRec,&curDERIset,&curDERI) );

}


int nextDERI()
{
	return( anyDERI=next_row( curDERIset,&curDERI ) );
}

int isanyDERI()
{
	return( anyDERI );
}

int getLemmaDerivations( Lemma_Derivations* lemma_derivations )
{
	
	lemma_derivations->numDerivations=-1;
	if ( getLemmasDerivationsset(lemma_derivations->out_lemma) ) {
		WFR_Inst* curDerivation;
		char* curWFR;
		Lemma* curComp;
		lemma_derivations->numDerivations++;
		/*WFR_Inst* */ curDerivation=&lemma_derivations->wfr_instances[lemma_derivations->numDerivations];
		/*char* */curWFR=strcpy( curDerivation->wfr_key, "" );
		//Lemma* curComp;
		// lemma presente nel lemmario
		if ( (char*) curDERI[0] ) 
		do {
			if ( strcmp(curWFR, (char*) curDERI[0]) ) { //new derivation
				curDerivation= & lemma_derivations->wfr_instances[lemma_derivations->numDerivations] ;
				lemma_derivations->numDerivations++;
				//WFR_KEY, CATEGORY, WFR_TYPE, AFFIX
				curWFR=strcpy( curDerivation->wfr_key, (char*) curDERI[0] );
				strcpy( curDerivation->category, (char*) curDERI[1] );
				strcpy( curDerivation->type, (char*) curDERI[2] );
				if ((char*) curDERI[3])
					strcpy( curDerivation->affix, (char*) curDERI[3] );
				else
					strcpy( curDerivation->affix, "" );
				curDerivation->numComp=0;
			}
			curComp=&curDerivation->inLemma[curDerivation->numComp];
			curDerivation->numComp++;
			//L_LEMMA, L_CODLEM, L_GEN, L_CODMORF, L_N_ID
			strcpy(curComp->lemma, (char*) curDERI[4]);
			strcpy(curComp->codlem, (char*) curDERI[5]);
            curComp->gen=((char*) curDERI[6])[0];
			memcpy(curComp->codmorf, (char*) curDERI[7],3);
            strcpy(curComp->n_id, (char*) curDERI[8]);
            curComp->src=((char*) curDERI[9])[0];

			nextDERI();
		} while ( isanyDERI() );
	}
	
	return lemma_derivations->numDerivations;	
}
