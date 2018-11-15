#include "lemlatDB.h"
#include "mysqlUtil.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *Lemmas;
static MYSQL_ROW  cur_lemma;

int build_lemma( const char* in_str, const char* cod, char* out_str)
{
	
	char selectRec[MAX_Q_LEN*2];
	int res;
//PAOLO 13-07-2018
// errore dopo aggiornamento a MariaDB e MySQL 5.7
/*
	sprintf(selectRec,
	   "SELECT INSERT(\'%s\',LENGTH(\'%s\')-LENGTH(%s)+1,LENGTH(%s),%s) \
		FROM %s WHERE %s=\'%s\' AND %s=RIGHT(\'%s\',LENGTH(%s)) \
		ORDER BY LENGTH(%s) DESC LIMIT 1",
        in_str,in_str,"in_ending","in_ending","out_ending",
		"lemma_ending",
		"codles",cod,"in_ending",in_str,"in_ending",
		"in_ending");
*/
	sprintf(selectRec,
       //SELECT CONCAT( SUBSTR('mentul',1,LENGTH('mentul')-LENGTH(in_ending)), out_ending )
	   "SELECT CONCAT( SUBSTR(\'%s\',1,LENGTH(\'%s\')-LENGTH(%s)), %s ) \
		FROM %s WHERE %s=\'%s\' AND %s=RIGHT(\'%s\',LENGTH(%s)) \
		ORDER BY LENGTH(%s) DESC LIMIT 1",
        /*SELECT*/in_str,in_str,"in_ending","out_ending",
		/*FROM*/"lemma_ending",
		/*WHERE*/"codles",cod,"in_ending",in_str,"in_ending",
		/*ORDER BY*/"in_ending");
//OLOAP
    res=first_row(h_lemlat_db,selectRec,&Lemmas,&cur_lemma);
	if (res)
		strcpy(out_str,(char*)cur_lemma[0]);
	else
		strcpy(out_str, in_str);

    return( res && !next_row(Lemmas,&cur_lemma));
}
