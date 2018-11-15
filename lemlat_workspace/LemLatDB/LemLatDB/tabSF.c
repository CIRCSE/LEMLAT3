#include "mysqlUtil.h"
#include "lemlatDB.h"
#include "tabSF_def.h"
#include "tabSM_def.h"
#include "tabCODLE_def.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *curSFset;
static MYSQL_ROW  curSF;
static int        anySF;

static MYSQL_RES *curSF_cod_set;
static MYSQL_ROW  curSF_cod;
static int        anySF_cod;

static MYSQL_RES *curCod_morf_set;
static MYSQL_ROW  curCod_morf;
static int        anyCod_morf;

int getSFset( const char *str)
{
	
	char selectRec[MAX_Q_LEN*2];
/*
	sprintf(selectRec,
	   "SELECT DISTINCT %s \
		FROM %s WHERE %s=RIGHT(\'%s\',LENGTH(%s)) \
		ORDER BY LENGTH(%s)",
        SEG,TAB_SF_NAME,SEG,str,SEG,SEG );
*/
	sprintf(selectRec,
	   "SELECT DISTINCT %s, LENGTH(%s) \
		FROM %s WHERE %s=RIGHT(\'%s\',LENGTH(%s)) \
		ORDER BY LENGTH(%s)",
        SEG, SEG, TAB_SF_NAME,SEG,str,SEG,SEG );
    return( anySF=first_row(h_lemlat_db,selectRec,&curSFset,&curSF) );
}

int  nextSF()
{
	return( anySF=next_row( curSFset, &curSF ) );
}

int isanySF()
{
	return(anySF);
}

char *getSF()
{
	return( (char*)curSF[0] );
}

/*---------------------------------------------------*/

int getSF_cod_set( const char *condition,int mode)
{
	
	char selectRec[MAX_Q_LEN*2];
	switch (mode)
	{
	case 0:
		sprintf(selectRec,
	    "SELECT DISTINCT %s \
		FROM %s WHERE (%s=\'%s\') AND (%s)",
        C_COD, TAB_SF_NAME, SEG, getSF(), condition );
		break;
	case 4:
		sprintf(selectRec,
	    "SELECT DISTINCT %s \
		FROM %s WHERE (%s=\'%s\') AND (%s=\'%c\') AND (%s)",
        C_COD, TAB_SF_NAME, SEG, getSF(), C08,'p',condition );
		break;
	case 3:
		sprintf(selectRec,
	    "SELECT DISTINCT %s \
			FROM %s LEFT JOIN %s \
			ON  (%s=%s) AND (%s=%s) AND (%s=%s) AND (%s=%s) AND (%s=%s) \
			AND (%s=%s) AND (%s=%s) AND %s \
			AND ( %s IS NULL ) AND (%s=\'%s\')",
			C_COD,
			TAB_SF_NAME,TAB_CODLE_NAME,
			C04C,C04F,C05C,C05F,C06C,C06F,C07C,C07F,C08C,C08F,C09C,C09F,C10C,C10F,
			condition,CODle,SEG, getSF() );
		break;
	case 5:
		sprintf(selectRec,
	    "SELECT DISTINCT %s \
			FROM %s LEFT JOIN %s \
			ON  (%s=%s) AND (%s=%s) AND (%s=%s) AND (%s=%s) AND (%s=%s) \
			AND (%s=%s) AND (%s=%s)  AND %s \
			AND ( %s IS NULL ) AND (%s=\'%s\') AND (%s=\'%c\')",
			C_COD,
			TAB_SF_NAME,TAB_CODLE_NAME,
			C04C,C04F,C05C,C05F,C06C,C06F,C07C,C07F,C08C,C08F,C09C,C09F,C10C,C10F,
			condition,CODle,SEG, getSF(),C08F,'p' );
		break;
	case 1:
		sprintf(selectRec,
	    "SELECT DISTINCT %s,%s,%s \
		FROM %s,%s \
		WHERE (%s.%s=\'%s\') AND (%s.%s=\'%s\') \
		AND (%s=IF( LEFT(%s,1)=\'v\', LEFT(%s,LENGTH(%s)), %s ) ) AND (%s)",
        C_COD,C_COD_P,C_COD_S,
		TAB_SF_NAME,TAB_SM_NAME,
		TAB_SF_NAME,SEG, getSF(), 
		TAB_SM_NAME,SEG_SM, getSM(SM1), 
		C_COD_S,C_COD_S,C_COD,C_COD_S,C_COD,
		condition );
		break;
	case 2:
		sprintf(selectRec,
	    "SELECT DISTINCT %s,TSM1.%s,TSM1.%s,%s,%s \
		FROM %s,%s as %s,%s as TSM1 \
		WHERE (%s.%s=\'%s\') AND (TSM1.%s=\'%s\') AND (%s=\'%s\') \
		AND (%s=TSM1.%s) AND \
		(TSM1.%s=IF( LEFT(TSM1.%s,1)=\'v\', LEFT(%s,LENGTH(TSM1.%s)), %s ) ) AND (%s)",
        C_COD,C_COD_P,C_COD_S,C_COD_P2,C_COD_S2,
		TAB_SF_NAME,TAB_SM_NAME,TAB_SM_NAME_ALIAS,TAB_SM_NAME,
		TAB_SF_NAME,SEG, getSF(), 
		SEG_SM, getSM(SM1), 
		SEG_SM2, getSM(SM2),
		C_COD_S2,C_COD_P,
		C_COD_S,C_COD_S,C_COD,C_COD_S,C_COD,
		condition );
		break;
	}
    return( anySF_cod=first_row( h_lemlat_db,selectRec,&curSF_cod_set,&curSF_cod ) );
}


