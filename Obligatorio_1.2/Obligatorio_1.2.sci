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
    
    L = 1;   
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
    //      Filter 50Hz
    //------------------------------------------ 
       
    phi_roots = [];
    phi_poles = [];
    gain_poles = [];  
   
    [num_z, den_z] = num_den_z(phi_roots, phi_poles, gain_poles);
         
    transf_50 = freq(num_z,den_z,v_z);
    max_value_50 = max(abs(transf_50)); 
    transf_50 = gain*(1/max_value_50)*transf_50;
    
    save('filter_50', 'num_z', 'den_z') 
    
    //------------------------------------------
    //      Filter 100Hz
    //------------------------------------------ 
       
    phi_roots = [];
    phi_poles = [];
    gain_poles = [];  
   
    [num_z, den_z] = num_den_z(phi_roots, phi_poles, gain_poles);
         
    transf_100 = freq(num_z,den_z,v_z);
    max_value_100 = max(abs(transf_100)); 
    transf_100 = gain*(1/max_value_100)*transf_100;
    
    save('filter_100', 'num_z', 'den_z') 
    
    //------------------------------------------
    //      Filter 150Hz
    //------------------------------------------ 
       
    phi_roots = [];
    phi_poles = [];
    gain_poles = [];  
   
    [num_z, den_z] = num_den_z(phi_roots, phi_poles, gain_poles);
         
    transf_150 = freq(num_z,den_z,v_z);
    max_value_150 = max(abs(transf_150)); 
    transf_150 = gain*(1/max_value_150)*transf_150;
    
    save('filter_150', 'num_z', 'den_z')      
    
    //------------------------------------------
    //      Filter 200Hz
    //------------------------------------------ 
       
    phi_roots = [phi3];
    phi_poles = [0.0040 0.0040 0.0040 0.0040 0.0040 0.05 0.05];
    gain_poles = [0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9];  
   
    [num_z, den_z] = num_den_z(phi_roots, phi_poles, gain_poles);
         
    transf_200 = freq(num_z,den_z,v_z);
    max_value_200 = max(abs(transf_200)); 
    transf_200 = gain*(1/max_value_200)*transf_200;
    
    save('filter_200', 'num_z', 'den_z')         
               
    //------------------------------------------
    //      Plot filters
    //------------------------------------------           
        
    scf(1);
    clf();
    xgrid();
    plot2d(v_phi,abs(transf_50),style=2);    
    plot2d(v_phi,ones(v_phi),style=5);
    legend("50Hz filter")
    
    scf(2);
    clf();
    xgrid();
    plot2d(v_phi,abs(transf_100),style=2);    
    plot2d(v_phi,ones(v_phi),style=5);
    legend("100Hz filter") 
    
    scf(3);
    clf();
    xgrid();
    plot2d(v_phi,abs(transf_150),style=2);    
    plot2d(v_phi,ones(v_phi),style=5);
    legend("150Hz filter")  
    
    scf(4);
    clf();
    xgrid();
    plot2d(v_phi,abs(transf_200),style=2);    
    plot2d(v_phi,ones(v_phi),style=5);  
    legend("200Hz filter")       


               
