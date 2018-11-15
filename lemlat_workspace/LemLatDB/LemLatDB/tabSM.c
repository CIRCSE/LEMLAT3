#include "lemlatDB.h"
#include "mysqlUtil.h"
#include "tabSM_def.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *curSMset[SM_MAX];
static MYSQL_ROW  curSM[SM_MAX];
static int        anySM[SM_MAX]={0,0};

int getSMset( const char *str, int sm_n)
{
	
	char selectRec[MAX_Q_LEN*2];
	sprintf(selectRec,
	   "SELECT DISTINCT %s \
		FROM %s WHERE %s=RIGHT(\'%s\',LENGTH(%s))",
        SEG_SM,TAB_SM_NAME,SEG_SM,str,SEG_SM,SEG_SM );
    return( anySM[sm_n]=first_row(h_lemlat_db,selectRec,&curSMset[sm_n],&curSM[sm_n]) );
}


int  nextSM(int sm_n)
{
	return( anySM[sm_n]=next_row( curSMset[sm_n], &curSM[sm_n] ) );
}


int isanySM(int sm_n)
{
	return(anySM[sm_n]);
}


char *getSM(int sm_n)
{
	return( (char*)(curSM[sm_n])[0] );
}
