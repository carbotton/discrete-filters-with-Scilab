////////////////////////////////////////////////////////////////////////////////
//
// archivo grafico_modulo_y_fase_transferencia_usando_freq_ejemplo_2
//
// guion de scilab para mostrar el uso de la predefinida freq()
// en el bosquejo del modulo y la fase de la respuesta en frecuencia
// h_techo(phi) de un sistema LIT descrito 
// por una ecuacion en diferencias de la forma
// y(n) = sum_0^N (bi*x(n-i)) - sum_0^D (ai*y(n-i))
//
////////////////////////////////////////////////////////////////////////////////

  clear;
  xdel(winsid());

//  exec('argumento.sce');
//  exec('alisar_argumento.sce');

////////////////////////////////////////////////////////////////////////////////
// ingreso de parametros
//
// ingresar los vectores de los coeficientes de la ecuacion en 
// diferencias en el orden usual

// vector de coeficientes bi en el formato [b0,b1,b2,...,bN]  

  v_bi = [1]
  
// vector de coeficientes ai en el formato [1,a1,a2,a3,...,aD]
//

//   ro = 0.8
//   phi = 1/8
//   tita = 2*%pi*phi;

//   v_ai = [1,-2*cos(4*%pi/5),1]
    v_ai = [1, 0.5]

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

// graficamos el modulo de h^(phi)

  scf(1);
  clf()
  xgrid()
  plot2d(v_phi,abs(v_h_phi),style=2)    

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

// graficamos la fase de  h^(phi)
   
   v_arg_h_phi = atan(imag(v_h_phi),real(v_h_phi)); 

  scf(2);
  clf()
  xgrid()
  plot2d(v_phi,(1/(2*%pi))*v_arg_h_phi,style=2)   

pause
  
// grafico alternativo eliminando los saltos de 2pi

  v_arg_h_phi2 = argumento(v_h_phi);
  
  plot2d(v_phi,(1/(2*%pi))*v_arg_h_phi2,style=5)   

pause
  
// grafico alternativo eliminando los saltos de pi  
  
  v_arg_h_phi3 = alisarargumento(v_arg_h_phi2);
  
    plot2d(v_phi,(1/(2*%pi))*v_arg_h_phi3,style=13)  
  
////////////////////////////////////////////////////////////////////////////////


pause
  
////////////////////////////////////////////////////////////////////////////////
// grafico de la curva compleja h_^(phi)

  scf(3);
  clf()
  xgrid()
  plot2d(real(v_h_phi),imag(v_h_phi),style=2,strf='041')   
  plot2d(real(v_z), imag(v_z),style=5, strf='001')
////////////////////////////////////////////////////////////////////////////////
  
  

////////////////////////////////////////////////////////////////////////////////
// uso de la funcion atan()
//
// atan - 2-quadrant and 4-quadrant inverse tangent
//
// phi=atan(x)
// phi=atan(y,x)
// Parameters
//
// x: real or complex scalar, vector or matrix
// phi: real or complex scalar, vector or matrix
// x, y: real scalars, vectors or matrices of the same size
// phi: real scalar, vector or matrix
// Description
// The first form computes the 2-quadrant inverse tangent, which is the inverse 
// of tan(phi). For real x, phi is in the interval (-pi/2, pi/2). 
// For complex x, atan has two singular, branching points +%i,-%i and the chosen 
// branch cuts are the two imaginary half-straight lines [i, i*oo) and (-i*oo, -i].
// The second form computes the 4-quadrant arctangent (atan2 in Fortran), this is, 
// it returns the argument (angle) of the complex number x+i*y. 
// The range of atan(y,x) is (-pi, pi].
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// uso de la funcion freq()
//
// v_H = freq(numerador, denominador,v_z)
// retorna los valores de la transferencia numerador/denominador
// evaluada en los complejos v_z

// para usar la funcion freq() debemos crear la funcion
// transferencia en el dominio Z expresada solo con exponentes
// positivos

// partimos de la funcion transferencia en el formato usual
// H(z) = (sum_0^N (bi*z^(-i))) / (sum_0^D (ai*z^(-i)))
// multiplicamos el numerador por z^N y el denominador por z^D
// y para que la funcion transferencia no cambie multiplicamos 




// el numerador por z^(D-N) si D > N
// o el denominador por z^(N-D) si N > D
////////////////////////////////////////////////////////////////////////////////

