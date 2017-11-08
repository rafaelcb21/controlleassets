import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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
              categoria TEXT NOT NULL,
              idcategoriapai INTEGER NOT NULL,
              cor INTEGER NOT NULL,
              ativada INTEGER NOT NULL
            )"""); //se nao for uma subcategoria a coluna idcategoriapai terao valor 0

    await db.execute("""
            CREATE TABLE tag (
              id INTEGER PRIMARY KEY, 
              tag TEXT NOT NULL,
              ativada INTEGER NOT NULL
            )""");

    await db.execute("""
            CREATE TABLE conta (
              id INTEGER PRIMARY KEY, 
              conta TEXT NOT NULL,
              saldoinicial REAL NOT NULL,
              ativada INTEGER NOT NULL
            )""");

    await db.execute("""
            CREATE TABLE cartao (
              id INTEGER PRIMARY KEY, 
              cartao TEXT NOT NULL,
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
              quantidaderepeticao INTEGER,

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

  static final columns = ["id", "categoria", "idcategoriapai", "cor","ativada"];

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

    List results = await db.query(categoriaTable,
      columns: Categoria.columns, where: "categoria = ?", whereArgs: [name]);
    
    Categoria categoria = Categoria.fromMap(results[0]);

    await db.close();     
    return categoria;

  }

  Future getCategoria(int id) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List results = await db.query(categoriaTable,
      columns: Categoria.columns, where: "id = ?", whereArgs: [id]);
    Categoria categoria = Categoria.fromMap(results[0]);

    await db.close();

    return categoria;
  }

  Future getAllCategoria() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    List<Map> listaPais = await db.query(categoriaTable, columns: Categoria.columns,
      where: "idcategoriapai = 0", orderBy: "categoria ASC");    
    List listaTotal = [];
    List<Map> listaFilhos;
    
    for(var i in listaPais) {
      var id = i["id"];
      listaFilhos = await db.rawQuery("SELECT * FROM categoria WHERE ? = idcategoriapai ORDER BY categoria ASC", [id]);
      listaTotal.add([i,listaFilhos]);
    }

    await db.close();

    return listaTotal; 
  }

  Future getOnlyCategoriaPai() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);

    var count = await db.rawQuery("SELECT COUNT(*) FROM categoria WHERE idcategoriapai = 0");
    List<Map> list = await db.query(categoriaTable, columns: Categoria.columns,
      where: "idcategoriapai = 0", orderBy: "categoria ASC");

    await db.close();
    
    return [count, list];    
  }

  Future countCategoria(String name) async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    Database db = await openDatabase(dbPath);
    var count = await db.rawQuery("SELECT COUNT(*) FROM categoria WHERE categoria = ?", [name]);

    if(count[0]["COUNT(*)"] > 0){
      return true;
    }
    await db.close();

    return false;
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


