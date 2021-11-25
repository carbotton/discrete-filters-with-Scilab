
    exec('./cod_decod.sce');
    
//    pathIN = './audio_original/questions_money.wav';
//    pathCOD = './audio_codificado/questions_money_cod.wav';
//    pathOUT = './audio_decodificado/questions_money_deco.wav';
    
    pathIN = './audio_original/preamble10.wav';
    pathCOD = './audio_codificado/preamble10_cod.wav';
    pathOUT = './audio_decodificado/preamble10_deco.wav';
    
    codificar(pathIN, pathCOD, 1);
    decodificar(pathCOD, pathOUT, 20);
    
