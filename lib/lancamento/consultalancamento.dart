import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../palette/palette.dart';
import '../db/database.dart';
import 'package:intl/intl.dart';

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
  String periodoFiltro = "";

  @override
  void initState() {
    setState(() {
      lancamentoDB.getLancamento().then(
        (list) {
          setState(() {
            if(list.length > 0) {
              this.periodoFiltro = list.removeLast()[1];
              this.listaDB = list;
            }            
          });
        } //[[11 de dezembro, [{idcategoria: 8, idconta: 1, fatura: null, hash
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> buildLancamentos(lista) {
      
      this.listaLancamentos = [
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
                          this.periodoFiltro,
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
          )
        ];

        for(var i = 0; i < lista.length; i++) {
          ///Dia
          this.listaLancamentos.add(
            new Container(
              padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0, top: 5.0),
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
                    lista[i][0], //dia ex: 1 de fevereiro
                    style: new TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF9E9E9E)
                    ),
                  ),
                ],
              ),
            )
          );

          for(var u = 0; u < lista[i][1].length; u++) {
            var valor, textoPago;
            int pago = lista[i][1][u]['pago'];
            int id = lista[i][1][u]['id'];
            String data = lista[i][1][u]['data'];
            String hash = lista[i][1][u]['hash'];
            
            if(lista[i][1][u]['tipo'] == "Despesa"){
              var numeroNegativo = lista[i][1][u]['valor']*-1;
              var f = new NumberFormat.currency(locale: "pt_BR", symbol: "", decimalDigits: 2);
              valor = f.format(numeroNegativo);
              if(lista[i][1][u]['pago'] == 0){
                textoPago = "não pago";
              } else {
                textoPago = "pago";
              }
            } else {
              var f = new NumberFormat.currency(locale: 'pt_BR', symbol: "", decimalDigits: 2);
              valor = f.format(lista[i][1][u]['valor']);

              if(lista[i][1][u]['pago'] == 0 && lista[i][1][u]['tipo'] == "Receita"){
                textoPago = "não recebido";
              } else if(lista[i][1][u]['pago'] == 0 && lista[i][1][u]['tipo'] == "Transferência") {
                textoPago = "não transferido";
              } else if(lista[i][1][u]['pago'] == 1 && lista[i][1][u]['tipo'] == "Receita") {
                textoPago = "recebido";
              } else if(lista[i][1][u]['pago'] == 1 && lista[i][1][u]['tipo'] == "Transferência") {
                textoPago = "transferido";
              }
            }            
            
            this.listaLancamentos.add(
              new ItemLancamento(
                key: new ObjectKey(lista[i][1][u]),
                id: id,
                tipo: lista[i][1][u]['tipo'],
                categoria: lista[i][1][u]['categoria'],
                //idtag: lista[i][1][u]['idtag'],
                //idconta: lista[i][1][u]['idconta'],
                //idcontadestino: lista[i][1][u]['idcontadestino'],
                //idcartao: lista[i][1][u]['idcartao'],
                valor: valor,
                data: data,
                descricao: lista[i][1][u]['descricao'],
                //tiporepeticao: lista[i][1][u]['tiporepeticao'],
                //periodorepeticao: lista[i][1][u]['periodorepeticao'],
                //quantidaderepeticao: lista[i][1][u]['quantidaderepeticao'],
                //fatura: lista[i][1][u]['fatura'],
                pago: pago,
                textoPago: textoPago,
                hash: hash,
                onPressed2: () async {
                  void showDeleteDialog<T>({ BuildContext context, Widget child }) {
                    showDialog<T>(
                      context: context,
                      child: child,
                    )
                    .then<Null>((T value) { });
                  }

                  if(hash == null) {
                    showDeleteDialog<DialogOptionsAction>(
                      context: context,
                      child: new AlertDialog(
                        title: const Text('Deletar Lançamento'),
                        content: new Text(
                            'Deseja deletar esse lançamento?',
                            softWrap: true,
                            style: new TextStyle(
                              color: Colors.black45,
                              fontSize: 16.0,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                            )
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: const Text('CANCEL'),
                            onPressed: () {                                
                              Navigator.pop(context);
                            }
                          ),
                          new FlatButton(
                            child: const Text('OK'),
                            onPressed: () {
                              lancamentoDB.deleteLancamento(id);
                              lancamentoDB.getLancamento().then(
                                (list) {
                                  setState(() {
                                    this.periodoFiltro = list.removeLast()[1];
                                    this.listaDB = list;
                                  });
                                }
                              );
                              Navigator.pop(context);
                            }
                          )
                        ]
                      )
                    );
                  } else {
                    showDeleteDialog<DialogOptionsAction>(
                      context: context,
                      child: new AlertDialog(
                        title: const Text('Deletar Lançamento'),
                        content: new Container(
                          height: 120.0,
                          child: new Column(
                            children: <Widget>[
                              new GestureDetector(
                                onTap: (){
                                  lancamentoDB.deleteLancamento(id);
                                  lancamentoDB.getLancamento().then(
                                    (list) {
                                      setState(() {
                                        this.periodoFiltro = list.removeLast()[1];
                                        this.listaDB = list;
                                      });
                                    }
                                  );
                                  Navigator.pop(context);
                                },
                                child: new Container(
                                  margin: new EdgeInsets.only(bottom: 16.0),
                                  padding: new EdgeInsets.only(left: 16.0, right: 16.0),                                
                                  width: 250.0,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    color: new Color(0xFF9E9E9E),
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        'Deletar apenas esse',
                                        softWrap: true,
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500,
                                        )
                                      ),
                                    ],
                                  )
                                ),
                              ),
                              new GestureDetector(
                                onTap: (){
                                  lancamentoDB.deleteLancamentoRepetidos(data, hash);
                                  lancamentoDB.getLancamento().then(
                                    (list) {
                                      setState(() {
                                        this.periodoFiltro = list.removeLast()[1];
                                        this.listaDB = list;
                                      });
                                    }
                                  );
                                  Navigator.pop(context);
                                },
                                child: new Container(
                                  margin: new EdgeInsets.only(bottom: 16.0),
                                  padding: new EdgeInsets.only(left: 16.0, right: 16.0),                                
                                  width: 250.0,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    color: new Color(0xFF9E9E9E),
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        'Deletar esse e os próximos',
                                        softWrap: true,
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500,
                                        )
                                      ),
                                    ],
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    );
                  }
                },
                onPressed3: () {                  
                  lancamentoDB.updateLancamentoPago(lista[i][1][u]['id'], pago);
                  lancamentoDB.getLancamento().then(
                    (list) {
                      setState(() {
                        this.periodoFiltro = list.removeLast()[1];
                        this.listaDB = list;
                      });
                    }
                  );
                },
              )
            );
          }
        }
      return this.listaLancamentos;
    }

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
      body: this.listaDB == [] ? new Container() : 
        new ListView(
          padding: new EdgeInsets.only(top: 16.0),
          children: buildLancamentos(this.listaDB)
        )
    );
  }
}

