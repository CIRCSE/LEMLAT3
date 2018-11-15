#include <string.h>
#include <stdlib.h>
#ifndef WIN32
	#include <ctype.h>
#endif
#include "silset.h" 

extern int initAnalyses( const char* formorig, const char * form_alt);

int silcall(const char* wordform)
{
	void siln();
	int q;

	strcpy(sil.form,wordform);

    for (q=0; (unsigned int)q<strlen(sil.form); q++)
	{
		sil.form[q]=tolower(sil.form[q]);
        if (sil.form[q] == 'v') sil.form[q] = 'u';
        if (sil.form[q] == 'j') sil.form[q] = 'i';
        //BACO!!
        if (sil.form[q] == '\'') sil.form[q] = ' ';
	}
	sil.form[q] = '\0';

	initAnalyses( wordform, sil.form);

	siln();

	return 0;
}


