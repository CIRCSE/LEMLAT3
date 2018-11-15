#include "lemlatDB.h"
#include "mysqlUtil.h"
#include "tabSAI_def.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *curSAIset;
static MYSQL_ROW  curSAI;
static int        anySAI=0;


int getSAIset( const char *str )
{
	
	char selectRec[MAX_Q_LEN*2];
	sprintf(selectRec,
	   "SELECT  t1.%s, t1.%s, t2.%s \
		FROM %s AS t1,%s AS t2 \
		WHERE t1.%s=LEFT(\'%s\',LENGTH(t1.%s)) AND \
		t1.%s=t2.%s AND t1.%s!=t2.%s \
		ORDER BY t1.%s",
        SEG_SAI, C_COD_SAI, SEG_SAI,
		TAB_SAI_NAME,TAB_SAI_NAME,
		SEG_SAI,str,SEG_SAI,
		C_COD_SAI,C_COD_SAI,SEG_SAI,SEG_SAI,
		SEG_SAI );
    return( anySAI=first_row(h_lemlat_db,selectRec,&curSAIset,&curSAI) );
}


int  nextSAI()
{
	return( anySAI=next_row( curSAIset, &curSAI ) );
}


int isanySAI( )
{
	return(anySAI);
}


char *getSAI( )
{
	return( (char*)(curSAI)[0] );
}


char *getSAI_cod()
{
	return( (char*)curSAI[1] );
}

char *getSAI_alt()
{
	return( (char*)curSAI[2] );
}
