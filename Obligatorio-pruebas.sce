///*========================================================================
//    Construir un ecualizador por bandas para señales de audio digital.
//    El sistema debe tener como mínimo 3 bandas y se debe poder ajustar inde-
//    pendientemente la ganancia en cada una de las bandas.
//========================================================================*/

x = [0 1];
newval = 5;
x = [x, newval]

v = [];
for ii = 1:3
  v = [v ii:4];
end
v  



//    clear;
//    xdel(winsid());
//    
////    phi0 = 0;
////    phi1 = 0.4;
////    phi2 = 0.6;
////    phi3 = 0.75;
////    phi4 = 0.9;
//    
//    exec('./z_roots_poles.sci')
//    
//    ceros = [z_roots_poles(0), z_roots_poles(1/3), z_roots_poles(-1/3)];
//    polos = [];
//    
////    num_z = poly(v_bi($:-1:1),'z','c');  
////    den_z = poly(v_ai($:-1:1),'z','c');
//
//    num_z = poly(ceros($:-1:1),'z','r');  
////    den_z = poly(polos($:-1:1),'z','r');
//    den_z = 1;
//
//    
////   N_D = length(v_bi)-length(v_ai);
////  
////   p_N_D = poly( [zeros(1,abs(N_D)),1],'z','c' );
//// 
////   if (N_D > 0)  then den_z = den_z*p_N_D;
////    elseif (N_D < 0) then num_z = num_z*p_N_D;
////   end
//   
//   L = 1;   
//   delta_phi = 0.0001;   
//   v_phi = (0:delta_phi:L); //valores de phi
//   v_z = exp(%i*2*%pi*v_phi);   
//   v_h_phi = freq(num_z,den_z,v_z); 
//   
//   scf(1);
//   clf()
//   xgrid()
//   plot2d(v_phi,abs(v_h_phi),style=2)                   
