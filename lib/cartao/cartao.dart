import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
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
                  return new NovaCartaoPage(true, cartaoEditar);
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
                  return new NovaCartaoPage(false, new Cartao());
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

  String sanitazerMoney(double money) {
    //var moneyBR = money.toStringAsFixed(2).toString().replaceAll(new RegExp(r"\."), ',');
    var f = new NumberFormat("#,###,###,###,###.00", "pt_BR");
    var moneyBR = f.format(double.parse(money.toStringAsFixed(2).toString()));
    return moneyBR;
  }

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
                        "Limite: R\$ " + sanitazerMoney(widget.limite),
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


class NovaCartaoPage extends StatefulWidget {
  NovaCartaoPage(this.editar, this.cartaoDBEditar);

  bool editar;
  Cartao cartaoDBEditar;

  @override
  NovaCartaoPageState createState() => new NovaCartaoPageState(this.editar, this.cartaoDBEditar);
}

class NovaCartaoPageState extends State<NovaCartaoPage>{
  NovaCartaoPageState(this.editar, this.cartaoDBEditar);
  FocusNode _focusNode = new FocusNode();

  String sanitazerMoney(double money) {
    var moneyBR = money.toStringAsFixed(2).toString().replaceAll(new RegExp(r"\."), ',');
    return moneyBR;
  }

  bool editar;
  Cartao cartaoDBEditar = new Cartao();
  Conta cartaoContaDB = new Conta();
  Color azulAppbar = new Color(0xFF26C6DA);
  Color colorEscolhida;
  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _controllerNumber = new TextEditingController();
  Cartao cartaoDB = new Cartao();
  List<Widget> tiles;
  List<Widget> palette;
  List<Widget> calendario;
  List<Widget> calendarioShow;
  Palette listaCores = new Palette();
  List cores = [];
  List listaContaDB = [];
  String contaPagamento = "Conta para pagamento";
  String fechamento = "";
  String vencimento = "";
  bool tamanhoList;

