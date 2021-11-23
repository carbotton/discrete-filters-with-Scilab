
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
    
//    graficarFiltros(f_M, 1000, pasabajos, pasabanda1, pasabanda2);
      
    //señal de audio
    
        path = './questions_money.wav';
//        [audio_in, fft_audio_in] = audioWav(path, %f); 
                       
    //-
    
    //division en bandas de la señal de audio
        [x_in_2c, Fs, bits] = wavread(path);
        [canales,L] = size(x_in_2c);
        x_in = x_in_2c(1,:);  
          
        bajos = convol(pasabajos, x_in);
        banda1 = convol(pasabanda1, x_in);
        banda2 = convol(pasabanda2, x_in); 
        
        //graficas FFT de cada banda
            scf(0);
            subplot(1,3,1)
            title("")
            subplot(1,3,2)
            title("Separación en bandas", "fontsize",4.5)
            subplot(1,3,3)
            title("")
            subplot(1,3,1)
            xgrid();        
            bajosFFT = fft([bajos,zeros(1,L-length(bajos))]);
            [a,b] = size(bajosFFT) ;
            vphi = (1/b)*[0:1:b-1];
            v_f = f_M*v_phi;
            plot2d(f_M*vphi,abs(bajosFFT),style=6);
            subplot(1,3,2)
            xgrid();        
            banda1FFT = fft([banda1,zeros(1,L-length(banda1))]);
            [a,b] = size(banda1FFT) ;
            vphi = (1/b)*[0:1:b-1];
            v_f = f_M*v_phi;
            plot2d(f_M*vphi,abs(banda1FFT),style=6); 
            subplot(1,3,3)
            xgrid();        
            banda2FFT = fft([banda2,zeros(1,L-length(banda2))]);
            [a,b] = size(banda2FFT) ;
            vphi = (1/b)*[0:1:b-1];
            v_f = f_M*v_phi;
            plot2d(f_M*vphi,abs(banda2FFT),style=6);                                
        //-

    //-
    
    //modulacion para trasladar bandas
        L= 2**16;
        vphi = (1/L)*[0:1:L-1];
        v_f = f_M*v_phi;

        //bajos a altos
            f_modBA = 3500;
            phi_modBA = f_modBA/f_M;
                    
            nPB = 0: (length(bajos)-1);    
            cosPB = cos(2*%pi*nPB*phi_modBA);         
            bajosA = bajos.*cosPB;
            
            scf(1);
            xgrid();        
            bajosAFFT = fft([bajosA,zeros(1,L-length(bajosA))]);
            [a,b] = size(bajosAFFT) ;
            vphi = (1/b)*[0:1:b-1];
            v_f = f_M*v_phi;
            plot2d(f_M*vphi,abs(bajosAFFT),style=6);
            title("Modulación bajos con f_mod="+string(f_mod), "fontsize",4.5)            
        //-
    //-
    
    //me quedo con la parte de la modulación que me sirve
        
        //genero filtros            
            f_s1 = f_modBA-100;           //frecuencia fin banda pasante izq
            f_p1 = f_modBA;           //frecuencia inicio banda rechazo izq
            f_p2 = f_modBA+1350;           //frecuencia fin banda pasante der
            f_s2 = f_modBA+1350+100;           //frecuencia inicio banda rechazo der  
            bajosmodfiltro = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);                    
        //-
        
        //aplico filtros
            bajosAOK = convol(bajosmodfiltro, bajosA);
        
            scf(3)
            xgrid();        
            bajosAOKFFT = fft([bajosAOK,zeros(1,L-length(bajosAOK))]);
            [a,b] = size(bajosAOKFFT) ;
            vphi = (1/b)*[0:1:b-1];
            v_f = f_M*v_phi;
            plot2d(f_M*vphi,abs(bajosAOKFFT),style=6); 
            title("Me quedo con lo que me sirve de los bajos modulados", "fontsize",4.5) ;
            wavwrite(bajosA, Fs, './questions_money_bajosAOK.wav');        
        //-
    //-
    
