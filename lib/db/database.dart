import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class DatabaseClient {
  Database _db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");

    _db = await openDatabase(dbPath, version: 1, onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute("""
            CREATE TABLE categoria (
              id INTEGER PRIMARY KEY,
              categoria TEXT NOT NULL UNIQUE,
              idcategoriapai INTEGER NOT NULL,
              ativada INTEGER NOT NULL
            )"""); //se nao for uma subcategoria a coluna idcategoriapai terao valor 0

    await db.execute("""
            CREATE TABLE tag (
              id INTEGER PRIMARY KEY, 
              tag TEXT NOT NULL UNIQUE,
              ativada INTEGER NOT NULL
            )""");

    await db.execute("""
            CREATE TABLE conta (
              id INTEGER PRIMARY KEY, 
              conta TEXT NOT NULL UNIQUE,
              saldoinicial REAL NOT NULL,
              ativada INTEGER NOT NULL
            )""");

    await db.execute("""
            CREATE TABLE cartao (
              id INTEGER PRIMARY KEY, 
              cartao TEXT NOT NULL UNIQUE,
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
              descricao TEXT NOT NULL,
              fixoparcelado TEXT,
              tiporepeticao TEXT,
              quantidaderepeticao INTEGER

              FOREIGN KEY (idcategoria) REFERENCES categoria (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
              FOREIGN KEY (idtag) REFERENCES tag (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
              FOREIGN KEY (idconta) REFERENCES conta (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
              FOREIGN KEY (idcontadestino) REFERENCES conta (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
              FOREIGN KEY (idcartao) REFERENCES cartao (id) 
                ON DELETE NO ACTION ON UPDATE NO ACTION
            )""");

 
    Future close() async => db.close();
  }
}

class Categoria {

  //Future openDB() async {
  //  Directory path = await getApplicationDocumentsDirectory();
  //  String dbPath = join(path.path, "database.db");
  //  Database db = await openDatabase(dbPath);
  //}

  Categoria();
  Database db;

  int id;
  String categoria;
  int idcategoriapai;
  int ativada;

  String categoriaTable = "categoria";

  static final columns = ["id", "categoria", "idcategoriapai", "ativada"];

  Map toMap() {
    Map map = {
      "categoria": categoria,
      "idcategoriapai": idcategoriapai,
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
    categoriaTable.ativada = map["ativada"];

    return categoriaTable;
  }

  //Future<Categoria> insert(Categoria categoria) async {
  //  categoria.id = await db.insert(categoriaTable, categoria.toMap());
  //  return categoria;
  //}

  Future upsertCategoria(Categoria categoria) async {
    if (categoria.id == null) {
      categoria.id = await db.insert(categoriaTable, categoria.toMap());
    } else {
      await db.update(categoriaTable, categoria.toMap(),
        where: "id = ?", whereArgs: [categoria.id]);
    }
    return categoria;
  }

  Future getCategoria(int id) async {
    List results = await db.query(categoriaTable,
      columns: Categoria.columns, where: "id = ?", whereArgs: [id]);
    Categoria categoria = Categoria.fromMap(results[0]);
    return categoria;
  }

  //Future<int> delete(int id) async {
  //  return await db.delete(categoriaTable, where: "id = ?", whereArgs: [id]);
  //} //sera para a tabela lancamento
}

class Tag {
  Tag();

  int id;
  String tag;
  int ativada;

  static final columns = ["id", "tag", "ativada"];

  Map toMap() {
    Map map = {
      "tag": tag,
      "ativada": ativada
    };

    if (id != null) { map["id"] = id; }

    return map;
  }

  static fromMap(Map map) {
    Tag tagTable = new Tag();
    tagTable.id = map["id"];
    tagTable.tag = map["tag"];
    tagTable.ativada = map["ativada"];

    return tagTable;
  }
}

class Conta {
  Conta();

  int id;
  String conta;
  double saldoinicial;
  int ativada;

  static final columns = ["id", "categoria", "saldoinicial", "ativada"];

  Map toMap() {
    Map map = {
      "conta": conta,
      "saldoinicial": saldoinicial,
      "ativada": ativada
    };

    if (id != null) { map["id"] = id; }

    return map;
  }

  static fromMap(Map map) {
    Conta contaTable = new Conta();
    contaTable.id = map["id"];
    contaTable.conta = map["conta"];
    contaTable.saldoinicial = map["saldoinicial"];
    contaTable.ativada = map["ativada"];

    return contaTable;
  }
}

class Cartao {
  Cartao();

  int id;
  String cartao;
  double limite;
  String vencimento;
  String fechamento;
  int contapagamento;
  int ativada;

  static final columns = ["id", "cartao", "limite", "vencimento", "fechamento",
                            "contapagamento", "atvada"];

  Map toMap() {
    Map map = {
      "cartao": cartao,
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
    cartaoTable.limite = map["limite"];
    cartaoTable.vencimento = map["vencimento"];
    cartaoTable.fechamento = map["fechamento"];
    cartaoTable.contapagamento = map["contapagamento"];
    cartaoTable.ativada = map["ativada"];

    return cartaoTable;
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
  double valor;
  String data;
  String descricao;
  String fixoparcelado;
  String tiporepeticao;
  int quantidaderepeticao;

  static final columns = ["id", "tipo", "idcategoria", "idtag", "idconta", "idcontadestino", "idcartao",
                          "valor", "data", "descricao", "fixoparcelado", "tiporepeticao",
                          "quantidaderepeticao"];

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
      "descricao" : descricao,
      "fixoparcelado" : fixoparcelado,
      "tiporepeticao" : tiporepeticao,
      "quantidaderepeticao" : quantidaderepeticao
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
    lancamentoTable.descricao = map["descricao"];
    lancamentoTable.fixoparcelado = map["fixoparcelado"];
    lancamentoTable.tiporepeticao = map["tiporepeticao"];
    lancamentoTable.quantidaderepeticao = map["quantidaderepeticao"];

    return lancamentoTable;
  }
}


//https://steemit.com/programming/@tstieff/using-sqflite-in-your-flutter-applicaiton-effectively
//https://github.com/tekartik/sqflite
//https://github.com/tekartik/sqflite/blob/master/doc/opening_asset_db.md
//https://pub.dartlang.org/packages/sqflite