  @override
  void initState() {
    this.cores = listaCores.cores;

    //cartaoDB.tipo = 'cartao corrente';
    cartaoDB.cor = 3;
    //cartaoDB.saldoinicial = 0.0;

    setState(() {
      if(this.editar) {
        cartaoDB.id = cartaoDBEditar.id;
        cartaoDB.cartao = cartaoDBEditar.cartao;
        cartaoDB.cor = cartaoDBEditar.cor;
        cartaoDB.limite = cartaoDBEditar.limite;
        cartaoDB.vencimento = cartaoDBEditar.vencimento;
        cartaoDB.fechamento = cartaoDBEditar.fechamento;
        cartaoDB.contapagamento = cartaoDBEditar.contapagamento;
        cartaoDB.ativada = cartaoDBEditar.ativada;        
        _controller.text = cartaoDBEditar.cartao;
        _controllerNumber.text = sanitazerMoney(cartaoDB.limite);
        this.colorEscolhida = this.cores[cartaoDBEditar.cor];
        this.vencimento = cartaoDB.vencimento;
        this.fechamento = cartaoDB.fechamento;
        cartaoContaDB.getConta(cartaoDB.contapagamento).then(
          (list) {
            setState(() {
              this.contaPagamento = list[0]["conta"];
            });
          }
        );
      } else {
        cartaoDB.cor = 3;
        this.colorEscolhida = Colors.black;
      }
    });

    cartaoContaDB.getAllConta().then(
      (list) {
        setState(() {
          this.listaContaDB = list;
        });
      }
    );
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

  void showContaPagamentoDialog<T>({ BuildContext context, Widget child }) {
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

  void showFechamentoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          this.fechamento = value.toString();
          cartaoDB.fechamento = this.fechamento;
        });
      }
    });
  }

  void showVencimentoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          this.vencimento = value.toString();
          cartaoDB.vencimento = this.vencimento;
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

    List<Widget> numerosCalendario() {
      this.calendario = [];
      for(var i = 1; i < 32; i++) {
        this.calendario.add(
          new InkWell(
            onTap: () {
              Navigator.pop(context, i.toString());
            },
            child: new Container(
              width: 20.0,
              height: 20.0,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    i.toString(),
                    style: new TextStyle(
                      color: Colors.black45,
                      fontSize: 16.0,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                    )
                  ),
                ],
              ),
            )            
          )
        );
      }

      for(var i = 32; i < 37; i++) {
        this.calendario.add(
          new Container(
            width: 20.0,
            height: 20.0,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  i.toString(),
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                  )
                ),
              ],
            ),
          )          
        );
      }
      return this.calendario;
    }    

    List<Widget> numerosCalendarioShow() {
      List<Widget> numeros = numerosCalendario();
      this.calendarioShow = [];
      this.calendarioShow.add(
        new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: numeros.sublist(0, 5)
                ),
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: numeros.sublist(5, 10)
                ),
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: numeros.sublist(10, 15)
                ),
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: numeros.sublist(15, 20)
                ),
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: numeros.sublist(20, 25)
                ),
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: numeros.sublist(25, 30)
                ),
              ),
              new Container(
                padding: new EdgeInsets.all(10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: numeros.sublist(30, 35)
                ),
              ),
            ],
          ),
        )
      );
      return this.calendarioShow;
    }

    List<Widget> buildTile(contaList) {
      this.tiles = [];
        for(var i in contaList) {
          this.tiles.add(
            new DialogContaItem(
              icon: Icons.brightness_1,
              color: this.cores[i['cor']],
              text: i['conta'],
              onPressed: () {
                setState((){
                  cartaoDB.contapagamento = i['id'];
                  this.contaPagamento = i['conta'];
                });
                Navigator.pop(context);
              }
            )
          );
        }
      return this.tiles;
    }

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
        child: new ListView(
          children: <Widget>[
            new Container( //nome do cartao
              margin: new EdgeInsets.only(right: 16.0),
              child: new TextField(
                controller: _controller,
                maxLines: 1,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.account_balance),
                  labelText: "Nome do cartão",
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

            new Container( //limite
              margin: new EdgeInsets.only(right: 16.0),
              child: new EnsureVisibleWhenFocused(
              focusNode: _focusNode,            
              child: new TextField(
                  controller: _controllerNumber,
                  maxLines: 1,
                  focusNode: _focusNode,
                  style: Theme.of(context).textTheme.title,
                  decoration: new InputDecoration(
                    labelText: "Limite",
                    icon: const Icon(Icons.attach_money),
                  ),
                ),
              ),
            ),

            new Container( //conta para pagamento
              margin: new EdgeInsets.only(left: 12.0, right: 16.0, top: 16.0),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.account_balance,
                    size: 24.0,
                    color: Colors.black45,
                  ),
                  new Expanded(
                    child: new InkWell(
                      onTap: () {
                        showContaPagamentoDialog<String>(
                          context: context,
                          child: new SimpleDialog(
                            title: const Text('Selecione uma conta'),
                            children: buildTile(this.listaContaDB)
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
                                this.contaPagamento,
                                style: new TextStyle(
                                  color: this.contaPagamento == "Conta para pagamento" ? Colors.black26 : Colors.black87,
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

            new Container( //fechamento e vencimento
              margin: new EdgeInsets.only(left: 12.0, right: 16.0, top: 32.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Icon(
                        Icons.date_range,
                        size: 24.0,
                        color: Colors.black45,
                      ),
                      new Container(
                        child: new InkWell(
                          onTap: () {
                            showFechamentoDialog<String>(
                              context: context,
                              child: new SimpleDialog(
                                title: const Text('Selecione o dia'),
                                children: numerosCalendarioShow()
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
                                    'Fecha dia: ',
                                    style: new TextStyle(
                                      color: Colors.black26,
                                      fontSize: 20.0,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500,
                                    )
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    this.fechamento,
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
                    ],
                  ),                  
                  
                  new Container(
                    child: new InkWell(
                      onTap: () {
                        showVencimentoDialog<String>(
                          context: context,
                          child: new SimpleDialog(
                            title: const Text('Selecione o dia'),
                            children: numerosCalendarioShow()
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
                                'Vence dia: ',
                                style: new TextStyle(
                                  color: Colors.black26,
                                  fontSize: 20.0,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                )
                              ),
                            ),
                            new Container(
                              child: new Text(
                                this.vencimento,
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
                      var validarText = _controller.text.replaceAll(new RegExp(r"[' ']+"), '');
                      cartaoDB.ativada = 1;

                      if(this.editar == false){
                        cartaoDB.getCartaoByName(_controller.text).then((list) {
                          list.length > 0 ? this.tamanhoList = true : this.tamanhoList = false;

                          var limite = _controllerNumber.text.toString();
                          var limiteSanitize = limite.replaceAll(new RegExp(r"[' ']+"), '');

                          if(limiteSanitize.length == 0) {
                            limiteSanitize = '0,00';
                          }
                          
                          RegExp _float = new RegExp(r'^(?:-?(?:[0-9]+))?(?:\,[0-9]{0,2})?$');
                          bool isFloat = _float.hasMatch(limiteSanitize);

                          if(isFloat) {
                            var limiteSanitize2 = limiteSanitize.replaceAll(new RegExp(r","), '.');
                            cartaoDB.limite = double.parse(limiteSanitize2);

                            if(
                              validarText.length > 0 &&
                              cartaoDB.vencimento != null &&
                              cartaoDB.fechamento != null &&
                              cartaoDB.contapagamento != null &&
                              limite.length > 0 &&
                              this.tamanhoList == false
                            ) {
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
                                          this.tamanhoList == false ?
                                          new Text(
                                            "Preencha os campos",
                                            softWrap: true,
                                            style: new TextStyle(
                                              color: Colors.black45,
                                              fontSize: 16.0,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w500,
                                            )
                                          ) :
                                          new Text(
                                            "Cartão já existente",
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
                                          "Limite inválido\nExemplo: 1234,56\n                -1234,56",
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
                        });
                      } else {
                        var limite = _controllerNumber.text.toString();
                        var limiteSanitize = limite.replaceAll(new RegExp(r"[' ']+"), '');

                        if(limiteSanitize.length == 0) {
                          limiteSanitize = '0,00';
                        }
                        
                        RegExp _float = new RegExp(r'^(?:-?(?:[0-9]+))?(?:\,[0-9]{0,2})?$');
                        bool isFloat = _float.hasMatch(limiteSanitize);

                        if(isFloat) {
                          var limiteSanitize2 = limiteSanitize.replaceAll(new RegExp(r","), '.');
                          cartaoDB.limite = double.parse(limiteSanitize2);

                          if(
                            validarText.length > 0 &&
                            cartaoDB.vencimento != null &&
                            cartaoDB.fechamento != null &&
                            cartaoDB.contapagamento != null &&
                            limite.length > 0
                          ) {
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
                                          "Preencha os campos",
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
                                        "Limite inválido\nExemplo: 1234,56\n                -1234,56",
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

class DialogContaItem extends StatelessWidget {
  DialogContaItem({ Key key, this.icon, this.size, this.color, this.text, this.onPressed }) : super(key: key);
 
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
            new Container(
              child: new Container(
                margin: size == 16.0 ? new EdgeInsets.only(left: 7.0) : null,
                child: new Icon(icon, size: size, color: color),
              )
            ),
            new Padding(
              padding: size == 16.0 ? const EdgeInsets.only(left: 17.0) : const EdgeInsets.only(left: 16.0),
              child: new Text(text),
            ),
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