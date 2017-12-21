import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class DatabaseClient {
  Database _db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    _db = await openDatabase(dbPath, version: 1, onCreate: this._create);

    List listaConta = await _db.rawQuery("SELECT * FROM conta WHERE ativada = 1 ORDER BY conta ASC");
    List listaCartao = await _db.rawQuery("SELECT * FROM cartao WHERE ativada = 1 ORDER BY cartao ASC");
    
    var dict = { 'conta':[], 'cartao':[] };
    
    if(listaConta.length > 0) {
      dict['conta'] = listaConta; 
    }

    if(listaCartao.length > 0) {
      dict['cartao'] = listaCartao; 
    }

    return dict;    

  }

  Future _create(Database db, int version) async {
    await db.execute("""
            CREATE TABLE categoria (
              id INTEGER PRIMARY KEY,
              categoria TEXT NOT NULL,
              idcategoriapai INTEGER NOT NULL,
              cor INTEGER NOT NULL,
              ativada INTEGER NOT NULL
            )"""); //se nao for uma subcategoria a coluna idcategoriapai terao valor 0

    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Alimentação', 0, 39, 1)");
    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Educação', 0, 43, 1)");
    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Investimento', 0, 47, 1)");
    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Lazer', 0, 15, 1)");
    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Outros', 0, 3, 1)");
    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Salário', 0, 67, 1)");
    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Saúde', 0, 19, 1)");
    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Telefonia', 0, 65, 1)");
    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Transporte', 0, 4, 1)");
    await db.rawInsert("INSERT INTO categoria (categoria, idcategoriapai, cor, ativada) VALUES ('Vestuário', 0, 73, 1)");

    await db.execute("""
            CREATE TABLE tag (
              id INTEGER PRIMARY KEY, 
              tag TEXT NOT NULL,
              cor INTEGER NOT NULL,
              relacionada TEXT NOT NULL,
              ativada INTEGER NOT NULL
            )""");

    await db.rawInsert("INSERT INTO tag (tag, cor, relacionada, ativada) VALUES ('Renda Fixa', 39, 'receita', 1)");
    await db.rawInsert("INSERT INTO tag (tag, cor, relacionada, ativada) VALUES ('Renda Variável', 43, 'receita', 1)");
    await db.rawInsert("INSERT INTO tag (tag, cor, relacionada, ativada) VALUES ('Despesa Fixa', 47, 'despesa', 1)");
    await db.rawInsert("INSERT INTO tag (tag, cor, relacionada, ativada) VALUES ('Despesa Variável', 15, 'despesa', 1)");

    await db.execute("""
            CREATE TABLE conta (
              id INTEGER PRIMARY KEY, 
              conta TEXT NOT NULL,
              tipo TEXT NOT NULL,
              saldoinicial REAL NOT NULL,
              cor INTEGER NOT NULL,
              ativada INTEGER NOT NULL
            )""");

    await db.execute("""
            CREATE TABLE cartao (
              id INTEGER PRIMARY KEY, 
              cartao TEXT NOT NULL,
              cor INTEGER NOT NULL,
              limite REAL,
              vencimento TEXT NOT NULL,
              fechamento TEXT NOT NULL,
              contapagamento INTEGER NOT NULL,
              ativada INTEGER NOT NULL,
              FOREIGN KEY (contapagamento) REFERENCES conta (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
            )""");

    await db.execute("""
            CREATE TABLE lancamento (
              id INTEGER PRIMARY KEY, 
              tipo TEXT NOT NULL,
              idcategoria INTEGER NOT NULL,
              idtag INTEGER NOT NULL,
              idconta INTEGER,
              idcontadestino INTEGER,
              idcartao INTEGER,
              valor REAL NOT NULL,
              data TEXT NOT NULL,
              datafatura TEXT,
              descricao TEXT NOT NULL,
              tiporepeticao TEXT,
              periodorepeticao TEXT,
              quantidaderepeticao INTEGER,
              fatura TEXT,
              pago INTEGER NOT NULL,
              hash TEXT,

              FOREIGN KEY (idcategoria) REFERENCES categoria (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION,
              FOREIGN KEY (idtag) REFERENCES tag (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION,
              FOREIGN KEY (idconta) REFERENCES conta (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION,
              FOREIGN KEY (idcontadestino) REFERENCES conta (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION,
              FOREIGN KEY (idcartao) REFERENCES cartao (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
            )""");

 
    Future close() async => db.close();
  }
}

