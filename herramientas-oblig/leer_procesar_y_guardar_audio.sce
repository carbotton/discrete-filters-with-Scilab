// leer_y_guardar_audio.sce
//
//
// posible comando para leer un archivo .wav en un vector

  [x_entrada, Fs, bits] = wavread('trozo_mono.wav');
  
  size(x_entrada)
  Fs
  bits

////////////////////////////////////////////////////////////////////////////////

//  x_procesado=x_entrada($:-1:1);

  load('filtro');
  
  x_procesado = rtitr(num_z,den_z,x_entrada);
  
////////////////////////////////////////////////////////////////////////////////  
   
  wavwrite(x_procesado, Fs, 'trozo_procesado.wav');
   
