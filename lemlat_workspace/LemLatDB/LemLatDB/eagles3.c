#include "lemlatDB.h"
#include "mysqlUtil.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *eagles3;
static MYSQL_ROW  cur_eagles3;

int get3eagles( const char* codlem,char* c01,char* c02,char* c03)
{
	char selectRec[MAX_Q_LEN*2];
	int res;
	sprintf(selectRec,
	   "SELECT %s,%s,%s \
		FROM %s WHERE %s=\'%s\' LIMIT 1",
        "c01","c02","c03",
		"eagles","codlem",codlem );
    if ( res=first_row(h_lemlat_db,selectRec,&eagles3,&cur_eagles3) )
	{
		*c01=*((char*)cur_eagles3[0]);
		*c02=*((char*)cur_eagles3[1]);
		*c03=*((char*)cur_eagles3[2]);
	}
	else
	{
		*c01='-';
		*c02='-';
		*c03='-';
	}
	mysql_free_result(eagles3);
    return( res );
}

int get_codlem3eagles( const char* codles,char codlem[],char* c01,char* c02,char* c03)
{
	char selectRec[MAX_Q_LEN*2];
	int res;
	sprintf(selectRec,
	   "SELECT %s,%s,%s,%s \
		FROM %s WHERE %s=\'%s\' LIMIT 1",
        "codlem","c01","c02","c03",
		"eagles","codles",codles );
    if ( res=first_row(h_lemlat_db,selectRec,&eagles3,&cur_eagles3) )
	{
		strcpy(codlem,(char*)cur_eagles3[0]);
		*c01=*((char*)cur_eagles3[1]);
		*c02=*((char*)cur_eagles3[2]);
		*c03=*((char*)cur_eagles3[3]);
	}
	else
	{
		strcpy(codlem,"unk");
		*c01='-';
		*c02='-';
		*c03='-';
	}
	mysql_free_result(eagles3);
    return( res );
}
