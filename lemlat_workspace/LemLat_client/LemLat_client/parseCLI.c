/*
 * parseCLI.c
 *
 *  Created on: 02/apr/2016
 *      Author: paolo
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "lemlatLIB.h"


#define LESSARIO_DUCANGE "lessario_ducange"
#define LESSARIO_ONOMASTICON "lessario_onomasticon"
#define LESSARIO_BASE "lessario_base"
#define LESSARIO_ALL "lessario"

int src=3;

//PAOLO
/*
char* LESSARIO;
*/
//OLOAP

int interactive;
FILE  *pi, *po, *pu;
FILE  *pxml, *pcsv;
int outxml=0;
int outcsv=0;
int outlem=0;

//PAOLO
/*
void     setLESsource(int s)
{
	src=s;
	switch (src) {
	case 0:
		strcpy(LESSARIO,LESSARIO_BASE);
		break;
	case 1:
		strcpy(LESSARIO,LESSARIO_ONOMASTICON);
		break;
	case 2:
		strcpy(LESSARIO,LESSARIO_DUCANGE);
		break;
	case 3:
		strcpy(LESSARIO,LESSARIO_ALL);
		break;
	default:
		printf("Wrong source!\n");
		exit(EXIT_FAILURE);
	}
}

char     getLESsource(int src)
{
	switch (src) {
	case 0:
		return 'B';
	case 1:
		return 'O';
	case 2:
		return 'D';
	case 3:
		return 'A';
	default:
		printf("Wrong source!\n");
		exit(EXIT_FAILURE);
	}
}
*/
void     setSource(int s)
{
	src=s;
	switch (src) {
	case 0:
		setLESsource(LESSARIO_BASE);
		break;
	case 1:
		setLESsource(LESSARIO_ONOMASTICON);
		break;
	case 2:
		setLESsource(LESSARIO_DUCANGE);
		break;
	case 3:
		setLESsource(LESSARIO_ALL);
		break;
	default:
		printf("Wrong source!\n");
		exit(EXIT_FAILURE);
	}
}

char     getSource(int src)
{
	switch (src) {
	case 0:
		return 'B';
	case 1:
		return 'O';
	case 2:
		return 'D';
	case 3:
		return 'A';
	default:
		printf("Wrong source!\n");
		exit(EXIT_FAILURE);
	}
}
//OLOAP

void usage(char *argv[]){
    printf("Usage:\n");
    printf("Show this HELP:   %s -h\n", argv[0]);
    printf("INTERACTIVE mode: %s [-s 0|1|2|3]\n", argv[0]);
    printf("BATCH mode:       %s [-s 0|1|2|3] -i filename  -o|-x|-c filename\n", argv[0]);
    printf(" -s n\tto use source according to n:\n");
    printf("     \t0 for BASE les list\n");
    printf("     \t1 for ONOMASTICON les list\n");
    printf("     \t2 for DU CANGE les list\n");
    printf("     \t3 for ALL les list [DEFAULT]\n");
    printf(" -i filename\tget input worform from FILE 'filename' and use: \n");
    printf("            \t filename.unk to store unknown wordforms \n");
    printf(" -o filename\toutput file in text format\n");
    printf(" -x filename\tencode output file in XML\n");
    printf(" -c filename\tencode output file in CSV\n");
}

static const char *optString = "s:i:o:x:c:h";

void parseCLI(int argc,char *argv[])
{
    char* inputfile=NULL;
    char* outputfile=NULL;
    char* outxmlfile=NULL;
    char* outcsvfile=NULL;
    char* outunkfile=NULL;


    int opt;
    while ((opt = getopt(argc, argv, optString)) != -1) {
        switch (opt) {
        case 's':
            src = atoi(optarg);
            break;
        case 'i':
            inputfile = (char*)malloc(80*sizeof(char));
            outunkfile = (char*)malloc(80*sizeof(char));
            strcpy(inputfile,optarg);
            strcpy(outunkfile,optarg);
            strcat(outunkfile,".unk");
            break;
        case 'o':
            outputfile = (char*)malloc(80*sizeof(char));
            strcpy(outputfile,optarg);
            break;
        case 'x':
            outxmlfile = (char*)malloc(80*sizeof(char));
            strcpy(outxmlfile,optarg);
            break;
        case 'c':
            outcsvfile = (char*)malloc(80*sizeof(char));
            strcpy(outcsvfile,optarg);
            break;
        case 'h':
        	usage(argv);
        	exit(0);
        default: /* '?' */
        	printf("Wrong arguments!\n");
        	usage(argv);
            exit(EXIT_FAILURE);
        }
    }

//SET file IO
	if (inputfile != NULL)
	{
		//input file
		if ((pi = fopen(inputfile,"r")) == NULL)
		{
			printf ("Cannot open %s\n", inputfile);
			exit(1);
		}
		interactive = 0;
		printf ("\n\tReading data from file '%s'\n" , inputfile);

		//unk file
		pu = fopen(outunkfile,"w");
		printf ("\tWriting Not analyzed wordforms to file '%s'\n",outunkfile);

		//out file
		if (outputfile != NULL)
		{
			po = fopen(outputfile,"w");
			printf ("\tWriting textual output to file '%s'\n",outputfile);
			outlem=1;
		}
		//xml file
		if (outxmlfile != NULL)
		{
			pxml = fopen(outxmlfile,"w");
			printf ("\tWriting XML output to file '%s'\n",outxmlfile);
			outxml=1;
		}
		//csv file
		if (outcsvfile != NULL)
		{
			if ((pcsv = fopen(outcsvfile,"w")) == NULL)
			{
				printf ("Cannot open %s\n", outcsvfile);
				exit(1);
			}
			printf ("\tWriting CSV output to file '%s'\n",outcsvfile);
			outcsv=1;
		}
		//no output file specified: using stdout!
		if ((outputfile == NULL) && (outxmlfile == NULL) && (outcsvfile == NULL))
		{
			po = stdout;
		}

	}
	else
	{
		interactive = 1;
		po=stdout;
		pu=stdout;
	}

//PAOLO
/*
//SET lessario
	LESSARIO=(char*)malloc(30*sizeof(char));
    setLESsource(src);
*/
    setSource(src);
//OLOAP
}
