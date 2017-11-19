import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import '../palette/palette.dart';
import '../db/database.dart';

class CartaoPage extends StatefulWidget {
  @override
  CartaoPageState createState() => new CartaoPageState();
}

class CartaoPageState extends State<CartaoPage> {
  Color azulAppbar = new Color(0xFF26C6DA);
  Cartao cartaoDB = new Cartao();
  List<Widget> listacartoes = [];
  List listaDB = [];
  Palette listaCores = new Palette();
  List cores = [];
  bool switchValue = true;

  @override
  void initState() {
    this.cores = listaCores.cores;
    cartaoDB.getAllCartao().then(
      (list) {
        setState(() {
          this.listaDB = list;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> buildlistacartoes(list) {
      this.listacartoes = [];
      for(var i in list) {
        var id = i['id'];
        var cartao = i['cartao'];
        var cor = this.cores[i['cor']];
        var limite = i['limite'];
        var vencimento = i['vencimento'];
        var fechamento = i['fechamento'];
        var contapagamento = i['contapagamento'];
        var numeroCor = i['cor'];
        var ativada = i['ativada'];

        this.listacartoes.add(
          new ItemCartao(
            id: id,
            cartao: cartao,
            cor: cor,
            limite: limite,
            vencimento: vencimento,
            fechamento: fechamento,
            contapagamento: contapagamento,
            numeroCor: numeroCor,
            ativada: ativada,
            onPressed: () async {
              Cartao cartaoEditar = new Cartao();
              cartaoEditar.id = id;
              cartaoEditar.cartao = cartao;
              cartaoEditar.cor = numeroCor;
              cartaoEditar.limite = limite;
              cartaoEditar.vencimento = vencimento;
              cartaoEditar.fechamento = fechamento;
              cartaoEditar.contapagamento = contapagamento;
              cartaoEditar.ativada = ativada;

              await Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new NovacartaoPage(true, cartaoEditar);
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
              cartaoDB.getAllCartao().then(
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
      return this.listacartoes;
    }

    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Cartões de Crédito'),
        backgroundColor: azulAppbar,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.add),
            color: new Color(0xFFFFFFFF),
            onPressed: () async {
              await Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new NovacartaoPage(false, new Cartao());
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
              cartaoDB.getAllCartao().then(
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
        children: buildlistacartoes(this.listaDB)
      )
    );
  }
}

class ItemCartao extends StatefulWidget {
   
  final int id;
  final String cartao;
  final Color cor;
  final double limite;
  final String vencimento;
  final String fechamento;
  final int contapagamento;  
  final int numeroCor;  
  final int ativada;
  final VoidCallback onPressed;

  ItemCartao({
    this.id,
    this.cartao,
    this.cor,
    this.limite,
    this.vencimento,
    this.fechamento,
    this.contapagamento,
    this.numeroCor,
    this.ativada,
    this.onPressed
  });

  @override
  ItemCartaoState createState() => new ItemCartaoState();
}

class ItemCartaoState extends State<ItemCartao> {
  ItemCartaoState();
  bool switchValue;
  Cartao cartaoDB = new Cartao();

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
                        widget.cartao,                        
                        style: new TextStyle(
                          color: this.switchValue ? Colors.black87 : Colors.black26,
                          fontFamily: "Roboto",
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          textBaseline: TextBaseline.alphabetic                        
                        ),
                      ),
                      new Text(
                        widget.limite.toString(),
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
                cartaoDB.id = widget.id;
                cartaoDB.cartao = widget.cartao;
                cartaoDB.cor = widget.numeroCor;
                cartaoDB.limite = widget.limite;
                cartaoDB.vencimento = widget.vencimento;
                cartaoDB.fechamento = widget.fechamento;
                cartaoDB.contapagamento = widget.contapagamento;
                cartaoDB.ativada = value ? 1 : 0;
                this.switchValue = value;
                cartaoDB.upsertCartao(cartaoDB);
              });
            },
          )
        ],
      ),
    ); 
  }  
}


class NovacartaoPage extends StatefulWidget {
  NovacartaoPage(this.editar, this.cartaoDBEditar);

  bool editar;
  Cartao cartaoDBEditar;

  @override
  NovaCartaoPageState createState() => new NovaCartaoPageState(this.editar, this.cartaoDBEditar);
}

class NovaCartaoPageState extends State<NovacartaoPage>{
  NovaCartaoPageState(this.editar, this.cartaoDBEditar);
  FocusNode _focusNode = new FocusNode();

