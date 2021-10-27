// leer_y_guardar_audio.sce
//
//
// posible comando para leer un archivo .wav en un vector

  [x_aux, Fs, bits] = wavread('trozo_mono.wav'); //Fs frec de muestreo
  
  size(x_aux) //devuelve filas y columnas. Si tiene 2 filas es stereo.
  Fs	//la Fs de muestreo es la que elegi en audacity al editar el archivo de audio
  bits
  
  //la idea es trabajar con audio mono pero si me queda con dos canales, me puedo quedar aca con una sola fila y listo
  x_entrada = x_aux(1,:);
  size(x_entrada);

  x_procesado=x_entrada($:-1:1);
   
  wavwrite(x_procesado, Fs, 'trozo_procesado.wav');
  
  
  //el formato wav admite valores (eje y) entre -1 y 1
  //si nuestro audio tiene una ganancia mayor, scilab automaticamente lo va a truncar para que quede en este rango

   