class Categoria {
  Categoria();
  Database db;

  //Future openDB() async {
  //  Directory path = await getApplicationDocumentsDirectory();
  //  String dbPath = join(path.path, "../../assets/database.db");
  //  Database db = await openDatabase(dbPath);
  //}  

  int id;
  String categoria;
  int idcategoriapai;
  int cor;
  int ativada;

  String categoriaTable = "categoria";

  static final columns = ["id", "categoria", "idcategoriapai", "cor", "ativada"];

  Map toMap() {
    Map map = {
      "categoria": categoria,
      "idcategoriapai": idcategoriapai,
      "cor": cor,
      "ativada": ativada
    };

    if (id != null) { map["id"] = id; }

    return map;
  }

  static fromMap(Map map) {
    Categoria categoriaTable = new Categoria();
    categoriaTable.id = map["id"];
    categoriaTable.categoria = map["categoria"];
    categoriaTable.idcategoriapai = map["idcategoria"];
    categoriaTable.cor = map["cor"];
    categoriaTable.ativada = map["ativada"];

    return categoriaTable;
  }

  //Future<Categoria> insert(Categoria categoria) async {
  //  categoria.id = await db.insert(categoriaTable, categoria.toMap());
  //  return categoria;
  //}

  Future upsertCategoria(Categoria categoria) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    if (categoria.id == null) {
      categoria.id = await db.insert(categoriaTable, categoria.toMap());
    } else {
      await db.update(categoriaTable, categoria.toMap(),
        where: "id = ?", whereArgs: [categoria.id]);
    }

    await db.close();

    return categoria;
  }

  Future getCategoriaByName(String name) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List results = await db.rawQuery("SELECT * FROM categoria WHERE categoria == ? AND ativada == 1", [name]);
    await db.close();   

    return results[0];
  }

  Future getCategoria(int id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List results = await db.query(categoriaTable,
      columns: Categoria.columns, where: "id = ?", whereArgs: [id]);
    Categoria categoria = Categoria.fromMap(results[0]);

    await db.close();

    return categoria.categoria;
  }

  Future getAllCategoria() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List<Map> listaPais = await db.rawQuery("SELECT * FROM categoria WHERE idcategoriapai == 0 AND ativada == 1 ORDER BY categoria ASC");
    
    //await db.query(categoriaTable, columns: Categoria.columns, where: "idcategoriapai = 0", orderBy: "categoria ASC");
      
    List listaTotal = [];
    List<Map> listaFilhos;
    
    for(var i in listaPais) {
      var id = i["id"];
      listaFilhos = await db.rawQuery("SELECT * FROM categoria WHERE ? = idcategoriapai AND ativada == 1 ORDER BY categoria ASC", [id]);
      listaTotal.add([i,listaFilhos]);
    }

    await db.close();

    return listaTotal; 
  }

  Future getOnlyCategoriaPai() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    var count = await db.rawQuery("SELECT COUNT(*) FROM categoria WHERE idcategoriapai = 0 AND ativada == 1");
    List<Map> list = await db.rawQuery("SELECT * FROM categoria WHERE idcategoriapai = 0 AND ativada == 1 ORDER BY categoria ASC");

    await db.close();
    
    return [count, list];    
  }

  Future getOnlyCategoriaPaiLess(id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    var count = await db.rawQuery("SELECT COUNT(*) FROM categoria WHERE idcategoriapai = 0 AND id != ? AND ativada == 1", [id]);

    List<Map> list = await db.rawQuery("SELECT * FROM categoria WHERE idcategoriapai = 0 AND id != ? AND ativada == 1 ORDER BY categoria ASC", [id]);

    await db.close();
    
    return [count, list];    
  }

  Future countCategoria(String name, bool editar) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    if(editar) { return false; }

    var count = await db.rawQuery("SELECT COUNT(*) FROM categoria WHERE categoria = ? AND ativada == 1", [name]);
    if(count[0]["COUNT(*)"] > 0){ return true; }
    
    await db.close();

    return false;
  }

  Future deleteCategoria(List list) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    List listaTotal = [];
    List<Map> listaFilhos;

    for(var x in list) {
      await db.rawUpdate("UPDATE categoria SET ativada = 0 WHERE id = ?", [x]);
    }

    List<Map> listaPais = await db.rawQuery("SELECT * FROM categoria WHERE idcategoriapai == 0 AND ativada == 1 ORDER BY categoria ASC");
    
    for(var i in listaPais) {
      var id = i["id"];
      listaFilhos = await db.rawQuery("SELECT * FROM categoria WHERE ? = idcategoriapai AND ativada == 1 ORDER BY categoria ASC", [id]);
      listaTotal.add([i,listaFilhos]);
    }

    await db.close();

    return listaTotal;
  }
  //Future<int> delete(int id) async {
    //db.delete(categoriaTable, where: "id = ?", whereArgs: list);
  //  return await db.delete(categoriaTable, where: "id = ?", whereArgs: [id]);
  //} //sera para a tabela lancamento
}

