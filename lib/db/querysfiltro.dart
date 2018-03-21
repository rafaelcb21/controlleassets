
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
  String gB = lista[1];
  String grupoC = lista[2];
  List grupoD = lista[3];
  List grupoE = lista[4];

  int rdt = receitaDespesaTransf(gB);
  int typeLaunch = tipoLancamento(grupoC);

  if(
    //B,C,D,E
    grupoA[0] == ' ' && grupoA[1] == 0 && rdt > 0 && typeLaunch > 0 && grupoD[1] > 0 && grupoE[1] > 0 ||
    grupoA[0] != ' ' && rdt > 0 && typeLaunch > 0 && grupoD[1] > 0 && grupoE[1] > 0
  ) {
    print('rafael1');
    return queryFiltroContinuacaoParte2(lista);
  
  } else if(
    //A,B,C,E
    grupoA[0] != ' ' && rdt > 0 && typeLaunch > 0 && grupoD[1] == 0 && grupoE[1] > 0
  ) {
    print('rafael2');
    return queryFiltroContinuacaoParte1(lista);

  } else {
    print('rafael3');
    return queryFiltro(lista);
  }

}

String tratarLegendaFiltro(lista) {
  String legendaA = lista[0][0];
  String legendaB = lista[1];
  String legendaC = lista[2];
  String legendaD = lista[3][0];
  String legendaE = lista[4][0];
  List listaLegendas = [];

  List legendas = [legendaA, legendaB, legendaC, legendaD, legendaE];

  for(String item in legendas) {
    if(item != ' ') {
      listaLegendas.add(item);
    }
  }

  return listaLegendas.join(', ');   
}

String tratarLegendaFiltroCartao(lista) {
  String legendaA = lista[0][0];
  String legendaB = lista[1];
  List listaLegendas = [];

  List legendas = [legendaA, legendaB];

  for(String item in legendas) {
    if(item != ' ') {
      listaLegendas.add(item);
    }
  }

  return listaLegendas.join(', ');   
}

int cartaoPagoOuNao(String palavra) {

  List palavras = palavra.split(' ');
  if(palavra == ' '){
    return 0;
  } else if(palavras[1] != 'não') {
    return 1;
  } else {
    return 2;
  }
}

String queryFiltroCartao(lista) {
  String queryEscolhida;

  List grupoA = lista[0];
  String gB = lista[1];

  int pgto = cartaoPagoOuNao(gB);

  if(grupoA[0] != ' ' && grupoA[1] > 0 && pgto == 0) {
    return queryEscolhida = 'l.idcartao = ' + grupoA[1].toString();
    
  } else if(grupoA[0] != ' ' && grupoA[1] > 0 && pgto == 1 ) {
    return queryEscolhida = 'l.idcartao = ' + grupoA[1].toString() + ' AND l.pago = 1'; 

  } else if(grupoA[0] != ' ' && grupoA[1] > 0 && pgto == 2 ) {
    return queryEscolhida = 'l.idcartao = ' + grupoA[1].toString() + ' AND l.pago = 0'; 

  } else if(grupoA[0] == 'Todos os cartões' && pgto == 0) {
    return queryEscolhida = 'l.idcartao > 0';
    
  } else if(grupoA[0] == 'Todos os cartões' && pgto == 1 ) {
    return queryEscolhida = 'l.idcartao > 0 AND l.pago = 1';

  } else if(grupoA[0] == 'Todos os cartões' && pgto == 2 ) {
    return queryEscolhida = 'l.idcartao > 0 AND l.pago = 0';

  } else if(grupoA[0] == ' ' && pgto == 1 ) {
    return queryEscolhida = 'l.idcartao > 0 AND l.pago = 1';

  } else if(grupoA[0] == ' ' && pgto == 2 ) {
    return queryEscolhida = 'l.idcartao > 0 AND l.pago = 0';

  }

}

