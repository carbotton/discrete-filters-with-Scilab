/* 
    LO QUE ESTA HECHO HASTA AHORA ES EL PASABAJOS APROX
*/

function [transf] = equializer(low_gain, middle_gain, high_gain)
    
    exec('./z_roots_poles.sci');
    
    phi_roots = [0.3 0.5];
    phi_poles = [0 0 0.2 0.2];
    gain_poles = [0.312 0.312 0.757 0.757 0.6 0.6]; 
    
    [num_z, den_z] = num_den_z(phi_roots, phi_poles, gain_poles);
  
    transf = num_z/den_z;
endfunction
