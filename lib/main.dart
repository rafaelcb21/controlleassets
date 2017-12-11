import "package:flutter/material.dart";

import './db/database.dart';
import "home/card_alertas.dart";
import "lancamento/lancamento.dart";
import "lancamento/consultalancamento.dart";
import "categoria/categoria.dart";
import "conta/conta.dart";
import "cartao/cartao.dart";
import "tag/tag.dart";
import 'palette/palette.dart';
import 'package:flutter/animation.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_admob/firebase_admob.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_auth/firebase_auth.dart';

//final googleSignIn = new GoogleSignIn();
//final FirebaseAuth _auth = FirebaseAuth.instance;

const String appId = 'ca-app-pub-5211132910751370~8529761448';
const String testDevice = '33B6FA56617D7688A3A466295DED82BE';
const String bannerAdUnitId = 'ca-app-pub-5211132910751370/4346015999';
const String interstitialAdUnitId = 'ca-app-pub-5211132910751370/9854327692';
const String interstitialAdUnitIdVideo = 'ca-app-pub-5211132910751370/8510754579';

void main() {
  Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting('pt_BR');
  runApp(new ControlleApp());
}

class ControlleApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return new MaterialApp(
      title: "Controlle Financeiro",
      home: new HomePage(),
      //routes: <String, WidgetBuilder> {
      //  '/home': (BuildContext context) => new HomePage(),
      //  '/categoria': (BuildContext context) => new CategoriaPage(),
      //  '/tag': (BuildContext context) => new TagPage(),
      //  '/conta': (BuildContext context) => new ContaPage(),
      //  '/cartao': (BuildContext context) => new CartaoPage(),
      //  '/consultalancamento': (BuildContext context) => new ConsultaLancamentoPage(),
      //  //'/conta': (BuildContext context) => new LancamentoPage()
      //},
    );
  }
}



