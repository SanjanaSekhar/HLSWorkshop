#include <stdint.h>
#include <stdio.h>

#include "MakeHT2.h"

#define NCrts 18
#define NCrds 7
#define NRgns 2
#define NHFRgns 8

void WriteLinkMapHT(uint16_t rgnET[NCrts*NCrds*NRgns], uint16_t hfET[NCrts*NHFRgns], uint16_t HT) {
  // This code is to write suitable mapping of inputs to signals in the CTP7_HLS project from Ales
  // Block 1 of User Code
  int iRgn, iHFRgn, link, loBit, hiBit;
  for(iRgn = 0; iRgn < NCrts*NCrds*NRgns; iRgn++) {
    printf("rgnET_%d : IN STD_LOGIC_VECTOR (15 downto 0);\n", iRgn);
  }
  for(iHFRgn = 0; iHFRgn < NCrts * NHFRgns; iHFRgn++) {
    printf("hfET_%d : IN STD_LOGIC_VECTOR (15 downto 0);\n", iHFRgn);
  }
  printf("HT_0 : OUT STD_LOGIC_VECTOR (15 downto 0);\n\n\n");
  // Block 2
  for(iRgn = 0; iRgn < NCrts*NCrds*NRgns; iRgn++) {
    printf("signal rgnET_%d : STD_LOGIC_VECTOR(15 DOWNTO 0);\n", iRgn);
  }
  for(iHFRgn = 0; iHFRgn < NCrts * NHFRgns; iHFRgn++) {
    printf("signal hfET_%d : STD_LOGIC_VECTOR(15 DOWNTO 0);\n", iHFRgn);
  }
  printf("signal HT_0 : STD_LOGIC_VECTOR (15 downto 0);\n\n\n");
  // Block 3
  for(iRgn = 0; iRgn < NCrts*NCrds*NRgns; iRgn++) {
    printf("rgnET_%d => rgnET_%d,\n", iRgn, iRgn);
  }
  for(iHFRgn = 0; iHFRgn < NCrts * NHFRgns; iHFRgn++) {
    printf("hfET_%d => hfET_%d,\n", iHFRgn, iHFRgn);
  }
  printf("HT_0 => HT_0,\n\n\n");
  // Block 4
  for(iRgn = 0; iRgn < NCrts*NCrds*NRgns; iRgn++) {
    // Each link can carry 192-bits, or 12x16-bits of data
    // Each iRgn needs 16 bits
    link = (iRgn / 12);
    loBit = (iRgn % 12) * 16;
    hiBit = loBit + 15;
    printf("rgnET_%d <= s_INPUT_LINK_ARR( %d )(%d downto %d);\n", iRgn, link, hiBit, loBit);
  }
  for(iHFRgn = 0; iHFRgn < NCrts * NHFRgns; iHFRgn++) {
    // Each link can carry 192-bits, or 12x16-bits of data
    // Each iHFRgn needs 16 bits
    link = (iHFRgn / 12) + 21;
    loBit = (iHFRgn % 12) * 16;
    hiBit = loBit + 15;
    printf("hfET_%d <= s_INPUT_LINK_ARR( %d )(%d downto %d);\n", iHFRgn, link, hiBit, loBit);
  }
  printf("s_OUTPUT_LINK_ARR( 0 )(15 downto 0) <= HT_0;\n");
}

int main(int argc, char **argv) {
  uint16_t rgnET[NCrts*NCrds*NRgns];
  uint16_t hfET[NCrts*NHFRgns];

  // Test data; Construct it using indices for the fun of it

  int iCrt;
  int iCrd;
  int iRgn;
  int i;
  int iHFRgn;
  for(iCrt = 0; iCrt < NCrts; iCrt++) {
    for(iCrd = 0; iCrd < NCrds; iCrd++) {
      for(iRgn = 0; iRgn < NRgns; iRgn++) {
        i = iCrt * NCrds * NRgns + iCrd * NRgns + iRgn;
        rgnET[i] = i;
      }
    }
    for(iHFRgn = 0; iHFRgn < NHFRgns; iHFRgn++) {
      i = iCrt * NHFRgns + iHFRgn;
      hfET[i] = i;
    }
  }

  // Determine HT using software

  uint16_t HT[3] = {0,0,0};
  for(iCrt = 0; iCrt < NCrts; iCrt++) {
    for(iCrd = 0; iCrd < NCrds; iCrd++) {
      for(iRgn = 0; iRgn < NRgns; iRgn++) {
        i = iCrt * NCrds * NRgns + iCrd * NRgns + iRgn;
        //if(rgnET[i] > MinETCutForHT) HT += rgnET[i];
        if(rgnET[i] > MinETCutForHT1) HT[0] += rgnET[i];
        else {if(rgnET[i] > MinETCutForHT2) HT[1] += rgnET[i];
        else {if(rgnET[i] > MinETCutForHT3) HT[2] += rgnET[i];
        else HT[0]+=0;
      }}}
    }
    for(iHFRgn = 0; iHFRgn < NHFRgns; iHFRgn++) {
      i = iCrt * NHFRgns + iHFRgn;
      //if(hfET[i] > MinHFETCutForHT) HT += hfET[i];
      if(hfET[i] > MinHFETCutForHT1) HT[0] += hfET[i];
      else {if(hfET[i] > MinHFETCutForHT2) HT[1] += hfET[i];
      else {if(hfET[i] > MinHFETCutForHT3) HT[2] += hfET[i];
      else HT[0]+=0;
    }}}
  }

  // Determine HT using hardware simulation
  // Are we declaring HT as a 1D array in order to pass by ref so that values neednt be returned?
  //uint16_t hlsHT = 0;
  uint16_t hlsHT[3]={0,0,0};
  MakeHT(rgnET, hfET, hlsHT);
  WriteLinkMapHT(rgnET, hfET, hlsHT[0]);
  // Compare

  printf("C says: HT[0] = %d; HLS says: HT[0] = %d\n", HT[0], hlsHT[0]);
  if(HT[0] != hlsHT[0]) 
    printf("Test failed\n");
  printf("C says: HT[1] = %d; HLS says: HT[1] = %d\n", HT[1], hlsHT[1]);
  if(HT[1] != hlsHT[1]) 
    printf("Test failed\n");
  printf("C says: HT[2] = %d; HLS says: HT[2] = %d\n", HT[2], hlsHT[2]);
  if(HT[2] != hlsHT[2]) 
    printf("Test failed\n");
    //return 1;
}  