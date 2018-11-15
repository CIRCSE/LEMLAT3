#ifndef __SILSET
#define __SILSET
#include "lemlatDB.h"

extern LES_ROW areavs;


struct silType {
   char radical[30];
   char *form;
   char lemma[487];
   char codice[5];
   char eagles3[3];
   char rad_sf[30];
   char rad_si[30];
   char rad_spfe[30];
   char rad_spf[30];
   char rad_sm1[30];
   char rad_sm2[30];
   char rad_alt[30];
   char rad_sai[30];
   char ind_alt[4];
   char *segment[7];
   int part;
   int isLE;
};
extern struct silType sil;

#endif
