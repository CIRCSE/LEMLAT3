#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#include "lemlatLIB.h"
#include "LemLat_client.h"

#define PROMPT ">"

#ifdef LL_EMB
#define APP_NAME "lemlat_EMB"
#define SSS 1 //start stop server
#else
#define APP_NAME "lemlat_CLIENT"
#define SSS 0 //start stop server
#endif


int main(int argc,char *argv[])
{
	int noWF=0;
	int noUNK=0;
	int noANA=0;
	char* buffer = malloc(256*sizeof(char));

	char* token;
	char delims[]="\'\"!?.;:, \n\t\r()";

//PAOLO
/*
	programBanner();
	parseCLI(argc,argv);
*/
//OLOAP

    initial( APP_NAME, NULL, SSS,NULL,stdout );

//PAOLO
	programBanner();
	parseCLI(argc,argv);
//OLOAP


	if (interactive == 1 ) {
		interactiveModeBanner();
		interactiveModeUsage();
		do {
			//CONSOLE:
			buffer=prompt(PROMPT);
			if (buffer==NULL)
				break;
			silcall(buffer);
			putchar('\n');
			conOutLemmas();
		}
		while(buffer != NULL);
		if (redirectToFile) fclose(po);
	}
	else {
		//FILE:
		if (outxml) XMLheader();
//PAOLO
/*		
		while(!feof(pi)){
			printf("LOOP FILE");
			fgets(buffer, 255, pi);
*/
		while(fgets(buffer, 255, pi)!=NULL){
//OLOAP
			token = strtok(buffer, delims);
			while(token != NULL){
				noWF++;
				silcall(token);
				if (analyses.numAnalysis == 0)
				{
					noUNK++;
					//forma non analizzata
					fprintf (pu,"%-30s \n",analyses.in_form);
				}
				else
				{
					noANA++;
					if ( outxml ) XMLOut();
					if ( outcsv ) CSVOut();
					if ( outlem || !(outxml||outcsv)) conOutLemmas();
				}
				token = strtok(NULL, delims);
			}
		}

		if ( outxml )
		{
			XMLending();
			fclose(pxml);
		}
		if (outcsv) fclose(pcsv);
		if (outlem) fclose(po);

		fclose(pu);

		printf("\nNo Wordforms: \t%d\n", noWF);
		printf("No Unknown: \t%d\n", noUNK);
		printf("No Analysed: \t%d\n", noANA);
	}

	//	finalize(1);
	finalize(SSS);


//	printf("\nSHALOM ALEICHEM!\n");

	return 0;
}
