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
          new Container(
            margin: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
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
          new Row(
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
                  child: new IconButton(
                    icon: new Icon(Icons.delete),
                    color: new Color(0xFFFFFFFF),
                    onPressed: widget.onPressed3
                  )
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
              decoration: new BoxDecoration(
                border: new Border(
                  top: new BorderSide(style: BorderStyle.solid, color: Colors.black26),
                ),
                color: new Color(0xFFFFFFFF),
              ),
              margin: new EdgeInsets.only(top: 0.0, bottom: 0.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[          
                  new Expanded(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new InkWell(
                          onTap: widget.onPressed,
                          child: 
                            new Container(
                              margin: new EdgeInsets.only(left: 16.0),
                              padding: new EdgeInsets.only(right: 40.0, top: 4.5, bottom: 4.5),
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                    margin: new EdgeInsets.only(right: 16.0),
                                    child: new Icon(
                                      Icons.brightness_1,
                                      color: widget.cor,
                                      size: 35.0,
                                    ),  
                                  ),
                                  new Text(
                                    widget.tag,
                                    style: new TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            )
                          )
                        ),
                      ],
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

