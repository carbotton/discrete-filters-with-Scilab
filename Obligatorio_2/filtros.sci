/*
    Recibe:
    Retorna:
*/

function [filtro] = altosBajosKaiser(tipoFiltro, f_M, f_p, f_s)
    
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
    
    if tipoFiltro == 'PB' then
        v_hn_idK = (2*phi_B)*sinc(%pi*(2*phi_B)*(v_nK-NK/2));
    else
        v_hn_idK = ((-1)**v_nK).*((1-2*phi_C)*sinc(%pi*(1-2*phi_C)*(v_nK-NK/2)));
    end

    v_hnK = v_hn_idK.*wK;

    // largo de la TDF a usar para calcular valores de la TFTD 
    L = 2**16;

    // calculo de valores en el eje de frecuencias y valores de la TFTD
    v_phi = (1/L)*(0:1:L-1);

    v_f = f_M*v_phi;    

    v_h_phiK = fft([v_hnK,zeros(1,L-length(v_hnK))]);
    
    filtro = v_h_phiK; //retorno
    
    // grafo del modulo de la transferencia de los filtros diseniados
    // grafico del modulo para verificacion
        if tipoFiltro == 'PB' then 
            scf(0);
            title = 'Módulo de la transferencia del filtro pasa bajos'
        else 
            scf(1);
            title = 'Módulo de la transferencia del filtro pasa altos' 
        end
        
        xgrid();
        plot2d(v_f,abs(v_h_phiK),style=16)
        xtitle(title);

        // grafico superpuesto de bandas de tolerancia
//        plot2d([0,f_p],[1+delta_1,1+delta_1],style=5)
//        plot2d([0,f_p],[1-delta_1,1-delta_1],style=5)
//        plot2d([f_p,f_p],[1-delta_1,1+delta_1],style=5)
//    
//        plot2d([(f_p+f_s)/2,(f_p+f_s)/2],[0,1],style=4)
//    
//        plot2d([f_s,f_M-f_s],[delta_2,delta_2],style=5)
//        plot2d([f_s,f_s],[0,delta_2],style=5)
//        plot2d([f_M-f_s,f_M-f_s],[0,delta_2],style=5)
    //-

    // visualizacion de un trozo del grafo sin usar zoom
//        scf(1);
//        clf()
//        xgrid()
//    
//        area_a_ver = [0.95*f_p,(1-5*delta_1),1.05*f_p,(1+5*delta_1)]; 
//    
//        plot2d(v_f,abs(v_h_phiK),style=3,rect=area_a_ver)
//    
//        xtitle('Salida de banda pasante');
//    
//        // grafico superpuesto de bandas de tolerancia
//        plot2d([0,f_p],[1+delta_1,1+delta_1],style=5,rect=area_a_ver)
//        plot2d([0,f_p],[1-delta_1,1-delta_1],style=5,rect=area_a_ver)
//        plot2d([f_p,f_p],[1-delta_1,1+delta_1],style=5,rect=area_a_ver)
    //-

    // visualizacion de un trozo del grafo sin usar zoom 
//        scf(2);
//        clf();
//        xgrid();
//    
//        area_a_ver = [0.95*f_s,0,1.05*f_s,(5*delta_2)]; 
//
//        plot2d(v_f,abs(v_h_phiK),style=3,rect=area_a_ver)
//    
//        xtitle('Entrada a banda de rechazo');
//    
//        // grafico superpuesto de bandas de tolerancia
//        plot2d([f_s,f_M-f_s],[delta_2,delta_2],style=5,rect=area_a_ver)
//        plot2d([f_s,f_s],[0,delta_2],style=5,rect=area_a_ver)
//        plot2d([f_M-f_s,f_M-f_s],[0,delta_2],style=5,rect=area_a_ver)
    //-        
    
endfunction

function [pasabanda] = pasaBandaKaiser(f_M, f_p1, f_p2, f_s1, f_s2, f_c1, f_c2)
    
    phi_p1 = f_p1/f_M;   
    phi_s1 = f_s1/f_M;
    phi_p2 = f_p2/f_M;   
    phi_s2 = f_s2/f_M;
    
    phi_c1 = f_c1/f_M;
    phi_c2 = f_c2/f_M;   
     
    phi_0 = (phi_c1+phi_c2)/2;
    
    phi_B = (phi_c2-phi_c1)/2;
    
    delta_1 = 10**(-60/20);
    delta_2 = 10**(-60/20);
    
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
   
    L= 2**16;
    vphi = (1/L)*[0:1:L-1];
    pasabanda = fft([vMn,zeros(1,L-length(vMn))]);    
         
    scf(2);
    xgrid()
    plot2d(Fs*vphi,abs(pasabanda),style=16)
    xtitle('Módulo de la transferencia del filtro pasa banda');
    
endfunction
