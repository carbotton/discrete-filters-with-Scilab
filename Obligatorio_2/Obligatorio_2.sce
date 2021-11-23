
    xdel(winsid());
    
    exec('./filtros.sci');
    exec('./audioWav.sci');
    
    //parámetros para generación de filtros
               
        f_M = 44100;             //frecuencia de muestreo
    
        //pasa bajos
            f_p = 1333;          //frecuencia fin banda pasante
            f_s = 1350;          //frecuencia inicio banda rechazo                   
            pasabajos = pasabajosKaiser(f_M, f_p, f_s);      
        //-
        
        //pasa banda 1
            f_s1 = 1350;           //izq
            f_p1 = 1400;           //izq
            f_p2 = 2666;           //der
            f_s2 = 2680;           //der  
            pasabanda1 = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);
        //-
        
        //pasa banda 2
            f_s1 = 2700;           //frecuencia fin banda pasante izq
            f_p1 = 2750;           //frecuencia inicio banda rechazo izq
            f_p2 = 4000;           //frecuencia fin banda pasante der
            f_s2 = 4050;           //frecuencia inicio banda rechazo der  
            pasabanda2 = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);
        //-            
        
    //-
    
    f_mod = 10000;
    graficarFiltros(f_M, f_mod, pasabajos, pasabanda1, pasabanda2);
    
    
    //modulacion de la señal de audio
    
        path = './questions_money.wav';
        [audio_in, fft_audio_in] = audioWav(path, %f); 
                       
    //-
    
