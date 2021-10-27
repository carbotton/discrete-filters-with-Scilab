////////////////////////////////////////////////////////////////////////////////
//
// archivo creacion_y_verificacion_transferencia_filtro.sce
//
//
// guion de scilab para mostrar el uso de la predefinida freq()
// en el bosquejo del modulo y la fase de la respuesta en frecuencia
// h_techo(phi) de un sistema LTI descrito 
// por una ecuacion en diferencias de la forma
// y(n) = sum_0^N (bi*x(n-i)) - sum_0^D (ai*y(n-i))
//
////////////////////////////////////////////////////////////////////////////////
    
//  clear;
  close(winsid());



////////////////////////////////////////////////////////////////////////////////
// ingreso de parametros
//
// ingresar los vectores de los coeficientes de la ecuacion en 
// diferencias en el orden usual

// vector de coeficientes bi en el formato [b0,b1,b2,...,bN]  

  v_bi = [1,0,0,0,-1];
  
// vector de coeficientes ai en el formato [1,a1,a2,a3,...,aD]
//
   
   ro=0.5;
   phi_0 = 1/8;
 
   v_ai = [1, -2*ro*cos(2*%pi*phi_0), ro**2];

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

////////////////////////////////////////////////////////////////////////////////
// normalizacion rapida de la maxima ganancia a 1
  
  G=max(abs(v_h_phi));
  
  num_z = (1/G)*num_z;
  
  v_h_phi = freq(num_z,den_z,v_z);


////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

// graficamos el modulo de h^(phi)

  scf(1);
  clf()
  xgrid()
  plot2d(Fs*v_phi,abs(v_h_phi),style=2)   
  

////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
// guardamos en un archivo los polinomios que define el filtro diseñado

  save('filtro', 'num_z','den_z')


////////////////////////////////////////////////////////////////////////////////