class Tag {
  Tag();
  Database db;

  int id;
  String tag;
  int cor;
  String relacionada;
  int ativada;

  static final columns = ["id", "tag", "cor", "relacionada", "ativada"];

  Map toMap() {
    Map map = {
      "tag": tag,
      "cor": cor,
      "relacionada": relacionada,
      "ativada": ativada
    };

    if (id != null) { map["id"] = id; }

    return map;
  }

  static fromMap(Map map) {
    Tag tagTable = new Tag();
    tagTable.id = map["id"];
    tagTable.tag = map["tag"];
    tagTable.cor = map["cor"];
    tagTable.relacionada = map["relacionada"];
    tagTable.ativada = map["ativada"];

    return tagTable;
  }

  Future getAllTag() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List lista = await db.rawQuery("SELECT * FROM tag WHERE ativada == 1 ORDER BY tag ASC");
    await db.close();
    return lista; 
  }

  Future getTagGroup(name) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    
    List lista = await db.rawQuery("SELECT * FROM tag WHERE ativada == 1 AND NOT relacionada = ? ORDER BY tag ASC", [name]);
    await db.close();
    return lista;
  }

  Future deleteTag(int id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    await db.rawUpdate("UPDATE tag SET ativada = 0 WHERE id = ?", [id]);
    List lista = await db.rawQuery("SELECT * FROM tag WHERE ativada == 1 ORDER BY tag ASC");
    await db.close();

    return lista;
  }

  Future upsertTag(Tag tag) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    if (tag.id == null) {
      tag.id = await db.insert("tag", tag.toMap());
    } else {
      await db.update("tag", tag.toMap(),
        where: "id = ?", whereArgs: [tag.id]);
    }

    await db.close();

    return tag;
  }
}

class Conta {
  Conta();

  int id;
  String conta;
  String tipo;
  double saldoinicial;
  int cor;
  int ativada;

  static final columns = ["id", "conta", "tipo", "saldoinicial", "cor", "ativada"];

  Map toMap() {
    Map map = {
      "conta": conta,
      "tipo": tipo,
      "saldoinicial": saldoinicial,
      "cor": cor,
      "ativada": ativada
    };

    if (id != null) { map["id"] = id; }

    return map;
  }

  static fromMap(Map map) {
    Conta contaTable = new Conta();
    contaTable.id = map["id"];
    contaTable.conta = map["conta"];
    contaTable.tipo = map["tipo"];
    contaTable.saldoinicial = map["saldoinicial"];
    contaTable.cor = map["cor"];
    contaTable.ativada = map["ativada"];

    return contaTable;
  }

  Future getAllConta() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List lista = await db.rawQuery("SELECT * FROM conta ORDER BY conta ASC");
    await db.close();

    return lista; 
  }

  Future getAllContaAtivas() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List lista = await db.rawQuery("SELECT * FROM conta WHERE ativada = 1 ORDER BY conta ASC");
    await db.close();

    return lista; 
  }

  Future getSaldoById(id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List listaReceitaById = await db.rawQuery("SELECT SUM(valor) FROM 'lancamento' WHERE idconta = ? AND pago = 1 AND tipo = 'Receita'", [id]);
    
    await db.close();

    return listaReceitaById; 
  }

  Future upsertConta(Conta conta) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    if (conta.id == null) {
      conta.id = await db.insert("conta", conta.toMap());
    } else {
      await db.update("conta", conta.toMap(),
        where: "id = ?", whereArgs: [conta.id]);
    }

    await db.close();

    return conta;
  }

    Future getConta(int id) async {
      Directory path = await getApplicationDocumentsDirectory();
      String dbPath = join(path.path, "database.db");
      Database db = await openDatabase(dbPath);
      List lista = await db.rawQuery("SELECT * FROM conta WHERE id = ? ORDER BY conta ASC", [id]);

      await db.close();

      return lista;
    }

    Future getContaByName(String name) async {
      Directory path = await getApplicationDocumentsDirectory();
      String dbPath = join(path.path, "database.db");
      Database db = await openDatabase(dbPath);
      List lista = await db.rawQuery("SELECT * FROM conta WHERE conta = ? ORDER BY conta ASC", [name]);

      await db.close();

      return lista;
    }
}