String queryFiltro(lista) {
  String queryEscolhida;

  List grupoA = lista[0];
  String grupoB = lista[1];
  String gB;
  int rdt;

  if(grupoB != ' ') {
    String letra = grupoB[0];

    if(letra == 'D') {
      gB = '\'Despesa\'';
    } else if(letra == 'R') {
      gB = '\'Receita\'';
    } else if(letra == 'T') {
      gB = '\'Transferência\'';
    }
    rdt = receitaDespesaTransf(grupoB);

  } else {
    rdt = 0;
  }
  
  String grupoC = lista[2];
  List grupoD = lista[3];
  List grupoE = lista[4];

  int typeLaunch = tipoLancamento(grupoC);

  // A
  if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = ' l.idconta = ' + grupoA[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = ' l.idconta > 0';
  
  // B
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0';
  
  // C
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tiporepeticao = \'Fixa\' AND l.idcartao = 0';

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tiporepeticao = \'Parcelada\' AND l.idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'NOT l.tiporepeticao = \'Fixa\' AND l.idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'NOT l.tiporepeticao = \'Parcelada\' AND l.idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcartao = 0';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcartao = 0';
  
  // D
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idcategoria = ' + grupoD[1].toString();
  
  // E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idtag = ' + grupoE[1].toString();
  
  // A,B
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB;
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.pago = 1';

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.pago = 0';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  // A,C
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\'';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\'';

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\'';

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\'';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\')';

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\')';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao = \'Fixa\'';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao = \'Parcelada\'';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND NOT l.tiporepeticao = \'Fixa\'';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND NOT l.tiporepeticao = \'Parcelada\'';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\')';

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\')';

  // A,D
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {    
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  // A,E
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {    
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.idtag = ' + grupoE[1].toString();
  
  // B,C
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\')';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\')';
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\')';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\')';
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\'';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\')';
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\')';
  
  // B,D
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  // B,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.idtag = ' + grupoE[1].toString();
  
  // C,D
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tiporepeticao = \'Fixa\' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tiporepeticao = \'Parcelada\' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'NOT l.tiporepeticao = \'Fixa\' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'NOT l.tiporepeticao = \'Parcelada\' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  // C,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tiporepeticao = \'Fixa\' AND l.idcartao = 0 AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tiporepeticao = \'Parcelada\' AND l.idcartao = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'NOT l.tiporepeticao = \'Fixa\' AND l.idcartao = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'NOT l.tiporepeticao = \'Parcelada\' AND l.idcartao = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcartao = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcartao = 0 AND l.idtag = ' + grupoE[1].toString();
  
  // D,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  // A,B,C
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB;
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB;
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB;
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB;
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB;
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB;
  ///
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1';
  ///
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0';
  ///////////
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB;
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB;
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1';
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0';
  
  // A,B,D
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  // A,B,E
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 0 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  // A,C,D
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();

  // A,C,E
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();

  // A,D,E
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {    
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  // B,C,D
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString();
  
  // B,C,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 6 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idtag = ' + grupoE[1].toString();
  
  // B,D,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  // C,D,E
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tiporepeticao = \'Fixa\' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tiporepeticao = \'Parcelada\' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] >0) {
    return queryEscolhida = 'NOT l.tiporepeticao = \'Fixa\' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'NOT l.tiporepeticao = \'Parcelada\' AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcartao = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  // A,B,C,D
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  ///////////
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] == 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString();

  //// A,B,D,E
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 0 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  //// A,C,D,E
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta > 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta > 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 0 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] >= 0) {
    return queryEscolhida = 'l.idconta > 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();

  } else {
    return queryEscolhida = ' ';
  }
}

String queryFiltroContinuacaoParte1(lista) {
  String queryEscolhida;

  List grupoA = lista[0];
  String grupoB = lista[1];
  String gB;
  int rdt;

  if(grupoB != ' ') {
    String letra = grupoB[0];

    if(letra == 'D') {
      gB = '\'Despesa\'';
    } else if(letra == 'R') {
      gB = '\'Receita\'';
    } else if(letra == 'T') {
      gB = '\'Transferência\'';
    }
    rdt = receitaDespesaTransf(grupoB);

  } else {
    rdt = 0;
  }
  
  String grupoC = lista[2];
  List grupoD = lista[3];
  List grupoE = lista[4];

  int typeLaunch = tipoLancamento(grupoC);


  //A,B,C,E
  if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  ///////////
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 1 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 2 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 3 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 4 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] == 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idtag = ' + grupoE[1].toString();
  }
}

String queryFiltroContinuacaoParte2(lista) {
  String queryEscolhida;

  List grupoA = lista[0];
  String grupoB = lista[1];
  String gB;
  int rdt;

  if(grupoB != ' ') {
    String letra = grupoB[0];

    if(letra == 'D') {
      gB = '\'Despesa\'';
    } else if(letra == 'R') {
      gB = '\'Receita\'';
    } else if(letra == 'T') {
      gB = '\'Transferência\'';
    }
    rdt = receitaDespesaTransf(grupoB);

  } else {
    rdt = 0;
  }
  
  String grupoC = lista[2];
  List grupoD = lista[3];
  List grupoE = lista[4];

  int typeLaunch = tipoLancamento(grupoC);


  // B,C,D,E
  if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
      return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
    
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 1 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 2 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Fixa\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND NOT l.tiporepeticao = \'Parcelada\' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();

  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == ' ' && grupoA[1] == 0 && rdt == 3 && typeLaunch == 6 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcartao = 0 AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  // A,B,C,D,E
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] != 'Todas as contas' && grupoA[1] != 0 && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta = ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  ///////////
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 1 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 2 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 1 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  ///
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 1 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 2 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 3 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Fixa\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 4 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND NOT l.tiporepeticao = \'Parcelada\' AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao NOT IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else if(grupoA[0] == 'Todas as contas' && rdt == 3 && typeLaunch == 5 && grupoD[1] > 0 && grupoE[1] > 0) {
    return queryEscolhida = 'l.idconta > ' + grupoA[1].toString() + ' AND l.tiporepeticao IN ( \'Fixa\', \'Parcelada\') AND l.tipo = ' + gB + ' AND l.pago = 0 AND l.idcategoria = ' + grupoD[1].toString() + ' AND l.idtag = ' + grupoE[1].toString();
  
  } else {
    return queryEscolhida = ' ';
  }
}