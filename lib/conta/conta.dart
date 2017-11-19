import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
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
  FocusNode _focusNode = new FocusNode();

  bool editar;
  Conta contaDBEditar= new Conta();
  Color azulAppbar = new Color(0xFF26C6DA);
  Color colorEscolhida;
  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _controllerNumber = new TextEditingController();
  Conta contaDB = new Conta();
  List listaCategoria;
  List<Widget> palette;
  bool x;
  Palette listaCores = new Palette();
  List cores = [];
  String tipo;

  @override
  void initState() {
    this.cores = listaCores.cores;
    this.tipo = "Conta corrente";

    contaDB.tipo = 'Conta corrente';
    contaDB.cor = 3;
    contaDB.saldoinicial = 0.0;

    setState(() {
      if(editar) {
        contaDB.id = contaDBEditar.id;
        contaDB.conta = contaDBEditar.conta;
        _controller.text = contaDBEditar.conta;
        contaDB.tipo = contaDBEditar.tipo;
        contaDB.saldoinicial= contaDBEditar.saldoinicial;
        //_controllerNumber.value = contaDBEditar.saldoinicial;
        contaDB.ativada = contaDBEditar.ativada;
        contaDB.cor = contaDBEditar.cor;
        this.colorEscolhida = this.cores[contaDBEditar.cor];
      } else {
        contaDBEditar.cor = 3;
        this.colorEscolhida = Colors.black;
      }
    });    
  }

  void showCorDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          
        });
      }
    });
  }

  void showTipoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {

        });
      }
    });
  }

  void showContaDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          
        });
      }
    });
  }

  void showValidarDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> buildPalette() {
      this.palette = [];
      for(var i = 0; i < 77; i+= 4) {
        this.palette.add(
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  color: cores[i],
                  height: 46.0,
                  width: 46.0,
                  child: new InkWell(
                    onTap: (){
                      this.colorEscolhida = cores[i];
                      contaDB.cor = i;
                      Navigator.pop(context, i);
                    },
                  ),
                ),
                new Container(
                  color: cores[i+1],
                  height: 46.0,
                  width: 46.0,
                  child: new InkWell(
                    onTap: (){
                      this.colorEscolhida = cores[i+1];
                      contaDB.cor = i+1;
                      Navigator.pop(context, i+1);
                    },
                  ),
                ),
                new Container(
                  color: cores[i+2],
                  height: 46.0,
                  width: 46.0,
                  child: new InkWell(
                    onTap: (){
                      this.colorEscolhida = cores[i+2];
                      contaDB.cor = i+2;
                      Navigator.pop(context, i+2);
                    },
                  ),
                ),
                new Container(
                  color: cores[i+3],
                  height: 46.0,
                  width: 46.0,
                  child: new InkWell(
                    onTap: (){
                      this.colorEscolhida = cores[i+3];
                      contaDB.cor = i+3;
                      Navigator.pop(context, i+3);
                    },
                  ),
                )
              ],
            )
          )
        );
      }
      return this.palette;
    }

    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Nova Conta'),
        backgroundColor: azulAppbar,
      ),
      body: new Container(
        //margin: new EdgeInsets.only(top: 6.0),
        child: new ListView(
          children: <Widget>[
            new Container( //nome da conta
              margin: new EdgeInsets.only(right: 16.0),
              child: new TextField(
                controller: _controller,
                maxLines: 1,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.account_balance),
                  labelText: "Nome da conta",
                ),
                style: Theme.of(context).textTheme.title,
              ),
            ),
            
            new Container( //cor
              margin: new EdgeInsets.only(left: 12.0, right: 16.0, top: 16.0),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.palette,
                    size: 24.0,
                    color: Colors.black45,
                  ),
                  new Expanded(
                    child: new InkWell(
                      onTap: () {
                        showCorDialog<String>(
                          context: context,
                          child: new SimpleDialog(
                            title: const Text('Selecione uma cor'),
                              children: buildPalette(),
                          )
                        );
                      },
                      child: new Container(
                        margin: new EdgeInsets.only(left: 12.0),
                        padding: new EdgeInsets.only(bottom: 2.0),
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
                            new Container(
                              child: new Text(
                                'Cor',
                                style: new TextStyle(
                                  color: Colors.black26,
                                  fontSize: 20.0,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                )
                              ),
                            ),
                            new Icon(Icons.lens, color: this.colorEscolhida)
                          ],
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),

            new Container( //tipo
              margin: new EdgeInsets.only(left: 12.0, right: 16.0, top: 32.0),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.account_balance_wallet,
                    size: 24.0,
                    color: Colors.black45,
                  ),
                  new Expanded(
                    child: new InkWell(
                      onTap: () {
                        showTipoDialog<String>(
                          context: context,
                          child: new SimpleDialog(
                            title: const Text('Tipo de conta'),
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  new DialogItem(
                                    text: 'Conta corrente',
                                    onPressed: () {
                                      contaDB.tipo = 'Conta corrente';
                                      this.tipo = contaDB.tipo;
                                      Navigator.pop(context, 'Conta corrente');
                                    }
                                  ),
                                  new DialogItem(
                                    text: 'Conta poupança',
                                    onPressed: () {
                                      contaDB.tipo = 'Conta poupança';
                                      this.tipo = contaDB.tipo;
                                      Navigator.pop(context, 'Conta poupança');
                                    }
                                  ),
                                  new DialogItem(
                                    text: 'Outros',
                                    onPressed: () {
                                      contaDB.tipo = 'Outros';
                                      this.tipo = contaDB.tipo;
                                      Navigator.pop(context, 'Outros');
                                    }
                                  ),
                                ],
                              ),
                            ],
                          )
                        );
                      },
                      child: new Container(
                        margin: new EdgeInsets.only(left: 12.0),
                        padding: new EdgeInsets.only(bottom: 2.0),
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
                            new Container(
                              child: new Text(
                                this.tipo,
                                style: new TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20.0,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                )
                              ),
                            ),
                          ],
                        )
                      )
                    )
                  ),
                ]
              ),
            ),            

            new Container( //saldo inicial
              margin: new EdgeInsets.only(right: 16.0),
              child: new EnsureVisibleWhenFocused(
              focusNode: _focusNode,            
              child: new TextField(
                  controller: _controllerNumber,
                  //keyboardType: TextInputType.number,
                  maxLines: 1,
                  focusNode: _focusNode,
                  style: Theme.of(context).textTheme.title,
                  decoration: new InputDecoration(
                    labelText: "Saldo inicial",
                    icon: const Icon(Icons.attach_money),
                  ),
                ),
              ),
            ),

            new Container(
              margin: new EdgeInsets.only(top: 36.0),
              child: new Column(
                children: <Widget>[
                  new RaisedButton(
                    color: this.azulAppbar,
                    child: const Text(
                      'OK',
                      style: const TextStyle(
                        color: const Color(0xFFFFFFFF),
                        fontSize: 24.0
                      ),  
                    ),
                    onPressed: () {
                      contaDB.conta = _controller.text;
                      contaDB.ativada = 1;

                      var saldo = _controllerNumber.text.toString();
                      var saldoSanitize = saldo.replaceAll(new RegExp(r"[' ']+"), '');

                      if(saldoSanitize.length == 0) {
                        saldoSanitize = '0,00';
                      }
                      
                      RegExp _float = new RegExp(r'^(?:-?(?:[0-9]+))?(?:\,[0-9]{0,2})?$');
                      bool isFloat = _float.hasMatch(saldoSanitize);

                      if(isFloat) {
                        var saldoSanitize2 = saldoSanitize.replaceAll(new RegExp(r","), '.');
                        contaDB.saldoinicial = double.parse(saldoSanitize2);
                      } else {
                        showValidarDialog<String>(
                          context: context,
                          child: new SimpleDialog(
                            title: const Text('Erro'),
                            children: <Widget>[
                              new Container(
                                margin: new EdgeInsets.only(left: 24.0),
                                child: new Row(
                                  children: <Widget>[
                                    new Container(
                                      margin: new EdgeInsets.only(right: 10.0),
                                      child: new Icon(
                                        Icons.error,
                                        color: const Color(0xFFE57373)),
                                    ),
                                    new Text(
                                      "Saldo inicial inválido\nExemplo: 1234,56\n                -1234,56",
                                      softWrap: true,
                                      style: new TextStyle(
                                        color: Colors.black45,
                                        fontSize: 16.0,
                                        fontFamily: "Roboto",
                                        fontWeight: FontWeight.w500,
                                      )
                                    )
                                  ],
                                ),
                              )
                            ]
                          )
                        );                      
                      }
                      

                      
                      
                      //print(x);
                      //print(contaDB.conta);
                      //print(contaDB.tipo);
                      //print(contaDB.cor);
                      //print(contaDB.saldoinicial);
                      //print(contaDB.ativada);
                      //if(contaDB.conta.length > 0) {
                      //  this.x = true;
                      //} else { this.x = false; }

                      //if(this.x) {
                      //  contaDB.upsertConta(contaDB);
                      //  Navigator.pop(context);
                      //} else {
                      //  showContaDialog<String>(
                      //    context: context,
                      //    child: new SimpleDialog(
                      //      title: const Text('Erro'),
                      //      children: <Widget>[
                      //        new Container(
                      //          margin: new EdgeInsets.only(left: 24.0),
                      //          child: new Row(
                      //            children: <Widget>[
                      //              new Container(
                      //                margin: new EdgeInsets.only(right: 10.0),
                      //                child: new Icon(
                      //                  Icons.error,
                      //                  color: const Color(0xFFE57373)),
                      //              ),
                      //              new Text(
                      //                "Preencha os campos",
                      //                softWrap: true,
                      //                style: new TextStyle(
                      //                  color: Colors.black26,
                      //                  fontSize: 16.0,
                      //                  fontFamily: "Roboto",
                      //                  fontWeight: FontWeight.w500,
                      //                )
                      //              )
                      //            ],
                      //          ),
                      //        )
                      //      ]
                      //    )
                      //  );
                      //}
                    }
                  ),
                ],
              )
            )
          ],
        ),
      )
    );
  }
}

