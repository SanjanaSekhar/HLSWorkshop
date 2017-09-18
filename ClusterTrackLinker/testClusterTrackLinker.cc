#include "ClusterFinder.hh"
#include "ClusterTrackLinker.hh"

#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <iostream>
#include <algorithm>
using namespace std;

double flat(double range) {
  long int r = random();
  double rDouble = r;
  double rMax = RAND_MAX;
  double flat = range * r / rMax;
  return flat;
}

int poisson(double mean) {
  static double oldMean = -1;
  static double g;
  if(mean != oldMean) {
    oldMean = mean;
    if(mean == 0) {
      g = 0;
    }
    else {
      g = exp(-mean);
    }
  }    
  double em = -1;
  double t = 1;
  do {
    em++;
    t *= flat(1.);
  } while(t > g);
  return em;
}

void WriteLinkMapCTL(
  uint16_t crystals[NCaloLayer1Eta][NCaloLayer1Phi][NCrystalsPerEtaPhi][NCrystalsPerEtaPhi], 
  uint16_t peakEta[NCaloLayer1Eta][NCaloLayer1Phi], 
  uint16_t peakPhi[NCaloLayer1Eta][NCaloLayer1Phi],
  uint16_t largeClusterET[NCaloLayer1Eta][NCaloLayer1Phi],
  uint16_t smallClusterET[NCaloLayer1Eta][NCaloLayer1Phi],
  uint16_t trackPT[MaxTracksInCard],
  uint16_t trackEta[MaxTracksInCard],
  uint16_t trackPhi[MaxTracksInCard],
  uint16_t linkedTrackPT[MaxTracksInCard],
  uint16_t linkedTrackEta[MaxTracksInCard],
  uint16_t linkedTrackPhi[MaxTracksInCard],
  uint16_t linkedTrackQuality[MaxTracksInCard],
  uint16_t neutralClusterET[MaxNeutralClusters],
  uint16_t neutralClusterEta[MaxNeutralClusters],
  uint16_t neutralClusterPhi[MaxNeutralClusters]) {
  // This code is to write suitable mapping of inputs to signals in the CTP7_HLS project frok Ales
  // Block 1 of User Code
  int iRgn, jRgn, mRgn, hRgn, iHFRgn, link, loBit, hiBit;

  //ClusterTrackLinker
  //printf("\n----------------ClusterTrackLinker---------------\n\n");
  for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           printf("peakEta_%d_%d : IN STD_LOGIC_VECTOR (15 downto 0);\n", mRgn,hRgn);
        }
      }
  printf("\n");
  for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           printf("peakPhi_%d_%d : IN STD_LOGIC_VECTOR (15 downto 0);\n", mRgn,hRgn);
        }
      }
  printf("\n");
  for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           printf("smallClusterET_%d_%d : IN STD_LOGIC_VECTOR (15 downto 0);\n", mRgn,hRgn);
        }
      }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("trackPT_%d : IN STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("trackEta_%d : IN STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("trackPhi_%d : IN STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("linkedTrackPT_%d : OUT STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("linkedTrackEta_%d : OUT STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("linkedTrackPhi_%d : OUT STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("linkedTrackQuality_%d : OUT STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           printf("neutralClusterET_%d : OUT STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           printf("neutralClusterEta_%d : OUT STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           printf("neutralClusterPhi_%d : OUT STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  //printf("HT_0 : OUT STD_LOGIC_VECTOR (15 downto 0);\n\n\n");
  //-------------------------------------------------------------------------------------------------
  // Block 2
  //  int iRgn, jRgn, mRgn, hRgn iHFRgn, link, loBit, hiBit;
  
  //ClusterTrackLinker
  printf("\n----------------ClusterTrackLinker---------------\n\n");
  for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           printf("signal peakEta_%d_%d : STD_LOGIC_VECTOR (15 downto 0);\n", mRgn,hRgn);
        }
      }
  printf("\n");
  for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           printf("signal peakPhi_%d_%d : STD_LOGIC_VECTOR (15 downto 0);\n", mRgn,hRgn);
        }
      }
  printf("\n");
  for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           printf("signal smallClusterET_%d_%d : STD_LOGIC_VECTOR (15 downto 0);\n", mRgn,hRgn);
        }
      }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("signal trackPT_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("signal trackEta_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("signal trackPhi_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("signal linkedTrackPT_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("signal linkedTrackEta_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("signal linkedTrackPhi_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("signal linkedTrackQuality_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           printf("signal neutralClusterET_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           printf("signal neutralClusterEta_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           printf("signal neutralClusterPhi_%d : STD_LOGIC_VECTOR (15 downto 0);\n",hRgn);
        }
  /*
  for(iRgn = 0; iRgn < NCrts*NCrds*NRgns; iRgn++) {
    printf("signal rgnET_%d : STD_LOGIC_VECTOR(15 DOWNTO 0);\n", iRgn);
  }
  for(iHFRgn = 0; iHFRgn < NCrts * NHFRgns; iHFRgn++) {
    printf("signal hfET_%d : STD_LOGIC_VECTOR(15 DOWNTO 0);\n", iHFRgn);
  }
  printf("signal HT_0 : STD_LOGIC_VECTOR (15 downto 0);\n\n\n");
  */
  //-------------------------------------------------------------------------------------
  // Block 3
  
  //ClusterTrackLinker
  //printf("\n----------------ClusterTrackLinker---------------\n\n");
  for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           printf("peakEta_%d_%d => peakEta_%d_%d,\n", mRgn,hRgn,mRgn,hRgn);
        }
      }
  printf("\n");
  for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
          printf("peakPhi_%d_%d => peakPhi_%d_%d,\n", mRgn,hRgn,mRgn,hRgn);         
        }
      }
  printf("\n");
  for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           printf("smallClusterET_%d_%d => smallClusterET_%d_%d,\n", mRgn,hRgn,mRgn,hRgn);
        }
      }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("trackPT_%d => trackPT_%d,\n", hRgn,hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("trackEta_%d => trackEta_%d,\n", hRgn,hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("trackPhi_%d => trackPhi_%d,\n", hRgn,hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("linkedTrackPT_%d => linkedTrackPT_%d,\n", hRgn,hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("linkedTrackEta_%d => linkedTrackEta_%d,\n", hRgn,hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("linkedTrackPhi_%d => linkedTrackPhi_%d,\n", hRgn,hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           printf("linkedTrackQuality_%d => linkedTrackQuality_%d,\n", hRgn,hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           printf("neutralClusterET_%d => neutralClusterET_%d,\n",hRgn,hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           printf("neutralClusterEta_%d => neutralClusterEta_%d,\n",hRgn,hRgn);
        }
  printf("\n");
  for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           printf("neutralClusterPhi_%d => neutralClusterPhi_%d,\n",hRgn,hRgn);
        }
/*
  for(iRgn = 0; iRgn < NCrts*NCrds*NRgns; iRgn++) {
    printf("rgnET_%d => rgnET_%d,\n", iRgn, iRgn);
  }
  for(iHFRgn = 0; iHFRgn < NCrts * NHFRgns; iHFRgn++) {
    printf("hfET_%d => hfET_%d,\n", iHFRgn, iHFRgn);
  }
  printf("HT_0 => HT_0,\n\n\n");
  */
//---------------------------------------------------------------------------------------------------------------
  // Block 4
/*
  printf("======================================================================================")
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

------ CHECK THE BIT NUMBERS AND LINK NUMBERS IN ALL------
   */
  //printf("\n----------------ClusterFinder---------------\n\n");
  int k=0;
  
      for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("peakEta_%d_%d <= s_INPUT_LINK_ARR( %d )(%d downto %d);\n", mRgn, hRgn, link, hiBit, loBit);
        }
      }
 
      printf("\n");
      for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("peakPhi_%d_%d <= s_INPUT_LINK_ARR( %d )(%d downto %d);\n", mRgn, hRgn, link, hiBit, loBit);
        }
      }
 
      printf("\n");
      for(mRgn = 0; mRgn < NCrystalsPerEtaPhi; mRgn++){
        for (hRgn =0; hRgn < NCrystalsPerEtaPhi; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("smallClusterET_%d_%d <= s_INPUT_LINK_ARR( %d )(%d downto %d);\n", mRgn, hRgn, link, hiBit, loBit);
        }
      }
 
      printf("\n");
      for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("trackPT_%d <= s_INPUT_LINK_ARR( %d )(%d downto %d);\n", hRgn, link, hiBit, loBit);
        }
 
      printf("\n");
      for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("trackEta_%d <= s_INPUT_LINK_ARR( %d )(%d downto %d);\n", hRgn, link, hiBit, loBit);
        }
 
      printf("\n");
      for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("trackPhi_%d <= s_INPUT_LINK_ARR( %d )(%d downto %d);\n", hRgn, link, hiBit, loBit);
        }
      k=0;
      printf("\n");
      for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("s_OUTPUT_LINK_ARR( %d )(%d downto %d) <= linkedTrackPT_%d ;\n", link, hiBit, loBit, hRgn);
        }
 
      printf("\n");
      for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("s_OUTPUT_LINK_ARR( %d )(%d downto %d) <= linkedTrackEta_%d ;\n", link, hiBit, loBit, hRgn);
        }
 
      printf("\n");
      for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("s_OUTPUT_LINK_ARR( %d )(%d downto %d) <= linkedTrackPhi_%d ;\n", link, hiBit, loBit, hRgn);
        }
 
      printf("\n");
      for (hRgn =0; hRgn < MaxTracksInCard; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("s_OUTPUT_LINK_ARR( %d )(%d downto %d) <= linkedTrackQuality_%d ;\n", link, hiBit, loBit, hRgn);
        }
 
      printf("\n");
      for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;   
           printf("s_OUTPUT_LINK_ARR( %d )(%d downto %d) <= neutralClusterET_%d ;\n", link, hiBit, loBit,hRgn);
        }
 
      printf("\n");
      for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;   
           printf("s_OUTPUT_LINK_ARR( %d )(%d downto %d) <= neutralClusterEta_%d ;\n", link, hiBit, loBit, hRgn);
        }
 
      printf("\n");
      for (hRgn =0; hRgn < MaxNeutralClusters; hRgn++)
        {
           link = (k / 12);
           loBit = (k % 12) * 16;
           hiBit = loBit + 15;
           k++;  
           printf("s_OUTPUT_LINK_ARR( %d )(%d downto %d) <= neutralClusterPhi_%d ;\n", link, hiBit, loBit, hRgn);
        }
    }



