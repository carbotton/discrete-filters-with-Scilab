/*========================================================================
    Construir un ecualizador por bandas para señales de audio digital.
    El sistema debe tener como mínimo 3 bandas y se debe poder ajustar 
    independientemente la ganancia en cada una de las bandas.
========================================================================*/
    clear;
    xdel(winsid());
    exec('./equalizer.sci');
    
    //----- SET GAIN -------//
        low_gain = 0.2;
        middle_gain = 0.5;
        high_gain = 0.8;
    //-----------------------
   
    disp_all_filters = %t; //true or false
    [transf] = equalizer(low_gain, middle_gain, high_gain, disp_all_filters);
     
    //------------------------------   
    
    //---------- GRAFICA DEL MODULO DE h(PHI) ----------
        L = 1;   
        delta_phi = 0.0001;   
        v_phi = (0:delta_phi:L); 
        max_value = max(abs(transf));
           
        scf(1);
        clf();
        xgrid();
        plot2d(v_phi,abs(transf)/max_value,style=2);
        title('Filtros sumados -> Ganancias: bajos: '+ string(low_gain)+', medios: '+ string(middle_gain)+', altos: '+ string(high_gain), 'fontsize',3); 
        xlabel('$\varphi$', 'fontsize', 2);
        ylabel(['|H(' '$\varphi$' ')|'])
    //------------------------------