  bool editar;
  Cartao cartaoDBEditar= new Cartao();
  Color azulAppbar = new Color(0xFF26C6DA);
  Color colorEscolhida;
  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _controllerNumber = new TextEditingController();
  Cartao cartaoDB = new Cartao();
  List listaCategoria;
  List<Widget> palette;
  Palette listaCores = new Palette();
  List cores = [];
  String tipo;

  @override
  void initState() {
    this.cores = listaCores.cores;
    this.tipo = "cartao corrente";

    //cartaoDB.tipo = 'cartao corrente';
    cartaoDB.cor = 3;
    //cartaoDB.saldoinicial = 0.0;

    setState(() {
      if(this.editar) {
        
        //var sanitizeNumberToString = cartaoDBEditar.saldoinicial.toString().replaceAll(new RegExp(r"\."), ',');
        //double sanitizeNumber = double.parse(sanitizeNumberToString.replaceAll(new RegExp(r","), '.'));
        
        cartaoDB.id = cartaoDBEditar.id;
        cartaoDB.cartao = cartaoDBEditar.cartao;
        cartaoDB.cor = cartaoDBEditar.cor;
        //cartaoDB.tipo = cartaoDBEditar.tipo;
        cartaoDB.ativada = cartaoDBEditar.ativada;
        //cartaoDBEditar.saldoinicial = sanitizeNumber;
        _controller.text = cartaoDBEditar.cartao;
        //_controllerNumber.text = sanitizeNumber.toStringAsFixed(2).toString().replaceAll(new RegExp(r"\."), ',');     
        
        this.colorEscolhida = this.cores[cartaoDBEditar.cor];
      } else {
        cartaoDBEditar.cor = 3;
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

  void showCartaoDialog<T>({ BuildContext context, Widget child }) {
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
                      cartaoDB.cor = i;
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
                      cartaoDB.cor = i+1;
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
                      cartaoDB.cor = i+2;
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
                      cartaoDB.cor = i+3;
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
        title: new Text('Novo Cartão de Crédito'),
        backgroundColor: azulAppbar,
      ),
      body: new Container(
        //margin: new EdgeInsets.only(top: 6.0),
        child: new ListView(
          children: <Widget>[
            new Container( //nome do cartao
              margin: new EdgeInsets.only(right: 16.0),
              child: new TextField(
                controller: _controller,
                maxLines: 1,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.account_balance),
                  labelText: "Nome da cartao",
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
                            title: const Text('Tipo de cartao'),
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  new DialogItem(
                                    text: 'cartao corrente',
                                    onPressed: () {
                                      //cartaoDB.tipo = 'cartao corrente';
                                      //this.tipo = cartaoDB.tipo;
                                      Navigator.pop(context, 'cartao corrente');
                                    }
                                  ),
                                  new DialogItem(
                                    text: 'cartao poupança',
                                    onPressed: () {
                                      //cartaoDB.tipo = 'cartao poupança';
                                      //this.tipo = cartaoDB.tipo;
                                      Navigator.pop(context, 'cartao poupança');
                                    }
                                  ),
                                  new DialogItem(
                                    text: 'Outros',
                                    onPressed: () {
                                      //cartaoDB.tipo = 'Outros';
                                      //this.tipo = cartaoDB.tipo;
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
                      cartaoDB.cartao = _controller.text;
                      cartaoDB.ativada = 1;

                      var saldo = _controllerNumber.text.toString();
                      var saldoSanitize = saldo.replaceAll(new RegExp(r"[' ']+"), '');

                      if(saldoSanitize.length == 0) {
                        saldoSanitize = '0,00';
                      }
                      
                      RegExp _float = new RegExp(r'^(?:-?(?:[0-9]+))?(?:\,[0-9]{0,2})?$');
                      bool isFloat = _float.hasMatch(saldoSanitize);

                      if(isFloat) {
                        var saldoSanitize2 = saldoSanitize.replaceAll(new RegExp(r","), '.');
                        //cartaoDB.saldoinicial = double.parse(saldoSanitize2);

                        if(cartaoDB.cartao.length > 0) {
                          cartaoDB.upsertCartao(cartaoDB);
                          Navigator.pop(context);
                        } else { 
                          showCartaoDialog<String>(
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
                                        "Preencha o campo:\nNome da cartao",
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