char *getSM_cod_P()
{
	return( (char*)curSF_cod[1] );
}


char *getSM_cod_S()
{
	return( (char*)curSF_cod[2] );
}


int  nextSF_cod()
{
	return( anySF_cod=next_row( curSF_cod_set, &curSF_cod ) );
}


int isanySF_cod()
{
	return(anySF_cod);
}


char *getSF_cod()
{
	return( (char*)curSF_cod[0] );
}


void clearSF_cod_set()
{
	mysql_free_result(curSF_cod_set);
}

/*---------------------------------------------------*/



int getCod_morf_set( const char *seg,const char* cod, const char gen,
					const char cod_noseg, const int isPT )
{
	
char selectRec[MAX_Q_LEN*3];
	if (isanySM(SM1))
		sprintf(selectRec,
	   "SELECT DISTINCT CONCAT(\
		if(%s='=',%s,%s),if(%s='=',%s,%s),if(%s='=',%s,%s),if(%s='=',%s,%s),\
		if(%s='=',%s,%s),if(%s='=',%s,%s),if(%s='=',%s,%s)) \
		FROM %s,%s \
		WHERE (%s.%s=\'%s\') AND (%s.%s=\'%s\') \
		AND (%s=\'%s\') AND (%s=\'%s\') \
		AND (%s=IF( LEFT(%s,1)=\'v\', LEFT(%s,LENGTH(%s)), %s ) )",
        C04M,C04F,C04M,C05M,C05F,C05M,
		C06M,C06F,C06M,C07M,C07F,C07M,C08M,C08F,C08M,C09M,C09F,C09M,C10M,C10F,C10M,
		TAB_SF_NAME,TAB_SM_NAME, 
		TAB_SF_NAME,SEG, seg,TAB_SM_NAME,SEG_SM,getSM(SM1),
		C_COD_P,getSM_cod_P(),C_COD_S,getSM_cod_S(),
		C_COD_S,C_COD_S,C_COD,C_COD_S,C_COD);
	else
	{
		if ( cod_noseg )
		{
			sprintf(selectRec,
			"SELECT CONCAT(%s,%s,%s,%s,%s,%s,%s) \
				FROM %s LEFT JOIN %s ON \
				( (%s=\'%c\')  AND \
				(%s=%s) AND (%s=%s) AND (%s=%s) AND (%s=%s) AND (%s=%s) \
				AND (%s=%s) AND (%s=%s) ) \
				WHERE ( %s IS NULL ) AND (%s=\'%s\') AND (%s=\'%s\')",
				C04F,C05F,C06F,C07F,C08F,C09F,C10F,
				TAB_SF_NAME,TAB_CODLE_NAME,
				CODle,cod_noseg,
				C04C,C04F,C05C,C05F,C06C,C06F,C07C,C07F,C08C,C08F,C09C,C09F,C10C,C10F,
				CODle,SEG, seg,C_COD,cod);
			if (isPT)
				sprintf(selectRec,"%s AND (%s=\'%c\') ",
				selectRec,C08F,'p');
		}

		else
		{
			sprintf(selectRec,
			"SELECT CONCAT(%s,%s,%s,%s,%s,%s,%s) \
				FROM %s WHERE (%s=\'%s\') ",
				C04,C05,C06,C07,C08,C09,C10,
				TAB_SF_NAME, SEG, seg);
			if (cod[0]=='v')
				sprintf(selectRec,"%s AND (LEFT(%s,%u)=\'%s\') ",
				selectRec,C_COD,strlen(cod),cod);
			else
			{
				sprintf(selectRec,"%s AND (%s=\'%s\') ",
				selectRec,C_COD,cod);
				if (isPT)
					sprintf(selectRec,"%s AND (%s=\'%c\') ",
					selectRec,C08,'p');
			}
		}
	}

	switch (gen)
	{
	case 'm':
	case 'f':
	case 'n':
		sprintf(selectRec,"%s AND (%s=\'%c\')",selectRec,C07F,gen);
		break;
	case '1':
		sprintf(selectRec,"%s AND ( (%s=\'m\') OR (%s=\'n\') )",selectRec,C07F,C07F);
		break;
	case '2':
		sprintf(selectRec,"%s AND ( (%s=\'m\') OR (%s=\'f\') )",selectRec,C07F,C07F);
		break;
	case '3':
		sprintf(selectRec,"%s AND ( (%s=\'n\') OR (%s=\'f\') )",selectRec,C07F,C07F);
		break;
	}

    return( anyCod_morf=first_row( h_lemlat_db,selectRec,&curCod_morf_set,&curCod_morf ) );
}




int  nextCod_morf()
{
	return( anyCod_morf=next_row( curCod_morf_set, &curCod_morf ) );
}



int isanyCod_morf()
{
	return(anyCod_morf);
}



char *getCod_morf()
{
	return( (char*)curCod_morf[0] );
}


int getCod_morf_setLE( const char cod )
{
	
char selectRec[MAX_Q_LEN*3];
		
	sprintf(selectRec,
	"SELECT CONCAT(%s,%s,%s,%s,%s,%s,%s) \
	  FROM %s WHERE (%s=\'%c\') ",
	  C04,C05,C06,C07,C08,C09,C10,
	  TAB_CODLE_NAME, CODle, cod);
    return( anyCod_morf=first_row( h_lemlat_db,selectRec,&curCod_morf_set,&curCod_morf ) );
}
