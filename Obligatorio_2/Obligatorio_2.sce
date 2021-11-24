
    exec('./cod_decod.sce');
    
//    pathIN = './questions_money.wav';
//    pathCOD = './questions_money_cod.wav';
//    pathOUT = './questions_money_deco.wav';
    
    pathIN = './preamble10.wav';
    pathCOD = './preamble10_cod.wav';
    pathOUT = './preamble10_deco.wav';
    
    codificar(pathIN, pathCOD);
    decodificar(pathCOD, pathOUT);
