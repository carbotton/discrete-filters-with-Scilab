   close(winsid());clear;

// frecuencia de muestreo
   f_M = 44100;

// frecuencia fin de la banda pasante
//   f_p = 2000;   
//   phi_p = f_p/f_M;

    phi_p = 0.1;
    f_p = phi_p*f_M;
      
// frecuencia inicio de la banda de rechazo
//   f_s = 3000;   
//   phi_s = f_s/f_M;

    phi_s = 0.15;
    f_s = phi_s*f_M;

// error de aproximacion en la banda pasante
   delta_1 = 10**(-60/20);

// error de aproximacion en la banda de rechazo
   delta_2 = 10**(-60/20);

// calculo de ancho de banda de transicion 
   deltaphi = phi_s - phi_p;

// opcion 1 ventana de Blackman
   NB = ceil(6/deltaphi)
 
   v_nB = 0:1:NB;

// calculo de los valores de la ventana   
   wB = 0.42 - 0.5*cos(2*%pi*v_nB/NB) + 0.08*cos(4*%pi*v_nB/NB);
 
   phi_B = (phi_s+phi_p)/2;
  
   v_hn_idB = (2*phi_B)*sinc(%pi*(2*phi_B)*(v_nB-NB/2));

   v_hnB = v_hn_idB.*wB;


// largo de la TDF a usar para calcular valores de la TFTD 
   L = 2**16;

// calculo de valores en el eje de frecuencias y valores de la TFTD
   v_phi = (1/L)*(0:1:L-1);
   
   v_f = f_M*v_phi;
   
   v_h_phiB = fft([v_hnB,zeros(1,L-length(v_hnB))]);


// opcion 2 ventana de Kaiser

// calculo del parametro Beta de la ventana de Kaiser 
// usando la formula empirica 
   A = -20*log10(delta_1); // atenuacion en dB
   
   if (A > 50) then Beta = 0.1102*(A-8.7)
   elseif (A > 21) then Beta = 0.5842*((A-21)^(0.4))+0.07886*(A-21)
   else Beta=0
   end,
   
// estimacion del largo del filtro       
   NK = ceil((A-8)/(2.285*2*%pi*deltaphi))

   v_nK = 0:1:NK;
    
// calculo de los valores de la ventana de Kaiser 
   wK = (1/besseli(0,Beta))*besseli(0,Beta*sqrt( 1-(1-(2*v_nK)/NK).^2) );

   phi_B = (phi_s+phi_p)/2;
  
   v_hn_idK = (2*phi_B)*sinc(%pi*(2*phi_B)*(v_nK-NK/2));

   v_hnK = v_hn_idK.*wK;

// largo de la TDF a usar para calcular valores de la TFTD 
   L = 2**16;

// calculo de valores en el eje de frecuencias y valores de la TFTD
   v_phi = (1/L)*(0:1:L-1);
   
   v_f = f_M*v_phi;
   
   v_h_phiK = fft([v_hnK,zeros(1,L-length(v_hnK))]);

// grafo del modulo de la transferencia de los filtros diseniados
// grafico del modulo para verificacion
   scf(0);
   clf()
   xgrid()
   plot2d(v_f,abs(v_h_phiB),style=2)
   plot2d(v_f,abs(v_h_phiK),style=3)
  
   xtitle('Comparacion pasabajos ventana Blackman (azul) ventana Kaiser (verde)');
   
// grafico superpuesto de bandas de tolerancia
   plot2d([0,f_p],[1+delta_1,1+delta_1],style=5)
   plot2d([0,f_p],[1-delta_1,1-delta_1],style=5)
   plot2d([f_p,f_p],[1-delta_1,1+delta_1],style=5)
   
   plot2d([(f_p+f_s)/2,(f_p+f_s)/2],[0,1],style=4)
   
   plot2d([f_s,f_M-f_s],[delta_2,delta_2],style=5)
   plot2d([f_s,f_s],[0,delta_2],style=5)
   plot2d([f_M-f_s,f_M-f_s],[0,delta_2],style=5)

// visualizacion de un trozo del grafo sin usar zoom
   scf(1);
   clf()
   xgrid()

   area_a_ver = [0.95*f_p,(1-5*delta_1),1.05*f_p,(1+5*delta_1)]; 
   
   plot2d(v_f,abs(v_h_phiB),style=2,rect=area_a_ver)
   plot2d(v_f,abs(v_h_phiK),style=3,rect=area_a_ver)

   xtitle('Comparacion pasabajos ventana Blackman (azul) ventana Kaiser (verde)');

// grafico superpuesto de bandas de tolerancia
   plot2d([0,f_p],[1+delta_1,1+delta_1],style=5,rect=area_a_ver)
   plot2d([0,f_p],[1-delta_1,1-delta_1],style=5,rect=area_a_ver)
   plot2d([f_p,f_p],[1-delta_1,1+delta_1],style=5,rect=area_a_ver)
 
// visualizacion de un trozo del grafo sin usar zoom 
   scf(2);
   clf()
   xgrid()

   area_a_ver = [0.95*f_s,0,1.05*f_s,(5*delta_2)]; 
   
   plot2d(v_f,abs(v_h_phiB),style=2,rect=area_a_ver)
   plot2d(v_f,abs(v_h_phiK),style=3,rect=area_a_ver)

   xtitle('Comparacion pasabajos ventana Blackman (azul) ventana Kaiser (verde)');

// grafico superpuesto de bandas de tolerancia
   plot2d([f_s,f_M-f_s],[delta_2,delta_2],style=5,rect=area_a_ver)
   plot2d([f_s,f_s],[0,delta_2],style=5,rect=area_a_ver)
   plot2d([f_M-f_s,f_M-f_s],[0,delta_2],style=5,rect=area_a_ver)

