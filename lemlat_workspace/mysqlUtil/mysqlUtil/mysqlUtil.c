#include "mysqlUtil.h"
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

static FILE* errorFile;
static FILE* logFile;

/*--------------------------------------------------------------------*/

static void die(MYSQL *db, char *fmt, ...)
{
	va_list ap;
	va_start(ap,fmt);
	vfprintf(errorFile,fmt,ap);
	va_end(ap);
	(void)putc('\n',errorFile);
	if (db)
		db_disconnect(db, 0);
	exit(EXIT_FAILURE);
}

/*--------------------------------------------------------------------*/

void start_server(const char * app_name, const char* cnfFile)
{
char *server_groups[2];/* ={"lemlat_SERVER",NULL};*/
char *server_args[3];/*= {"lemlat","--defaults-file=./my.cnf", NULL};*/

if (app_name!=NULL)
{
	server_groups[0]=(char*)malloc( strlen(app_name)+strlen(DEFAULT_SERVER_GROUP)+1 );
	sprintf( server_groups[0], "%s%s",app_name,DEFAULT_SERVER_GROUP );
}
else
	server_groups[0]=NULL;
server_groups[1]=NULL;

server_args[0]=(char*)malloc( strlen("lemlat")+1 );
strcpy( server_args[0], "lemlat" );

if (cnfFile!=NULL)
{
server_args[1]=(char*)malloc( strlen("--defaults-file=")+strlen(cnfFile)+1 );
sprintf( server_args[1], "--defaults-file=%s",cnfFile );
}
else
{
server_args[1]=(char*)malloc( strlen("--defaults-file=")+strlen(DEFAULT_CNF_FILE)+1 );
sprintf( server_args[1], "--defaults-file=%s",DEFAULT_CNF_FILE );
}

server_args[2]=NULL;

mysql_server_init(2,(char**)server_args,(char**)server_groups);

}

/*--------------------------------------------------------------------*/

MYSQL *db_connect(const char * app_name, const char* cnfFile, const int startServer,
				  FILE* lf, FILE* ef)
{
	MYSQL *db;

	logFile=lf;
	errorFile=ef;

	if ( startServer )
		start_server(app_name,cnfFile);

	db =mysql_init(NULL);
	if (!db)
		die(db,"mysql_init failed: no memory");

	if (cnfFile!=NULL)
		if (cnfFile[0])
			mysql_options(db,MYSQL_READ_DEFAULT_FILE,cnfFile);
		else
			mysql_options(db,MYSQL_READ_DEFAULT_FILE, DEFAULT_CNF_FILE);
	else
		mysql_options(db,MYSQL_READ_DEFAULT_FILE, DEFAULT_CNF_FILE);

	if (app_name!=NULL)
		mysql_options(db,MYSQL_READ_DEFAULT_GROUP, app_name);

	if (!mysql_real_connect(db,NULL,NULL,NULL,NULL,0,NULL,0))
		die(db,"mysql_real_connect failed: %s",mysql_error(db));
	return db;
}

/*--------------------------------------------------------------------*/

void db_disconnect(MYSQL *db, const int stopServer)
{
	mysql_close(db);
	if ( stopServer )
		mysql_server_end();
}

/*--------------------------------------------------------------------*/

void db_do_query(MYSQL *db, const char *query/*,FILE* resFile*/)
{
	if (mysql_query(db,query)!=0)
		goto err;

	return;

err:
	die(db,"db_do_query failed: %s [%s]",mysql_error(db),query);
}

/*--------------------------------------------------------------------*/

int first_row(MYSQL *db, const char *query,MYSQL_RES **db_res,MYSQL_ROW *db_res_row)
{
	if (mysql_query(db,query)!=0)
		goto err;
	if (mysql_field_count(db)>0)
	{
		if (!(*db_res=mysql_store_result(db)))
			goto err;
		if ((*db_res_row=mysql_fetch_row(*db_res)))
			return(1);
		else
		{
			mysql_free_result(*db_res);
			*db_res=NULL;
			return(0);
		}
	}
	else
        return(0);

	return(1);

err:
	die(db,"db_do_query failed: %s [%s]",mysql_error(db),query);
	return(0);
}

/*--------------------------------------------------------------------*/

int next_row(MYSQL_RES *db_res,MYSQL_ROW *db_res_row)
{
	if ((*db_res_row=mysql_fetch_row(db_res)))
		return(1);
	else
	{
		mysql_free_result(db_res);
		return(0);
	}
}