class Cartao {
  Cartao();

  int id;
  String cartao;
  int cor;
  double limite;
  String vencimento;
  String fechamento;
  int contapagamento;
  int ativada;

  static final columns = ["id", "cartao", "cor", "limite", "vencimento", "fechamento",
                            "contapagamento", "atvada"];

  Map toMap() {
    Map map = {
      "cartao": cartao,
      "cor": cor,
      "limite": limite,
      "vencimento": vencimento,
      "fechamento": fechamento,      
      "contapagamento": contapagamento,     
      "ativada": ativada
    };

    if (id != null) { map["id"] = id; }

    return map;
  }

  static fromMap(Map map) {
    Cartao cartaoTable = new Cartao();
    cartaoTable.id = map["id"];
    cartaoTable.cartao = map["cartao"];
    cartaoTable.cor = map["cor"];
    cartaoTable.limite = map["limite"];
    cartaoTable.vencimento = map["vencimento"];
    cartaoTable.fechamento = map["fechamento"];
    cartaoTable.contapagamento = map["contapagamento"];
    cartaoTable.ativada = map["ativada"];

    return cartaoTable;
  }

  Future getAllCartao() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    
    List lista = await db.rawQuery("SELECT * FROM cartao ORDER BY cartao ASC");

    await db.close();

    return lista; 
  }

  Future getAllCartaoAtivos() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    
    List lista = await db.rawQuery("SELECT * FROM cartao WHERE ativada = 1 ORDER BY cartao ASC");

    await db.close();

    return lista; 
  }

  Future upsertCartao(Cartao cartao) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    if (cartao.id == null) {
      cartao.id = await db.insert("cartao", cartao.toMap());
    } else {
      await db.update("cartao", cartao.toMap(),
        where: "id = ?", whereArgs: [cartao.id]);
    }

    await db.close();

    return cartao;
  }

  Future getCartaoByName(String name) async {
      Directory path = await getApplicationDocumentsDirectory();
      String dbPath = join(path.path, "database.db");
      Database db = await openDatabase(dbPath);
      List lista = await db.rawQuery("SELECT * FROM cartao WHERE cartao = ? ORDER BY cartao ASC", [name]);

      await db.close();

      return lista;
    }
}

class Lancamento {
  Lancamento();

  int id; 
  String tipo;
  int idcategoria;
  int idtag;
  int idconta;
  int idcontadestino;
  int idcartao;
  num valor;
  String data;
  String datafatura;
  String descricao;
  String tiporepeticao;
  String periodorepeticao;
  num quantidaderepeticao;
  String fatura;
  int pago;
  String hash;


  static final columns = ["id", "tipo", "idcategoria", "idtag", "idconta", "idcontadestino", "idcartao",
                          "valor", "data", "datafatura", "descricao", "tiporepeticao", "periodorepeticao", "quantidaderepeticao",
                          "fatura", "pago", "hash"];

  Map toMap() {
    Map map = {
      "tipo" : tipo,
      "idcategoria" : idcategoria,
      "idtag" : idtag,
      "idconta" : idconta,
      "idcontadestino" : idcontadestino,
      "idcartao" : idcartao,
      "valor" : valor,
      "data" : data,
      "datafatura": datafatura,
      "descricao" : descricao,
      "tiporepeticao" : tiporepeticao,
      "periodorepeticao" : periodorepeticao,
      "quantidaderepeticao" : quantidaderepeticao,
      "fatura": fatura,
      "pago": pago,
      "hash": hash
    };

    if (id != null) { map["id"] = id; }

    return map;
  }

