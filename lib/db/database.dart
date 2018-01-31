import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:queries/collections.dart';

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

    await db.execute("""
            CREATE TABLE lancamentofixo (
              id INTEGER PRIMARY KEY, 
              hashlancamento TEXT NOT NULL,
              periodorepeticao TEXT NOT NULL,
              data TEXT NOT NULL
            )""");

 
    Future close() async => db.close();
  }
}

class LancamentoFixo {
  LancamentoFixo();
  Database db;

  int id;
  String hashlancamento;
  String periodorepeticao;
  String data;

  String lancamentoFixoTable = "lancamentofixo";

  static final columns = ["id", "hashlancamento", "periodorepeticao", "data"];

  Map toMap() {
    Map map = {
      "hashlancamento": hashlancamento,
      "periodorepeticao": periodorepeticao,
      "data": data
    };

    if (id != null) { map["id"] = id; }

    return map;
  }

  static fromMap(Map map) {
    LancamentoFixo lancamentoFixoTable = new LancamentoFixo();
    lancamentoFixoTable.id = map["id"];
    lancamentoFixoTable.hashlancamento = map["hashlancamento"];
    lancamentoFixoTable.periodorepeticao = map["periodorepeticao"];
    lancamentoFixoTable.data = map["data"];

    return lancamentoFixoTable;
  }

  Future insertLancamentoFixo(LancamentoFixo lancamentofixo) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    await db.insert(lancamentoFixoTable, lancamentofixo.toMap());

    await db.close();

    return lancamentofixo;
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

  //Future getTag(int id) async {
  //  Directory path = await getApplicationDocumentsDirectory();
  //  String dbPath = join(path.path, "database.db");
  //  Database db = await openDatabase(dbPath);

  //  List results = await db.query('tag',
  //    columns: Tag.columns, where: "id = ?", whereArgs: [id]);
  //  Tag tag = Tag.fromMap(results[0]);

  //  await db.close();
  //  return tag.tag; 
  //}