class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  DatabaseClient db = new DatabaseClient();
  List listaContas = [];
  List listaDBConta = [];
  List listaDBCartao = [];
  int _angle = 90;
  bool _isRotated = true;
  List cores = [];
  Palette listaCores = new Palette();
  Conta contaDB = new Conta();
  Cartao cartaoDB = new Cartao();
  bool cardContaNew = true;
  bool cardCartaoNew = true;

  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;
  Animation<double> _animation3;

 static final MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    birthday: new DateTime.now(),
    childDirected: true,
    gender: MobileAdGender.male,
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return new BannerAd(
      unitId: bannerAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
      unitId: interstitialAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  @override
  void initState() {
    this.cores = listaCores.cores;
    FirebaseAdMob.instance.initialize(appId: appId);
    //_bannerAd = createBannerAd()..load();
    //_bannerAd ??= createBannerAd();
    //_bannerAd..load()..show();
    _interstitialAd = createInterstitialAd()..load();
    _interstitialAd ??= createInterstitialAd();
    _interstitialAd..load()..show();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.linear),
    );

    _animation3 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.8, 1.0, curve: Curves.linear),
    );
    _controller.reverse();
    
    db.create().then((dict) {
      setState(() {
        if(dict['conta'].length > 0) {
          this.listaDBConta = dict['conta'];
          this.cardContaNew = false;
        } else {
          this.listaDBConta = dict['conta'];
          this.cardContaNew = true;
        }

        if(dict['cartao'].length > 0) {
          this.listaDBCartao = dict['cartao'];
          this.cardCartaoNew = false;
        } else {
          this.cardCartaoNew = dict['cartao'];
          this.cardCartaoNew = true;
        }


      });
    });

    super.initState();
    
  }

  @override
  void dispose() {
    //_bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    Color cinzaDrawer = new Color(0xFF9E9E9E);
    Color azulAppbar = new Color(0xFF26C6DA);
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;
    final double _height = logicalSize.height;

    void _rotate(){
      setState((){
        if(_isRotated) {
          _angle = 45;
          _isRotated = false;
          _controller.forward(from: 0.0);
        } else {
          _angle = 90;
          _isRotated = true;
          _controller.reverse(from: 1.0);
        }
      });
    }

    List<Widget> buildListaContas(list) {
      this.listaContas = [
        new Container(
          padding: new EdgeInsets.only(left: 18.0, top: 18.0),
          child: new Text(
          'Contas',
            style: new TextStyle(
              fontSize: 14.0,
              fontFamily: 'Roboto',
              color: new Color(0xFF757575),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ];

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
            onPressed: () {}
          )
        );
      }

      return this.listaContas;
    }

    List<Widget> buildListaCartoes(list) {
      this.listaContas = [
        new Container(
          padding: new EdgeInsets.only(left: 18.0, top: 18.0),
          child: new Text(
          'Cartões de crédito',
            style: new TextStyle(
              fontSize: 14.0,
              fontFamily: 'Roboto',
              color: new Color(0xFF757575),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ];

      for(var i in list) {
        var id = i['id'];
        var cartao = i['cartao'];
        var limite = i['limite'];
        var vencimento = i['vencimento'];
        var fechamento = i['fechamento'];
        var contapagamento = i['contapagamento'];
        var cor = this.cores[i['cor']];
        var numeroCor = i['cor'];
        var ativada = i['ativada'];

        this.listaContas.add(
          new ItemCartao(
            id: id,
            cartao: cartao,
            limite: limite,
            vencimento: vencimento,
            fechamento: fechamento,
            contapagamento: contapagamento,            
            cor: cor,
            numeroCor: numeroCor,
            ativada: ativada,
            onPressed: () {}
          )
        );
      }

      return this.listaContas;
    }

    return new Scaffold( 
      appBar: new AppBar(
        backgroundColor: azulAppbar,
      ),
      drawer: !_isRotated ? new Drawer() : new Drawer(
        child: new ListView(
          children: <Widget>[
            //new DrawerHeader(
            //  decoration: new BoxDecoration(
            //    color: azulAppbar                
            //  ),
            //  child: new Text(''),
            //),
            new Container(
              color: azulAppbar,
              height: 80.0,
            ),
            new ListTile(
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(new PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return new ContaPage();
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

                contaDB.getAllContaAtivas().then(
                  (lista) {
                    setState(() {
                      if(lista.length > 0) {
                        this.listaDBConta = lista;
                        this.cardContaNew = false;
                      } else {
                        this.listaDBConta = lista;
                        this.cardContaNew = true;
                      }        
                    });
                  }
                );
              },
              leading: new Icon(
                Icons.account_balance,
                color: cinzaDrawer,
              ),
              title: new Text(
                'Contas',
                style: new TextStyle(
                  color: cinzaDrawer
                ),  
              )
            ),

            new ListTile(
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(new PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return new CartaoPage();
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

                cartaoDB.getAllCartaoAtivos().then(
                  (lista) {
                    setState(() {
                      if(lista.length > 0) {
                        this.listaDBCartao = lista;
                        this.cardCartaoNew = false;
                      } else {
                        this.listaDBCartao = lista;
                        this.cardCartaoNew = true;
                      }        
                    });
                  }
                );
              },
              leading: new Icon(
                Icons.credit_card,
                color: cinzaDrawer,
              ),
              title: new Text(
                'Cartões de Crédito',
              style: new TextStyle(
                  color: cinzaDrawer
                ),
              )
            ),
            new ListTile(
              onTap: (){
                //Navigator.popAndPushNamed(context, '/categoria');
                Navigator.pop(context);
                Navigator.of(context).push(new PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return new CategoriaPage();
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
              },
              leading: new Icon(
                Icons.folder,
                color: cinzaDrawer,
              ),
              title: new Text(
                'Categorias',
              style: new TextStyle(
                  color: cinzaDrawer
                ),
              )
            ),
            new ListTile(
              onTap: (){
                Navigator.pop(context);
                Navigator.of(context).push(new PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return new TagPage();
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
              },
              leading: new Icon(
                Icons.local_offer,
                color: cinzaDrawer,
              ),
              title: new Text(
                'Tags',
              style: new TextStyle(
                  color: cinzaDrawer
                ),
              )
            ),
            new ListTile(
              leading: new Icon(
                Icons.pie_chart,
                color: cinzaDrawer,
              ),
              title: new Text(
                'Relatórios',
              style: new TextStyle(
                  color: cinzaDrawer
                ),
              )
            ),
            new ListTile(
              leading: new Icon(
                Icons.settings,
                color: cinzaDrawer,
              ),
              title: new Text(
                'Configurações',
              style: new TextStyle(
                  color: cinzaDrawer
                ),
              )
            ),
            new ListTile(
              leading: new Icon(
                Icons.backup,
                color: cinzaDrawer,
              ),
              title: new Text(
                'Backup',
              style: new TextStyle(
                  color: cinzaDrawer
                ),
              )
            ),
            new ListTile(
              leading: new Icon(
                Icons.file_download,
                color: cinzaDrawer,
              ),
              title: new Text(
                'Download',
              style: new TextStyle(
                  color: cinzaDrawer
                ),
              )
            ),
            new ListTile(),
            new ListTile(),
          ],
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new ListView  (
            children: <Widget>[  
              
              //Carda Saldo
              new Container(
                padding: new EdgeInsets.only(bottom: 3.0, right: 6.0, left: 6.0, top: 12.0),
                child: new Card(
                  child: new InkWell(
                    onTap: () async {
                      await Navigator.of(context).push(new PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return new ConsultaLancamentoPage();
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

                      //retorno
                    },
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Container(
                          padding: new EdgeInsets.only(top: 18.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                'R\$  ',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF26C6DA),
                                )
                              ),
                              new Text(
                                '3.435,23',
                                style: new TextStyle(
                                  fontSize: 35.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF26C6DA)
                                ),
                              )
                            ],
                          ),
                        ),
                        new Container(
                          padding: new EdgeInsets.only(top: 3.0, bottom: 3.0),
                          child: new Text(
                            'saldo geral',
                            style: new TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF757575),
                            ),
                          ),
                        ),
                        
                        new Container(
                          padding: new EdgeInsets.only(left: 32.0, right: 32.0),
                          child: new Divider(),
                        ),

                        new Container(
                          padding: new EdgeInsets.only(top: 3.0),
                          child: new Text(
                            '20/05 - 19/06',
                            style: new TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF212121),
                            ),
                          ),
                        ),

                        new Container(
                          padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 6.0, bottom: 3.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(
                                'Receita:',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF757575),
                                ),
                              ),
                              new Text(
                                'R\$ 3.051,00',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF00BFA5),
                                ),
                              )
                            ],
                          ),
                        ),
                        new Container(
                          padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 3.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(
                                'Despesa:',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF757575),
                                ),
                              ),
                              new Text(
                                'R\$ 2.587,00',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFFF44336),
                                ),
                              )
                            ],
                          ),
                        ),
                        new Container(
                          padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 18.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(
                                'Resultado:',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF757575),
                                ),
                              ),
                              new Text(
                                'R\$ 464,00',
                                style: new TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Roboto',
                                  color: new Color(0xFF00BFA5),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
              //Fim do Card Saldo

              this.cardContaNew ? 
              new Container( // Card Contas
                padding: new EdgeInsets.only(bottom: 6.0, right: 6.0, left: 6.0),
                child: new  Card(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(bottom: 8.0, top: 26.0),
                        child: new Icon(
                          Icons.account_balance,
                          color: cinzaDrawer,
                          size: 40.0
                        ),
                      ),
                      new GestureDetector(
                        child: new Container(
                          padding: new EdgeInsets.only(bottom: 26.0, top: 8.0),
                          child: new Chip(label: const Text('Adicionar contas')),
                        ),                        
                        onTap:  () async {
                          await Navigator.of(context).push(new PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new ContaPage();
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
                          contaDB.getAllContaAtivas().then(
                            (lista) {
                              setState(() {
                                if(lista.length > 0) {
                                  this.listaDBConta = lista;
                                  this.cardContaNew = false;
                                } else {
                                  this.listaDBConta = lista;
                                  this.cardContaNew = true;
                                }        
                              });
                            }
                          );
                        },
                      )
                    ]
                  ),
                ),
              )
              :
              new Container( // Card Contas
                padding: new EdgeInsets.only(bottom: 6.0, right: 6.0, left: 6.0),
                child: new  Card(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildListaContas(this.listaDBConta)                    
                  ),
                ),
              ),

              this.cardCartaoNew ? 
              new Container( // Card Cartao
                padding: new EdgeInsets.only(bottom: 6.0, right: 6.0, left: 6.0),
                child: new  Card(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(bottom: 8.0, top: 26.0),
                        child: new Icon(
                          Icons.credit_card,
                          color: cinzaDrawer,
                          size: 40.0
                        ),
                      ),
                      new GestureDetector(
                        child: new Container(
                          padding: new EdgeInsets.only(bottom: 26.0, top: 8.0),
                          child: new Chip(label: const Text('Adicionar cartões')),
                        ),
                        onTap: () async {
                          await Navigator.of(context).push(new PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new CartaoPage();
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
                          cartaoDB.getAllCartaoAtivos().then(
                            (lista) {
                              setState(() {
                                if(lista.length > 0) {
                                  this.listaDBCartao = lista;
                                  this.cardCartaoNew = false;
                                } else {
                                  this.listaDBCartao = lista;
                                  this.cardCartaoNew = true;
                                }        
                              });
                            }
                          );
                        },
                      )
                    ]
                  ),
                ),
              )
              :
              new Container( // Card Cartoes
                padding: new EdgeInsets.only(bottom: 6.0, right: 6.0, left: 6.0),
                child: new  Card(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildListaCartoes(this.listaDBCartao)                    
                  ),
                ),
              ),

              new CardAlertas(),
              new Container(
                height: 70.0,
              )
            ],
          ),

          // float button
          new Positioned(
              bottom: 0.0,
              child: new GestureDetector(
                onTap: _rotate,
                child: new AnimatedBuilder(
                  animation: _animation,
                  builder: (BuildContext context, Widget child) {
                    return new Container(
                      height: _height,
                      child: new CustomPaint(
                        painter: new Sky(_width, _height * _animation.value),
                        child: new Container(
                          height: _isRotated ? 0.0 : _height * _animation.value,
                          width: _isRotated ? 0.0 : _width,
                        ),
                      ),
                    );
                  }
                ),
              )
            ),
            new Positioned(
              bottom: 200.0,
              right: 24.0,
              child: new Container(
                child: new Row(
                  children: <Widget>[
                    new ScaleTransition(
                      scale: _animation3,
                      alignment: FractionalOffset.center,
                      child: new Container(
                        margin: new EdgeInsets.only(right: 16.0),
                        child: new Text(
                          'transferência',
                          style: new TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E),
                            fontWeight: FontWeight.bold,
                          ),
                        ), 
                      ),
                    ),
                    
                    new ScaleTransition(
                      scale: _animation3,
                      alignment: FractionalOffset.center,
                      child: new Material(
                        color: new Color(0xFF9E9E9E),
                        type: MaterialType.circle,
                        elevation: 6.0,
                        child: new GestureDetector(
                          child: new Container(
                            width: 40.0,
                            height: 40.0,
                            child: new InkWell(
                              onTap: ()  async {
                                if(_angle == 45.0){
                                  _rotate();
                                  
                                  bool isLoggedIn = await Navigator.of(context).push(new PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (BuildContext context, _, __) {
                                      return new LancamentoPage(false, new Lancamento(), new Color(0xFF9E9E9E));
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
                                  //_interstitialAd = createInterstitialAd()..load();
                                  //_interstitialAd ??= createInterstitialAd();
                                  //_interstitialAd..load()..show();
                                }
                              },
                              child: new Center(
                                child: new Icon(
                                  Icons.add,
                                  color: new Color(0xFFFFFFFF),
                                ),                      
                              ),
                            )
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              )
            ),
          
          new Positioned(
            bottom: 144.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: _animation2,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Text(
                        'receita',
                        style: new TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF9E9E9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ), 
                    ),
                  ),

                  new ScaleTransition(
                    scale: _animation2,
                    alignment: FractionalOffset.center,
                    child: new Material(
                      color: new Color(0xFF00BFA5),
                      type: MaterialType.circle,
                      elevation: 6.0,
                      child: new GestureDetector(
                        child: new Container(
                          width: 40.0,
                          height: 40.0,
                          child: new InkWell(
                            onTap: () async {
                              if(_angle == 45.0) {
                                _rotate();
                                
                                bool isLoggedIn = await Navigator.of(context).push(new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new LancamentoPage(false, new Lancamento(), new Color(0xFF00BFA5));
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
                                //_interstitialAd = createInterstitialAd()..load();
                                //_interstitialAd ??= createInterstitialAd();
                                //_interstitialAd..load()..show();
                              }
                            },
                            child: new Center(
                              child: new Icon(
                                Icons.add,
                                color: new Color(0xFFFFFFFF),
                              ),
                            ),
                          )
                        ),
                      )
                    ),
                  ), 
                ],
              ),
            )
          ),
          new Positioned(
            bottom: 88.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: _animation,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Text(
                        'despesa',
                        style: new TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF9E9E9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ), 
                    ),
                  ),
                  
                  new ScaleTransition(
                    scale: _animation,
                    alignment: FractionalOffset.center,
                    child: new Material(
                      color: new Color(0xFFE57373),
                      type: MaterialType.circle,
                      elevation: 6.0,
                      child: new GestureDetector(
                        child: new Container(
                          width: 40.0,
                          height: 40.0,
                          child: new InkWell(
                            onTap: () async {
                              if(_angle == 45.0){
                                _rotate();
                                
                                bool isLoggedIn = await Navigator.of(context).push(new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new LancamentoPage(false, new Lancamento(), new Color(0xFFE57373));
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
                                //_interstitialAd = createInterstitialAd()..load();
                                //_interstitialAd ??= createInterstitialAd();
                                //_interstitialAd..load()..show();
                              }
                            },
                            child: new Center(
                              child: new Icon(
                                Icons.add,
                                color: new Color(0xFFFFFFFF),
                              ),                      
                            ),
                          )
                        ),
                      )
                    ),
                  ), 
                ],
              ),
            )
          ),
          
          new Positioned(
            bottom: 16.0,
            right: 16.0,
            child: new Material(
              color: new Color(0xFFE57373),
              type: MaterialType.circle,
              elevation: 6.0,
              child: new GestureDetector(
                child: new Container(
                  width: 56.0,
                  height: 56.00,
                  child: new InkWell(
                    onTap: _rotate,
                    child: new Center(
                      child: new RotationTransition(
                        turns: new AlwaysStoppedAnimation(_angle / 360),
                        child: new Icon(
                          Icons.add,
                          color: new Color(0xFFFFFFFF),
                        ),
                      )
                    ),
                  )
                ),
              )
            ),
          ),
        ]
      )
    );
  }
}

