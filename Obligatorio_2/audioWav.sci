
function graficarAudio(path, titulo, num)
    
    [x_in_2c, Fs, bits] = wavread(path);
    x_in = x_in_2c(1,:);
    
    [canales,L] = size(x_in);
    v_phi = (1/L)*[0:1:L-1];
    fft_audio_in = fft(x_in);
   
    scf(num);
    clf();
    xgrid();
    Fs = 44100;
    plot2d(v_phi*Fs, abs(fft_audio_in), style=9);
    title(titulo);
        
endfunction
