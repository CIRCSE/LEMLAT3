#include <stdlib.h>
#include "silset.h" 
#include "sillib.h"
#include "lemlatDB.h"
 
void siln()
{
static char dummy[2]="\0";
 
while(sil.form!=NULL)
{
	for(getSPFset(sil.form,SPF1); isanySPF(SPF1); nextSPF(SPF1))
	{
		sil.segment[6]=dummy;
		spferic();

		for(getSPFset(sil.rad_spfe,SPF2); isanySPF(SPF2); nextSPF(SPF2))
		{
			sil.segment[0]=dummy;
			spfric();
			sil.segment[5]=getSPF(SPF2);

			for(getSIset(sil.rad_spf); isanySI(); nextSI())
			{
				sil.segment[4]=dummy;
				siric();
				sil.segment[0]=getSI();

				sil.segment[3]=sil.segment[2]=dummy;
				sil.segment[1]=sil.rad_si;
				lemmi_ecc(sil.rad_si);
			
				for(getSFset(sil.rad_si); isanySF(); nextSF())
				{
					sil.segment[3]=sil.segment[2]=dummy;
					sfric();
					sil.segment[4]=getSF(); //attenzione!!!
					sil.segment[1]=sil.rad_sf;

					if (*sil.rad_sf) analysis(sil.rad_sf);
				
					for(getSMset(sil.rad_sf,SM1); isanySM(SM1); nextSM(SM1))
					{
						sil.segment[2]=dummy;
						smric(sil.rad_sf,sil.rad_sm1,SM1);
						sil.segment[3]=getSM(SM1);
						sil.segment[1]=sil.rad_sm1;
					
						if (*sil.rad_sm1) analysis(sil.rad_sm1);
					
						for(getSMset(sil.rad_sm1,SM2); isanySM(SM2); nextSM(SM2))
						{
							smric(sil.rad_sm1,sil.rad_sm2,SM2);
							sil.segment[2]=getSM(SM2);
							sil.segment[1]=sil.rad_sm2;

							if (*sil.rad_sm2) analysis(sil.rad_sm2);
						}
					}
				}
			}
		}
	}
	break;
}
}

