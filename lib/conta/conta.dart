import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../palette/palette.dart';
import '../db/database.dart';

class ContaPage extends StatefulWidget {
  @override
  ContaPageState createState() => new ContaPageState();
}

class ContaPageState extends State<ContaPage> {
  Color azulAppbar = new Color(0xFF26C6DA);
  Conta contaDB = new Conta();
  List<Widget> listaContas = [];
  List listaDB = [];
  Palette listaCores = new Palette();
  List cores = [];
  bool switchValue = true;

  @override
  void initState() {
    this.cores = listaCores.cores;
    contaDB.getAllConta().then(
      (list) {
        setState(() {
          this.listaDB = list;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> buildListaContas(list) {
      this.listaContas = [];
      for(var i in list) {
        var id = i['id'];
        var conta = i['conta'];
        var tipo = i['tipo'];
        var saldoinicial = i['saldoinicial'];
        var cor = this.cores[i['cor']];
        var numeroCor = i['cor'];
        var ativada = i['ativada'];

        this.listaContas.add(
          new ItemConta(
            id: id,
            conta: conta,
            tipo: tipo,
            saldoinicial: saldoinicial,
            cor: cor,
            numeroCor: numeroCor,
            ativada: ativada,
            onPressed: () async {
              await Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new NovaContaPage(false, new Conta());
                },
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  return new SlideTransition(
                    position: new Tween<Offset>(
                      begin:  const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                }
              ));
              contaDB.getAllConta().then(
                (list) {
                  setState(() {
                    this.listaDB = list;
                  });
                }
              );              
            },
          )
        );
      }
      return this.listaContas;
    }

    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Contas'),
        backgroundColor: azulAppbar,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.add),
            color: new Color(0xFFFFFFFF),
            onPressed: () async {
              await Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new NovaContaPage(false, new Conta());
                },
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  return new SlideTransition(
                    position: new Tween<Offset>(
                      begin:  const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                }
              ));
              contaDB.getAllConta().then(
                (list) {
                  setState(() {
                    this.listaDB = list;
                  });
                }
              );
            }
          )
        ],
      ),
      body: new ListView(
        padding: new EdgeInsets.only(top: 8.0, right: 0.0, left: 0.0),
        children: buildListaContas(this.listaDB)
      )
    );
  }
}

class ItemConta extends StatefulWidget {
   
  final int id;
  final String conta;
  final String tipo;
  final double saldoinicial;
  final int numeroCor;
  final Color cor;
  final int ativada;
  final VoidCallback onPressed;

  ItemConta({
    this.id,
    this.conta,
    this.tipo,
    this.saldoinicial,
    this.cor,
    this.numeroCor,
    this.ativada,
    this.onPressed,
  });

  @override
  ItemContaState createState() => new ItemContaState();
}

class ItemContaState extends State<ItemConta> {
  ItemContaState();
  bool switchValue;
  Conta contaDB = new Conta();

  @override
  void initState() {
    this.switchValue = widget.ativada == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            style: BorderStyle.solid,
            color: Colors.black26,
          )
        )
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Expanded(
            child: new InkWell(
              onTap: this.switchValue ? widget.onPressed  : () {},
              child: new Row(
                children: <Widget>[
                  new Container(
                    margin: new EdgeInsets.only(left: 16.0, right: 32.0),
                    child: new Icon(Icons.brightness_1, color: this.switchValue ? widget.cor : Colors.black26),
                  ),
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        widget.conta,                        
                        style: new TextStyle(
                          color: this.switchValue ? Colors.black87 : Colors.black26,
                          fontFamily: "Roboto",
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          textBaseline: TextBaseline.alphabetic                        
                        ),
                      ),
                      new Text(
                        widget.tipo,                        
                        style: new TextStyle(
                          color: this.switchValue ? Colors.black54 : Colors.black26,
                          fontFamily: "Roboto",
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          textBaseline: TextBaseline.alphabetic
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          new Switch(
            value: this.switchValue,
            onChanged: (bool value) {
              setState(() {
                contaDB.id = widget.id;
                contaDB.conta = widget.conta;
                contaDB.tipo = widget.tipo;
                contaDB.saldoinicial = widget.saldoinicial;
                contaDB.cor = widget.numeroCor;
                contaDB.ativada = value ? 1 : 0;
                this.switchValue = value;
                contaDB.upsertConta(contaDB);                
              });
            },
          )                 
        ],
      ),
    ); 
  }  
}


class NovaContaPage extends StatefulWidget {
  NovaContaPage(this.editar, this.contaDBEditar);

  bool editar;
  Conta contaDBEditar;

  @override
  NovaContaPageState createState() => new NovaContaPageState(this.editar, this.contaDBEditar);
}

class NovaContaPageState extends State<NovaContaPage>{
  NovaContaPageState(this.editar, this.contaDBEditar);

  bool editar;
  Conta contaDBEditar= new Conta();
  Color azulAppbar = new Color(0xFF26C6DA);

  @override
  Widget build(BuildContext context) {
    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Nova Conta'),
        backgroundColor: azulAppbar,
      ),
    );
  }
}