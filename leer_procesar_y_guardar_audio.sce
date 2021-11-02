// leer_y_guardar_audio.sce
//
//
// posible comando para leer un archivo .wav en un vector

  [x_aux, Fs, bits] = wavread('example_1.wav');
  
  x_entrada = x_aux(1,:);
  size(x_entrada)
  Fs
  bits

////////////////////////////////////////////////////////////////////////////////

//  x_procesado=x_entrada($:-1:1);

  load('filtro'); //archivo que contiene el filtro
  
  //a rtitr tengo que pasarle un x_entrada que tenga UNA SOLA FILA
  //num_z y den_z de la transferencia del filtro
  x_procesado = rtitr(num_z,den_z,x_entrada);	
  
////////////////////////////////////////////////////////////////////////////////  
   
  wavwrite(x_procesado, Fs, 'example_1_procesado.wav');
   