  static fromMap(Map map) {
    Lancamento lancamentoTable = new Lancamento();
    lancamentoTable.id = map["id"];
    lancamentoTable.tipo = map["tipo"];
    lancamentoTable.idcategoria = map["idcategoria"];
    lancamentoTable.idtag = map["idtag"];
    lancamentoTable.idconta = map["idconta"];
    lancamentoTable.idcontadestino = map["idcontadestino"];
    lancamentoTable.idcartao = map["idcartao"];
    lancamentoTable.valor = map["valor"];
    lancamentoTable.data = map["data"];
    lancamentoTable.datafatura = map["datafatura"];
    lancamentoTable.descricao = map["descricao"];
    lancamentoTable.tiporepeticao = map["tiporepeticao"];
    lancamentoTable.periodorepeticao = map["periodorepeticao"];
    lancamentoTable.quantidaderepeticao = map["quantidaderepeticao"];
    lancamentoTable.fatura = map["fatura"];
    lancamentoTable.pago = map["pago"];
    lancamentoTable.hash = map["hash"];

    return lancamentoTable;
  }

  int mesEscolhido(month) {
    switch(month) {
      case "janeiro": return 1; break;
      case "fevereiro": return 2; break;
      case "março": return 3; break;
      case "abril": return 4; break;
      case "maio": return 5; break;
      case "junho": return 6; break;
      case "julho": return 7; break;
      case "agosto": return 8; break;
      case "setembro": return 9; break;
      case "outubro": return 10; break;
      case "novembro": return 11; break;
      case "dezembro": return 12; break;
    }
  }

  String stringDateInDateTimeString(String date, String vencimento) {
    List listaMesAno = date.split(" ");
    String nomeMes = listaMesAno[0];
    int ano = int.parse(listaMesAno[2]);
    int mes = mesEscolhido(nomeMes);
    int dia = int.parse(vencimento);

    DateTime data = new DateTime(ano, mes, dia);
    String dataString = new DateFormat("yyyy-MM-dd").format(data);

    return dataString;
  }

  List nextPeriod(String date, bool next) {
    List listaMesAno = date.split(" ");
    String nomeMes = listaMesAno[0];
    int ano = int.parse(listaMesAno[2]);
    int mes = mesEscolhido(nomeMes);
    DateTime data = new DateTime(ano, mes, 1);
    String dataString = new DateFormat("yyyy-MM-dd").format(data);
    DateTime nextDate;

    next ? 
      nextDate = DateTime.parse(dataString).add(new Duration(days: 31)) 
    :
      nextDate = DateTime.parse(dataString).subtract(new Duration(days: 5));
     

    String hojeMesDescrito = new DateFormat.yMMMM("pt_BR").format(nextDate).toString(); //janeiro de 2018    
    

    return [hojeMesDescrito, nextDate];
  }

  Future getLancamento(DateTime diaSearch) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    //List lista = await db.rawQuery("SELECT * FROM lancamento");

    var listaPorData = [];
    var listaDeFaturas = [];
    //var listaDataAndFatura = [];

    List listaData = await db.rawQuery("SELECT data FROM lancamento GROUP BY data");
    
    //var hoje = new DateTime.now();
    var hojeMes = new DateFormat.yM("pt_BR").format(diaSearch); // 12/2017
    var hojeMesDescrito = new DateFormat.yMMMM("pt_BR").format(diaSearch).toString(); // dezembro de 2017

    var fatura = hojeMesDescrito[0].toUpperCase() + hojeMesDescrito.substring(1); // Dezembro de 2017
    
    List listaIdCartao = await db.rawQuery("SELECT id, vencimento FROM cartao"); //todos os ids de cartao

    //var x = await db.rawQuery("SELECT * FROM lancamento");
    //for(var i in x){print(i);}

