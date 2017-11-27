import "package:flutter/material.dart";

import './db/database.dart';
import "home/card_saldo.dart";
import "home/card_contas.dart";
import "home/card_cartoes.dart";
import "home/card_alertas.dart";
import "lancamento/lancamento.dart";
import "categoria/categoria.dart";
import "conta/conta.dart";
import "cartao/cartao.dart";
import "tag/tag.dart";
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
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new HomePage(),
        '/categoria': (BuildContext context) => new CategoriaPage(),
        '/tag': (BuildContext context) => new TagPage(),
        '/conta': (BuildContext context) => new ContaPage(),
        '/cartao': (BuildContext context) => new CartaoPage(),
        //'/novacategoria': (BuildContext context) => new NovaCategoriaPage(),
        //'/conta': (BuildContext context) => new LancamentoPage()
      },
    );
  }
}



class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  DatabaseClient db = new DatabaseClient();
  int _angle = 90;
  bool _isRotated = true;

  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;
  Animation<double> _animation3;

  createdb() async {
    await db.create();
  }


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
    
    super.initState();
    createdb();
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

    return new Scaffold( 
      appBar: new AppBar(
        backgroundColor: azulAppbar,
        //actions: <Widget>[
        //  new IconButton(
        //    icon: const Icon(Icons.add_circle),
        //    color: new Color(0xFFFFFFFF),
        //    onPressed: () {
        //      showDialog(
        //        context: context,
        //        child: new SimpleDialog(
        //          children: <Widget>[
        //            new FlatButton(
        //              textColor: new Color(0xFF9E9E9E),
        //              child: new Row(
        //                children: <Widget>[
        //                  new Icon(
        //                    Icons.add_circle,
        //                    size: 24.0
        //                  ),
        //                  new Container(
        //                    padding: new EdgeInsets.only(left: 16.0),
        //                    child: new Text(
        //                      'transferência',
        //                      style: new TextStyle(
        //                        fontFamily: 'Roboto',
        //                        fontSize: 16.0
        //                      ),
        //                    ),
        //                  )
        //                ],
        //              ),
        //              onPressed: () async {
        //                //_bannerAd?.dispose();
        //                //_bannerAd = null;
        //                Navigator.pop(context);
        //                bool isLoggedIn = await Navigator.of(context).push(new PageRouteBuilder(
        //                  opaque: false,
        //                  pageBuilder: (BuildContext context, _, __) {
        //                    return new LancamentoPage(new Color(0xFF9E9E9E));
        //                  },
        //                  transitionsBuilder: (
        //                    BuildContext context,
        //                    Animation<double> animation,
        //                    Animation<double> secondaryAnimation,
        //                    Widget child,
        //                  ) {
        //                    return new SlideTransition(
        //                      position: new Tween<Offset>(
        //                        begin:  const Offset(1.0, 0.0),
        //                        end: Offset.zero,
        //                      ).animate(animation),
        //                      child: child,
        //                    );
        //                  }
        //                ));
        //                _interstitialAd = createInterstitialAd()..load();
        //                _interstitialAd ??= createInterstitialAd();
        //                _interstitialAd..load()..show();
        //                  //_bannerAd ??= createBannerAd();
        //                  //_bannerAd..load()..show();
        //                
        //              },
        //            ),
        //            new FlatButton(
        //              textColor: new Color(0xFF00BFA5),
        //              child: new Row(
        //                children: <Widget>[
        //                  new Icon(
        //                    Icons.add_circle,
        //                    size: 24.0
        //                  ),
        //                  new Container(
        //                    padding: new EdgeInsets.only(left: 16.0),
        //                    child: new Text(
        //                      'receita',
        //                      style: new TextStyle(
        //                        fontFamily: 'Roboto',
        //                        fontSize: 16.0
        //                      ),
        //                    ),
        //                  )
        //                ],
        //              ),                
        //              onPressed: () async {
        //                //_bannerAd?.dispose();
        //                //_bannerAd = null;
        //                Navigator.pop(context);
        //                bool isLoggedIn = await Navigator.of(context).push(new PageRouteBuilder(
        //                  opaque: false,
        //                  pageBuilder: (BuildContext context, _, __) {
        //                    return new LancamentoPage(new Color(0xFF00BFA5));
        //                  },
        //                  transitionsBuilder: (
        //                    BuildContext context,
        //                    Animation<double> animation,
        //                    Animation<double> secondaryAnimation,
        //                    Widget child,
        //                  ) {
        //                    return new SlideTransition(
        //                      position: new Tween<Offset>(
        //                        begin:  const Offset(1.0, 0.0),
        //                        end: Offset.zero,
        //                      ).animate(animation),
        //                      child: child,
        //                    );
        //                  }
        //                ));
        //                _interstitialAd = createInterstitialAd()..load();
        //                _interstitialAd ??= createInterstitialAd();
        //                _interstitialAd..load()..show();
        //                  //_bannerAd ??= createBannerAd();
        //                  //_bannerAd..load()..show();
        //                
        //              },
        //            ),
        //            new FlatButton(
        //              textColor: new Color(0xFFE57373),
        //              child: new Row(
        //                children: <Widget>[
        //                  new Icon(
        //                    Icons.add_circle,
        //                    size: 24.0
        //                  ),
        //                  new Container(
        //                    padding: new EdgeInsets.only(left: 16.0),
        //                    child: new Text(
        //                      'despesa',
        //                      style: new TextStyle(
        //                        fontFamily: 'Roboto',
        //                        fontSize: 16.0
        //                      ),
        //                    ),
        //                  )
        //                ],
        //              ),                
        //              onPressed: () async {
        //                //_bannerAd?.dispose();
        //                //_bannerAd = null;
        //                Navigator.pop(context);
        //                bool isLoggedIn = await Navigator.of(context).push(new PageRouteBuilder(
        //                  opaque: false,
        //                  pageBuilder: (BuildContext context, _, __) {
        //                    return new LancamentoPage(new Color(0xFFE57373));
        //                  },
        //                  transitionsBuilder: (
        //                    BuildContext context,
        //                    Animation<double> animation,
        //                    Animation<double> secondaryAnimation,
        //                    Widget child,
        //                  ) {
        //                    return new SlideTransition(
        //                      position: new Tween<Offset>(
        //                        begin:  const Offset(1.0, 0.0),
        //                        end: Offset.zero,
        //                      ).animate(animation),
        //                      child: child,
        //                    );
        //                  }
        //                ));
        //                  _interstitialAd = createInterstitialAd()..load();
        //                  _interstitialAd ??= createInterstitialAd();
        //                  _interstitialAd..load()..show();
        //                  //_bannerAd ??= createBannerAd();
        //                  //_bannerAd..load()..show();
        //                
        //              },
        //            ),
        //          ],
        //        )
        //      );
        //    },
        //  )
        //],
      ),
      drawer: new Drawer(
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
              onTap: (){
                Navigator.pop(context);
                Navigator.of(context).push(new PageRouteBuilder(
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
              onTap: (){
                Navigator.pop(context);
                Navigator.of(context).push(new PageRouteBuilder(
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
              new CardSaldo(),
              new CardContas(),
              new CardCartoes(),
              new CardAlertas(),
              new Container(
                height: 70.0,
              )
            ],
          ),
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