#include <stdio.h>
#include <string.h>

#include "lemlatDB.h"
#include "tabLES_def.h"
#include "mysqlUtil.h"
#include "tabGV_def.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *curLESset[NUM_LES_Q_MODE];
static MYSQL_ROW curLES[NUM_LES_Q_MODE];
static int anyLES[NUM_LES_Q_MODE];

int getLESset(const char *value, const LES_Q_MODE q_mode)
{
	
	char selectRec[MAX_Q_LEN*2];

	sprintf(selectRec,
		"SELECT %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s ",
            N_ID,GEN,I_CLEM,I_SI,I_SMV,I_SPF,LES,CODLES,LEM,S_OMO,PIU,CODLEM,TYPE, COD_LE,
			PT,A_GRA,GRA_U,PR_KEY );
	switch (q_mode)
	{
	case BY_LES:
        sprintf(selectRec,"%s FROM %s INNER JOIN %s ON %s=%s WHERE \
			%s=REPLACE(\'%s\', %s, %s) \
			UNION  SELECT %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s \
			FROM %s WHERE %s=\'%s\' ",
			selectRec, LESSARIO, GRAPH_VARS, A_GRA, GV_CODE, 
			LES,value, GV_IN, GV_OUT,
            N_ID,GEN,I_CLEM,I_SI,I_SMV,I_SPF,LES,CODLES,LEM,S_OMO,PIU,CODLEM,TYPE, COD_LE,
			PT,A_GRA,GRA_U,PR_KEY,
			LESSARIO, LES, value );
		break;
	case BY_CLEM:
		//ATTENZIONE:  dividere campo rif di areavs
		/*
		sprintf(selectRec,"%s FROM %s WHERE %s=LEFT(\'%s\',%u) AND %s=\'v\'",
			selectRec, LESSARIO, N_ID,value,lRIF-1,I_CLEM);
		*/
		sprintf(selectRec,"%s FROM %s WHERE %s=\'%s\' AND %s=\'v\'",
			selectRec, LESSARIO, N_ID, value, I_CLEM);
		break;
	case BY_KEY:
		sprintf(selectRec,"%s FROM %s WHERE %s='%s\'",
			selectRec, LESSARIO, PR_KEY,value);
		break;
	default:
		return (0);
	}

	return( anyLES[q_mode]=first_row(h_lemlat_db,selectRec,&curLESset[q_mode],&curLES[q_mode]) );
}


int nextLES(const LES_Q_MODE q_mode)
{
	return( anyLES[q_mode]=next_row( curLESset[q_mode],&curLES[q_mode] ) );
}

int isanyLES(const LES_Q_MODE q_mode)
{
	return( anyLES[q_mode] );
}

void  getLES(LES_ROW* rec,const LES_Q_MODE q_mode)
{
	strcpy(rec->n_id,(char*)curLES[q_mode][0]);
	rec->gen=((char*)curLES[q_mode][1])[0];
	rec->clem=((char *)curLES[q_mode][2])[0];
	rec->si=((char *)curLES[q_mode][3])[0];
	rec->smv=((char *)curLES[q_mode][4])[0];
	strcpy(rec->spf,(char *)curLES[q_mode][5]);
    strcpy(rec->les,(char*)curLES[q_mode][6]);

	strcpy(rec->codles,curLES[q_mode][7]);
    strcpy(rec->lem,(char*)curLES[q_mode][8]);
    strcpy(rec->s_omo,(char*)curLES[q_mode][9]);
	rec->piu=((char*)curLES[q_mode][10])[0];

	strcpy(rec->codlem,curLES[q_mode][11]);
	rec->type=((char *)curLES[q_mode][12])[0];
	rec->cod_noseg=((char *)curLES[q_mode][13])[0];
	rec->pt=((char *)curLES[q_mode][14])[0];
	strcpy(rec->a_gra,(char*)curLES[q_mode][15]);
	rec->gra_u=((char*)curLES[q_mode][16])[0];
	sscanf((char*)curLES[q_mode][17],"%d",&(rec->les_id));
}
