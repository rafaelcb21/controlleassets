
int tipoLancamento(String tipo) {

  if(tipo == ' ') {
    return 0;
  }

  List palavras = tipo.split(' ');  

  if(palavras[1] == 'não') {
    if(palavras.last == 'fixos') {
      return 3;

    } else if(palavras.last == 'parcelados') {
      return 4;

    } else if(palavras.last == 'parc.') {
      return 5;
    }

  } else {
    if(palavras.length == 2) {
      if(palavras.last == 'fixos') {
        return 1;

      } else if(palavras.last == 'parcelados') {
        return 2;
      }

    } else if(palavras.length == 4) {
      return 6;
    }
  }
}

int receitaDespesaTransf(String rdt) {

  if(rdt == ' ') {
    return 0;
  }

  int numero = rdt.split(' ').length;
  return numero;
}


String escolherFuncao(lista) {

  List grupoA = lista[0];
  String grupoB = lista[1];
  String grupoC = lista[2];
  List grupoD = lista[3];
  List grupoE = lista[4];

  int rdt = receitaDespesaTransf(grupoB);
  int typeLaunch = tipoLancamento(grupoC);

  if(
    grupoA[0] == ' ' && grupoA[1] == 0 && rdt > 0 && typeLaunch > 0 && grupoD[1] > 0 && grupoE[1] > 0 ||
    grupoA[0] != ' ' && rdt > 0 && typeLaunch > 0 && grupoD[1] > 0 && grupoE[1] > 0
  ) {
    return queryFiltroContinuacao(lista);
  
  } else {
    return queryFiltro(lista);
  }

}

String queryFiltro(lista) {

  String queryEscolhida;

  List grupoA = lista[0];
  String grupoB = lista[1];
  String grupoC = lista[2];
  List grupoD = lista[3];
  List grupoE = lista[4];

  int rdt = receitaDespesaTransf(grupoB);
  int typeLaunch = tipoLancamento(grupoC);

  // A
  if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {    
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0';
  
  // B
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0';
  
  // C
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND idcartao = 0';

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Parcelada AND idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Parcelada AND idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcartao = 0';
  
  // D
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idcategoria = ' + grupoD[1].toString();
  
  // E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idtag = ' + grupoE[1].toString();
  
  // A,B
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB;
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND pago = 1';

  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND pago = 0';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND pago = 0';
  
  // A,C
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa';
  
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada';

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa';

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada';
  
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada';

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND tiporepeticao = Parcelada';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Fixa';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada';

  // A,D
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {    
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND idcategoria = ' + grupoD[1].toString();
  
  // A,E
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {    
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND idtag = ' + grupoE[1].toString();
  
  // B,C
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Fixa';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Fixa';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada';
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada';
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada';
  
  // B,D
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString();
  
  // B,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND idtag = ' + grupoE[1].toString();
  
  // C,D
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString();
  
  // C,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND idcartao = 0 AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Parcelada AND idcartao = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND idcartao = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Parcelada AND idcartao = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcartao = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcartao = 0 AND idtag = ' + grupoE[1].toString();
  
  // D,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  // A,B,C
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB;
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB;
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB;
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB;
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB;
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB;
  ///
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1';
  ///
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0';
  ///////////
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB;
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1';
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0';
  
  // A,B,D
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND pago = 1 AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND pago = 0 AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  // A,B,E
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND pago = 1 AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND pago = 0 AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  // A,C,D
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();

  // A,C,E
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();

  // A,D,E
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {    
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND idcategoria = ' + grupoD[1].toString() + 'AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND idcategoria = ' + grupoD[1].toString() + 'AND idtag = ' + grupoE[1].toString();
  
  // B,C,D
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString();
  
  // B,C,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ' + grupoE[1].toString();
  
  // B,D,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  // C,D,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] >0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  // A,B,C,D
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  ///////////
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString();
  
  // A,B,C,E
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  ///////////
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idtag = ' + grupoE[1].toString();
  
  // A,B,D,E
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tipo = ?' + grupoB + ' AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?' + grupoB + ' AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  // A,C,D,E
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[1] != 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = > 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else {
    return queryEscolhida = ' ';
  }
}


String queryFiltroContinuacao(lista) {
  String queryEscolhida;

  List grupoA = lista[0];
  String grupoB = lista[1];
  String grupoC = lista[2];
  List grupoD = lista[3];
  List grupoE = lista[4];

  int rdt = receitaDespesaTransf(grupoB);
  int typeLaunch = tipoLancamento(grupoC);

  // B,C,D,E
  if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
      return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
    
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE tipo = ' + grupoB + ' AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  // A,B,C,D,E
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  ///////////
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + ' AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 1 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'SELECT * FROM lancamento WHERE idconta = ' + grupoA[1].toString() + ' AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND tipo = ?' + grupoB + 'AND pago = 0 AND idcategoria = ' + grupoD[1].toString() + ' AND idtag = ' + grupoE[1].toString();
  
  } else {
    return queryEscolhida = ' ';
  }
}