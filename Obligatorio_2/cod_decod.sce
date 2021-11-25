       
    exec('./audioWav.sci');
    exec('./filtros.sci');
    
function codificar(pathIN, pathCOD, num)
    
    xdel(winsid());
    
    //==========================
    // Definicion de frecuencias
    // para filtrar bandas
    //==========================
    
    f_M = 44100;             //frecuencia de muestreo
    
    //primera banda
        f_p = 1133;          //frecuencia fin banda pasante
        f_s = 1333;          //frecuencia inicio banda rechazo               
        b1 = pasabajosKaiser(f_M, f_p, f_s);   
    //-

    //segunda banda
        f_s1_b2 = 1333;           //fin banda de rechazo izq
        f_p1_b2 = 1533;           //comienzo banda pasante
        f_p2_b2 = 2466;           //fin banda pasante
        f_s2_b2 = 2666;           //comienzo banda rechazo der
        b2 = pasaBandaKaiser(f_M, f_p1_b2, f_p2_b2, f_s1_b2, f_s2_b2);
    //-
        
    //tercera banda
        f_s1_b3 = 2667;           //fin banda de rechazo izq
        f_p1_b3 = 2867;           //comienzo banda pasante
        f_p2_b3 = 3800;           //fin banda pasante
        f_s2_b3 = 4000;           //comienzo banda rechazo der 
        b3 = pasaBandaKaiser(f_M, f_p1_b3, f_p2_b3, f_s1_b3, f_s2_b3);
    //- 
    
    //========================== FIN DEFINICION PARAMETROS   
    
    
    //====================================================
 
    //guardo parametros y filtros para usar en deco
        save('./filtros_bandas/banda1', 'b1', 'f_p', 'f_s')  
        save('./filtros_bandas/banda2', 'b2', 'f_s1_b2', 'f_p1_b2', 'f_p2_b2', 'f_s2_b2')    
        save('./filtros_bandas/banda3', 'b3', 'f_s1_b3', 'f_p1_b3', 'f_p2_b3', 'f_s2_b3') 
    //-
        
    //graficar filtros b1, b2 y b3
        graficarFiltro(f_M, b1, '', 0, 6, 2**16);
        graficarFiltro(f_M, b2, '', 0, 1, 2**16);
        graficarFiltro(f_M, b3, 'Filtros para las bandas '+string(pathIN), num, 13, 2**16);
    //-
    
    //anchos de banda
        bw_b1 = f_s;
        bw_b2 = f_s2_b2-f_s1_b2;
        bw_b3 = f_s2_b3-f_s1_b3;   
    //-
      
    //señal de audio    
        graficarAudio(pathIN, "FFT audio IN en Hertz", num+1);
        [audio_in, Fs_audio, bits] = wavread(pathIN);
        [canales,L] = size(audio_in);
        audio_mono = audio_in(1,:);                      
    //-
    
    //division en bandas de la señal de audio          
        audio_b1 = convol(b1, audio_mono);
        audio_b2 = convol(b2, audio_mono);
        audio_b3 = convol(b3, audio_mono); 
        
        graficarBandasAudio(f_M, audio_b1, audio_b2, audio_b3, 'Separación en bandas de '+string(pathIN), num+2, 6, 1, 13);
        legend("banda 1", "banda 2", "banda 3");
    //-
    
    //modulacion para trasladar bandas

        //b1 a b3
            f_mod1_3 = f_s1_b3;
            phi_mod1_3 = f_mod1_3/f_M;
                    
            n1 = 0: (length(audio_b1)-1);    
            cos1 = 2*cos(2*%pi*n1*phi_mod1_3);       
            audio_b1_3 = audio_b1.*cos1;                    
        //-
        
        //b3 a b2
            f_mod3_2 = f_s1_b3-f_s1_b2;
            phi_mod3_2 = f_mod3_2/f_M;
                    
            n3 = 0: (length(audio_b3)-1);    
            cos3 = 2*cos(2*%pi*n3*phi_mod3_2);         
            audio_b3_2 = audio_b3.*cos3;                                  
        //-
        
        //b2 a b1
            f_mod2_1 = f_s;
            phi_mod2_1 = f_mod2_1/f_M;
                    
            n2 = 0: (length(audio_b2)-1);    
            cos2 = 2*cos(2*%pi*n2*phi_mod2_1);         
            audio_b2_1 = audio_b2.*cos2;                    
        //-
        
        graficarBandasAudio(f_M, audio_b1_3, audio_b3_2, audio_b2_1, 'Modulación', num+3, 6, 1, 13);
        legend("banda 1", "banda 2", "banda 3");
               
    //-
    
    //me quedo con la parte de la modulación que me sirve
        
        //genero filtros
                       
            f_s1 = f_mod1_3;           
            f_p1 = f_mod1_3+10;           
            f_p2 = f_mod1_3+f_s;          
            f_s2 = f_p2+10;            
            audio_b1_3_filtro = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);   
            
            f_s1 = f_mod3_2;           
            f_p1 = f_mod3_2+10;                            
            f_s2 = f_mod3_2+bw_b3;     
            f_p2 = f_s2-10;       
            audio_b3_2_filtro = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);
            
            f_s1 = f_s1_b2-bw_b2;           
            f_p1 = f_s1+10;                  
            f_s2 = bw_b2;
            f_p2 = f_s2-10;            
            audio_b2_1_filtro = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2);                                
        //-
        
        //aplico filtros
        
            audio_b1_3_OK = convol(audio_b1_3_filtro, audio_b1_3);                        
            audio_b3_2_OK = convol(audio_b3_2_filtro, audio_b3_2);                       
            audio_b2_1_OK = convol(audio_b2_1_filtro, audio_b2_1);              
        
            graficarBandasAudio(f_M, audio_b1_3_OK, audio_b3_2_OK, audio_b2_1_OK, "Modulación y filtrado", num+4, 6, 13, 1);
            legend("banda 1 -> banda 3", "banda 3 -> banda 2", "banda 2 -> banda 1")
                
        //-
    //-
    
    //salida del CODIFICADOR
        audio_codificado = audio_b1_3_OK + audio_b3_2_OK + audio_b2_1_OK;
        wavwrite(audio_codificado, Fs_audio, pathCOD);
        graficarAudio(pathCOD, "FFT audio OUT en Hertz", num+5);     
    //-
    
endfunction

function decodificar(pathCOD, pathOUT, num)
    
    f_M = 44100;
    
    //filtros por banda
        load('./filtros_bandas/banda1') //b1
        load('./filtros_bandas/banda2') //b2
        load('./filtros_bandas/banda3') //b3
    //-
    
    //leo audio
        [audio_mono, Fs_audio, bits] = wavread(pathCOD);   
    //-  
    
    //division en bandas de la señal de audio          
        cod_b1 = convol(b1, audio_mono);
        cod_b2 = convol(b2, audio_mono);
        cod_b3 = convol(b3, audio_mono); 
        
        graficarBandasAudio(f_M, cod_b1, cod_b2, cod_b3, 'Separación en bandas de '+string(pathCOD), 22, 1, 13, 6);
        legend("banda 2 en el lugar 1", "banda 3 en el lugar 2", "banda 1 en el lugar 3");
    //- 
    
    //
    
    //-    
    
endfunction

function decodificar_con_cod(pathCOD, pathOUT, num)
    codificar(pathCOD, pathOUT, num);
    codificar(pathOUT, pathOUT, num+1);
endfunction
