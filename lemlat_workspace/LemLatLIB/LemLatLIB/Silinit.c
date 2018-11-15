#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef WIN32
	#include <io.h>
#else
	#include <unistd.h>
#endif

#include "silset.h"
#include "lemlatDB.h"

FILE* plog;

LES_ROW areavs;
struct silType sil;
/*-------------------------------------------------------------*/

void initial(const char* app_name, const char* cnfFile, const int startServer,
			 FILE* lf, FILE* ef)
{
int i;

*sil.ind_alt='\0';
for(i=0;i<7;i++) sil.segment[i]=NULL;
sil.isLE=0;
sil.form=(char*)malloc(64);

ll_connect(app_name, cnfFile, startServer, lf, ef);
//PAOLO
/*--------------inzializzazione nome tabella lessario---------------*/
initLESsource(NULL);
//OLOAP

}

/*-------------------------------------------------------------*/

void finalize(const int stopServer)
{
	ll_disconnect( stopServer );
	free(sil.form);
	sil.form=NULL;
}
