/*========================================================================
    Construir un ecualizador por bandas para señales de audio digital.
    El sistema debe tener como mínimo 3 bandas y se debe poder ajustar 
    independientemente la ganancia en cada una de las bandas.
========================================================================*/
    clear;
    xdel(winsid());
    exec('./equalizer.sci');
    
    //----- SET GAIN -------//
        low_gain = 1;
        middle_gain = 1;
        high_gain = 1;
    //-----------------------
   
    disp_all_filters = "same_fig";   //none, same_fig, all
    [transf] = equalizer(low_gain, middle_gain, high_gain, disp_all_filters);
     
    //------------------------------   
    
    //---------- GRAFICA DEL MODULO DE h(PHI) ----------
        L = 1;   
        delta_phi = 0.0001;   
        v_phi = (0:delta_phi:L); 
        max_value = max(abs(transf));
            
        scf(0);
        clf();
        xgrid();
        plot2d(v_phi,abs(transf)/max_value,style=1);    
        legend("filter")           
    //------------------------------
  

    //---------- GRAFICA DE LA CURVA COMPLEJA DE h(PHI) ----------
//        scf(3);
//        clf()
//        xgrid()
//        plot2d(real(v_h_phi),imag(v_h_phi),style=2,strf='041')    
//        plot2d(real(v_z), imag(v_z),style=5, strf='001')
    //------------------------------