  Future getTag(int id) async {
      Directory path = await getApplicationDocumentsDirectory();
      String dbPath = join(path.path, "database.db");
      Database db = await openDatabase(dbPath);

      List lista = await db.rawQuery("SELECT * FROM tag WHERE id = ?", [id]);

      await db.close();

      return lista[0]['tag'];
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

  List fixoList = ['Mensal', 'Bimestral', 'Trimestral', 'Semestral', 'Anual'];

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

  int mesEscolhidoAbreviado(month) {
    switch(month) {
      case "Jan": return 1; break;
      case "Fev": return 2; break;
      case "Mar": return 3; break;
      case "Abr": return 4; break;
      case "Mai": return 5; break;
      case "Jun": return 6; break;
      case "Jul": return 7; break;
      case "Ago": return 8; break;
      case "Set": return 9; break;
      case "Out": return 10; break;
      case "Nov": return 11; break;
      case "Dez": return 12; break;
    }
  }

  String mesEscolhidoNome(month) {
    switch(month) {
      case 1: return "Janeiro"; break;
      case 2: return "Fevereiro"; break;
      case 3: return "Março"; break;
      case 4: return "Abril"; break;
      case 5: return "Maio"; break;
      case 6: return "Junho"; break;
      case 7: return "Julho"; break;
      case 8: return "Agosto"; break;
      case 9: return "Setembro"; break;
      case 10:return  "Outubro"; break;
      case 11:return  "Novembro"; break;
      case 12:return  "Dezembro"; break;
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

  List nextPeriod(String date, bool next, String periodo) {

    if(periodo == 'hoje') {
      List listaMesAno = date.split(" "); //[23, Dez, 2017]
      String nomeMes = listaMesAno[1];
      int dia = int.parse(listaMesAno[0]);
      int ano = int.parse(listaMesAno[2]);
      int mes = mesEscolhidoAbreviado(nomeMes);
      DateTime data = new DateTime(ano, mes, dia);
      String dataString = new DateFormat("yyyy-MM-dd").format(data);
      DateTime nextDate;

      next ? 
        nextDate = DateTime.parse(dataString).add(new Duration(days: 1))
      :
        nextDate = DateTime.parse(dataString).subtract(new Duration(days: 1));

      String hojeMesDescrito = new DateFormat.yMMMM("pt_BR").format(nextDate).toString(); //janeiro de 2018
      
      return [hojeMesDescrito, nextDate];
    }

    if(periodo == 'semana') {
      List listaMesAno = date.split(" "); // ['17', 'Dez', 'à', '23', 'Dez'] 01 Jan de 2018 à 07 Jan de 2018
      String nomeMes = listaMesAno[6];
      int dia = int.parse(listaMesAno[5]);
      int ano = int.parse(listaMesAno[8]);
      int mes = mesEscolhidoAbreviado(nomeMes);
      DateTime data = new DateTime(ano, mes, dia);
      String dataString = new DateFormat("yyyy-MM-dd").format(data);
      DateTime nextDate;

      next ? 
        nextDate = DateTime.parse(dataString).add(new Duration(days: 1)) 
      :
        nextDate = DateTime.parse(dataString).subtract(new Duration(days: 7));     

      String anoMesDia = new DateFormat.yMMMd("pt_BR").format(nextDate); // 23 de dez de 2017
      List yMMMd = anoMesDia.split(' ');

      String anoMesDiaApresentacao = yMMMd[0] + ' ' + yMMMd[2][0].toUpperCase() + yMMMd[2].substring(1) + ' ' + yMMMd[4]; // 01 Dez à 07 Jan

      return [anoMesDiaApresentacao, nextDate];
    }

    if(periodo == 'mes') {
      List listaMesAno = date.split(" "); // [dezembro, de, 2017]
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

      String anoMesDia = new DateFormat.yMMMd("pt_BR").format(nextDate); // 23 de dez de 2017
      List yMMMd = anoMesDia.split(' ');
      String anoMesDiaApresentacao = yMMMd[0] + ' ' + yMMMd[2][0].toUpperCase() + yMMMd[2].substring(1) + ' ' + yMMMd[4]; // 23 Dez 2017

      return [anoMesDiaApresentacao, nextDate];
    }

    if(periodo == 'periodo') {
      DateTime nextDateInicio;
      DateTime nextDateFim;
      DateTime resultadoDataInicio;
      DateTime resultadoDataFim;
      String newNextDateInicioString;
      String newNextDateFimString;
      //List mesesNaoPossuemDia31 = [2, 4, 6, 7, 9, 11];

      List listaMesAno = date.split(" "); // ['17', 'Dez', 'à', '23', 'Dez'] 01 Jan de 2018 à 07 Jan de 2018
      String nomeMesInicio = listaMesAno[1];
      int diaInicio = int.parse(listaMesAno[0]);
      int anoInicio = int.parse(listaMesAno[3]);
      int mesInicio = mesEscolhidoAbreviado(nomeMesInicio);
      DateTime dataInicio = new DateTime(anoInicio, mesInicio, diaInicio);
      String dataStringInicio = new DateFormat("yyyy-MM-dd").format(dataInicio);

      String nomeMesFim = listaMesAno[6];
      int diaFim = int.parse(listaMesAno[5]);
      int anoFim = int.parse(listaMesAno[8]);
      int mesFim = mesEscolhidoAbreviado(nomeMesFim);
      DateTime dataFim = new DateTime(anoFim, mesFim, diaFim);
      String dataStringFim = new DateFormat("yyyy-MM-dd").format(dataFim);
      int diferencaDias = dataFim.difference(dataInicio).inDays;

      //verificar se escolheu um periodo fechado ou não
      //periodo Fechado
      if(dataFim.add(new Duration(hours: 25)).day == diaInicio) {        

        //avancar data right
        if(next) {
          nextDateInicio = DateTime.parse(dataStringFim).add(new Duration(hours: 25)); //DateTime
          newNextDateInicioString = new DateFormat("yyyy-MM-dd").format(nextDateInicio); //String Resultado data Inicio

          //diferença entre datas
          nextDateFim = DateTime.parse(newNextDateInicioString).add(new Duration(days: diferencaDias));
          
          String nextDateFimString = new DateFormat("yyyy-MM-dd").format(nextDateFim);
          newNextDateFimString = nextDateFimString.substring(0, 8) + dataStringFim.substring(8,10); // 2017-12-20 Resultado data Fim
        
        //recuar data left
        } else {
          nextDateFim = DateTime.parse(dataStringInicio).subtract(new Duration(days: 1));
          newNextDateFimString = new DateFormat("yyyy-MM-dd").format(nextDateFim); // Resultado data Fim

          nextDateInicio = DateTime.parse(newNextDateFimString).subtract(new Duration(days: diferencaDias));

          String nextDateInicioString = new DateFormat("yyyy-MM-dd").format(nextDateInicio);
          newNextDateInicioString = nextDateInicioString.substring(0, 8) + dataStringInicio.substring(8,10); //String Resultado data Inicio
        }

      //periodo Continuo
      } else {
        //avancar data right
        if(next) {
          nextDateInicio = DateTime.parse(dataStringFim).add(new Duration(hours: 25)); //DateTime
          newNextDateInicioString = new DateFormat("yyyy-MM-dd").format(nextDateInicio); //String Resultado data Inicio
          
          //diferença entre datas
          nextDateFim = DateTime.parse(newNextDateInicioString).add(new Duration(days: diferencaDias));
          
          newNextDateFimString = new DateFormat("yyyy-MM-dd").format(nextDateFim);
          
        //recuar data left
        } else {
          nextDateFim = DateTime.parse(dataStringInicio).subtract(new Duration(days: 1));
          newNextDateFimString = new DateFormat("yyyy-MM-dd").format(nextDateFim); // Resultado data Fim
          
          nextDateInicio = DateTime.parse(newNextDateFimString).subtract(new Duration(days: diferencaDias));

          newNextDateInicioString = new DateFormat("yyyy-MM-dd").format(nextDateInicio);
          
        }
      }     

      resultadoDataInicio = new DateTime(
        int.parse(newNextDateInicioString.substring(0, 4)),
        int.parse(newNextDateInicioString.substring(5, 7)),
        int.parse(newNextDateInicioString.substring(8, 10))
      );

      resultadoDataFim = new DateTime(
        int.parse(newNextDateFimString.substring(0, 4)),
        int.parse(newNextDateFimString.substring(5, 7)),
        int.parse(newNextDateFimString.substring(8, 10))
      );

      return [resultadoDataInicio, resultadoDataFim];
    }
    
  }

  Future getLancamentoHoje(DateTime hoje) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List listaDeFaturas = [];
    List listaPorDataHoje = [];
    List dateMap = [];
    String diaLabelInicio = "";

    //String dataHoje = new DateFormat.yMd().format(hoje); // 23/12/2017
    String dataFormatada = new DateFormat.MMMMd("pt_BR").format(hoje).toString(); // 23 de dezembro

    //String dataHoje1 = new DateFormat.yM().format(hoje); // 12/2017

    String data = new DateFormat("yyyy-MM-dd").format(hoje); // 2017-12-23

    String dia = hoje.day.toString();

    var anoMesDia = new DateFormat.yMMMd("pt_BR").format(hoje); // 23 de dez de 2017

    List yMMMd = anoMesDia.split(' ');

    yMMMd[0].length == 1 ? diaLabelInicio = '0' + yMMMd[0] : diaLabelInicio = yMMMd[0];
    
    String anoMesDiaApresentacao = diaLabelInicio + ' ' + yMMMd[2][0].toUpperCase() + yMMMd[2].substring(1) + ' ' + yMMMd[4]; // 23 Dez 2017

    var hojeMesDescrito = new DateFormat.yMMMM("pt_BR").format(hoje).toString(); // dezembro de 2017

    var fatura = hojeMesDescrito[0].toUpperCase() + hojeMesDescrito.substring(1); // Dezembro de 2017

    List listaIdCartao = await db.rawQuery("SELECT id, vencimento FROM cartao WHERE vencimento = ?", [dia]); //todos os ids de cartao

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

    List lista = await db.rawQuery('''
      SELECT  l.id, l.data, l.descricao, l.tipo, c.categoria, 
              l.valor, l.pago, l.hash 
                FROM lancamento AS l
        LEFT JOIN categoria AS c ON l.idcategoria = c.id
        LEFT JOIN tag ON l.idtag = tag.id
        LEFT JOIN conta ON l.idconta = conta.id
        LEFT JOIN cartao ON l.idcartao = cartao.id
          WHERE l.data = ? AND l.idcartao = 0
    ''', [data]);    
      
    if(lista.length > 0) {
      listaPorDataHoje.add([hoje, dataFormatada, 'semCartao', lista]);
    }

    for(var lista in listaPorDataHoje) {
      DateTime dateKey = lista[0];
      String dateNome = lista[1];
      String tipoLancamento = lista[2];
      List lancamentos = lista[3];
      
      for(var itemLancamento in lancamentos) {
        dateMap.add([
          dateKey,
          itemLancamento['descricao'], dateNome, tipoLancamento, itemLancamento['categoria'],
          itemLancamento['pago'], itemLancamento['hash'], itemLancamento['valor'],
          itemLancamento['id'], itemLancamento['data'], itemLancamento['tipo']
        ]);
      }
    }

    for(var lista in listaDeFaturas) {

      DateTime dateKey = lista[0];
      int pago = lista[4];
      List idsFatura = lista[5];
      
      String tipoLancamento = lista[2];
      double somaValor = lista[3]['SUM(valor)'];
      String faturaLancamento = lista[3]['fatura'];
      String vencimentoLancamento = lista[3]['vencimento'];
      String cartaoLancamento = lista[3]['cartao'];
      
      dateMap.add([
        dateKey,
        faturaLancamento, dataFormatada, tipoLancamento, cartaoLancamento, somaValor, vencimentoLancamento, pago, idsFatura
      ]);
    }

    List listaUnica = [];

    if(dateMap.length > 0) {
      listaUnica.add(dateMap);
    }

    for(List dia in listaUnica) {
      dia.sort((a, b) => a[1].compareTo(b[1]));
    }

    await db.close();

    return [listaUnica, [[hoje], anoMesDiaApresentacao]];

  }

Future getLancamentoSemana(DateTime diaDeReferencia) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    DateTime inicioDaSemana;
    DateTime fimDaSemana;
    DateTime proximaData;
    List listaDataSemana = [];
    List listaIdCartao = [];
    List listaFaturaIdCartao = [];
    String diaLabelInicio = "";
    String diaLabelFim = "";

    var listaPorData = [];
    var listaDeFaturas = [];

    if(diaDeReferencia.weekday == 1) {
      inicioDaSemana = diaDeReferencia;
      fimDaSemana = diaDeReferencia.add(new Duration(days: 6));
    } else if(diaDeReferencia.weekday == 2) {
      inicioDaSemana = diaDeReferencia.subtract(new Duration(days: 1));
      fimDaSemana = diaDeReferencia.add(new Duration(days: 5));
    } else if(diaDeReferencia.weekday == 3) {
      inicioDaSemana = diaDeReferencia.subtract(new Duration(days: 2));
      fimDaSemana = diaDeReferencia.add(new Duration(days: 4));
    } else if(diaDeReferencia.weekday == 4) {
      inicioDaSemana = diaDeReferencia.subtract(new Duration(days: 3));
      fimDaSemana = diaDeReferencia.add(new Duration(days: 3));
    } else if(diaDeReferencia.weekday == 5) {
      inicioDaSemana = diaDeReferencia.subtract(new Duration(days: 4));
      fimDaSemana = diaDeReferencia.add(new Duration(days: 2));
    } else if(diaDeReferencia.weekday == 6) {
      inicioDaSemana = diaDeReferencia.subtract(new Duration(days: 5));
      fimDaSemana = diaDeReferencia.add(new Duration(days: 1));
    } else if(diaDeReferencia.weekday == 7) {
      inicioDaSemana = diaDeReferencia.subtract(new Duration(days: 6));
      fimDaSemana = diaDeReferencia;
    }
    
    proximaData = inicioDaSemana;
    while(proximaData.compareTo(fimDaSemana) != 0) {
      listaDataSemana.add(
        new DateFormat("yyyy-MM-dd").format(proximaData)
      );
      proximaData = proximaData.add(new Duration(days: 1));
    }

    listaDataSemana.add(
        new DateFormat("yyyy-MM-dd").format(fimDaSemana)
      );

    var anoMesDiaInicio = new DateFormat.yMMMd("pt_BR").format(inicioDaSemana); // 23 de dezembro de 2017
    List yMMMdInicio = anoMesDiaInicio.split(' ');


    yMMMdInicio[0].length == 1 ? diaLabelInicio = '0' + yMMMdInicio[0] : diaLabelInicio = yMMMdInicio[0];
    String diaMesInicio = diaLabelInicio + ' ' + yMMMdInicio[2][0].toUpperCase() + yMMMdInicio[2].substring(1); // 23 Dez

    var anoMesDiaFim = new DateFormat.yMMMd("pt_BR").format(fimDaSemana); // 23 de dezembro de 2017
    List yMMMdFim = anoMesDiaFim.split(' ');

    yMMMdFim[0].length == 1 ? diaLabelFim = '0' + yMMMdFim[0] : diaLabelFim = yMMMdFim[0];
    
    String diaMesFim = diaLabelFim + ' ' + yMMMdFim[2][0].toUpperCase() + yMMMdFim[2].substring(1); // 29 Dez

    String label = diaMesInicio + " de " +  yMMMdInicio[4] + " à " + diaMesFim + " de " +  yMMMdFim[4]; // 23 Dez de 2017 à 29 Dez de 2018

    for(var i in listaDataSemana) {
      String dia = int.parse(i.substring(8, 10)).toString();
      String mes = mesEscolhidoNome(int.parse(i.substring(5, 7))); //Janeiro
      String ano = i.substring(0, 4);
      String fatura = mes + " de " + ano; //Janeiro de 2017

      List listaIdCartaoww = await db.rawQuery("SELECT id, vencimento FROM cartao");
      
      listaIdCartao = await db.rawQuery("SELECT id, vencimento FROM cartao WHERE vencimento = ?", [dia]); //todos os ids de cartao de um determinado dia
      listaFaturaIdCartao.add([fatura, listaIdCartao]);
    }

    for(List i in listaFaturaIdCartao) {

      if(i[1].length > 0) {
        List somaFaturaCartao = await db.rawQuery(
          '''SELECT c.vencimento, l.fatura, c.cartao, SUM(valor), SUM(pago)
                FROM lancamento AS l
                  LEFT JOIN cartao AS c ON l.idcartao = c.id
                WHERE l.idcartao = ? AND l.fatura = ?
          ''', [ i[1][0]['id'], i[0] ]);
        
        List idsLancamentosFatura = await db.rawQuery(
          'SELECT l.id FROM lancamento AS l WHERE l.idcartao = ? AND l.fatura = ?', [ i[1][0]['id'], i[0] ]);

        String hojeMesDescrito = i[0][0].toLowerCase() + i[0].substring(1);

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
    }

    for(var data in listaDataSemana){
      List lista = await db.rawQuery('''
        SELECT  l.id, l.data, l.descricao, l.tipo, c.categoria, 
                l.valor, l.pago, l.hash 
                  FROM lancamento AS l
          LEFT JOIN categoria AS c ON l.idcategoria = c.id
          LEFT JOIN tag ON l.idtag = tag.id
          LEFT JOIN conta ON l.idconta = conta.id
          LEFT JOIN cartao ON l.idcartao = cartao.id
            WHERE l.data = ? AND l.idcartao = 0
      ''', [data]);
      
      List dataAnoMesDia = data.split("-");
      DateTime dataDateTime = new DateTime(
        int.parse(dataAnoMesDia[0]), int.parse(dataAnoMesDia[1]), int.parse(dataAnoMesDia[2])
      );

      var dataFormatada = new DateFormat.MMMMd("pt_BR").format(dataDateTime).toString();
      
      if(lista.length > 0) {
        listaPorData.add([dataDateTime, dataFormatada, 'semCartao', lista]);
      }        
      
    }

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
    
    for(List dia in listaUnica) {
      dia.sort((a, b) => a[1].compareTo(b[1]));
    }

    await db.close();

    return [listaUnica, [[diaDeReferencia], label]]; //label: 23 Dez de 2017 à 29 Dez de 2018
  }

  Future getLancamentoMes(DateTime diaSearch) async {
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

    //fruits.sort((a, b) => getPrice(a).compareTo(getPrice(b)));
    for(List dia in listaUnica) {
      dia.sort((a, b) => a[1].compareTo(b[1]));
    }

    await db.close();
    return [listaUnica, [[diaSearch], hojeMesDescrito]];
  }

  Future consultarDatas(Lancamento lancamento, String dataInicial) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    if(dataInicial != lancamento.data) {
      List dataSelecionada = await db.rawQuery('SELECT data FROM lancamento WHERE hash = ? AND data = ?', [lancamento.hash, lancamento.data]);
      await db.close();

      if(dataSelecionada.length > 0) {
        return false;
      }
    }
    
    await db.close();
    return true;
  }

  Future upsertLancamento(List<Lancamento> list) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    //if(id != null && id > 0) {
    //  await db.rawDelete("DELETE FROM lancamento WHERE id = ?", [id]);
    //}

    //list[0].id = id;
    for(var lancamento in list) {
      if (lancamento.id == null) {
        lancamento.id = await db.insert("lancamento", lancamento.toMap());
      } else {
        await db.update("lancamento", lancamento.toMap(),
          where: "id = ?", whereArgs: [lancamento.id]);
      }
    }
    await db.close();

    return true;
  }

