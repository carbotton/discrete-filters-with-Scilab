
//Recibe: f_M frecuencia de muestreo
//        f_p frecuencia fin banda pasante
//        f_s frecuencia inicio banda rechazo
//Retorna: filtro FIR pasabajos usando ventana de Kaiser


function [filtro] = pasabajosKaiser(f_M, f_p, f_s)

    // frecuencia fin de la banda pasante  
    phi_p = f_p/f_M;

    // frecuencia inicio de la banda de rechazo   
    phi_s = f_s/f_M;

    // error de aproximacion en la banda pasante
    delta_1 = 10**(-60/20);

    // error de aproximacion en la banda de rechazo
    delta_2 = 10**(-60/20);

    // calculo de ancho de banda de transicion 
    deltaphi = phi_s - phi_p;

    // calculo del parametro Beta de la ventana de Kaiser 
    A = -20*log10(delta_1); // atenuacion en dB

    if (A > 50) then Beta = 0.1102*(A-8.7)
    elseif (A > 21) then Beta = 0.5842*((A-21)^(0.4))+0.07886*(A-21)
    else Beta=0
    end
    //-

    // estimacion del largo del filtro       
    NK = ceil((A-8)/(2.285*2*%pi*deltaphi))

    v_nK = 0:1:NK;

    // calculo de los valores de la ventana de Kaiser 
    wK = (1/besseli(0,Beta))*besseli(0,Beta*sqrt( 1-(1-(2*v_nK)/NK).^2) );

    phi_B = (phi_s+phi_p)/2;
    phi_C = phi_B;
    
    v_hn_idK = (2*phi_B)*sinc(%pi*(2*phi_B)*(v_nK-NK/2));

    v_hnK = v_hn_idK.*wK;

    // largo de la TDF a usar para calcular valores de la TFTD 
    L = 2**16;

    // calculo de valores en el eje de frecuencias y valores de la TFTD
    v_phi = (1/L)*(0:1:L-1);

    v_f = f_M*v_phi;    

    v_h_phiK = fft([v_hnK,zeros(1,L-length(v_hnK))]);
    
    //retorno
    filtro = v_hnK; 
    
    //ver como quedó kaiser
    graficarFiltro(f_M, filtro, "Kaiser pasa bajos", 30, 6, 2**16)   

endfunction

//
//Recibe: f_M frecuencia de muestreo
//        f_p1 frecuencia comienzo banda pasante
//        f_s1 frecuencia fin banda de rechazo izq 
//        f_p2 frecuencia fin banda pasante
//        f_s2 frecuencia inicio banda de rechazo der
//Retorna: filtro FIR pasabanda usando ventana de Kaiser


function [pasabanda] = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2)

    phi_p1 = f_p1/f_M;   
    phi_s1 = f_s1/f_M;
    phi_p2 = f_p2/f_M;   
    phi_s2 = f_s2/f_M;

    f_c1 = (f_s1+f_p1)/2;
    f_c2 = (f_s2+f_p2)/2; 

    phi_c1 = f_c1/f_M;
    phi_c2 = f_c2/f_M;   

    phi_0 = (phi_c1+phi_c2)/2;

    phi_B = (phi_c2-phi_c1)/2;

    delta_1 = 10**(-60/20);
    delta_s = 10**(-60/20);

    deltaphi = min(phi_p1-phi_s1, phi_s2-phi_p2);    

    A = -20*log10(delta_s); // atenuacion en dB

    if (A > 50) then Beta = 0.1102*(A-8.7)
    elseif (A > 21) then Beta = 0.5842*((A-21)^(0.4))+0.07886*(A-21)
    else Beta=0
    end,

    N = ceil((A-8)/(2.285*2*%pi*deltaphi));
    vn = [0:1:N];

    hbpi = (2*phi_B)*sinc(%pi*(2*phi_B)*(vn-N/2)).*(2*cos(2*%pi*phi_0*(vn-N/2)));   
    wK= window('kr',N+1,Beta);
    //   wK = (1/besseli(0,Beta))*besseli(0,Beta*sqrt( 1-(1-(2*v_nK)/NK).^2) );

    vMn = hbpi.*wK;
    
    //retorno
    pasabanda = vMn;    

endfunction


//Recibe: f_M frecuencia de muestreo
//        filtro en el dominio del tiempo
//        titulo para el plot
//        numero de ventana para el plot
//        color para el plot
//        largo del vector de puntos


function graficarFiltro(f_M, filtro, titulo, num, col, L)
    
    vphi = (1/L)*[0:1:L-1];
    
    filtroFFT = fft([filtro,zeros(1,L-length(filtro))]);
        
    scf(num);
    xgrid();
    plot2d(f_M*vphi,abs(filtroFFT),style=col);
    title(titulo, "fontsize",4.5); 

endfunction


//Recibe: f_M frecuencia de muestreo
//        audio_b1, _b2 y _b3 son los trozos de audio a graficar (en el tiempo)
//        titulo para el plot
//        numero de ventana para el plot
//        color para el plot de cada trozo


function graficarBandasAudio (f_M, audio_b1, audio_b2, audio_b3, titulo, num, col1, col2, col3)
    
    [a,L1] = size(audio_b1);
    [a,L2] = size(audio_b2);
    [a,L3] = size(audio_b3);
    graficarFiltro(f_M, audio_b1, "", num, col1, L1);
    graficarFiltro(f_M, audio_b2, "", num, col2, L2);
    graficarFiltro(f_M, audio_b3, titulo, num, col3, L3);
    
endfunction
