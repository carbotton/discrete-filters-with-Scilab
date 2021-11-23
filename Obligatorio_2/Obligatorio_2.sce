
    xdel(winsid());
    
    exec('./filtros.sci');
    exec('./audioWav.sci');
    exec('./pasaBandaKaiser.sci');
    
    //ver FFT de la señal de audio    
//        path = './questions_money.wav';
//        audioWav(path);
    //-
    
    //parámetros para generación de filtros
               
        f_M = 44100;        //frecuencia de muestreo
//        graficas = %f;
//    
//        //pasa bajos
//            f_p = 20;          //frecuencia fin banda pasante
//            f_s = 300;         //frecuencia inicio banda rechazo                     
//            pasabajos = filtrosKaiser('PB', f_M, f_p, f_s, graficas);      
//        //-
        //pasa banda
            f_s1 = 300;         //frecuencia fin banda pasante izq
            f_p1 = 400;         //frecuencia inicio banda rechazo izq
            f_p2 = 1000;         //frecuencia fin banda pasante der
            f_s2 = 1500;         //frecuencia inicio banda rechazo der  
            f_c1 = (f_s1+f_p1)/2;
            f_c2 = (f_s2+f_p2)/2;
            graficas = %t;
            pasabanda = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2, f_c1, f_c2, graficas);
        //-
//        //pasa altos
//            f_p = 1600;         //frecuencia fin banda pasante
//            f_s = 20000;         //frecuencia inicio banda rechazo
//            pasaltos = filtrosKaiser('PA', f_M, f_p, f_s, graficas);        
//        //-
        
    //-
