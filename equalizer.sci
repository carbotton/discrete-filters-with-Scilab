/* 
  return num and den from crossover filter transfer function and 
  save low_pass_filter, band_pass_filter and high_pass_filter
  to file 
*/

function [transf] = equalizer(low_gain, middle_gain, high_gain, disp_filters)
    
    exec('./num_den_z.sci');
    L = 1;   
    delta_phi = 0.0001;   
    v_phi = (0:delta_phi:L); 
    v_z = exp(%i*2*%pi*v_phi);    
    
    //------------------------------------------
    //              Low pass filter
    //              cutoff freq = 0.2
    //------------------------------------------
    
    phi_roots_low = [0.25];
    phi_poles_low = [0.17 0 0.16 0.1];
    gain_poles_low = [0.86 0.86 0.51 0.565 0.565 0.55 0.55];    
     
    [num_z_low, den_z_low] = num_den_z(phi_roots_low, phi_poles_low, gain_poles_low);
      
    transf_low = freq(num_z_low,den_z_low,v_z);
    max_value_low = max(abs(transf_low)); 
    transf_low = low_gain*(1/max_value_low)*transf_low;
    
    save('low_pass_filter', 'num_z_low', 'den_z_low')  
     
    disp("transf_low")
    disp(num_z_low/den_z_low)
    //------------------------------------------
    //              Band pass filter
    //              cutoff freqs = 0.25; 0.35
    //------------------------------------------ 
       
    phi_roots_mid = [0 0.2 0.4 0.15 0.45];
    phi_poles_mid = [0.32 0.25];
    gain_poles_mid = [0.865 0.865 0.9 0.9]; 
    
    [num_z_mid, den_z_mid] = num_den_z(phi_roots_mid, phi_poles_mid, gain_poles_mid);  

    transf_mid = freq(num_z_mid,den_z_mid,v_z);
    max_value_mid = max(abs(transf_mid));
    transf_mid = middle_gain*(1/max_value_mid)*transf_mid;
    
    save('band_pass_filter', 'num_z_mid', 'den_z_mid')
    
    //------------------------------------------
    //              High pass filter
    //              cutoff freq = 0.4
    //------------------------------------------ 
       
    phi_roots_high = [0 0.1 0.2 0.3 0.35];
    phi_poles_high = [0.38 0.38 0.45 0.45];
    gain_poles_high = [0.9 0.9 0.9 0.9 0.48 0.48 0.48 0.48]; 
    
    [num_z_high, den_z_high] = num_den_z(phi_roots_high, phi_poles_high, gain_poles_high);

    transf_high = freq(num_z_high,den_z_high,v_z);
    max_value_high = max(abs(transf_high));
    transf_high = high_gain*(1/max_value_high)*transf_high;
    
    save('high_pass_filter', 'num_z_high', 'den_z_high')   //SIN ; sino no anda el LOAD
    
    //------------------------------------------
    //              Crossover filter
    //------------------------------------------
    
    transf = transf_low + transf_mid + transf_high;

//    disp(transf_low)
//    disp(max(abs(transf_low)))
//    disp("==========================")
//    disp(transf_mid)
//    disp(max(abs(transf_mid)))
//    disp("==========================")
//    disp(transf_high)
//    disp(max(abs(transf_high)))
//    disp("==========================")
//    disp(transf)
//    disp(max(abs(transf)))
    
    //------------------------------------------
    //              Display filters separately
    //------------------------------------------ 
    
    if  disp_filters == "all" then             
        
        scf(1); //low pass filter
        clf();
        xgrid();
        plot2d(v_phi,abs(transf_low),style=2);    
        plot2d(v_phi,ones(v_phi),style=5);
        legend("Low pass filter")
        
        scf(2); //band pass filter
        clf();
        xgrid();
        plot2d(v_phi,abs(transf_mid),style=2);    
        plot2d(v_phi,ones(v_phi),style=5); 
        legend("Band pass filter") 
          
        scf(3); //high pass filter
        clf();
        xgrid();
        plot2d(v_phi,abs(transf_high),style=2);    
        plot2d(v_phi,ones(v_phi),style=5);  
        legend("High pass filter")
                
        scf(4); //all filters
        clf();
        xgrid();
        plot2d(v_phi,abs(transf_low),style=2);
        plot2d(v_phi,abs(transf_mid),style=6);          
        plot2d(v_phi,abs(transf_high),style=15);  
        plot2d(v_phi,ones(v_phi),style=5);  
        legend("low pass", "band pass", "high pass")   
            
    elseif disp_filters == "same_fig" then
        
        scf(4); //all filters
        clf();
        xgrid();
        plot2d(v_phi,abs(transf_low),style=2);
        plot2d(v_phi,abs(transf_mid),style=6);          
        plot2d(v_phi,abs(transf_high),style=15);  
        plot2d(v_phi,ones(v_phi),style=5);  
        legend("low pass", "band pass", "high pass")  
           
    end
               
endfunction
