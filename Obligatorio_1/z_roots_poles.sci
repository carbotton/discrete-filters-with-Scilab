
//  Recieves value in phi domain and returns it in z domain

function [z, z_conj] = z_roots_poles(phi0)
  z = exp(%i*2*%pi*phi0);
  z_conj = conj(z);
endfunction