  List listaDosMeses(quantidaderepeticao, data, periodorepeticao) {
    List meses = [];

    for(var i = 0; i < quantidaderepeticao; i++) {
      if(meses.length == 0) {
        int monthToList = int.parse(data.substring(5,7));
        meses.add(monthToList);
      } else {
        if(periodorepeticao == 'Meses') {
          if(meses[i-1] == 12) {
            meses.add(1);
          } else {
            meses.add(meses[i-1] + 1);
          }
        } else if(periodorepeticao == 'Bimestres') {
          if(meses[i-1] == 12) {
            meses.add(2);
          } else if(meses[i-1] == 11) {
            meses.add(1);
          } else {
            meses.add(meses[i-1] + 2);
          }
        } else if(periodorepeticao == 'Trimestres') {
          if(meses[i-1] == 12) {
            meses.add(3);
          } else if(meses[i-1] == 11) {
            meses.add(2);
          } else if(meses[i-1] == 10) {
            meses.add(1);
          } else {
            meses.add(meses[i-1] + 3);
          }
        } else if(periodorepeticao == 'Semestres') {
          if(meses[i-1] == 12) {
            meses.add(6);
          } else if(meses[i-1] == 11) {
            meses.add(5);
          } else if(meses[i-1] == 10) {
            meses.add(4);
          } else if(meses[i-1] == 9) {
            meses.add(3);
          } else if(meses[i-1] == 8) {
            meses.add(2);
          } else if(meses[i-1] == 7) {
            meses.add(1);
          } else {
            meses.add(meses[i-1] + 6);
          }
        }
      }
    }

    return meses;
  }

