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
    transf_low = num_z_low/den_z_low;
    
    //------------------------------------------
    //              Band pass filter
    //------------------------------------------ 
       
    phi_roots_mid = [];
    phi_poles_mid = [];
    gain_poles_mid = []; 
    
    [num_z_mid, den_z_mid] = num_den_z(phi_roots_mid, phi_poles_mid, gain_poles_mid);  
    transf_mid = num_z_mid/den_z_mid;
    
    //------------------------------------------
    //              High pass filter
    //------------------------------------------ 
       
    phi_roots_high = [];
    phi_poles_high = [];
    gain_poles_high = []; 
    
    [num_z_high, den_z_high] = num_den_z(phi_roots_high, phi_poles_high, gain_poles_high);  
    transf_high = num_z_high/den_z_high;
    
    //------------------------------------------
    //              Crossover filter
    //------------------------------------------
    
    transf = transf_low*transf_mid*transf_high;
    num_z = transf.num;
    den_z = transf.den;
                
endfunction