class DialogItem extends StatelessWidget {
  DialogItem({ Key key, this.icon, this.size, this.color, this.text, this.onPressed }) : super(key: key);
 
  final IconData icon;
  double size = 36.0;
  final Color color;
  final String text;
  final VoidCallback onPressed;
 
  @override
  Widget build(BuildContext context) {
    return new SimpleDialogOption(
      onPressed: onPressed,
      child: new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[       
            new Text(
              text,
              style: new TextStyle(
                fontSize: 16.0
              ),
            )
          ],
        ),
      )
    );
  }
}

class EnsureVisibleWhenFocused extends StatefulWidget {
  const EnsureVisibleWhenFocused({
    Key key,
    @required this.child,
    @required this.focusNode,
    this.curve: Curves.ease,
    this.duration: const Duration(milliseconds: 100),
  }) : super(key: key);

  final FocusNode focusNode;
  final Widget child;
  final Curve curve;
  final Duration duration;

  EnsureVisibleWhenFocusedState createState() => new EnsureVisibleWhenFocusedState();
}

class EnsureVisibleWhenFocusedState extends State<EnsureVisibleWhenFocused> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_ensureVisible);
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode.removeListener(_ensureVisible);
  }

  Future<Null> _ensureVisible() async {
    await new Future.delayed(const Duration(milliseconds: 600));

    if (!widget.focusNode.hasFocus)
      return;

    final RenderObject object = context.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    ScrollableState scrollableState = Scrollable.of(context);
    assert(scrollableState != null);

    ScrollPosition position = scrollableState.position;
    double alignment;
    if (position.pixels > viewport.getOffsetToReveal(object, 0.0)) {
      alignment = 0.0;
    } else if (position.pixels < viewport.getOffsetToReveal(object, 1.0)) {
      alignment = 1.0;
    } else {
      return;
    }
    position.ensureVisible(
      object,
      alignment: alignment,
      duration: widget.duration,
      curve: widget.curve,
    );
  }
  Widget build(BuildContext context) => widget.child;
}