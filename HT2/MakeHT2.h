#ifndef MakeHT2_h
#define MakeHT2_h

#define NCrts 18
#define NCrds 7
#define NRgns 2
#define NHFRgns 8

#define MinETCutForHT1 20
#define MinETCutForHT2 10
#define MinETCutForHT3 5

#define MinHFETCutForHT1 20
#define MinHFETCutForHT2 10
#define MinHFETCutForHT3 5

#include <stdint.h>

void MakeHT(uint16_t rgnET[NCrts*NCrds*NRgns], uint16_t hfET[NCrts*NHFRgns], uint16_t HT[3]);

#endif
