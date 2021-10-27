/*========================================================================
    Construir un ecualizador por bandas para señales de audio digital.
    El sistema debe tener como mínimo 3 bandas y se debe poder ajustar inde-
    pendientemente la ganancia en cada una de las bandas.
========================================================================*/
    clear;
    xdel(winsid());
    exec('./z_roots_poles.sci');
    
    //---------- INPUTS ----------
    //    phi_roots = [0 0.4 0.5 0.75 0.8 0.9]; //phi0, phi1, phi2, phi3, phi4, phi5
        phi_roots = [0 1/3]; //con decimales funciona mal
        phi_poles = [];
    //------------------------------
    
    //---------- NUM_Z AND DEN_Z ----------    
        roots_qty = length(phi_roots);
        poles_qty = length(phi_poles);
        
        z_roots = [];
        if roots_qty > 0 then
         for i = 1:roots_qty
             [z, z_conj] = z_roots_poles(phi_roots(i));
             if z == z_conj then
                 z_roots = [z_roots, z];
             else
                 z_roots = [z_roots, z];
                 z_roots = [z_roots, z_conj];
             end
         end
         num_z = poly(z_roots($:-1:1),'z','r');
        else
            num_z = 1;     
        end    
        
        z_poles = [];
        if poles_qty > 0 then
         for i = 1:poles_qty
             [z, z_conj] = z_roots_poles(phi_poles(i));
             if z == z_conj then
                 z_poles = [z_poles, z];
             else
                 z_poles = [z_poles, z];
                 z_poles = [z_poles, z_conj];
             end
         end
         den_z = poly(z_poles($:-1:1),'z','r');
        else
            den_z = 1;     
        end
    //------------------------------
    
    //------------------------------   
        L = 1;   
        delta_phi = 0.0001;   
        v_phi = (0:delta_phi:L); 
        v_z = exp(%i*2*%pi*v_phi);   
        v_h_phi = freq(num_z,den_z,v_z);
    //------------------------------
    
    //---------- GRAFICA DEL MODULO DE h(PHI) ----------
        scf(1);
        clf();
        xgrid();
        plot2d(v_phi,abs(v_h_phi),style=2);    
        plot2d(v_phi,ones(v_phi),style=5); 
        h2 = legend("Prueba");   
    //------------------------------
  

    //---------- GRAFICA DE LA CURVA COMPLEJA DE h(PHI) ----------
        scf(3);
        clf()
        xgrid()
        plot2d(real(v_h_phi),imag(v_h_phi),style=2,strf='041')    
        plot2d(real(v_z), imag(v_z),style=5, strf='001')
    //------------------------------



//////////////////////77 EL QUE YA SE QUE ESTA BIEN
    k = 1;           
    v_bi = k*[1, 0, 0, -1];
    v_ai = [1];     
    
    num_z_1 = poly(v_bi($:-1:1),'z','c');  
    den_z_2 = poly(v_ai($:-1:1),'z','c');

   N_D = length(v_bi)-length(v_ai);
  
   p_N_D = poly( [zeros(1,abs(N_D)),1],'z','c' );
 
   if (N_D > 0)  then den_z_2 = den_z_2*p_N_D;
    elseif (N_D < 0) then num_z_1 = num_z_1*p_N_D;
   end

    L2 = 1;   
    delta_phi2 = 0.0001;   
    v_phi2 = (0:delta_phi2:L2); //valores de phi

   v_z2 = exp(%i*2*%pi*v_phi2);
   
   v_h_phi2 = freq(num_z_1,den_z_2,v_z2);

  
  scf(2);
  clf()
  xgrid()
  plot2d(v_phi2,abs(v_h_phi2),style=2)
  plot2d(v_phi2,ones(v_phi2),style=5)     
  hl = legend("Correcto");


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
