
    xdel(winsid());
    
    exec('./audioWav.sci');
    exec('./filtros.sci');
    
    //==========================
    // Definicion de frecuencias
    // para todos los filtros
    //==========================
    
    f_M = 44100;             //frecuencia de muestreo
    
    //primera banda
        f_p = 1333;          //frecuencia fin banda pasante
        f_s = 1350;          //frecuencia inicio banda rechazo                  
        b1 = pasabajosKaiser(f_M, f_p, f_s);   
    //-

    //segunda banda
        f_s1_b2 = 1350;           //fin banda de rechazo izq
        f_p1_b2 = 1400;           //comienzo banda pasante
        f_p2_b2 = 2666;           //fin banda pasante
        f_s2_b2 = 2680;           //comienzo banda rechazo der
        b2 = pasaBandaKaiser(f_M, f_p1_b2, f_p2_b2, f_s1_b2, f_s2_b2);
    //-
        
    //tercera banda
        f_s1_b3 = 2700;           //fin banda de rechazo izq
        f_p1_b3 = 2750;           //comienzo banda pasante
        f_p2_b3 = 4000;           //fin banda pasante
        f_s2_b3 = 4050;           //comienzo banda rechazo der 
        b3 = pasaBandaKaiser(f_M, f_p1_b3, f_p2_b3, f_s1_b3, f_s2_b3);
    //- 
               
    //    graficarFiltros(f_M, 1000, b1, b2, b3);
    
    //========================== FIN DEFINICION PARAMETROS   
    
    
    //====================================================
       
    //señal de audio    
        path = './questions_money.wav';
    //        [audio_in, fft_audio_in] = audioWav(path, %f);
        [audio_in, Fs_audio, bits] = wavread(path);
        [canales,L] = size(audio_in);
        audio_mono = audio_in(1,:);                       
    //-
    
    //division en bandas de la señal de audio  
          
        bajos = convol(b1, x_in);
        banda1 = convol(pasabanda1, audio_mono);
        banda2 = convol(pasabanda2, audio_mono); 
        
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

        //b1 a b3
            f_modBA = (f_p2_b3+f_p1_b3)/2;
            phi_modBA = f_modBA/f_M;
                    
            nPB = 0: (length(bajos)-1);    
            cosPB = cos(2*%pi*nPB*phi_modBA);         
            bajosA = bajos.*cosPB;            
        //-
        
        //b3 a b2
            f_mod21 = (f_p2_b2+f_p1_b2)/2;
            phi_mod21 = f_mod21/f_M;
                    
            nB1 = 0: (length(banda1)-1);    
            cosB1 = cos(2*%pi*nB1*phi_mod21);         
            banda21 = banda1.*cosB1;           
        //-
        
        //graficas FFT de las bandas moduladas
            scf(1);
            subplot(1,3,1)
            xgrid();        
            bajosAFFT = fft([bajosA,zeros(1,L-length(bajosA))]);
            [a,b] = size(bajosAFFT);
            vphi = (1/b)*[0:1:b-1];
            v_f = f_M*v_phi;
            plot2d(f_M*vphi,abs(bajosAFFT),style=6);
            title("Mod bajos hacia banda 2 con f_mod="+string(f_modBA)) 
            subplot(1,3,2)       
            xgrid();        
            banda21FFT = fft([banda21,zeros(1,L-length(banda21))]);
            [a,b] = size(banda21FFT) ;
            vphi = (1/b)*[0:1:b-1];
            v_f = f_M*v_phi;
            plot2d(f_M*vphi,abs(banda21FFT),style=6);
            title("Mod banda2 hacia banda1 con f_mod="+string(f_mod21))             
        //-        
    //-
    
    //me quedo con la parte de la modulación que me sirve
        
        //genero filtros
                       
            f_s1 = f_modBA-100;           //frecuencia fin banda pasante izq
            f_p1 = f_modBA;           //frecuencia inicio banda rechazo izq
            f_p2 = f_modBA+f_s;           //frecuencia fin banda pasante der
            f_s2 = f_p2+100;           //frecuencia inicio banda rechazo der  
            bajosmodfiltro = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);   
            
            f_s1 = f_mod21-100;           //frecuencia fin banda pasante izq
            f_p1 = f_mod21;           //frecuencia inicio banda rechazo izq
            f_p2 = f_mod21+(f_p22-f_p12);           //frecuencia fin banda pasante der
            f_s2 = f_p2+100;           //frecuencia inicio banda rechazo der  
            banda2modfiltro = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);
                                         
        //-
        
        //aplico filtros
            bajosAOK = convol(bajosmodfiltro, bajosA);
            wavwrite(bajosA, Fs_audio, './questions_money_bajosAOK.wav');
            
            banda21OK = convol(banda2modfiltro, banda21);
            wavwrite(banda21OK, Fs_audio, './questions_money_banda21OK.wav');
        
            scf(3)
            xgrid();        
            bajosAOKFFT = fft([bajosAOK,zeros(1,L-length(bajosAOK))]);
            [a,b] = size(bajosAOKFFT) ;
            vphi = (1/b)*[0:1:b-1];
            v_f = f_M*v_phi;
            plot2d(f_M*vphi,abs(bajosAOKFFT),style=6); 
            title("Me quedo con lo que me sirve de los bajos modulados", "fontsize",4.5) ;
                    
        //-
    //-
    
