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
    //              cutoff freq = 0.17
    //------------------------------------------    
    
    phi_roots_low = [0.2 0.22 0.3 0.45]; 
    phi_poles_low = [0.1 0.56; 0.16 0.9; 0.17 0.83];         
     
    [num_z_low, den_z_low] = num_den_z(phi_roots_low, phi_poles_low);

    transf_low = freq(num_z_low,den_z_low,v_z);
    max_value_low = max(abs(transf_low)); 

    transf_low = low_gain*(1/max_value_low)*transf_low;

    save('./filters/low_pass_filter', 'num_z_low', 'den_z_low', 'low_gain')  

    //------------------------------------------
    //              Band pass filter
    //              cutoff freqs = 0.18; 0.35
    //------------------------------------------ 

    phi_roots_mid = [0 0.1 0.15 0.4 0.45]
    phi_poles_mid = [0.18 0.9; 0.19 0.8; 0.25 0.63; 0.34 0.75; 0.35 0.84];
    
    [num_z_mid, den_z_mid] = num_den_z(phi_roots_mid, phi_poles_mid); 

    transf_mid = freq(num_z_mid,den_z_mid,v_z);
    max_value_mid = max(abs(transf_mid));
    transf_mid = middle_gain*(1/max_value_mid)*transf_mid;
    
    save('./filters/band_pass_filter', 'num_z_mid', 'den_z_mid', 'middle_gain')
    
    //------------------------------------------
    //              High pass filter
    //              cutoff freq = 0.36
    //------------------------------------------ 

    phi_roots_high = [0.3 0.35];
    phi_poles_high = [0.38 0.86; 0.38 0.86; 0.45 0.67];
    
    [num_z_high, den_z_high] = num_den_z(phi_roots_high, phi_poles_high);

    transf_high = freq(num_z_high,den_z_high,v_z);
    max_value_high = max(abs(transf_high));
    transf_high = high_gain*(1/max_value_high)*transf_high;
    
    save('./filters/high_pass_filter', 'num_z_high', 'den_z_high', 'high_gain')   //SIN ; sino no anda el LOAD
    
    //------------------------------------------
    //              Crossover filter
    //------------------------------------------
    
    transf = transf_low + transf_mid + transf_high;
    
    //------------------------------------------
    //              Display filters separately
    //------------------------------------------ 

if disp_all_filters               
    scf(2);        
    subplot(2,2,1)
    xgrid();
    plot2d(v_phi,abs(transf_low),style=2);
    title('Filtro pasa bajos','fontsize',3);        
    subplot(2,2,2)
    xgrid();
    plot2d(v_phi,abs(transf_mid),style=2); 
    title('Filtro pasa banda','fontsize',3);        
    subplot(2,2,3)
    xgrid();
    plot2d(v_phi,abs(transf_high),style=2);
    title('Filtro pasa altos','fontsize',3);        
    subplot(2,2,4)
    xgrid();
    plot2d(v_phi,abs(transf_low),style=2);
    xgrid();    
    plot2d(v_phi,abs(transf_mid),style=6); 
    xgrid();     
    plot2d(v_phi,abs(transf_high),style=15);
    title('Filtros pasa bajos, pasa banda y pasa altos','fontsize',2);    
end               
endfunction