  List proximoMesFunction(periodo, mes, ano) {
    if(periodo == 'Mensal') {
      if(mes == 12) {
        return [1, ano+1];
      } else {
        return [mes + 1, ano];
      } 
    } else if(periodo == 'Bimestral') {
      if(mes == 11) {
        return [1, ano+1];
      } if(mes == 12) {
        return [2, ano+1];
      } else {
        return [mes + 2, ano];
      } 
    } else if(periodo == 'Trimestral') {
      if(mes == 10) {
        return [1, ano+1];
      } if(mes == 11) {
        return [2, ano+1];
      } if(mes == 12) {
        return [3, ano+1];
      } else {
        return [mes + 3, ano];
      } 
    } else if(periodo == 'Semestral') {
      if(mes == 7) {
        return [1, ano+1];
      } if(mes == 8) {
        return [2, ano+1];
      } if(mes == 9) {
        return [3, ano+1];
      } if(mes == 10) {
        return [4, ano+1];
      } if(mes == 11) {
        return [5, ano+1];
      } if(mes == 12) {
        return [6, ano+1];
      } else {
        return [mes + 6, ano];
      } 
    } else if(periodo == 'Anual') {
      return [mes, ano+1];
    }
    return [];
  }

  //atualizarLancamento trata de lancamentos repetidos e divididos
  Future atualizarLancamento(Lancamento lancamento, String dataInicial, bool todos) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    List<Lancamento> lancamentoList = [];

    Map periodos = {
      'Dias': 1,
      'Semanas': 7,
      'Quinzenas': 15,
      'Meses': 30, 
      'Bimestres': 60,
      'Trimestres': 90,
      'Semestres': 180,
      'Anos': 365
    };

