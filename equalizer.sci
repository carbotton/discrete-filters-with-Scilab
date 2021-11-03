/* 
  return num and den from crossover filter transfer function  
*/

function [num_z, den_z] = equalizer(low_gain, middle_gain, high_gain, disp_filters)
    
    exec('./num_den_z.sci');
    
    //------------------------------------------
    //              Low pass filter
    //              cutoff freq = 0.2
    //------------------------------------------
    
    phi_roots_low = [0.25];
    phi_poles_low = [0.17 0 0.16 0.1];
    gain_poles_low = [0.86 0.86 0.51 0.565 0.565 0.55 0.55]; 
    
    [num_z_low, den_z_low] = num_den_z(phi_roots_low, phi_poles_low, gain_poles_low);  
    transf_low = low_gain*num_z_low/den_z_low;
    
    //------------------------------------------
    //              Band pass filter
    //              cutoff freqs = 0.25; 0.35
    //------------------------------------------ 
       
    phi_roots_mid = [0 0.2 0.4 0.15 0.45];
    phi_poles_mid = [0.32 0.25];
    gain_poles_mid = [0.865 0.865 0.9 0.9]; 
    
    [num_z_mid, den_z_mid] = num_den_z(phi_roots_mid, phi_poles_mid, gain_poles_mid);  
    transf_mid = middle_gain*num_z_mid/den_z_mid;
    
    //------------------------------------------
    //              High pass filter
    //              cutoff freq = 0.4
    //------------------------------------------ 
       
    phi_roots_high = [0 0.1 0.2 0.3 0.35];
    phi_poles_high = [0.38 0.38 0.45 0.45];
    gain_poles_high = [0.9 0.9 0.9 0.9 0.48 0.48 0.48 0.48]; 
    
    [num_z_high, den_z_high] = num_den_z(phi_roots_high, phi_poles_high, gain_poles_high);  
    transf_high = high_gain*num_z_high/den_z_high;
    
    //------------------------------------------
    //              Crossover filter
    //------------------------------------------
    
    transf = clean(transf_low) + clean(transf_mid) + clean(transf_high);
    num_z = clean(transf.num);
    den_z = clean(transf.den);
    disp(transf_low)
    disp("==========================")
    disp(transf_mid)
    disp("==========================")
    disp(transf_high)
    disp("==========================")
    disp(transf)
    
    //------------------------------------------
    //              Display filters separately
    //------------------------------------------ 
    if  disp_filters == "true" then
        L = 1;   
        delta_phi = 0.0001;   
        v_phi = (0:delta_phi:L); 
        v_z = exp(%i*2*%pi*v_phi); 
          
        v_h_phi_low = freq(num_z_low,den_z_low,v_z);
        max_value_low = max(abs(v_h_phi_low));
        v_h_phi_mid = freq(num_z_mid,den_z_mid,v_z);
        max_value_mid = max(abs(v_h_phi_mid)); 
        v_h_phi_high = freq(num_z_high,den_z_high,v_z);
        max_value_high = max(abs(v_h_phi_high));               
        
        scf(1); //low pass filter
        clf();
        xgrid();
        plot2d(v_phi,abs(v_h_phi_low)/max_value_low,style=2);    
        plot2d(v_phi,ones(v_phi),style=5);
        legend("Low pass filter")
        
        scf(2); //band pass filter
        clf();
        xgrid();
        plot2d(v_phi,abs(v_h_phi_mid)/max_value_mid,style=2);    
        plot2d(v_phi,ones(v_phi),style=5); 
        legend("Band pass filter") 
          
        scf(3); //high pass filter
        clf();
        xgrid();
        plot2d(v_phi,abs(v_h_phi_high)/max_value_high,style=2);    
        plot2d(v_phi,ones(v_phi),style=5);  
        legend("High pass filter")
                
        scf(4); //all filters
        clf();
        xgrid();
        plot2d(v_phi,abs(v_h_phi_low)/max_value_low,style=2);
        plot2d(v_phi,abs(v_h_phi_mid)/max_value_mid,style=6);          
        plot2d(v_phi,abs(v_h_phi_high)/max_value_high,style=15);  
        plot2d(v_phi,ones(v_phi),style=5);  
        legend("low pass", "band pass", "high pass")       
    end
               
endfunction
