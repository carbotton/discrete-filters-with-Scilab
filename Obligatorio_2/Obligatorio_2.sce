
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
    
    //========================== FIN DEFINICION PARAMETROS   
    
    
    //====================================================
    
    //graficar filtros b1, b2 y b3
        //graficarFiltro(f_M, b1);
        //graficarFiltro(f_M, b2);
        //graficarFiltro(f_M, b3);
    //-
       
    //señal de audio    
        path = './questions_money.wav';
        //graficarAudioIn(path);
        [audio_in, Fs_audio, bits] = wavread(path);
        [canales,L] = size(audio_in);
        audio_mono = audio_in(1,:);                       
    //-
    
    //division en bandas de la señal de audio          
        audio_b1 = convol(b1, audio_mono);
        audio_b2 = convol(b2, audio_mono);
        audio_b3 = convol(b3, audio_mono); 
        
        graficarBandasAudio(audio_b1, audio_b2, audio_b3, 'Separación en bandas', 5);
    //-
    
    //modulacion para trasladar bandas

        //b1 a b3
            f_mod1_3 = (f_p2_b3+f_p1_b3)/2;
            phi_mod1_3 = f_mod1_3/f_M;
                    
            n1 = 0: (length(audio_b1)-1);    
            cos1 = cos(2*%pi*n1*phi_mod1_3);         
            audio_b1_3 = audio_b1.*cos1;            
        //-
        
        //b3 a b2
            f_mod3_2 = (f_p2_b2+f_p1_b2)/2;
            phi_mod3_2 = f_mod3_2/f_M;
                    
            n3 = 0: (length(audio_b3)-1);    
            cos3 = cos(2*%pi*n3*phi_mod3_2);         
            audio_b3_2 = audio_b3.*cos3;           
        //-
        
        //b2 a b1
            f_mod2_1 = f_s;
            phi_mod2_1 = f_mod2_1/f_M;
                    
            n2 = 0: (length(audio_b2)-1);    
            cos2 = cos(2*%pi*n2*phi_mod2_1);         
            audio_b2_1 = audio_b2.*cos2;         
        //-
        
        graficarBandasAudio(audio_b1_3, audio_b3_2, audio_b2_1, 'Bandas de audio moduladas', 3);
               
    //-
    
    //me quedo con la parte de la modulación que me sirve
        
        //genero filtros
                       
            f_s1 = f_mod1_3-50;           
            f_p1 = f_mod1_3;           
            f_p2 = f_mod1_3+f_s;          
            f_s2 = f_p2+50;            
            audio_b1_3_filtro = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);   
            
            f_s1 = f_mod3_2-50;           
            f_p1 = f_mod3_2;           
            f_p2 = f_mod3_2 +(f_p2_b3-f_p1_b3);        
            f_s2 = f_p2+50;            
            audio_b3_2_filtro = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);
            
            f_s1 = f_mod2_1-50;           
            f_p1 = f_mod2_1;           
            f_p2 = f_mod2_1 +(f_p2_b2-f_p1_b2);        
            f_s2 = f_p2+50;            
            audio_b2_1_filtro = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);      
                                         
        //-
        
        //aplico filtros
        
            audio_b1_3_OK = convol(audio_b1_3_filtro, audio_b1_3);
            wavwrite(audio_b1_3_OK, Fs_audio, './questions_money_audio_b1_3_OK.wav');            
            audio_b3_2_OK = convol(audio_b3_2_filtro, audio_b3_2);
            wavwrite(audio_b3_2_OK, Fs_audio, './questions_money_audio_b3_2_OK.wav');            
            audio_b2_1_OK = convol(audio_b2_1_filtro, audio_b2_1);
            wavwrite(audio_b2_1_OK, Fs_audio, './questions_money_audio_b2_1_OK.wav');      
        
            graficarBandasAudio(audio_b1_3_OK, audio_b3_2_OK, audio_b2_1_OK, "Me quedo con lo que me sirve de los bajos modulados", 4);
                    
        //-
    //-
    