    for(var idCartao in listaIdCartao) {
      List somaFaturaCartao = await db.rawQuery(
        '''SELECT c.vencimento, l.fatura, c.cartao, SUM(valor), SUM(pago)
              FROM lancamento AS l
                LEFT JOIN cartao AS c ON l.idcartao = c.id
              WHERE l.idcartao = ? AND l.fatura = ?
        ''', [ idCartao['id'], fatura ]);
      
      List idsLancamentosFatura = await db.rawQuery(
        'SELECT l.id FROM lancamento AS l WHERE l.idcartao = ? AND l.fatura = ?', [ idCartao['id'], fatura ]);

      if(somaFaturaCartao[0]['vencimento'] != null) {
        String dataFatura = stringDateInDateTimeString(hojeMesDescrito, somaFaturaCartao[0]['vencimento']);
        DateTime dataFaturaDateTime = DateTime.parse(dataFatura);
        var pagoFatura = somaFaturaCartao[0]['SUM(pago)'];
        int resultadoPagamentoFatura;

        if(pagoFatura > 0) {
          resultadoPagamentoFatura = 1;
        } else {
          resultadoPagamentoFatura = 0;
        }

        if(somaFaturaCartao[0]['SUM(valor)'] != 0) { // se tiver valor na fatura
          listaDeFaturas.add([dataFaturaDateTime, dataFatura, 'comCartao', somaFaturaCartao[0], resultadoPagamentoFatura, idsLancamentosFatura]);
        }
      }      
    }

    for(var i in listaData){
      //List lista = await db.rawQuery("SELECT * FROM lancamento WHERE data = ?", [i['data']]);

      List lista = await db.rawQuery('''
        SELECT  l.id, l.data, l.descricao, l.tipo, c.categoria, 
                l.valor, l.pago, l.hash 
                  FROM lancamento AS l
          LEFT JOIN categoria AS c ON l.idcategoria = c.id
          LEFT JOIN tag ON l.idtag = tag.id
          LEFT JOIN conta ON l.idconta = conta.id
          LEFT JOIN cartao ON l.idcartao = cartao.id
            WHERE l.data = ? AND l.idcartao = 0
      ''', [i['data']]);
      
      var data = new DateFormat("yyyy-MM-dd").parse(i['data']);
      
      List dataAnoMesDia = i['data'].split("-");
      DateTime dataDateTime = new DateTime(
        int.parse(dataAnoMesDia[0]), int.parse(dataAnoMesDia[1]), int.parse(dataAnoMesDia[2])
      );


      var filtro = new DateFormat.yM("pt_BR").format(data);

      if(hojeMes == filtro) {
        var dataFormatada = new DateFormat.MMMMd("pt_BR").format(data).toString();
        
        if(lista.length > 0) {
          //listaPorData.add([dataFormatada, lista]);
          listaPorData.add([dataDateTime, dataFormatada, 'semCartao', lista]);
        }        
      }
    }

    //I/flutter (26604): ********************
    //I/flutter (26604): [[2017-12-10 00:00:00.000, 2017-12-10, comCartao, {SUM(valor): 310.98, fatura: Dezembro de 2017, vencimento: 10, cartao: Platinium}]]
    //I/flutter (26604): ********************
    //I/flutter (26604): +++++++++++++++++++++++
    //I/flutter (26604): [[2017-12-17 00:00:00.000, 17 de dezembro, semCartao, [{categoria: Investimento, pago: 0, descricao: Rrrrr, hash: null, valor: -85.0, id: 4, data: 2017-12-17, tipo: Despesa}, {categoria: Educação, pago: 0, descricao: Uuuuu, hash: null, valor: -112.54, id: 5, data: 2017-12-17, tipo: Despesa}]]]

    //Map<DateTime, List> dateMap = {};
    var dateMap = new LinkedHashMap();
    
    List allDate = [];

    for(var key in listaDeFaturas) {
      allDate.add(key[0]); //pega todas as datas
    }

    for(var key in listaPorData) {
      allDate.add(key[0]); //pega todas as datas
    }

    allDate.sort();

    for(var key in allDate) {
      dateMap.putIfAbsent(key, () => []); //insere todas as datas de forma ordenada no {}
    }

    //for(var key in listaDeFaturas) {
    //  dateMap.putIfAbsent(key[0], () => []); //pega todas as datas
    //}

    //for(var key in listaPorData) {
    //  dateMap.putIfAbsent(key[0], () => []); //pega todas as datas
    //}

    for(var lista in listaPorData) {
      DateTime dateKey = lista[0];
      String dateNome = lista[1];
      String tipoLancamento = lista[2];
      List lancamentos = lista[3];
      
      for(var itemLancamento in lancamentos) {
        dateMap[dateKey].add([
          dateKey,
          itemLancamento['descricao'], dateNome, tipoLancamento, itemLancamento['categoria'],
          itemLancamento['pago'], itemLancamento['hash'], itemLancamento['valor'],
          itemLancamento['id'], itemLancamento['data'], itemLancamento['tipo']
        ]);
      }
    }

