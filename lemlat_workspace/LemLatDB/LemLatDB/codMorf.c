#include "mysqlUtil.h"
#include "lemlatDB.h"

extern MYSQL *h_lemlat_db;


static MYSQL_RES *Cods;
static MYSQL_ROW  cur_cod;

int descr_cod_morf( const int pos, const char cod, char* field_descr,char* value_descr)
{
	
	char selectRec[MAX_Q_LEN*2];
	int res;
	sprintf(selectRec,
	   "SELECT %s,%s \
		FROM %s WHERE %s=%u AND %s=LOWER(\'%c\')",
        "field_descr","value_descr","cod_morf",
		"field_pos",pos,"value",cod );
    res=first_row(h_lemlat_db,selectRec,&Cods,&cur_cod);
	if (res)
	{
		strcpy(field_descr,(char*)cur_cod[0]);
		strcpy(value_descr,(char*)cur_cod[1]);
	}
	else
	{
		strcpy(field_descr,"");
		strcpy(value_descr,"");
	}
    return( res && !next_row(Cods,&cur_cod));
}
