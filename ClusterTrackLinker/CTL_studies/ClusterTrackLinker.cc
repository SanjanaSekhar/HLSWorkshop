#include "ClusterFinder.hh"
#include "ClusterTrackLinker.hh"
#include <stdio.h>
bool getClusterTrackLinker(uint16_t clusterET[NCaloLayer1Eta][NCaloLayer1Phi],
			   uint16_t peakEta[NCaloLayer1Eta][NCaloLayer1Phi], 
			   uint16_t peakPhi[NCaloLayer1Eta][NCaloLayer1Phi], 
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
#pragma HLS PIPELINE II=6
#pragma HLS ARRAY_PARTITION variable=clusterET complete dim=0
#pragma HLS ARRAY_PARTITION variable=peakEta complete dim=0
#pragma HLS ARRAY_PARTITION variable=peakPhi complete dim=0
#pragma HLS ARRAY_PARTITION variable=trackPT complete dim=0
#pragma HLS ARRAY_PARTITION variable=trackEta complete dim=0
#pragma HLS ARRAY_PARTITION variable=trackPhi complete dim=0
#pragma HLS ARRAY_PARTITION variable=linkedTrackPT complete dim=0
#pragma HLS ARRAY_PARTITION variable=linkedTrackEta complete dim=0
#pragma HLS ARRAY_PARTITION variable=linkedTrackPhi complete dim=0
#pragma HLS ARRAY_PARTITION variable=linkedTrackQuality complete dim=0
#pragma HLS ARRAY_PARTITION variable=neutralClusterET complete dim=0
#pragma HLS ARRAY_PARTITION variable=neutralClusterEta complete dim=0
#pragma HLS ARRAY_PARTITION variable=neutralClusterPhi complete dim=0
  uint16_t clusterEta[MaxNeutralClusters];
  uint16_t clusterPhi[MaxNeutralClusters];
#pragma HLS ARRAY_PARTITION variable=clusterEta complete dim=0
#pragma HLS ARRAY_PARTITION variable=clusterPhi complete dim=0
  printf("==== peakEta ====\n");
  for(int i=0;i<NCaloLayer1Eta;i++)
  {
    for(int j=0;j<NCaloLayer1Phi;j++)
    {
      printf("%d,%d: %04x\n",i,j,peakEta[i][j]);
    }
  }
  printf("==== peakPhi ====\n");
  for(int i=0;i<NCaloLayer1Eta;i++)
  {
    for(int j=0;j<NCaloLayer1Phi;j++)
    {
      printf("%d,%d: %04x\n",i,j,peakPhi[i][j]);
    }
  }
  printf("==== clusterET ====\n");
  for(int i=0;i<NCaloLayer1Eta;i++)
  {
    for(int j=0;j<NCaloLayer1Phi;j++)
    {
      printf("%d,%d: %04x\n",i,j,clusterET[i][j]);
    }
  }
    printf("==== trackPT ====\n");
    for(int j=0;j<MaxTracksInCard;j++)
    {
      printf("%d: %04x\n",j,trackPT[j]);
    }
    printf("==== trackEta ====\n");
    for(int j=0;j<MaxTracksInCard;j++)
    {
      printf("%d: %04x\n",j,trackEta[j]);
    }
    printf("==== trackPhi ====\n");
    for(int j=0;j<MaxTracksInCard;j++)
    {
      printf("%d: %04x\n",j,trackPhi[j]);
    }
  getClusterPositions(clusterEta,clusterPhi,peakPhi,peakEta);

  for(int tEta = 0; tEta < NCaloLayer1Eta; tEta++) {
#pragma HLS UNROLL
    for(int tPhi = 0; tPhi < NCaloLayer1Phi; tPhi++) {
#pragma HLS UNROLL
      int cluster = tEta * NCaloLayer1Phi + tPhi;
      // Convert cruder calorimeter position to track LSB
      // This can be a LUT - perhaps HLS will take care of this efficiently
      //clusterEta[cluster] = (tEta * NCrystalsPerEtaPhi + peakEta[tEta][tPhi]) * MaxTrackEta / NCrystalsInEta;
      //clusterPhi[cluster] = (tPhi * NCrystalsPerEtaPhi + peakPhi[tEta][tPhi]) * MaxTrackPhi / NCrystalsInPhi;
      // Initialize neutral clusters
      neutralClusterET[cluster] = clusterET[tEta][tPhi];
      neutralClusterEta[cluster] = clusterEta[cluster];
      neutralClusterPhi[cluster] = clusterPhi[cluster];
    }
  }
  // Double loop over tracks and clusters for linking
  for(int track = 0; track < MaxTracksInCard; track++) {
#pragma HLS UNROLL
    linkedTrackPT[track] = trackPT[track];
    linkedTrackEta[track] = trackEta[track];
    linkedTrackPhi[track] = trackPhi[track];
    linkedTrackQuality[track] = 0;
    uint8_t nMatches = 0;
    for(int cluster = 0; cluster < MaxNeutralClusters; cluster++) {
#pragma HLS UNROLL
      uint16_t diffEta = clusterEta[cluster] - trackEta[track];
      if(diffEta >= MaxTrackEta) diffEta = trackEta[track] - clusterEta[cluster];
      uint16_t diffPhi = clusterPhi[cluster] - trackPhi[track];
      if(diffPhi >= MaxTrackPhi) diffPhi = trackPhi[track] - clusterPhi[cluster];
      if(diffEta <= 1 && diffPhi <= 2) {
        nMatches++;
        linkedTrackQuality[track] |= 0x0001;
        if(diffEta <= 1 && diffPhi <= 1) {
          linkedTrackQuality[track] |= 0x0002;
        }
        if(diffEta == 0 && diffPhi == 0) {
          linkedTrackQuality[track] |= 0x0004;
        }
        if(neutralClusterET[cluster] > trackPT[track]) {
          neutralClusterET[cluster] -= trackPT[track];
          linkedTrackQuality[track] |= 0x0010;
          // To do: Adjust eta, phi somehow
        }
        else {
          linkedTrackQuality[track] |= 0x0020;
          neutralClusterET[cluster] = 0;
        }
      }
    }
    linkedTrackQuality[track] |= (nMatches << 8);
  }
  return true;
}
void getClusterPositions(
  uint16_t clusterEta[MaxNeutralClusters],
  uint16_t clusterPhi[MaxNeutralClusters],
  uint16_t peakPhi[NCaloLayer1Eta][NCaloLayer1Phi],
  uint16_t peakEta[NCaloLayer1Eta][NCaloLayer1Phi])
{
  for(int tEta = 0; tEta < NCaloLayer1Eta; tEta++) {
#pragma HLS UNROLL
    for(int tPhi = 0; tPhi < NCaloLayer1Phi; tPhi++) {
#pragma HLS UNROLL
      int cluster = tEta * NCaloLayer1Phi + tPhi;
      // Convert cruder calorimeter position to track LSB
      // This can be a LUT - perhaps HLS will take care of this efficiently
      clusterEta[cluster] = (tEta * NCrystalsPerEtaPhi + peakEta[tEta][tPhi]) * MaxTrackEta / NCrystalsInEta;
      clusterPhi[cluster] = (tPhi * NCrystalsPerEtaPhi + peakPhi[tEta][tPhi]) * MaxTrackPhi / NCrystalsInPhi;
    }
  }
}