#include "mysqlUtil.h"
#include "lemlatDB.h"
#include "tabFE_def.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *curCod_morf_set_fe;
static MYSQL_ROW  curCod_morf_fe;
static int        anyCod_morf_fe;

static MYSQL_RES *cur3Cod_morf_set;
static MYSQL_ROW  cur3Cod_morf;
static int        any3Cod_morf;
static char cur3Cod_morf_buffer[21];


char* getEncFE(int les_id)
{
	char selectRec[MAX_Q_LEN*2];

	sprintf(selectRec,
	   "SELECT %s \
		FROM %s WHERE (%s=%d) LIMIT 1",
        ENC,
		TAB_FE_NAME, LES_ID, les_id);

	memset(cur3Cod_morf_buffer,'\0',21);
    if ( first_row( h_lemlat_db, selectRec, &cur3Cod_morf_set, &cur3Cod_morf ) )
	{
		if ((char*)cur3Cod_morf[0])
			strncpy(cur3Cod_morf_buffer,(char*)cur3Cod_morf[0],20);
		mysql_free_result(cur3Cod_morf_set);
	}
	return(&cur3Cod_morf_buffer[0] );
}


char* getAddLem(int les_id)
{
	char selectRec[MAX_Q_LEN*2];

	sprintf(selectRec,
	   "SELECT %s \
		FROM %s WHERE (%s=%d) LIMIT 1",
        ADD_LEM,
		TAB_FE_NAME, LES_ID, les_id);

	memset(cur3Cod_morf_buffer,'\0',21);
    if (first_row( h_lemlat_db,selectRec, &cur3Cod_morf_set,&cur3Cod_morf ))
	{
		if ((char*)cur3Cod_morf[0])
			strncpy(cur3Cod_morf_buffer,(char*)cur3Cod_morf[0],20);
		mysql_free_result(cur3Cod_morf_set);
	}
	return( &cur3Cod_morf_buffer[0] );
}


int get3code_set_fe(int les_id)
{
	char selectRec[MAX_Q_LEN*2];

	sprintf(selectRec,
	   "SELECT DISTINCT CONCAT(%s,%s,%s) \
		FROM %s WHERE (%s=%d) ",
        C01,C02,C03,
		TAB_FE_NAME, LES_ID, les_id);

    return( any3Cod_morf=first_row( h_lemlat_db,selectRec,
		&cur3Cod_morf_set,&cur3Cod_morf ) );
}

int isany3code_fe()
{
	return(any3Cod_morf);
}


int next3code_fe()
{
	return( any3Cod_morf=next_row( cur3Cod_morf_set, &cur3Cod_morf ) );
}


char* get3code_fe()
{
	return( (char*)cur3Cod_morf[0] );
}


int getCod_morf_set_fe( int les_id)
{
	
	char selectRec[MAX_Q_LEN*2];

	sprintf(selectRec,
	   "SELECT CONCAT(%s,%s,%s,%s,%s,%s,%s) \
		FROM %s WHERE (%s=%d) AND CONCAT(%s,%s,%s)=\'%s\'",
        C04,C05,C06,C07,C08,C09,C10,
		TAB_FE_NAME, LES_ID, les_id,C01,C02,C03,(char*)cur3Cod_morf[0]);

    return( anyCod_morf_fe=first_row( h_lemlat_db,selectRec,&curCod_morf_set_fe,&curCod_morf_fe ) );
}


int  nextCod_morf_fe()
{
	return( anyCod_morf_fe=next_row( curCod_morf_set_fe, &curCod_morf_fe ) );
}


int isanyCod_morf_fe()
{
	return(anyCod_morf_fe);
}


char *getCod_morf_fe()
{
	return( (char*)curCod_morf_fe[0] );
}
