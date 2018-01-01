//MakeHT with some modifications: 
//HT is no longer an array of size 1 but just a 16 bit integer
//Add multiple cutoffs, 3 for rgnET and 3 for hfET -> HT->HT[3]
//remove the else parts

#include <stdint.h>
#include "MakeHT2.h"

void MakeHT(uint16_t rgnET[NCrts*NCrds*NRgns], uint16_t hfET[NCrts*NHFRgns], uint16_t HT[3]) {
#pragma HLS PIPELINE II=6
#pragma HLS ARRAY_PARTITION variable=rgnET block factor=4
#pragma HLS ARRAY_PARTITION variable=hfET block factor=4
#pragma HLS ARRAY_PARTITION variable=HT block factor=4

	uint16_t rgnHT = 0;
	uint16_t hfHT = 0;
iRgn:
	for(int iRgn = 0; iRgn < NCrts*NCrds*NRgns; iRgn++) {
#pragma HLS UNROLL
#pragma HLS DEPENDENCE intra true 
		if(rgnET[iRgn] > MinETCutForHT1) HT[0] += rgnET[iRgn];
		else { if(rgnET[iRgn] > MinETCutForHT2) HT[1] += rgnET[iRgn];
		else { if(rgnET[iRgn] > MinETCutForHT3) HT[2] += rgnET[iRgn];
		else HT[0]+=0;
	}}}
iHFRgn:
	for(int iHFRgn = 0; iHFRgn < NCrts * NHFRgns; iHFRgn++) {
#pragma HLS UNROLL
#pragma HLS DEPENDENCE intra true 
		if(hfET[iHFRgn] > MinHFETCutForHT1) HT[0] += hfET[iHFRgn];
		else { if(hfET[iHFRgn] > MinHFETCutForHT2) HT[1] += hfET[iHFRgn];
		else { if(hfET[iHFRgn] > MinHFETCutForHT3) HT[2] += hfET[iHFRgn];
		else HT[0]+=0;
	}}}
	//HT = rgnHT + hfHT;
	//return HT;
}