#include "lemlatDB.h"
#include "mysqlUtil.h"
#include "tabSI_def.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *curSIset;
static MYSQL_ROW  curSI;
static int        anySI=0;

int getSIset( const char *str )
{
	
	char selectRec[MAX_Q_LEN*2];
	sprintf(selectRec,
	   "SELECT  %s, %s \
		FROM %s WHERE %s=LEFT(\'%s\',LENGTH(%s)) \
		ORDER BY LENGTH(%s)",
        SEG_SI,C_COD_SI, TAB_SI_NAME,SEG_SI,str,SEG_SI,SEG_SI,SEG_SI );
    return( anySI=first_row(h_lemlat_db,selectRec,&curSIset,&curSI) );
}


int  nextSI()
{
	return( anySI=next_row( curSIset, &curSI ) );
}


int isanySI( )
{
	return(anySI);
}


char *getSI( )
{
	return( (char*)(curSI)[0] );
}


char *getSI_cod()
{
	return( (char*)curSI[1] );
}
