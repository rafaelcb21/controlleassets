import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../palette/palette.dart';
import '../db/database.dart';

class ConsultaLancamentoPage extends StatefulWidget {
  @override
  ConsultaLancamentoPageState createState() => new ConsultaLancamentoPageState();
}

class ConsultaLancamentoPageState extends State<ConsultaLancamentoPage>{
  Color azulAppbar = new Color(0xFF26C6DA);
  Lancamento lancamentoDB = new Lancamento();
  List<Widget> listaLancamentos = [];
  List listaDB = [];
  Palette listaCores = new Palette();
  List cores = [];

  @override
  Widget build(BuildContext context) {


    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Lancamentos'),
        backgroundColor: azulAppbar,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.filter_list),
            color: new Color(0xFFFFFFFF),
            onPressed: () {}
          )
        ],
      ),
      body: new ListView(
        padding: new EdgeInsets.only(top: 16.0),
        children: <Widget>[

          ///Filtro
          new Container(
            padding: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                bottom: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.black12,
                ),
              )
            ),
            child: new Row(
              children: <Widget>[
                new Text(
                  'Filtro:  ',
                  style: new TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Roboto',
                    color: new Color(0xFF9E9E9E)
                  ),
                ),
              ],
            ),
          ),

          ///Mes
          new Container(
            padding: new EdgeInsets.only(bottom: 9.0, top: 9.0),
            child: new Row(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.only(left: 8.0),
                  child: new InkWell(
                    onTap: (){},
                    child: new Icon(
                      Icons.keyboard_arrow_left,
                      color: new Color(0xFF9E9E9E),
                      size: 28.0,
                    ),
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new InkWell(
                        onTap: (){},
                        child: new Text(
                          "Dezembro de 2017",
                          style: new TextStyle(
                            fontSize: 16.0,
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.only(right: 8.0),
                  child: new InkWell(
                    onTap: (){},
                    child: new Icon(
                      Icons.keyboard_arrow_right,
                      color: new Color(0xFF9E9E9E),
                      size: 28.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          

          ///Dia
          new Container(
            padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0, top: 5.0),
            decoration: new BoxDecoration(
              border: new Border(
                bottom: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.black12,
                ),
                top: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.black12,
                ),
              )
            ),
            child: new Row(
              children: <Widget>[
                new Text(
                  '1 de dezembro',
                  style: new TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Roboto',
                    color: new Color(0xFF9E9E9E)
                  ),
                ),
              ],
            ),
          ),

          ///Lancamento
          new ItemLancamento(),
          
        ]
      )
    );
  }
}

class ItemLancamento extends StatefulWidget {
   
  final int id;
  final String tag;
  final int numeroCor;
  final String relacionada;
  final Color cor;
  final int ativada;
  final VoidCallback onPressed;
  final VoidCallback onPressed3;

  ItemLancamento({
    Key key,

    this.id,
    this.tag,
    this.relacionada,
    this.cor,
    this.numeroCor,
    this.ativada,
    this.onPressed,
    this.onPressed3}) : super(key: key);

  @override
  ItemLancamentoState createState() => new ItemLancamentoState();
}

enum DialogOptionsAction {
  cancel,
  ok
}

class ItemLancamentoState extends State<ItemLancamento> with TickerProviderStateMixin {
  ItemLancamentoState();

  Lancamento lancamentoDB = new Lancamento();
  AnimationController _controller;
  Animation<double> _animation;
  bool startFling = true;
  double abertura;

  void initState() {
    super.initState();
    _controller = new AnimationController(duration: 
      const Duration(milliseconds: 246), vsync: this);

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );
  }

  void _move(DragUpdateDetails details) {
    final double delta = details.primaryDelta / 304;
    _controller.value -= delta;
  }

  void _settle(DragEndDetails details) {
    if(this.startFling) {
      _controller.fling(velocity: 1.0);
      this.startFling = false;
    } else if(!this.startFling){
      _controller.fling(velocity: -1.0);
      this.startFling = true;
    }
  }

  void showDeleteDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { });
  }

  @override
  Widget build(BuildContext context) {
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;

    this.abertura = -(48.0/_width);

    return new GestureDetector(
      onHorizontalDragUpdate: _move,
      onHorizontalDragEnd: _settle,
      child: new Stack(
        children: <Widget>[
          new Positioned.fill(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                    color: new Color(0xFFE57373),
                  ),
                  padding: new EdgeInsets.all(12.0),
                  child: new GestureDetector(
                    onTap: (){},
                    child: new Icon(
                      Icons.delete,
                      color: new Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new SlideTransition(
            position: new Tween<Offset>(
              begin:  Offset.zero,
              end: new Offset(this.abertura, 0.0),
            ).animate(_animation),
            child: new Container(
              padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
              decoration: new BoxDecoration(
                color: new Color(0xFFFAFAFA),
                border: new Border(
                  bottom: new BorderSide(
                    style: BorderStyle.solid,
                    color: Colors.black12,
                  ),
                )
              ),
              child: new Row(
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.only(right: 8.0),
                    child: new Icon(
                      Icons.brightness_1,
                      color: new Color(0xFFE57373),
                      size: 10.0,
                    ),
                  ),
                  new Expanded(
                    child: new InkWell(
                      onTap: (){},
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            'Telefone fixo',
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF212121),
                            ),
                          ),
                          new Text(
                            'Telefonia',
                            style: new TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF9E9E9E)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    padding: new EdgeInsets.only(left: 8.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          '-137,00',
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFFE57373),
                          ),
                        ),
                        new Text(
                          'Pago',
                          style: new TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E)
                          ),
                        ),
                      ],
                    ),
                  ),
                      
                  new InkWell(
                    onTap: (){},
                    child: new Container(
                      padding: new EdgeInsets.only(left: 10.0),
                      child: new Icon(
                        Icons.thumb_up,
                        color: new Color(0xFF00BFA5),
                        size: 24.0,
                      ),
                    ),
                  )                
                ],
              ),
            )
          ),
        ],
      )
    );
  }
}

