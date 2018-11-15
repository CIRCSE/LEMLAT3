#include "mysqlUtil.h"

MYSQL *h_lemlat_db;

int ll_connect(const char * app_name, const char * cnfFile, const int startServer,
			   FILE* lf, FILE* ef)
{
	h_lemlat_db=db_connect(app_name, cnfFile, startServer, lf, ef);

	if ( h_lemlat_db==NULL )
		return(0);
	return 1;
}


void ll_disconnect(const int stopServer)
{
	db_disconnect(h_lemlat_db, stopServer);
}