class Sky extends CustomPainter {
  final double _width;
  double _rectHeight;

  Sky(this._width, this._rectHeight);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      new Rect.fromLTRB(
        0.0, size.height - _rectHeight, this._width, size.height
      ),
      new Paint()..color = new Color.fromRGBO(255, 255, 255, 0.9)
    );
  }

  @override
  bool shouldRepaint(Sky oldDelegate) {
    return _width != oldDelegate._width || _rectHeight != oldDelegate._rectHeight;
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
  Conta contaDB = new Conta();

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        print('contascontas');
      },
      child: new ListTile(
        leading: new CircleAvatar(
          backgroundColor: widget.cor,
          radius: 16.0,
        ),
        title: new Text(
          widget.conta,
          style: new TextStyle(
            fontSize: 13.0,
            fontFamily: 'Roboto',
            color: new Color(0xFF212121),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: new Text(
          widget.tipo,
          style: new TextStyle(
            fontSize: 12.0,
            fontFamily: 'Roboto',
            color: new Color(0xFF9E9E9E)
          ),
        ),
        trailing: new Text(
          'R\$ 3.051,00',
          style: new TextStyle(
            fontSize: 16.0,
            fontFamily: 'Roboto',
            color: new Color(0xFF26C6DA)
          ),
        )
      ), 
      
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
  Cartao cartaoDB = new Cartao();

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
        print('cartoescartoes');
      },
      child: new Container(
        padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
        child: new Row(        
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.only(right: 24.0),
              child: new CircleAvatar(
                backgroundColor: widget.cor, //0xFFF5F5F5
                radius: 16.0,
              )
            ),
            new Expanded(
              child: new Container(
                padding: new EdgeInsets.only(right: 13.0),
                child: new Text(
                  widget.cartao,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Roboto',
                    color: new Color(0xFF212121),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Text(
                        'Fatura  ',
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF9E9E9E)
                        ),
                      ),
                      new Text(
                        'R\$ 00,00',
                        style: new TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF212121)
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Text(
                        'Limite  ',
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF9E9E9E)
                        ),
                      ),
                      new Text(
                        'R\$ ' + widget.limite.toString(),
                        style: new TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF9E9E9E)
                        ),
                      ),
                    ],
                  ),
                ]
              )
            )
          ]
        ),
      )
    );
  }
}

