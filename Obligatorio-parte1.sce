/*========================================================================
    Construir un ecualizador por bandas para señales de audio digital.
    El sistema debe tener como mínimo 3 bandas y se debe poder ajustar inde-
    pendientemente la ganancia en cada una de las bandas.
========================================================================*/
    clear;
    xdel(winsid());
    exec('./z_roots_poles.sci');
    
    phi0 = 0;
    phi1 = 0.4;
    phi2 = 0.6;
    phi3 = 0.75;
    phi4 = 0.8;
    phi5 = 0.9;    
      
    ceros = [exp(2*%pi*%i*0), exp(2*%pi*%i*1/3), exp(-2*%pi*%i*1/3)];
    polos = [];

    num_z = poly(ceros($:-1:1),'z','r');  
//    den_z = poly(polos($:-1:1),'z','r');
    den_z = 1;        
    
    L = 1;   
    delta_phi = 0.0001;   
    v_phi = (0:delta_phi:L); //valores de phi


//    k = 1;           
//    v_bi = k*[1, -0,38, -1.23, -0.38, 1];
//    v_ai = [1];     
//    
//    num_z = poly(v_bi($:-1:1),'z','c');  
//    den_z = poly(v_ai($:-1:1),'z','c');
//    
//   N_D = length(v_bi)-length(v_ai);
//  
//   p_N_D = poly( [zeros(1,abs(N_D)),1],'z','c' );
// 
//   if (N_D > 0)  then den_z = den_z*p_N_D;	//ajuste de coeficientes
//    elseif (N_D < 0) then num_z = num_z*p_N_D;
//   end
//   

   v_phi = (1/L)*(0:1:L);

   v_z = exp(%i*2*%pi*v_phi);
   
   v_h_phi = freq(num_z,den_z,v_z);

// graficamos el modulo de h^(phi)

  scf(1);
  clf()
  xgrid()
  plot2d(v_phi,abs(v_h_phi),style=2)   
  
  plot2d(v_phi,ones(v_phi),style=5) 



 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////
/*    


  exec('argumento.sce');
  exec('alisar_argumento.sce');

/////
// ingreso de parametros
//
// ingresar los vectores de los coeficientes de la ecuacion en 
// diferencias en el orden usual

// vector de coeficientes bi en el formato [b0,b1,b2,...,bN]  
 a=0.8

  v_bi = [1-a];
  
// vector de coeficientes ai en el formato [1,a1,a2,a3,...,aD]
//
   
//   lambda = - 0.9
 
   v_ai = [1,-a]

// ingresar la cantidad de puntos del grafo para los cuales se evaluara
// la transferencia


   L = 1000;

// fin de ingreso de parametros
////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// preparacion de la funcion H(z) a evaluar

// creamos el polinomio numerador

  num_z = poly(v_bi($:-1:1),'z','c');
  
// creamos el polinomio denominador

  den_z = poly(v_ai($:-1:1),'z','c');
  
// si los ordenes de numerador y denominador no son iguales,
// agregamos el factor z^(D-N) o z^(N-D) segun corresponda

   N_D = length(v_bi)-length(v_ai);
  
   p_N_D = poly( [zeros(1,abs(N_D)),1],'z','c' );
 
   if (N_D > 0)  then den_z = den_z*p_N_D;
    elseif (N_D < 0) then num_z = num_z*p_N_D;
   end

// fin de preparacion de la funcion H(z) a evaluar
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// evaluacion de la funcion H(z) sobre puntos de la circunferencia unidad

// creamos el vector de valores de la variable adimensionada
// phi donde vamos a evaluar la transferencia
   
   v_phi = (1/L)*(0:1:L);
    
// creamos el vector de complejos donde evaluaremos H(z)

  v_z = exp(%i*2*%pi*v_phi);
  
// evaluamos el vector de valores de la funcion h^(phi)

  v_h_phi = freq(num_z,den_z,v_z);

// fin de evaluacion de la funcion H(z) sobre puntos de la circunferencia unidad
////////////////////////////////////////////////////////////////////////////////
  
v_bi_1 = [(1-a)/2,(1-a)/2];
v_ai_1 = [1,-a]

num_z_1 = poly(v_bi_1($:-1:1),'z','c');
  
// creamos el polinomio denominador

  den_z_1 = poly(v_ai_1($:-1:1),'z','c');
  
// si los ordenes de numerador y denominador no son iguales,
// agregamos el factor z^(D-N) o z^(N-D) segun corresponda

   N_D_1 = length(v_bi_1)-length(v_ai_1);
  
   p_N_D_1 = poly( [zeros(1,abs(N_D_1)),1],'z','c' );
 
   if (N_D_1 > 0)  then den_z_1 = den_z_1*p_N_D_1;
    elseif (N_D_1 < 0) then num_z_1 = num_z_1*p_N_D_1;
   end

v_phi_1 = (1/L)*(0:1:L);
    
// creamos el vector de complejos donde evaluaremos H(z)

  v_z_1 = exp(%i*2*%pi*v_phi_1);
  
// evaluamos el vector de valores de la funcion h^(phi)

  v_h_phi_1 = freq(num_z_1,den_z_1,v_z_1);

////////////////////////////////////////////////////////////////////////////////

// graficamos el modulo de h^(phi)

  scf(1);
  clf()
  xgrid()
  plot2d(v_phi_1,abs(v_h_phi_1),style=2)   
  
  plot2d(v_phi_1,ones(v_phi_1).*1/sqrt(2),style=5) 

////////////////////////////////////////////////////////////////////////////////
// graficamos el modulo de h^(phi)

  scf(1);
  //clf()
  xgrid()
  plot2d(v_phi,abs(v_h_phi),style=2)   
  
  plot2d(v_phi,ones(v_phi).*1/sqrt(2),style=5) 
////////////////////////////////////////////////////////////////////////////////

// graficamos la fase de  h^(phi)
   
   v_arg_h_phi_1 = atan(imag(v_h_phi_1),real(v_h_phi_1)); 

  scf(3);
  clf()
  xgrid()
  plot2d(v_phi_1,(1/(2*%pi))*v_arg_h_phi_1,style=2)   
  
     v_arg_h_phi = atan(imag(v_h_phi),real(v_h_phi)); 

  scf(4);
  clf()
  xgrid()
  plot2d(v_phi,(1/(2*%pi))*v_arg_h_phi,style=2) */  