int main(int argc, char **argv) {

  if(argc == 2) srandom((unsigned int) atoi(argv[1]));

  uint16_t crystals[NCaloLayer1Eta][NCaloLayer1Phi][NCrystalsPerEtaPhi][NCrystalsPerEtaPhi];
  for(int tEta = 0; tEta < NCaloLayer1Eta; tEta++) {
    for(int tPhi = 0; tPhi < NCaloLayer1Phi; tPhi++) {
      for(int cEta = 0; cEta < NCrystalsPerEtaPhi; cEta++) {
        for(int cPhi = 0; cPhi < NCrystalsPerEtaPhi; cPhi++) {
          crystals[tEta][tPhi][cEta][cPhi] = 0;
        }
      }
    }
  }
  uint16_t trackPT[MaxTracksInCard] = {0};
  uint16_t trackEta[MaxTracksInCard] = {0};
  uint16_t trackPhi[MaxTracksInCard] = {0};
  for(int track = 0; track < MaxTracksInCard; track++) {
    trackPT[track] = 0;
  }

  // Get a randok number of objects and tracks, but within hardware constraints

  int nObjects = max(poisson(50), int(MaxNeutralClusters));
  int nTracks = max(poisson(15), int(MaxTracksInCard));
  if(nTracks > nObjects) nTracks = nObjects;

  double totalET = 0;
  cout << "Generated objects: " << endl;
  cout << "tEta\ttPhi\tcEta\tcPhi\tobjectET" << endl;
  for(int object = 0; object < nObjects; object++) {
    // Crude simulation of dispersal of object ET for fun around some location
    double objectET = flat(1023.);
    int tEta = flat(17.);
    int tPhi = flat(4.);
    int cEta = flat(5.);
    int cPhi = flat(5.);
    // Print information
    cout << tEta
         << "\t" << tPhi
         << "\t" << cEta
         << "\t" << cPhi
         << "\t" << objectET << endl;
    for(int dEta = -1; dEta <= 1; dEta++) {
      for(int dPhi = -1; dPhi <= 1; dPhi++) {
        int ncEta = cEta + dEta;
        int ncPhi = cPhi + dPhi;
        // Start within the tower boundary
        int ntEta = tEta;
        int ntPhi = tPhi;
        // Adjust neighbor trigger tower as needed
        if(ncEta < 0) {ncEta = NCaloLayer1Phi; ntEta = tEta - 1;}
        else if(ncEta > NCaloLayer1Phi) {ncEta = 0; ntEta = tEta + 1;}
        if(ncPhi < 0) {ncPhi = NCaloLayer1Phi; ntPhi = tPhi - 1;}
        else if(ncPhi > NCaloLayer1Phi) {ncPhi = 0; ntPhi = tPhi + 1;}
        // Ignore spill-overs outside the card, defering to next layer
        if(dEta == 0 && dPhi == 0) {
          crystals[tEta][tPhi][cEta][cPhi] = (objectET * 0.9);
        }
        else {
          if(ntEta >= 0 && ntEta < NCaloLayer1Eta && ntPhi >= 0 && ntPhi < NCaloLayer1Phi)
            crystals[ntEta][ntPhi][ncEta][ncPhi] = (objectET * 0.1 / 8.);
        }
      }
    }
    totalET += objectET;
    // Set matching track parameters for nTracks chosen
    if(object < nTracks) {
      double phi = (tPhi * NCrystalsPerEtaPhi + cPhi) * (0.087 / NCrystalsPerEtaPhi);
      // PT is measured with LSB = 1 GeV
      trackPT[object] = int(objectET);
      trackEta[object] = (tEta * NCrystalsPerEtaPhi + cEta) * MaxTrackEta / NCrystalsInEta;
      trackPhi[object] = (tPhi * NCrystalsPerEtaPhi + cPhi) * MaxTrackPhi / NCrystalsInPhi;
    }
  }
  cout << "Total generated ET = " << totalET << endl;
  uint16_t totalDeposited = 0;
  for(int tEta = 0; tEta < NCaloLayer1Eta; tEta++) {
    for(int tPhi = 0; tPhi < NCaloLayer1Phi; tPhi++) {
      for(int cEta = 0; cEta < NCrystalsPerEtaPhi; cEta++) {
        for(int cPhi = 0; cPhi < NCrystalsPerEtaPhi; cPhi++) {
          totalDeposited += crystals[tEta][tPhi][cEta][cPhi];
        }
      }
    }
  }
  cout << "Total deposited ET = " << totalDeposited << endl;
  uint16_t peakEta[NCaloLayer1Eta][NCaloLayer1Phi];
  uint16_t peakPhi[NCaloLayer1Eta][NCaloLayer1Phi];
  uint16_t largeClusterET[NCaloLayer1Eta][NCaloLayer1Phi];
  uint16_t smallClusterET[NCaloLayer1Eta][NCaloLayer1Phi];
  uint16_t totalCardET = 0;
  if(getClustersInCard(crystals, peakEta, peakPhi, largeClusterET, smallClusterET)) {
    cout << "Frok the cluster simulation: " << endl;
    cout << "tEta\ttPhi\tpeakEta\tpeakPhi\tlargeClusterET\tsmallClusterET" << endl;
    for(int tEta = 0; tEta < NCaloLayer1Eta; tEta++) {
      for(int tPhi = 0; tPhi < NCaloLayer1Phi; tPhi++) {
        if(largeClusterET[tEta][tPhi] > 0) 
          cout << tEta
               << "\t" << tPhi
               << "\t" << peakEta[tEta][tPhi]
               << "\t" << peakPhi[tEta][tPhi]
               << "\t" << largeClusterET[tEta][tPhi]
               << "\t" << smallClusterET[tEta][tPhi] << endl;
        totalCardET += largeClusterET[tEta][tPhi];
      }
    }
    cout << "Total card ET = " << totalCardET << endl;
  }
  else {
    cout << "ClusterFinder failed" << endl;
    return 1;
  }

  uint16_t linkedTrackPT[MaxTracksInCard] = {0};
  uint16_t linkedTrackEta[MaxTracksInCard] = {0};
  uint16_t linkedTrackPhi[MaxTracksInCard] = {0};
  uint16_t linkedTrackQuality[MaxTracksInCard] = {0};
  uint16_t neutralClusterET[MaxNeutralClusters] = {0};
  uint16_t neutralClusterEta[MaxNeutralClusters] = {0};
  uint16_t neutralClusterPhi[MaxNeutralClusters] = {0};

  if(getClusterTrackLinker(smallClusterET, peakEta, peakPhi, 
         trackPT, trackEta, trackPhi, 
         linkedTrackPT, linkedTrackEta, linkedTrackPhi, linkedTrackQuality,
         neutralClusterET, neutralClusterEta, neutralClusterPhi)) {

    cout << "Frok the cluster-track linking simulation: " << endl;

    cout << "LinkedTracks: " << endl;
    cout << "trackEta\ttrackPhi\ttrackPT\ttrackLinkQuality" << endl;
    for(int track = 0; track < MaxTracksInCard; track++) {
      if(linkedTrackPT[track] > 0) {
  cout << linkedTrackEta[track]
       << "\t" << linkedTrackPhi[track]
       << "\t" << linkedTrackPT[track]
       << "\t" << linkedTrackQuality[track]
       << endl;
      }
    }

    cout << "Neutral Clusters: " << endl;
    cout << "clusterEta\tclusterPhi\tclusterET" << endl;
    for(int cluster = 0; cluster < MaxNeutralClusters; cluster++) {
      if(neutralClusterET[cluster] > 0) {
  cout << neutralClusterEta[cluster]
       << "\t" << neutralClusterPhi[cluster]
       << "\t" << neutralClusterET[cluster]
       << endl;
      }
    }

  }
  WriteLinkMapCTL(
  crystals, 
  peakEta, 
  peakPhi,
  largeClusterET,
  smallClusterET,
  trackPT,
  trackEta,
  trackPhi,
  linkedTrackPT,
  linkedTrackEta,
  linkedTrackPhi,
  linkedTrackQuality,
  neutralClusterET,
  neutralClusterEta,
  neutralClusterPhi);
  return 0;
}

