#include "lemlatDB.h"
#include "mysqlUtil.h"
#include "tabSPF_def.h"

extern MYSQL *h_lemlat_db;

static MYSQL_RES *curSPFset[SPF_MAX];
static MYSQL_ROW  curSPF[SPF_MAX];
static int        anySPF[SPF_MAX]={0,0};

int getSPFset( const char *str, int spf_n )
{
	
	char selectRec[MAX_Q_LEN*2];
	switch (spf_n)
	{
	case SPF1:
		sprintf(selectRec,
		   "SELECT  %s, %s \
			FROM %s WHERE %s=RIGHT(\'%s\',LENGTH(%s)) \
			AND (LEFT(%s,1)='e' OR %s='') \
			ORDER BY LENGTH(%s)",
		    SEG_SPF,C_COD_SPF, 
			TAB_SPF_NAME,SEG_SPF,str,SEG_SPF,
			C_COD_SPF,C_COD_SPF,
			SEG_SPF );
		break;
	case SPF2:
		sprintf(selectRec,
		   "SELECT  %s, %s \
			FROM %s WHERE %s=RIGHT(\'%s\',LENGTH(%s)) \
			AND (LEFT(%s,1)!='e' OR %s='')\
			ORDER BY LENGTH(%s)",
		    SEG_SPF,C_COD_SPF, 
			TAB_SPF_NAME,SEG_SPF,str,SEG_SPF,
			C_COD_SPF,C_COD_SPF,
			SEG_SPF );
		break;
	}
    return( anySPF[spf_n]=first_row(h_lemlat_db,selectRec,&curSPFset[spf_n],&curSPF[spf_n]) );
}


int  nextSPF( int spf_n )
{
	return( anySPF[spf_n]=next_row( curSPFset[spf_n], &curSPF[spf_n] ) );
}


int isanySPF( int spf_n )
{
	return(anySPF[spf_n]);
}


char *getSPF( int spf_n )
{
	return( (char*)(curSPF[spf_n])[0] );
}


char *getSPF_cod( int spf_n )
{
	return( (char*)(curSPF[spf_n])[1] );
}
