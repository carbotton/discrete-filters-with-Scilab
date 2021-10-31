/*========================================================================
    Construir un ecualizador por bandas para señales de audio digital.
    El sistema debe tener como mínimo 3 bandas y se debe poder ajustar inde-
    pendientemente la ganancia en cada una de las bandas.
========================================================================*/
    clear;
    xdel(winsid());
    exec('./equalizer.sci');
    
    //----- SET GAIN -------//
    low_gain = 2;
    middle_gain = 1;
    high_gain = 3;
    //-----------------------
   
    [num_z, den_z] = equalizer(low_gain, middle_gain, high_gain);
     
    //------------------------------   
        L = 1;   
        delta_phi = 0.0001;   
        v_phi = (0:delta_phi:L); 
        v_z = exp(%i*2*%pi*v_phi);   
        v_h_phi = freq(num_z,den_z,v_z);
        max_value = max(abs(v_h_phi));
    //------------------------------
    
    //---------- GRAFICA DEL MODULO DE h(PHI) ----------
        scf(1);
        clf();
        xgrid();
        plot2d(v_phi,abs(v_h_phi)/max_value,style=2);    
        plot2d(v_phi,ones(v_phi),style=5);   
    //------------------------------
  

    //---------- GRAFICA DE LA CURVA COMPLEJA DE h(PHI) ----------
//        scf(3);
//        clf()
//        xgrid()
//        plot2d(real(v_h_phi),imag(v_h_phi),style=2,strf='041')    
//        plot2d(real(v_z), imag(v_z),style=5, strf='001')
    //------------------------------
