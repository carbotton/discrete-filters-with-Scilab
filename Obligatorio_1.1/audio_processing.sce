    
    //------------------------------------------
    //              import audio
    //              save 1 channel
    //------------------------------------------ 
    
//        [x_in, Fs, bits] = wavread('./audios/beth-symph.wav');
        [x_in, Fs, bits] = wavread('./audios/example_1.wav');
        x_in_mono = x_in(1,:);
         
    //------------------------------------------
    //              apply filters             
    //------------------------------------------     

        load('./filters/low_pass_filter');
        load('./filters/band_pass_filter'); 
        load('./filters/high_pass_filter');
        
        x_proc_low = rtitr(num_z_low, den_z_low, x_in_mono);
        x_proc_mid = rtitr(num_z_mid, den_z_mid, x_in_mono);
        x_proc_high = rtitr(num_z_high, den_z_high, x_in_mono);
        
        //solve inconsistent row-column dimensions
            [rl,cl] = size(x_proc_low);
            [rm,cm] = size(x_proc_mid);
            [rh,ch] = size(x_proc_high);

            c = min([cl cm ch]);        
            
            x_proc_low = x_proc_low(:, 1:c);
            x_proc_mid = x_proc_mid(:, 1:c); 
            x_proc_high = x_proc_high(:, 1:c);  
        //-      
        
        x_proc = x_proc_low + x_proc_mid + x_proc_high;       
        x_proc = x_proc/max(x_proc);
        
//        wavwrite(x_proc, Fs, './audios/beth-symph-processed.wav');
        wavwrite(x_proc, Fs, './audios/example_1-processed.wav');

    //------------------------------------------
    //              plot using FFT
    //------------------------------------------    
  
        [canales,L] = size(x_in_mono);
        v_phi = (1/L)*[0:1:L-1];
              
        v_h_phi_x_in_mono = fft(x_in_mono);                   
        v_h_phi_x_proc = fft(x_proc);       
                            
        scf(5);
        clf() 
        xgrid()       
        //multiplico por Fs para escalar 
        plot2d(Fs*v_phi, abs(v_h_phi_x_in_mono), style=2)
        
        scf(6);
        clf() 
        xgrid()
        //solve incompatible sizes plot2d
           [r1,c1] = size(v_phi);
           [r2,c2] = size(v_h_phi_x_proc);
           c = min([c1 c2]);
           v_h_phi_x_proc = v_h_phi_x_proc(:, 1:c);
           v_phi = v_phi(:, 1:c);
        //-
        plot2d(Fs*v_phi, abs(v_h_phi_x_proc), style=5) 
   
