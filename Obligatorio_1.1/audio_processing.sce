
    //----- Import audio and change into mono -------//    
    //    [x_in, Fs, bits] = wavread('./audios/example_1.wav');
        [x_in, Fs, bits] = wavread('./audios/beth-symph.wav');
        x_in_mono = x_in(1,:); //1 channel
    //-
    
    //----- Apply low, band and high pass filters -------//
        load('./filters/low_pass_filter');
        x_low = rtitr(num_z_low, den_z_low, x_in_mono);
        x_low = x_low($:-1:1); //truncar entre -1 y 1 porque sino lo hace scilab
        wavwrite(x_low, Fs, './audios/beth-symph/low.wav');
      
        load('./filters/band_pass_filter');
        x_low_mid = rtitr(num_z_mid, den_z_mid, x_low);
        x_low_mid = x_low_mid($:-1:1); 
        wavwrite(x_low_mid, Fs, './audios/beth-symph/low_mid.wav');  
      
        load('./filters/high_pass_filter');
        x_processed = rtitr(num_z_high, den_z_high, x_low_mid);
        x_processed = x_processed($:-1:1);
        wavwrite(x_processed, Fs, './audios/beth-symph/low_mid_high.wav'); 
    //-   
  
    //----- Plot using fast fourier transform -----// 
        [canales,L] = size(x_in_mono);
              
        v_h_phi_x_entrada = fft(x_in_mono);
                    
        v_phi = (1/L)*[0:1:L-1];
                            
        scf(5);
        clf() 
        xgrid()        
        plot2d(Fs*v_phi, abs(v_h_phi_x_entrada), style=2)   //multiplico por Fs para escalar 
      
        v_h_phi_x_procesado = fft(x_processed);
        
        scf(6);
        clf() 
        xgrid()     
        plot2d(Fs*v_phi, abs(v_h_phi_x_procesado), style=5) 
   
