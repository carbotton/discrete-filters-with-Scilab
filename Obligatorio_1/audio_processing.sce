    
    //------------------------------------------
    //              import audio
    //              save 1 channel
    //------------------------------------------ 
    
        [x_in, Fs, bits] = wavread('./audios/beth-symph.wav');
//        [x_in, Fs, bits] = wavread('./audios/example.wav');
//        [x_in, Fs, bits] = wavread('./audios/sweepinv.wav');
        x_in_mono = x_in(1,:);
         
    //------------------------------------------
    //              apply filters             
    //------------------------------------------     

        load('./filters/low_pass_filter');
        load('./filters/band_pass_filter'); 
        load('./filters/high_pass_filter');
        
        //normalize
            L = 1;   
            delta_phi = 0.0001;   
            v_phi = (0:delta_phi:L); 
            v_z = exp(%i*2*%pi*v_phi); 
            
            transf_low = freq(num_z_low,den_z_low,v_z);
            num_z_low = num_z_low/max(abs(transf_low));
        
            transf_mid = freq(num_z_mid,den_z_mid,v_z);
            num_z_mid = num_z_mid/max(abs(transf_mid));
            
            transf_high = freq(num_z_high,den_z_high,v_z);
            num_z_high = num_z_high/max(abs(transf_high));    
        //-
        
        x_proc_low = rtitr(low_gain*num_z_low, den_z_low, x_in_mono);
        x_proc_mid = rtitr(middle_gain*num_z_mid, den_z_mid, x_in_mono);
        x_proc_high = rtitr(high_gain*num_z_high, den_z_high, x_in_mono);
        
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
        
        wavwrite(x_proc, Fs, './audios/beth-symph-processed.wav');
//        wavwrite(x_proc, Fs, './audios/example-processed.wav');
//        wavwrite(x_proc, Fs, './audios/sweepinv-processed.wav');

    //------------------------------------------
    //              plot using FFT
    //------------------------------------------    
  
        [canales,L] = size(x_in_mono);
        v_phi = (1/L)*[0:1:L-1];
              
        v_h_phi_x_in_mono = fft(x_in_mono);                   
        v_h_phi_x_proc = fft(x_proc);                               
        
        scf(3)             
        clf()
        subplot(2,2,1)
        xgrid()
        plot2d(Fs*v_phi, abs(v_h_phi_x_in_mono), style=2)  //multiplico por Fs para escalar 
        title('FFT: Audio de entrada','fontsize',3);
        xlabel("f");
        //solve incompatible sizes plot2d
           [r1,c1] = size(v_phi);
           [r2,c2] = size(v_h_phi_x_proc);
           c = min([c1 c2]);
           v_h_phi_x_proc = v_h_phi_x_proc(:, 1:c);
           v_phi = v_phi(:, 1:c);
        //-        
        subplot(2,2,2)
        xgrid()
        plot2d(Fs*v_phi, abs(v_h_phi_x_proc), style=5) 
        title('FFT: Audio procesado','fontsize',3);
        xlabel("f");
        subplot(2,2,3)
        xgrid()
        plot(x_in_mono)
        title('Audio entrada','fontsize',3)
        subplot(2,2,4)
        xgrid()
        plot(x_proc)
        title('Audio procesado','fontsize',3)
