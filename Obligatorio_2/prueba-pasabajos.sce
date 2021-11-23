// archivo guion_p_verificacion_filtros_fir

// VER CLASE 10 DE NOVIEMBRE

// guion simple de scilab para comprobar el diseño de filtros FIR
// usando el metodo de la ventana

   clear;close(winsid());

////////////////////////////////////////////////////////////////////////////////
// definicion de parametros usados para los distintos tipo de filtros

  Fs = 44100;
  
    f_s1 = 300;         //frecuencia fin banda pasante izq
    f_p1 = 400;         //frecuencia inicio banda rechazo izq
    f_p2 = 1000;         //frecuencia fin banda pasante der
    f_s2 = 1500;         //frecuencia inicio banda rechazo der  
    f_c1 = (f_s1+f_p1)/2;
    f_c2 = (f_s2+f_p2)/2; 
     
    phi_p1 = f_p1/Fs;   
    phi_s1 = f_s1/Fs;
    phi_p2 = f_p2/Fs;   
    phi_s2 = f_s2/Fs;
    
    phi_c1 = f_c1/Fs;
    phi_c2 = f_c2/Fs;   
     
    phi_0 = (phi_c1+phi_c2)/2;
    
    phi_B = (phi_c2-phi_c1)/2;
  
  delta_p = 10**(1/20); // atenuacion no apreciable. 1db = 0
  delta_s = 10**(-60/20);
  
  deltaphi = min(phi_p1-phi_s1, phi_s2-phi_p2);

////////////////////////////////////////////////////////////////////////////////

 
  
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// ventana 
   
// calculo del parametro Beta de la ventana de Kaiser 
// usando la formula empirica 

   A = -20*log10(delta_s); // atenuacion en dB
   
   if (A > 50) then Beta = 0.1102*(A-8.7)
   elseif (A > 21) then Beta = 0.5842*((A-21)^(0.4))+0.07886*(A-21)
   else Beta=0
   end,
   
   N = ceil((A-8)/(2.285*2*%pi*deltaphi));
   vn = [0:1:N];
   
   hbpi = (2*phi_B)*sinc(%pi*(2*phi_B)*(vn-N/2)).*(2*cos(2*%pi*phi_0*(vn-N/2)));   
   wK= window('kr',N+1,Beta);
   
////////////////////////////////////////////////////////////////////////////////
// coeficientes del filtro a verificar, se elige la combinacion segun caso estudiado

   vMn = hbpi.*wK;


////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
// calculo y graficado del modulo de la transferencia en escala lineal

    L= 2**16;
    vphi = (1/L)*[0:1:L-1];
    vtecho = fft([vMn,zeros(1,L-length(vMn))]);
    scf(0);
    xgrid()
    plot2d(Fs*vphi,abs(vtecho),style=2)
//    plot2d(Fs*vphi,(1+delta_p)*ones(vphi),style=5)
//    plot2d(Fs*vphi,(1-delta_p)*ones(vphi),style=5)
//    plot2d(Fs*vphi,delta_s*ones(vphi),style=5)
       
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
