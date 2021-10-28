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
    //adentro de la func
        phi_roots = [0.3 0.5]; //con decimales funciona mal
        phi_poles = [0 0 0.2 0.2];
        gain_poles = [0.312 0.312 0.757 0.757 0.6 0.6];
    //-
        gain = 2;
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
            v_bi = [1];
            num_z = poly(v_bi($:-1:1),'z','c');
//            num_z = 1;     
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
         den_z = poly(gain_poles($:-1:1).*z_poles($:-1:1),'z','r');
        else
            v_ai = [gain_poles(1)];
            den_z = poly(v_ai($:-1:1),'z','c');
//            den_z = 1;     
        end
    //------------------------------

    //------------------------------
//       v_bi = coeff(num_z);
//       v_ai = coeff(den_z);
//    
//       N_D = length(v_bi)-length(v_ai);
//      
//       p_N_D = poly( [zeros(1,abs(N_D)),1],'z','c' );
//     
//       if (N_D > 0)  then den_z = den_z*p_N_D;
//        elseif (N_D < 0) then num_z = num_z*p_N_D;
//       end
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
        plot2d(v_phi,gain*abs(v_h_phi)/max(abs(v_h_phi)),style=2);    
        plot2d(v_phi,ones(v_phi),style=5); 
        h2 = legend("Prueba");   
        
        // max(abs(v_h_phi))
    //------------------------------
  

    //---------- GRAFICA DE LA CURVA COMPLEJA DE h(PHI) ----------
//        scf(3);
//        clf()
//        xgrid()
//        plot2d(real(v_h_phi),imag(v_h_phi),style=2,strf='041')    
//        plot2d(real(v_z), imag(v_z),style=5, strf='001')
    //------------------------------
