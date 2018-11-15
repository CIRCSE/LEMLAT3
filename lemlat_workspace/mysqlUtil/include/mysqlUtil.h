#if defined(_WIN32) || defined(_WIN64)
#include <windows.h>
#endif

#include <stdio.h>
#include "mysql.h"

#define DEFAULT_CNF_FILE "./my.cnf"

#define DEFAULT_SERVER_GROUP "_SERVER"

MYSQL *db_connect(const char * app_name, const char* cnfFile,  const int startServer,
				  FILE* lf, FILE* ef);
void db_disconnect(MYSQL *db, const int stopServer);
void db_do_query(MYSQL *db,const char *query);
int first_row(MYSQL *db, const char *query,MYSQL_RES **db_res,MYSQL_ROW *db_res_row);
int next_row(MYSQL_RES *db_res,MYSQL_ROW *db_res_row);
