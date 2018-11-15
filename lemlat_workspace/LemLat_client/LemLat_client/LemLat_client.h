#include <stdio.h>

char *prompt(char *message);
void parseCLI(int argc,char *argv[]);
void conOutLemmas();


extern char area [255];
extern int interactive;
extern FILE  *pi, *po, *pu;
extern FILE  *pxml, *pcsv;
extern short redirectToFile;

extern int outxml;
extern int outcsv;
extern int outlem;

//LES SOURCE
extern int src;
//PAOLO
/*
void setLESsource(int src);
char getLESsource(int src);
*/
void setSource(int src);
char getSource(int src);
//

void interactiveModeBanner();
void interactiveModeUsage();
void programBanner();
void usage(char *argv[]);

void XMLheader();
void XMLOut();
void XMLending();

void CSVOut();

