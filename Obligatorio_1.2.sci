/*========================================================================
    Construir filtros digitales para reducir interferencia de frecuencias 
    50 Hz, 100 Hz, 150 Hz y 200 Hz 
    que contamina a una señal de audio digital. Debe lograrse mediante 
    el filtrado una atenuación de 50 dB o mayor de la interferencia y 
    alterar mínimamente la señal audio.
========================================================================*/
    clear;
    xdel(winsid());
    exec('./num_den_z.sci');
    
    L = 0.1;   
    delta_phi = 0.0001;   
    v_phi = (0:delta_phi:L); 
    v_z = exp(%i*2*%pi*v_phi); 
       
    fs = 44100; //Hz
    db50 = 10^(50/20);
//    gain = 1/db50;
    gain = 1;
    
    f0 = 50; //Hz
    f1 = 100;
    f2 = 150;
    f3 = 200;
    
    phi0 = f0/fs; //0.0011
    phi1 = f1/fs; //0.0022
    phi2 = f2/fs; //0.0034
    phi3 = f3/fs; //0.0045

    //------------------------------------------
    //      Filter phi0
    //------------------------------------------ 
       
    phi_roots = [phi0];
    phi_poles = [0 0 0.0019 0.00001];
    gain_poles = [0.5 0.5 0.9 0.9 0.9 0.9];    
   
    [num_z, den_z] = num_den_z(phi_roots, phi_poles, gain_poles);
         
    transf = freq(num_z,den_z,v_z);
    max_value = max(abs(transf)); 
    transf = gain*(1/max_value)*transf;
    
    save('filter', 'num_z', 'den_z')  
    
    //------------------------------------------
    //      Display filters
    //------------------------------------------           
        
    scf(1);
    clf();
    xgrid();
    plot2d(v_phi,abs(transf),style=2);    
    plot2d(v_phi,ones(v_phi),style=5);


               
