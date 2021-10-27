// grafos_del_espectro_de_entrada_y_salida.sce


  [canales,L] = size(x_entrada);
  
  v_h_phi_x_entrada = fft(x_entrada);
  
  v_phi = (1/L)*[0:1:L-1];
  
  scf(5);
  clf() 
  xgrid()
  plot2d(Fs*v_phi,abs(v_h_phi_x_entrada),style=2)  
  
  v_h_phi_x_procesado = fft(x_procesado);

  plot2d(Fs*v_phi,abs(v_h_phi_x_procesado),style=5)  
 
