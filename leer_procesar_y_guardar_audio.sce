    
//    [x_in, Fs, bits] = wavread('./audios/example_1.wav');
    [x_in, Fs, bits] = wavread('./audios/beth-symph.wav');
    x_in_mono = x_in(1,:);
    size(x_in_mono)
    Fs
    bits

////////////////////////////////////////////////////////////////////////////////

  load('./filters/low_pass_filter');
  x_low = rtitr(num_z_low, den_z_low, x_in_mono);
  x_low = x_low($:-1:1); //truncar entre -1 y 1 porque sino lo hace scilab
  wavwrite(x_low, Fs, './audios/beth-symph/low.wav');
  
  load('./filters/band_pass_filter');
  x_mid = rtitr(num_z_mid, den_z_mid, x_low);
  x_mid = x_mid($:-1:1); 
  wavwrite(x_mid, Fs, './audios/beth-symph/low_mid.wav');  
  
  load('./filters/high_pass_filter');
  x_high = rtitr(num_z_high, den_z_high, x_mid);
  x_high = x_high($:-1:1);
  wavwrite(x_high, Fs, './audios/beth-symph/low_mid_high.wav');    
  
////////////////////////////////////////////////////////////////////////////////  
   
  
  [canales,L] = size(x_in_mono);
  
  v_h_phi_x_entrada = fft(x_in_mono); //fast fourier transform (transformada discreta de fourier)
  
  v_phi = (1/L)*[0:1:L-1];
  
  scf(5);
  clf() 
  xgrid()
  plot2d(Fs*v_phi,abs(v_h_phi_x_entrada),style=2)   //multiplico por Fs para escalar 
  
  v_h_phi_x_procesado = fft(x_high);

  plot2d(Fs*v_phi,abs(v_h_phi_x_procesado),style=5) 
   
