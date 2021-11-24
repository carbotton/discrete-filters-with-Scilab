
    exec('./cod_decod.sce');
    
    pathIN = './questions_money.wav';
    pathCOD = './questions_money_cod.wav';
    pathOUT = './questions_money_deco.wav';
    
    codificar(pathIN, pathCOD);
    decodificar(pathCOD, pathOUT);
