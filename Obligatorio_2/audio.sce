    clear;close(winsid());
    
    [x_in_2c, Fs, bits] = wavread('./questions_money.wav');
    x_in = x_in_2c(1,:);
    
    [canales,L] = size(x_in);
    v_phi = (1/L)*[0:1:L-1];
    v_h_phi_x_in = fft(x_in);

    scf(9);
    clf();
    xgrid();
    plot2d(x_in, style=16);
    title("Audio IN");
    
    scf(8);
    clf();
    xgrid();
    Fs = 44100;
    plot2d(v_phi*Fs, abs(v_h_phi_x_in), style=9);
    title("FFT audio IN en Hertz");
    
    scf(7);
    clf();
    xgrid();
    plot2d(v_phi, abs(v_h_phi_x_in), style=9);
    title("FFT audio IN (phi)");    
    
    wavwrite(x_in, Fs, './questions_money_proc.wav');
