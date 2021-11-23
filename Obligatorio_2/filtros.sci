/*
Recibe: f_M frecuencia de muestreo
        f_p frecuencia fin banda pasante
        f_s frecuencia inicio banda rechazo
Retorna: filtro FIR
*/

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
    
    filtro = v_hnK;    

endfunction

/*
Recibe: f_M frecuencia de muestreo
        f_p1 
        f_s1 
        ...
Retorna: filtro FIR
*/

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
    
    pasabanda = vMn;    

endfunction

function graficarFiltros(f_M, f_mod, filtroPB, filtroPM1, filtroPM2)
    
    L= 2**16;
    vphi = (1/L)*[0:1:L-1];
    v_f = f_M*v_phi;
    
    filtroPB_fft = fft([filtroPB,zeros(1,L-length(filtroPB))]);    
    filtroPM1_fft = fft([filtroPM1,zeros(1,L-length(filtroPM1))]);
    filtroPM2_fft = fft([filtroPM2,zeros(1,L-length(filtroPM2))]);
    
    scf(1);
    xgrid();
    plot2d(f_M*vphi,abs(filtroPB_fft),style=6);
    plot2d(f_M*vphi,abs(filtroPM1_fft),style=5);
    plot2d(f_M*vphi,abs(filtroPM2_fft),style=11);
    xtitle('Módulo de la transferencia de los filtros');  
    
    phi_mod = f_mod/f_M;
    
    nPB = 0: (length(filtroPB)-1);    
    cosPB = cos(2*%pi*nPB*phi_mod); 
    nPM1 = 0: (length(filtroPM1)-1);    
    cosPM1 = cos(2*%pi*nPM1*phi_mod);     
    nPM2 = 0: (length(filtroPM2)-1);    
    cosPM2 = cos(2*%pi*nPM2*phi_mod);
        
    filtroPB_cos = fft([filtroPB.*cosPB,zeros(1,L-length(filtroPB))]);
    filtroPM1_cos = fft([filtroPM1.*cosPM1,zeros(1,L-length(filtroPM1))]);
    filtroPM2_cos = fft([filtroPM2.*cosPM2,zeros(1,L-length(filtroPM2))]);
    
    scf(2);
    clf();
    xgrid();
    plot2d(v_f,abs(filtroPB_cos),style=6);
    plot2d(v_f,abs(filtroPM1_cos),style=5);
    plot2d(v_f,abs(filtroPM2_cos),style=11);
    xtitle('(MODULADO) Módulo de la transferencia de los filtros');     
        
endfunction