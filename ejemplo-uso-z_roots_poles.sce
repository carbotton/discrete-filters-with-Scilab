
    clear;
    xdel(winsid()); 
    
    exec('./z_roots_poles.sci')
    
    ceros = [z_roots_poles(0), z_roots_poles(1/3), z_roots_poles(-1/3)];
    polos = [];

    num_z = poly(ceros($:-1:1),'z','r');  
//    den_z = poly(polos($:-1:1),'z','r');
    den_z = 1;
       
    L = 1;   
    delta_phi = 0.0001;   
    v_phi = (0:delta_phi:L); //valores de phi
    v_z = exp(%i*2*%pi*v_phi);   
    v_h_phi = freq(num_z,den_z,v_z); 
   
    scf(1);
    clf()
    xgrid()
    plot2d(v_phi,abs(v_h_phi),style=2)                   
