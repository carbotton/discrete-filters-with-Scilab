
   clear;
   close(winsid());
    
    exec('./pasabajos.sci');
    
    f_M = 44100;        //frecuencia de muestreo
    f_p = 4410;         //frecuencia fin banda pasante
    f_s = 6615;         //frecuencia inicio banda rechazo
    pasabajos = pasabajosKaiser(f_M, f_p, f_s);
    



        