    for(var lista in listaDeFaturas) {

      DateTime dateKey = lista[0];
      String dateString = lista[1];
      int pago = lista[4];
      List idsFatura = lista[5];

      var data = new DateFormat("yyyy-MM-dd").parse(dateString);
      var dataFormatada = new DateFormat.MMMMd("pt_BR").format(data).toString();
      
      String tipoLancamento = lista[2];
      double somaValor = lista[3]['SUM(valor)'];
      String faturaLancamento = lista[3]['fatura'];
      String vencimentoLancamento = lista[3]['vencimento'];
      String cartaoLancamento = lista[3]['cartao'];
      
      dateMap[dateKey].add([
        dateKey,
        faturaLancamento, dataFormatada, tipoLancamento, cartaoLancamento, somaValor, vencimentoLancamento, pago, idsFatura
      ]);
    }

    List listaUnica = [];

    dateMap.forEach((key, value) {
      listaUnica.add(value);
    });
    
    //listaUnica.add([hoje, hojeMesDescrito]);


    //listaDataAndFatura = new List.from(listaPorData)..addAll(listaDeFaturas);
    //listaDataAndFatura.sort();
    //listaDataAndFatura.add([hoje, hojeMesDescrito]);


    //listaUnica.add([hoje, hojeMesDescrito]);

    await db.close();
    return [listaUnica, [diaSearch, hojeMesDescrito]];
  }

  Future upsertLancamento(List<Lancamento> list) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    for(var lancamento in list) {
      if (lancamento.id == null) {
        lancamento.id = await db.insert("lancamento", lancamento.toMap());
      } else {
        await db.update("lancamento", lancamento.toMap(),
          where: "id = ?", whereArgs: [lancamento.id]);
      }
    }
    await db.close();

    return list;
  }

  Future updateLancamentoPago(int id, int pago) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List lista = [];
    if(pago == 0) {
      await db.rawQuery('UPDATE lancamento SET pago = 1 WHERE id = ?', [id]);
    } else if(pago == 1) {
      await db.rawQuery('UPDATE lancamento SET pago = 0 WHERE id = ?', [id]);
    }

    await db.close();

    return lista;
  }

  

  Future updateLancamentoPagoFatura(List ids, int pago) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List lista = [];
    for(var dict in ids) {
      if(pago == 0) {
        await db.rawQuery('UPDATE lancamento SET pago = 1 WHERE id = ?', [dict['id']]);
      } else if(pago == 1) {
        await db.rawQuery('UPDATE lancamento SET pago = 0 WHERE id = ?', [dict['id']]);
      }
    }

    await db.close();

    return lista;
  }


  Future deleteLancamento(int id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    await db.rawUpdate("DELETE FROM lancamento WHERE id = ?", [id]);

    await db.close();

    return true;
  }

  Future deleteLancamentoRepetidos(String date, String hash) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    DateTime dataCompare;
    DateTime data = new DateFormat("yyyy-MM-dd").parse(date);
    List listaId = [];

    List listaHash = await db.rawQuery("SELECT id, data FROM lancamento WHERE hash = ?", [hash]);
    
    for(var i in listaHash) {
      dataCompare = new DateFormat("yyyy-MM-dd").parse(i['data']);
      if(dataCompare.isAfter(data) || dataCompare == data) {
        listaId.add(i['id']);
      }
    }

    for(var u in listaId) {
      await db.rawUpdate("DELETE FROM lancamento WHERE id = ?", [u]);
    }

    await db.close();

    return true;
  }
  

  Future upsertLancamentoRepetirParcela(Lancamento lancamento) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    if (lancamento.id == null) {
      lancamento.id = await db.insert("lancamento", lancamento.toMap());
    } else {
      await db.update("lancamento", lancamento.toMap(),
        where: "id = ?", whereArgs: [lancamento.id]);
    }

    await db.close();

    return lancamento;
  }
}


//https://steemit.com/programming/@tstieff/using-sqflite-in-your-flutter-applicaiton-effectively
//https://github.com/tekartik/sqflite
//https://github.com/tekartik/sqflite/blob/master/doc/opening_asset_db.md
//https://pub.dartlang.org/packages/sqflite