    if (!todos) {
      
      await db.rawUpdate(
      '''UPDATE lancamento SET
          data = ?,
          idcategoria = ?,
          idtag = ?,
          idconta = ?,
          idcontadestino = ?,
          idcartao = ?,
          valor = ?,
          descricao = ?,
          fatura = ?,
          hash = ?,
          quantidaderepeticao = ?,
          periodorepeticao = ?,
          tiporepeticao = ?
        WHERE id = ?
      ''', [
        lancamento.data, lancamento.idcategoria, lancamento.idtag, lancamento.idconta,
        lancamento.idcontadestino, lancamento.idcartao, lancamento.valor,
        lancamento.descricao, lancamento.fatura, lancamento.hash, lancamento.quantidaderepeticao,
        lancamento.periodorepeticao, lancamento.tiporepeticao, lancamento.id
      ]);

      await db.close();
      return true;

    } else if(
        todos &&
        lancamento.periodorepeticao == 'Dias' ||
        lancamento.periodorepeticao == 'Semanas' ||
        lancamento.periodorepeticao == 'Quinzenas' 
      ) {
      List datas = [];
      //[{data: 2018-01-15}, {data: 2018-01-16}, {data: 2018-01-17}
      List datasParaSelecionar = await db.rawQuery('SELECT data FROM lancamento WHERE hash = ?', [lancamento.hash]);
      DateTime data = new DateFormat("yyyy-MM-dd").parse(dataInicial); //2018-01-17 00:00:00.000

      for(var dataString in datasParaSelecionar) {
        DateTime dataCompare = DateTime.parse(dataString['data']);
        if(dataCompare.isAfter(data) || dataCompare.compareTo(data) == 0) {
          String dataFormatada = new DateFormat("yyyy-MM-dd").format(dataCompare).toString();
          datas.add(dataFormatada); //selecionara as datas que serao atualizadas
        }
      }

      List descricaoStringList = lancamento.descricao.split(' ');
      List ultimoElementoDescricao = descricaoStringList.removeLast().split('/');
      String primeirosElementosDescricao = descricaoStringList.join(' ');
      int x = int.parse(ultimoElementoDescricao[0]);

      List ordemPagos = [];
      for(var data in datas) {
        List pagos = await db.rawQuery("SELECT pago FROM lancamento WHERE hash = ? AND data = ?", [lancamento.hash, data]);
        for(int i = 0; i < pagos.length; i++) {
          ordemPagos.add(pagos[i]['pago']);
        }
      }

      for(var data in datas) {
        await db.rawDelete("DELETE FROM lancamento WHERE hash = ? AND data = ?", [lancamento.hash, data]);
      }

      for(var i = 0; i < datas.length; i++) {
        Lancamento lancamentoEditado = new Lancamento();
        lancamentoEditado.tipo = lancamento.tipo;
        lancamentoEditado.fatura = lancamento.fatura;
        lancamentoEditado.idcategoria = lancamento.idcategoria;
        lancamentoEditado.idtag = lancamento.idtag;
        lancamentoEditado.idconta = lancamento.idconta;
        lancamentoEditado.idcontadestino = lancamento.idcontadestino;
        lancamentoEditado.idcartao = lancamento.idcartao;
        lancamentoEditado.valor = lancamento.valor;
        lancamentoEditado.descricao = primeirosElementosDescricao + ' ' + (x+i).toString() + '/' + lancamento.quantidaderepeticao.toString();
        lancamentoEditado.tiporepeticao = lancamento.tiporepeticao;
        lancamentoEditado.quantidaderepeticao = lancamento.quantidaderepeticao;
        lancamentoEditado.periodorepeticao = lancamento.periodorepeticao;
        lancamentoEditado.datafatura = lancamento.datafatura;
        lancamentoEditado.pago = ordemPagos[i];
        lancamentoEditado.hash = lancamento.hash;
        lancamentoEditado.data = lancamento.data;

        int days = i * periodos[lancamentoEditado.periodorepeticao];
        lancamentoEditado.data = DateTime.parse(lancamentoEditado.data).add(new Duration(days: days)).toString().substring(0,10);
        lancamentoList.add(lancamentoEditado);
      }

      for(var lancamento in lancamentoList) {
        await db.insert("lancamento", lancamento.toMap());
      }

      await db.close();
      return true;      

    } else if(todos && lancamento.periodorepeticao == 'Anos') {

      List datas = [];
      List datasParaSelecionar = await db.rawQuery('SELECT data FROM lancamento WHERE hash = ?', [lancamento.hash]);
      DateTime data = new DateFormat("yyyy-MM-dd").parse(dataInicial); //2018-01-17 00:00:00.000

      for(var dataString in datasParaSelecionar) {
        DateTime dataCompare = DateTime.parse(dataString['data']);
        if(dataCompare.isAfter(data) || dataCompare.compareTo(data) == 0) {
          String dataFormatada = new DateFormat("yyyy-MM-dd").format(dataCompare).toString();
          datas.add(dataFormatada); //selecionara as datas que serao atualizadas
        }
      }

      List ordemPagos = [];
      for(var data in datas) {
        List pagos = await db.rawQuery("SELECT pago FROM lancamento WHERE hash = ? AND data = ?", [lancamento.hash, data]);
        ordemPagos.add(pagos[0]['pago']);
      }

      for(var data in datas) {
        await db.rawDelete("DELETE FROM lancamento WHERE hash = ? AND data = ?", [lancamento.hash, data]);
      }

      List descricaoStringList = lancamento.descricao.split(' ');
      List ultimoElementoDescricao = descricaoStringList.removeLast().split('/');
      String primeirosElementosDescricao = descricaoStringList.join(' ');
      int x = int.parse(ultimoElementoDescricao[0]);

      for(var i = 0; i < datas.length; i++) {
        Lancamento lancamentoEditado = new Lancamento();
        lancamentoEditado.tipo = lancamento.tipo;
        lancamentoEditado.fatura = lancamento.fatura;
        lancamentoEditado.idcategoria = lancamento.idcategoria;
        lancamentoEditado.idtag = lancamento.idtag;
        lancamentoEditado.idconta = lancamento.idconta;
        lancamentoEditado.idcontadestino = lancamento.idcontadestino;
        lancamentoEditado.idcartao = lancamento.idcartao;
        lancamentoEditado.valor = lancamento.valor;
        lancamentoEditado.descricao = primeirosElementosDescricao + ' ' + (x+i).toString() + '/' + lancamento.quantidaderepeticao.toString();
        lancamentoEditado.tiporepeticao = lancamento.tiporepeticao;
        lancamentoEditado.quantidaderepeticao = lancamento.quantidaderepeticao;
        lancamentoEditado.periodorepeticao = lancamento.periodorepeticao;
        lancamentoEditado.datafatura = lancamento.datafatura;
        lancamentoEditado.pago = ordemPagos[i];
        lancamentoEditado.hash = lancamento.hash;
        lancamentoEditado.data = lancamento.data;

        int days = i * periodos[lancamentoEditado.periodorepeticao];
        int _dia = int.parse(lancamentoEditado.data.substring(8,10));
        int _mes = int.parse(lancamentoEditado.data.substring(5,7));
        int _ano = DateTime.parse(lancamentoEditado.data).add(new Duration(days: days)).year;
        
        if(_dia == 29 && _mes == 2) {
          lancamentoEditado.data = new DateTime(_ano, _mes + 1, 0).toString().substring(0,10);
        } else {
          lancamentoEditado.data = new DateTime(_ano, _mes, _dia).toString().substring(0,10);
        }
        lancamentoList.add(lancamentoEditado);
      }

      for(var lancamento in lancamentoList) {
        await db.insert("lancamento", lancamento.toMap());
      }
      
      await db.close();
      return true;

    } else {
      List datas = [];

      List mesesLista = listaDosMeses(
        lancamento.quantidaderepeticao,
        lancamento.data,
        lancamento.periodorepeticao
      );

      List datasParaSelecionar = await db.rawQuery('SELECT data FROM lancamento WHERE hash = ?', [lancamento.hash]);
      DateTime data = new DateFormat("yyyy-MM-dd").parse(dataInicial); //2018-01-17 00:00:00.000

      for(var dataString in datasParaSelecionar) {
        DateTime dataCompare = DateTime.parse(dataString['data']);
        if(dataCompare.isAfter(data) || dataCompare.compareTo(data) == 0) {
          String dataFormatada = new DateFormat("yyyy-MM-dd").format(dataCompare).toString();
          datas.add(dataFormatada); //selecionara as datas que serao atualizadas
        }
      }

      List ordemPagos = [];
      for(var data in datas) {
        List pagos = await db.rawQuery("SELECT pago FROM lancamento WHERE hash = ? AND data = ?", [lancamento.hash, data]);
        ordemPagos.add(pagos[0]['pago']);
      }

      for(var data in datas) {
        await db.rawDelete("DELETE FROM lancamento WHERE hash = ? AND data = ?", [lancamento.hash, data]);
      }

      List descricaoStringList = lancamento.descricao.split(' ');
      List ultimoElementoDescricao = descricaoStringList.removeLast().split('/');
      String primeirosElementosDescricao = descricaoStringList.join(' ');
      int x = int.parse(ultimoElementoDescricao[0]);

      for(var i = 0; i < datas.length; i++) {
        Lancamento lancamentoEditado = new Lancamento();
        lancamentoEditado.tipo = lancamento.tipo;
        lancamentoEditado.fatura = lancamento.fatura;
        lancamentoEditado.idcategoria = lancamento.idcategoria;
        lancamentoEditado.idtag = lancamento.idtag;
        lancamentoEditado.idconta = lancamento.idconta;
        lancamentoEditado.idcontadestino = lancamento.idcontadestino;
        lancamentoEditado.idcartao = lancamento.idcartao;
        lancamentoEditado.valor = lancamento.valor;
        lancamentoEditado.descricao = primeirosElementosDescricao + ' ' + (x+i).toString() + '/' + lancamento.quantidaderepeticao.toString();
        lancamentoEditado.tiporepeticao = lancamento.tiporepeticao;
        lancamentoEditado.quantidaderepeticao = lancamento.quantidaderepeticao;
        lancamentoEditado.periodorepeticao = lancamento.periodorepeticao;
        lancamentoEditado.datafatura = lancamento.datafatura;
        lancamentoEditado.pago = ordemPagos[i];
        lancamentoEditado.hash = lancamento.hash;
        lancamentoEditado.data = lancamento.data;

        int days = i * periodos[lancamentoEditado.periodorepeticao];
        int _dia = int.parse(lancamentoEditado.data.substring(8,10));
        int _ano = DateTime.parse(lancamentoEditado.data).add(new Duration(days: days)).year;
        
        if((_dia > 28 && mesesLista[i] == 2) || _dia == 31) {
          lancamentoEditado.data = new DateTime(_ano, mesesLista[i] + 1, 0).toString().substring(0,10);
        } else {
          lancamentoEditado.data = new DateTime(_ano, mesesLista[i], _dia).toString().substring(0,10);                                                           
        }
        lancamentoList.add(lancamentoEditado);
      }

      //for(var lancamento in lancamentoList) {        
      //  print(lancamento.idcategoria);
      //  print(lancamento.idconta);
      //  print(lancamento.fatura); //null
      //  print(lancamento.hash); //yyyyyyy
      //  print(lancamento.valor);
      //  print(lancamento.data); //2018-01-22
      //  print(lancamento.idcontadestino);
      //  print(lancamento.idtag);
      //  print(lancamento.pago);
      //  print(lancamento.descricao);
      //  print(lancamento.id);
      //  print(lancamento.quantidaderepeticao); //2
      //  print(lancamento.idcartao);
      //  print(lancamento.tipo);
      //  print(lancamento.datafatura);
      //  print(lancamento.periodorepeticao); //Meses
      //  print(lancamento.tiporepeticao); //Parcelada
      //  print('============');
      //}

      for(var lancamento in lancamentoList) {
        await db.insert("lancamento", lancamento.toMap());
      }

      await db.close();
      return true;
    }    
  }

  Future getLancamentoPeriodo(DateTime from, DateTime to) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    //DateTime proximaData;
    List listaDatasPeriodo = [];
    List listaIdCartao = [];
    List listaFaturaIdCartao = [];
    String diaLabelInicio = "";
    String diaLabelFim = "";
    String label = "";

    var listaPorData = [];
    var listaDeFaturas = [];
    
    //proximaData = from;
    int diaFrom = from.day;
    int mesFrom = from.month;
    int anoFrom = from.year;
    int semanaFrom = from.weekday;
    int diaTo = to.day;
    int mesTo = to.month;
    int anoTo = to.year;
    int semanaTo = to.weekday;
    String periodo = "periodo";

    int ultimoDiaTo = new DateTime(anoTo, mesTo + 1, 0).day;
    
    int diferencaDias = to.difference(from).inDays;

    listaDatasPeriodo.add(
      new DateFormat("yyyy-MM-dd").format(from)
    );

    for(int i = 1; i <= diferencaDias; i++) {
      
      if(from.add(new Duration(days: i)).hour == 23) {        
        DateTime provisorio = from.add(new Duration(days: i));
        listaDatasPeriodo.add(
          new DateFormat("yyyy-MM-dd").format(
            provisorio.add(new Duration(hours: 1))
          )
        );      
      } else {
        listaDatasPeriodo.add(
          new DateFormat("yyyy-MM-dd").format(
            from.add(new Duration(days: i))
          )
        );
      }
    }

    var anoMesDiaInicio = new DateFormat.yMMMd("pt_BR").format(from); // 23 de dezembro de 2017
    List yMMMdInicio = anoMesDiaInicio.split(' ');


    yMMMdInicio[0].length == 1 ? diaLabelInicio = '0' + yMMMdInicio[0] : diaLabelInicio = yMMMdInicio[0];
    String diaMesInicio = diaLabelInicio + ' ' + yMMMdInicio[2][0].toUpperCase() + yMMMdInicio[2].substring(1); // 23 Dez

    var anoMesDiaFim = new DateFormat.yMMMd("pt_BR").format(to); // 23 de dezembro de 2017
    List yMMMdFim = anoMesDiaFim.split(' ');

    yMMMdFim[0].length == 1 ? diaLabelFim = '0' + yMMMdFim[0] : diaLabelFim = yMMMdFim[0];
    
    String diaMesFim = diaLabelFim + ' ' + yMMMdFim[2][0].toUpperCase() + yMMMdFim[2].substring(1); // 29 Dez

    label = diaMesInicio + " de " +  yMMMdInicio[4] + " à " + diaMesFim + " de " +  yMMMdFim[4]; // 23 Dez de 2017 à 29 Dez de 2018

    for(var i in listaDatasPeriodo) {
      String dia = int.parse(i.substring(8, 10)).toString();
      String mes = mesEscolhidoNome(int.parse(i.substring(5, 7))); //Janeiro
      String ano = i.substring(0, 4);
      String fatura = mes + " de " + ano; //Janeiro de 2017

      List listaIdCartao = await db.rawQuery("SELECT id, vencimento FROM cartao");
      
      listaIdCartao = await db.rawQuery("SELECT id, vencimento FROM cartao WHERE vencimento = ?", [dia]); //todos os ids de cartao de um determinado dia
      listaFaturaIdCartao.add([fatura, listaIdCartao]);
    }

    for(List i in listaFaturaIdCartao) {

      if(i[1].length > 0) {
        List somaFaturaCartao = await db.rawQuery(
          '''SELECT c.vencimento, l.fatura, c.cartao, SUM(valor), SUM(pago)
                FROM lancamento AS l
                  LEFT JOIN cartao AS c ON l.idcartao = c.id
                WHERE l.idcartao = ? AND l.fatura = ?
          ''', [ i[1][0]['id'], i[0] ]);
        
        List idsLancamentosFatura = await db.rawQuery(
          'SELECT l.id FROM lancamento AS l WHERE l.idcartao = ? AND l.fatura = ?', [ i[1][0]['id'], i[0] ]);

        String hojeMesDescrito = i[0][0].toLowerCase() + i[0].substring(1);

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
    }

    for(var data in listaDatasPeriodo){
      List lista = await db.rawQuery('''
        SELECT  l.id, l.data, l.descricao, l.tipo, c.categoria, 
                l.valor, l.pago, l.hash 
                  FROM lancamento AS l
          LEFT JOIN categoria AS c ON l.idcategoria = c.id
          LEFT JOIN tag ON l.idtag = tag.id
          LEFT JOIN conta ON l.idconta = conta.id
          LEFT JOIN cartao ON l.idcartao = cartao.id
            WHERE l.data = ? AND l.idcartao = 0
      ''', [data]);
      
      List dataAnoMesDia = data.split("-");
      DateTime dataDateTime = new DateTime(
        int.parse(dataAnoMesDia[0]), int.parse(dataAnoMesDia[1]), int.parse(dataAnoMesDia[2])
      );

      var dataFormatada = new DateFormat.MMMMd("pt_BR").format(dataDateTime).toString();
      
      if(lista.length > 0) {
        listaPorData.add([dataDateTime, dataFormatada, 'semCartao', lista]);
      }        
      
    }

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

    for(List dia in listaUnica) {
      dia.sort((a, b) => a[1].compareTo(b[1]));
    }

    await db.close();

    if(mesFrom == mesTo && anoFrom == anoTo && ultimoDiaTo == diaTo && diaFrom == 1) {
      label = new DateFormat.yMMMM("pt_BR").format(new DateTime(anoTo, mesTo, diaTo)).toString(); // dezembro de 2017
      periodo = "mes";
    } else if(mesFrom == mesTo && anoFrom == anoTo && semanaFrom == 1 && semanaTo == 7) {
      periodo = "semana";
    } else if(mesFrom == mesTo && anoFrom == anoTo && diaFrom == diaTo) {
      periodo = "hoje";
      label = label.substring(0, 7) + label.substring(10, 14);
    }

    return [listaUnica, [[from, to], label, periodo]]; //label: 23 Dez de 2017 à 29 Dez de 2018
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

  Future lancamentoDeFixo(String periodo, String periodoFiltro) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    String mesString = '';
    List listaDatas = [];

    //[hoje, 30 Jan 2018]
    //[semana, 29 Jan de 2018 à 04 Fev de 2018]
    //[mes, janeiro de 2018]
    //[periodo, 30 Jan de 2018 à 27 Fev de 2018]
    List listaPeriodoFiltro = periodoFiltro.split(' ');
    List datasDeRederencia = [];

    if(periodo == 'hoje') {
      int ano = int.parse(listaPeriodoFiltro[2]);
      int mes = mesEscolhidoAbreviado(listaPeriodoFiltro[1]);
      int dia = int.parse(listaPeriodoFiltro[0]);
      String data = new DateFormat("yyyy-MM-dd").format(new DateTime(ano, mes, dia)).toString();
      datasDeRederencia.add(data);
      print(datasDeRederencia);
    }

    if(periodo == 'semana') {
      int anoFim = int.parse(listaPeriodoFiltro[8]);
      int mesFim = mesEscolhidoAbreviado(listaPeriodoFiltro[6]);
      int diaFim = int.parse(listaPeriodoFiltro[5]);
      DateTime ultimoDia = new DateTime(anoFim, mesFim, diaFim);
      
      // Seleciona as datas da semana   
      for(int i in [6 ,5 ,4 ,3 ,2 ,1, 0]) {
        String data = new DateFormat("yyyy-MM-dd").format(
          ultimoDia.subtract(new Duration(hours: i*24))
        ).toString();
        datasDeRederencia.add(data);
      }
      print(datasDeRederencia);
    }
    
    if(periodo == 'mes') {
      List dias = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11',
        '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24',
        '25', '26', '27', '28', '29', '30', '31'
      ];

      int mes = mesEscolhido(listaPeriodoFiltro[0]);
      if(mes < 10) {
        mesString = '0' + mes.toString();
      } else {
        mesString =  mes.toString();
      }
            
      int ano = int.parse(listaPeriodoFiltro[2]);
      int ultimoDia = new DateTime(ano, mes + 1, 0).day;

      // Seleciona as datas do mes     
      for(String dia in dias) {
        String data = ano.toString()+'-'+mesString+'-'+dia;
        datasDeRederencia.add(data);
        if(dia == ultimoDia.toString()) {
          break;
        }
      }
      print(datasDeRederencia);
    }

    if(periodo == 'periodo') {
      int anoInicio = int.parse(listaPeriodoFiltro[3]);
      int mesInicio = mesEscolhidoAbreviado(listaPeriodoFiltro[1]);
      int diaInicio = int.parse(listaPeriodoFiltro[0]);
      DateTime primeiroDia = new DateTime(anoInicio, mesInicio, diaInicio);

      int anoFim = int.parse(listaPeriodoFiltro[8]);
      int mesFim = mesEscolhidoAbreviado(listaPeriodoFiltro[6]);
      int diaFim = int.parse(listaPeriodoFiltro[5]);
      DateTime ultimoDia = new DateTime(anoFim, mesFim, diaFim);

      int diferencaDeDias = ultimoDia.difference(primeiroDia).inDays;
      
      var listNumeros = new List<int>.generate(diferencaDeDias, (i) => i);

      // Seleciona as datas entre o periodo  
      for(int i in listNumeros.reversed.toList()) {
        String data = new DateFormat("yyyy-MM-dd").format(
          ultimoDia.subtract(new Duration(hours: i*24))
        ).toString();
        datasDeRederencia.add(data);
      }
      print(datasDeRederencia);
    }

    // Seleciona todos os hash da tabela lancamentofixo
    List allHash = await db.rawQuery('SELECT hashlancamento FROM lancamentofixo');
    
    // Remove os hash duplicados
    List allHashDistinct = new Collection(allHash).distinct().toList();

    for(var i in allHashDistinct) {
      String hash = i['hashlancamento'];
      List datas = await db.rawQuery('SELECT data, periodorepeticao FROM lancamentofixo WHERE hashlancamento = ?', [hash]);

      // Pegar a primeira e a ultima data
      for(var j in datas) {
        listaDatas.add(DateTime.parse(j['data']));
      }
      listaDatas.sort();
      DateTime primeiroItemData = listaDatas[0];
      String primeiroItemDataString = new DateFormat("yyyy-MM-dd").format(primeiroItemData).toString().substring(0,10);
      DateTime ultimoItemData = listaDatas.last;

      List item = await db.rawQuery('SELECT * FROM lancamento WHERE hash = ? AND data = ?', [hash, primeiroItemDataString]);

      // Se a ultima data for maior que a data final referencia => não evolui
      DateTime primeiraDataReferencia = DateTime.parse(datasDeRederencia[0]);
      DateTime ultimaDataReferencia = DateTime.parse(datasDeRederencia.last);

      if(datas[0]['periodorepeticao'] == 'Mensal') {

        while(!ultimoItemData.isAfter(ultimaDataReferencia)) {
          String dataStringUltimoItem = new DateFormat("yyyy-MM-dd").format(ultimoItemData).toString();
          //int days = i * this.periodos[lancamentoDB.periodorepeticao];
          int _dia = int.parse(dataStringUltimoItem.substring(8,10));
          int _mes = int.parse(dataStringUltimoItem.substring(5,7));
          int _ano = DateTime.parse(dataStringUltimoItem).add(new Duration(days: 30)).year;
          
          if((_dia > 28 && _mes == 1) || _dia == 31) {
            dataStringUltimoItem = new DateTime(_ano, 3, 0).toString().substring(0,10);
          } else {
            dataStringUltimoItem = new DateTime(_ano, _mes + 1, _dia).toString().substring(0,10);                                                           
          }
          ultimoItemData = DateTime.parse(dataStringUltimoItem);

          if(ultimoItemData.isAfter(ultimaDataReferencia)) {break;}

          // Salvar no banco nas tabelas lancamento e lancamentofixo
          Lancamento lancamento = new Lancamento();
          lancamento.tipo = item[0]['tipo'];
          lancamento.fatura = item[0]['fatura'];
          lancamento.idcategoria = item[0]['idcategoria'];
          lancamento.idtag = item[0]['idtag'];
          lancamento.idconta = item[0]['idconta'];
          lancamento.idcontadestino = item[0]['idcontadestino'];
          lancamento.idcartao = item[0]['idcartao'];
          lancamento.valor = item[0]['valor'];
          lancamento.descricao = item[0]['quantidaderepeticao'];
          lancamento.tiporepeticao = item[0]['tiporepeticao'];
          lancamento.quantidaderepeticao = item[0]['quantidaderepeticao'];
          lancamento.periodorepeticao = item[0]['periodorepeticao'];
          lancamento.datafatura = item[0]['datafatura'];
          lancamento.pago = item[0]['pago'];
          lancamento.hash = item[0]['hash'];
          lancamento.data = dataStringUltimoItem;

          LancamentoFixo lancamentoFixoTable = new LancamentoFixo();
          lancamentoFixoTable.hashlancamento = lancamento.hash;
          lancamentoFixoTable.periodorepeticao = lancamento.periodorepeticao;
          lancamentoFixoTable.data = lancamento.data;
          lancamentoFixoTable.insertLancamentoFixo(lancamentoFixoTable);
          
        }
      }
      


      


      
      //se a utima for menor que a data inicial => evolui ate chegar na ultima data final antes de ultrapassar
      //se a ultima data estiver no meio => evolui ate chegar na ultima data final antes de ultrapassar
      // oque evoluir vai para a tabela lancamento
    }
    




    await db.close();

    return true;
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
    
    if(id != null) {
      List lancamentoById = await db.rawQuery('SELECT * FROM lancamento WHERE id = ?', [id]);
      String hash = lancamentoById[0]['hash'];

      await db.rawDelete("DELETE FROM lancamento WHERE id = ?", [id]).then(
        (result) async {
          List lancamentosByHash = await db.rawQuery('SELECT * FROM lancamento WHERE hash = ?', [hash]);

          for(int i = 0; i < lancamentosByHash.length; i++) {
            id = lancamentosByHash[i]['id'];
            List descricaoList = lancamentosByHash[i]['descricao'].split(' ');
            var ultimoElemento = descricaoList.removeLast();
            String contador = (i + 1).toString() + '/' + lancamentosByHash.length.toString();
            String descricao = descricaoList.join(' ');
            String descricaoCompleta = descricao + ' ' + contador;

            await db.rawUpdate("UPDATE lancamento SET descricao = ? WHERE id = ?", [descricaoCompleta, id]);
          }
          await db.close();

          return true;
        }
      );
    }
  }

  Future deleteLancamentoNaoRepetidos(int id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    await db.rawDelete("DELETE FROM lancamento WHERE id = ?", [id]);
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
      await db.rawDelete("DELETE FROM lancamento WHERE id = ?", [u]);
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

  Future getLancamento(int id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

   List lancamento = await db.rawQuery("SELECT * FROM lancamento WHERE id = ?", [id]);    

    await db.close();

    return lancamento;
  }
}


//https://steemit.com/programming/@tstieff/using-sqflite-in-your-flutter-applicaiton-effectively
//https://github.com/tekartik/sqflite
//https://github.com/tekartik/sqflite/blob/master/doc/opening_asset_db.md
//https://pub.dartlang.org/packages/sqflite


