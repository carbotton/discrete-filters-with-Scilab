
    xdel(winsid());
    
    exec('./filtros.sci');
    exec('./audioWav.sci');
    
    //filtros para determinar las 3 bandas
               
        f_M = 44100;             //frecuencia de muestreo
    
        //pasa bajos
            f_p = 1333;          //frecuencia fin banda pasante
            f_s = 1350;          //frecuencia inicio banda rechazo                  
            pasabajos = pasabajosKaiser(f_M, f_p, f_s);      
        //-
        
        //pasa banda 1
            f_s11 = 1350;           //izq
            f_p11 = 1400;           //izq
            f_p21 = 2666;           //der
            f_s21 = 2680;           //der  
            pasabanda1 = pasaBandaKaiser(f_M, f_p11, f_p21, f_s11, f_s21);
        //-
        
        //pasa banda 2
            f_s12 = 2700;           //frecuencia fin banda pasante izq
            f_p12 = 2750;           //frecuencia inicio banda rechazo izq
            f_p22 = 4000;           //frecuencia fin banda pasante der
            f_s22 = 4050;           //frecuencia inicio banda rechazo der  
            pasabanda2 = pasaBandaKaiser(f_M, f_p12, f_p22, f_s12, f_s22);
        //-            
        
    //-
    
//    graficarFiltros(f_M, 1000, pasabajos, pasabanda1, pasabanda2);
      
    //señal de audio    
        path = './questions_money.wav';
    //        [audio_in, fft_audio_in] = audioWav(path, %f);
        [x_in_2c, Fs, bits] = wavread(path);
        [canales,L] = size(x_in_2c);
        x_in = x_in_2c(1,:);                       
    //-
    
    //division en bandas de la señal de audio  
          
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

        //bajos a banda 2
            f_modBA = (f_p22+f_p12)/2;
            phi_modBA = f_modBA/f_M;
                    
            nPB = 0: (length(bajos)-1);    
            cosPB = cos(2*%pi*nPB*phi_modBA);         
            bajosA = bajos.*cosPB;            
        //-
        
        //banda 2 a banda 1
            f_mod21 = (f_p21+f_p11)/2;
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
            wavwrite(bajosA, Fs, './questions_money_bajosAOK.wav');
            
            banda21OK = convol(banda2modfiltro, banda21);
            wavwrite(banda21OK, Fs, './questions_money_banda21OK.wav');
        
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
    
