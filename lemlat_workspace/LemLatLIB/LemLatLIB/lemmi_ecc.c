#include "silset.h" 
//#include "silio.h" 
#include "sillib.h" 
#include "lemlatDB.h"
//#include "sillem.h"
#include <string.h>

//paolo 20-11-05
/*
MYSQL_RES *curLem_set;
MYSQL_ROW  curLem;
int        anyLem;
*/
//oloap

int comp_le( const char *str)
{
/*	
	struct areavsType areal;
*/
	LES_ROW areal;

	if (*sil.ind_alt)
		if ( !compai() ) return 0;

	if (isanySI() && *(getSI()))
		if ( !compsi() ) return 0;

	if (isanySPF(SPF1) && *(getSPF(SPF1)) )
		if ( !compspfe() ) return 0;

	if (isanySPF(SPF2) )
		if ( !compspf() ) return 0;

	areacp(&areal,&areavs);
	sil.isLE=1;
    lemtiz(&areal,IPOLEMMA);
	sil.isLE=0;
	lemv(&areal, IPERLEMMA);

	return 1;
}

int lemmi_ecc( const char *str)
{

	strcpy(sil.radical,str);

	*sil.ind_alt='\0';
	*sil.rad_alt='\0';

	for ( getLEset(str);isanyLE(); nextLE() )
		for ( getLESset( getLE_LESid(), BY_KEY ); isanyLES(BY_KEY); nextLES(BY_KEY) )
		{
			getLES(&areavs, BY_KEY);
			comp_le(sil.radical);
		}


	return 1;
}
