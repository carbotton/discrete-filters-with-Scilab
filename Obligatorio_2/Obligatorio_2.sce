
   clear;close(winsid());

////////////////////////////////////////////////////////////////////////////////
// definicion de parametros usados para los distintos tipo de filtros

  Fs = 44100;
  
  phi_p = 2000/Fs;  
  phi_s = 3000/Fs;
  
  phi_B = (phi_p+phi_s)/2;
  phi_c = 0.3;
  phi_0 = 0.25;
  
//  N = 192; //N para todas las ventanas menos kaiser
  
  delta_p = 10**(-40/20);
  delta_s = 10**(-60/20);
  
// calculo del parametro Beta de la ventana de Kaiser 
// usando la formula empirica 

   A = -20*log10(delta_s); // atenuacion en dB
   
   if (A > 50) then Beta = 0.1102*(A-8.7)
   elseif (A > 21) then Beta = 0.5842*((A-21)^(0.4))+0.07886*(A-21)
   else Beta=0
   end
   
   delta_phi = phi_s - phi_p;
   
   N = round((A-8)/(2.285*2*%pi*delta_phi)); //N para kaiser  

////////////////////////////////////////////////////////////////////////////////

  
////////////////////////////////////////////////////////////////////////////////
// vector de indices de los coeficientes del filtro

   vn = [0:1:N];

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// expresion analitica de los coeficientes ideales


  hlpi = (2*phi_B)*sinc(%pi*(2*phi_B)*(vn-N/2)); // pasabajo
  
  hhpi = ((-1)**vn).*((1-2*phi_c)*sinc(%pi*(1-2*phi_c)*(vn-N/2))); // pasa alto
  
  hbpi = (2*phi_B)*sinc(%pi*(2*phi_B)*(vn-N/2)).*(2*cos(2*%pi*phi_0*(vn-N/2))); // pasabanda
  
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// ventana 

   wh = window('hn',N+1); // ventana de hanning o Hann
   wH = window('hm',N+1); // ventana de Hamming
   wB = 0.42 - 0.5*cos(2*%pi*(1/N)*vn) + 0.08*cos(4*%pi*(1/N)*vn); // ventana de Blackman
   
   
   wK= window('kr',N+1,Beta);
   
////////////////////////////////////////////////////////////////////////////////
// coeficientes del filtro a verificar, se elige la combinacion segun caso estudiado

   vhn = hlpi.*wK;

    
////////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////////
// calculo y graficado del modulo de la transferencia en escala lineal

    L= 2**16;
    vphi = (1/L)*[0:1:L-1];
    vhtecho = fft([vhn,zeros(1,L-length(vhn))]);
    scf(0);
    xgrid()
    plot2d(Fs*vphi,abs(vhtecho),style=2)
    plot2d(Fs*vphi,(1+delta_p)*ones(vphi),style=5)
    plot2d(Fs*vphi,(1-delta_p)*ones(vphi),style=5)
    plot2d(Fs*vphi,delta_s*ones(vphi),style=5)


    
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
