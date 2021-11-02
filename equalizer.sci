/* 
    
*/

function [num_z, den_z] = equalizer(low_gain, middle_gain, high_gain)
    
    exec('./num_den_z.sci');
    
    //------------------------------------------
    //              Low pass filter
    //------------------------------------------
    
    phi_roots_low = [0.25];
    phi_poles_low = [0.17 0 0.16 0.1];
    gain_poles_low = [0.86 0.86 0.51 0.565 0.565 0.55 0.55]; 
    
    [num_z_low, den_z_low] = num_den_z(phi_roots_low, phi_poles_low, gain_poles_low);  
    transf_low = low_gain*num_z_low/den_z_low;
    
    //------------------------------------------
    //              Band pass filter
    //------------------------------------------ 
       
    phi_roots_mid = [0 0.2 0.4 0.15 0.45];
    phi_poles_mid = [0.32 0.25];
    gain_poles_mid = [0.865 0.865 0.9 0.9]; 
    
    [num_z_mid, den_z_mid] = num_den_z(phi_roots_mid, phi_poles_mid, gain_poles_mid);  
    transf_mid = middle_gain*num_z_mid/den_z_mid;
    
    //------------------------------------------
    //              High pass filter
    //------------------------------------------ 
       
    phi_roots_high = [0 0.1 0.2 0.3 0.35 0.4 0.6];
    phi_poles_high = [0.4 0.45];
    gain_poles_high = [0.9 0.9 0.8 0.8]; 
    
    [num_z_high, den_z_high] = num_den_z(phi_roots_high, phi_poles_high, gain_poles_high);  
    transf_high = high_gain*num_z_high/den_z_high;
    
    //------------------------------------------
    //              Crossover filter
    //------------------------------------------
    
    transf = clean(transf_low+transf_mid+transf_high);
//    transf = transf_low;
    num_z = clean(transf.num);
    den_z = clean(transf.den);
                
endfunction
