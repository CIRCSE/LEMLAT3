#include "lemlatDB.h"
#include "mysqlUtil.h"
#include "tabLE_def.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *curLem_set;
static MYSQL_ROW  curLem;
static int        anyLem;

int getLEset( const char *str)
{
	char selectRec[MAX_Q_LEN*2];

	sprintf(selectRec,
		"SELECT %s, %s, %s\
		FROM %s WHERE %s=\'%s\'",
		tabLE_LESid, tabLE_CODLE, tabLE_LEMMA, TAB_LE_NAME, tabLE_LEMMA, str );

	return ( anyLem=first_row(h_lemlat_db,selectRec,&curLem_set,&curLem) );
}


int nextLE()
{
	return ( anyLem=next_row( curLem_set,&curLem) );
}

int isanyLE()
{
	return anyLem;
}


char* getLE_LESid()
{ 
	return ((char*)curLem[0]);
}


char getCodLE()
{ 
	return ((char*)curLem[1])[0];
}


char* getLE()
{ 
	return (char*)curLem[2];
}