class ItemLancamento extends StatefulWidget {   
  final int id;
  final String tipo;
  final String categoria;
  //final int idtag;
  //final int idconta;
  //final int idcontadestino;
  //final int idcartao;
  final String valor;
  final String data;
  final String descricao;
  //final String tiporepeticao;
  //final String periodorepeticao;
  //final int quantidaderepeticao;
  //final String fatura;
  final int pago;
  final String textoPago;
  final String hash;
  final VoidCallback onPressed;
  final VoidCallback onPressed2;
  final VoidCallback onPressed3;

  ItemLancamento({
    Key key,
    this.id,
    this.tipo,
    this.categoria,
    //this.idtag,
    //this.idconta,
    //this.idcontadestino,
    //this.idcartao,
    this.valor,
    this.data,
    this.descricao,
    //this.tiporepeticao,
    //this.periodorepeticao,
    //this.quantidaderepeticao,
    //this.fatura,
    this.pago,
    this.textoPago,
    this.hash,
    this.onPressed,
    this.onPressed2,
    this.onPressed3,}) : super(key: key);

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
                    onTap: widget.onPressed2,
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
                      widget.tipo != "Transferência" ? Icons.brightness_1 : Icons.swap_horizontal_circle,
                      color: widget.tipo != "Despesa" ? new Color(0xFF00BFA5) : new Color(0xFFE57373),
                      size: 10.0,
                    ),
                  ),
                  new Expanded(
                    child: new InkWell(
                      onTap: widget.onPressed,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            widget.descricao,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF212121),
                            ),
                          ),
                          new Text(
                            widget.categoria,
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
                          //widget.tipo != "Despesa" ? widget.valor.toString() : widget.valor,
                          widget.valor,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Roboto',
                            color: widget.tipo == "Despesa" ? new Color(0xFFE57373) : new Color(0xFF00BFA5),
                          ),
                        ),
                        new Text(
                          widget.textoPago,
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
                    onTap: widget.onPressed3,
                    child: new Container(
                      padding: new EdgeInsets.only(left: 10.0),
                      child: new Icon(
                        widget.pago == 0 ? Icons.thumb_down : Icons.thumb_up,
                        color: widget.pago == 0 ? new Color(0xFFE57373) : new Color(0xFF00BFA5),
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

