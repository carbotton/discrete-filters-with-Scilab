
function [x_in, fft_audio_in] = audioWav(path, graficar)
    
    [x_in_2c, Fs, bits] = wavread(path);
    x_in = x_in_2c(1,:);
    
    [canales,L] = size(x_in);
    v_phi = (1/L)*[0:1:L-1];
    fft_audio_in = fft(x_in);

    if graficar == %t then    
        scf(8);
        clf();
        xgrid();
        Fs = 44100;
        plot2d(v_phi*Fs, abs(fft_audio_in), style=9);
        title("FFT audio IN en Hertz");
        
        scf(7);
        clf();
        xgrid();
        plot2d(v_phi, abs(fft_audio_in), style=9);
        title("FFT audio IN (phi)");    
    end
    
//    wavwrite(x_in, Fs, './questions_money_proc.wav');
    
endfunction
