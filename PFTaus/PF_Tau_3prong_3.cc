 #include "PF_Tau.hpp"
//changing all structs to arrays 
//changed all ap_int to uint
//particle type: 00 :electron; 01 :charged hadron; 10: muon
//position of tau cand is not weighted avg but a 
void tau_three_prong_alg(uint16_t pf_cands_et[N_TRACKS],
                         uint16_t pf_cands_eta_side[N_TRACKS],
                         uint16_t pf_cands_eta[N_TRACKS],
                         uint16_t pf_cands_phi[N_TRACKS],
                         uint16_t pf_cands_particle_type[N_TRACKS],
                         uint16_t tau_cands_et[4],
                         uint16_t tau_cands_eta_side[4],
                         uint16_t tau_cands_eta[4],
                         uint16_t tau_cands_phi[4],
                         uint16_t tau_cands_type[4],
                         uint16_t tau_cands_iso_charged[4],
                         uint16_t iso_sum_charged_hadron, 
                         uint16_t three_prong_seed, 
                         uint16_t three_prong_delta_r)
{
/*  pf_charged_t three_prong_tau_cand[3];
  pf_charged_t temphadron, second_prong_hadron,third_prong_hadron;
  pftau_t tau_cands_temp[4];

#pragma HLS ARRAY_PARTITION variable=tau_cands_temp complete dim=0
#pragma HLS ARRAY_PARTITION variable=pf_charged complete dim=0
#pragma HLS ARRAY_PARTITION variable=tau_cands complete dim=0
#pragma HLS ARRAY_PARTITION variable=three_prong_tau_cand complete dim=0
*/
uint16_t three_prong_cand_et[3];
uint16_t three_prong_cand_eta_side[3];
uint16_t three_prong_cand_eta[3];
uint16_t three_prong_cand_phi[3];
uint16_t three_prong_cand_particle_type[3];

uint16_t temphadron_et;
uint16_t temphadron_eta_side;
uint16_t temphadron_eta;
uint16_t temphadron_phi;
uint16_t temphadron_particle_type;

/*                     
uint16_t tau_cands_temp_et[4],
uint16_tF tau_cands_eta_side[4],
uint16_t tau_cands_eta[4],
uint16_t tau_cands_phi[4],
uint16_t tau_cands_type[4],
uint16_t tau_cands_iso_charged[4],
*/

#pragma HLS ARRAY_PARTITION variable=three_prong_cand_et complete dim=0
#pragma HLS ARRAY_PARTITION variable=three_prong_cand_eta complete dim=0
#pragma HLS ARRAY_PARTITION variable=three_prong_cand_phi complete dim=0
#pragma HLS ARRAY_PARTITION variable=three_prong_cand_eta_side complete dim=0
#pragma HLS ARRAY_PARTITION variable=three_prong_cand_particle_type complete dim=0

#pragma HLS ARRAY_PARTITION variable=pf_cands_et complete dim=0
#pragma HLS ARRAY_PARTITION variable=pf_cands_eta complete dim=0
#pragma HLS ARRAY_PARTITION variable=pf_cands_phi complete dim=0
#pragma HLS ARRAY_PARTITION variable=pf_cands_eta_side complete dim=0
#pragma HLS ARRAY_PARTITION variable=pf_cands_particle_type complete dim=0

#pragma HLS ARRAY_PARTITION variable=tau_cands_et complete dim=0
#pragma HLS ARRAY_PARTITION variable=tau_cands_eta complete dim=0
#pragma HLS ARRAY_PARTITION variable=tau_cands_phi complete dim=0
#pragma HLS ARRAY_PARTITION variable=tau_cands_eta_side complete dim=0
#pragma HLS ARRAY_PARTITION variable=tau_cands_type complete dim=0
#pragma HLS ARRAY_PARTITION variable=tau_cands_iso_charged complete dim=0

#pragma HLS PIPELINE II=6

  int n_found_prongs=1;
  int idx, jdx, n_taus=0;

  for (idx = 0; idx < N_TRACKS; idx++)  
  {
#pragma HLS UNROLL
      if((pf_cands_particle_type[idx]==01) && (pf_cands_et[idx]>=three_prong_seed))
      {
        //seed_cand
        //three_prong_tau_cand[0] = pf_charged[idx];

        n_found_prongs=1;

        three_prong_cand_et[0]=pf_cands_et[idx];
        three_prong_cand_eta[0]=pf_cands_eta[idx];
        three_prong_cand_phi[0]=pf_cands_phi[idx];
        three_prong_cand_eta_side[0]=pf_cands_eta_side[idx];
        three_prong_cand_particle_type[0]=01;

        for (jdx = idx+1; jdx < N_TRACKS; jdx++)
        {
#pragma HLS UNROLL
          //pf_cands are sorted according to decreasing Et 
          if(pf_cands_particle_type[jdx]==01)
          {
            //possible prong if meets delta_R requirements
            //temphadron = pf_charged[jdx];

            temphadron_et=pf_cands_et[jdx];
            temphadron_eta=pf_cands_eta[jdx];
            temphadron_phi=pf_cands_phi[jdx];
            temphadron_eta_side=pf_cands_eta_side[jdx];
            temphadron_particle_type=01;
            uint16_tF output=Delta_R(three_prong_cand_eta[0], three_prong_cand_phi[0], temphadron_eta, temphadron_phi, three_prong_delta_r);
            if(output==1){
              if(n_found_prongs==1)
              {
                n_found_prongs=2;
                
                three_prong_cand_et[1]=temphadron_et;
                three_prong_cand_eta[1]=temphadron_eta;
                three_prong_cand_phi[1]=temphadron_phi;
                three_prong_cand_eta_side[1]=temphadron_eta_side;
                three_prong_cand_particle_type[1]=01;
              }
              else if(n_found_prongs==2)
              {
                n_found_prongs=3;

                three_prong_cand_et[2]=temphadron_et;
                three_prong_cand_eta[2]=temphadron_eta;
                three_prong_cand_phi[2]=temphadron_phi;
                three_prong_cand_eta_side[2]=temphadron_eta_side;
                three_prong_cand_particle_type[2]=01;

                //break;
              }
            }
          }
        }
        //Max 4 3-prong taus can be reconstructed
        if(n_found_prongs == 3 && n_taus < 4)
        {
          /*
          three_prong_tau_cand[1]=second_prong_hadron;
          three_prong_tau_cand[2]=third_prong_hadron;
          //tau_eT is sum_eT of all 3 prongs
          tau_cands_temp[n_taus].et          = three_prong_tau_cand[0].et + three_prong_tau_cand[1].et + three_prong_tau_cand[2].et;
          //tau position is a weighted average of all 3 prong positions
          //tau_cands_temp[n_taus].eta         = weighted_avg_eta_p_p_p(three_prong_tau_cand[0], three_prong_tau_cand[1], three_prong_tau_cand[2]);
          //tau_cands_temp[n_taus].phi         = weighted_avg_phi_p_p_p(three_prong_tau_cand[0], three_prong_tau_cand[1], three_prong_tau_cand[2]);
          //isolation sum is computed previously and contain momenta of all electrons and charged hadrons in the cone
          //this number is not accurate and must be computed within this function itself, hence temporary
          tau_cands_temp[n_taus].iso_charged = iso_sum_charged_hadron; 
          tau_cands_temp[n_taus].tau_type    = 10;
          //tau eta_side is +1 or -1 depending on where the seed is 
          tau_cands_temp[n_taus].eta_side    = three_prong_tau_cand[0].eta_side;
          */
          tau_cands_et[n_taus]=three_prong_cand_et[0]+three_prong_cand_et[1]+three_prong_cand_et[2];
          tau_cands_eta[n_taus]=three_prong_cand_eta[0];
          tau_cands_phi[n_taus]=three_prong_cand_phi[0];
          tau_cands_eta_side[n_taus]=three_prong_cand_eta_side[0];
          tau_cands_iso_charged[n_taus]=iso_sum_charged_hadron;
          tau_cands_type[n_taus]=10;

          n_taus++;
        }
      }
    //assign to output ports at the end so that design remains simple
    /*tau_cands[0]=tau_cands_temp[0];
    tau_cands[1]=tau_cands_temp[1];
    tau_cands[2]=tau_cands_temp[2];
    tau_cands[3]=tau_cands_temp[3];
    */
  }}
 uint16_tF Delta_R(uint16_t eta_1, uint16_t phi_1, uint16_t eta_2, uint16_t phi_2, uint16_t maximum_delta_R){
   uint16_t output;
   uint16_t delta_eta = 0;
   uint16_t delta_phi = 0;
   if(eta_2>eta_1)
     delta_eta = eta_2 - eta_1;
   else
     delta_eta = eta_1 - eta_2;

   if(phi_2>phi_1)
     delta_phi = phi_2 - phi_1;
   else
     delta_phi = phi_1 - phi_2;

   if((delta_phi + delta_eta) < maximum_delta_R)
     output = 1;
   else
     output = 0;

   return output;
 }
