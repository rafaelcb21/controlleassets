import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';
import './textpicker.dart';
import 'package:numberpicker/numberpicker.dart';
import '../db/database.dart';
import '../palette/palette.dart';

class LancamentoPage extends StatefulWidget {
  final Color color;
  LancamentoPage(this.color);
  LancamentoPageStatus createState() => new LancamentoPageStatus(this.color);
}
 
class LancamentoPageStatus extends State<LancamentoPage> with TickerProviderStateMixin{
  LancamentoPageStatus(this.color);
  final Color color;
  ValueNotifier<List<int>> numeros = new ValueNotifier<List<int>>(<int>[]);
 
  AnimationController _controller;
  //AnimationController _controller2;
  Animation _animation;
  //Animation _animation2;
  Animation<double> _frontScale;
  Animation<double> _backScale;
 
  String numeroBrasil(List<int> numerosLista){
    if(numerosLista.length == 0) {
      return '0,00';
    }
    if(numerosLista.length == 1) {
      return '0,0' + numerosLista[0].toString();
    }
   if(numerosLista.length == 2) {
      return '0,' + numerosLista[0].toString() + numerosLista[1].toString();
    }
    if(numerosLista.length >= 3) {
      List<int> inteiroLista = numerosLista.getRange(0, numerosLista.length -2);
      List<int> decimalLista = numerosLista.getRange(numerosLista.length -2, numerosLista.length);
      String inteiroListaString = inteiroLista.map((i) => i.toString()).join('');
      String decimalListaString = decimalLista.map((i) => i.toString()).join('');
 
      var f = new NumberFormat("#,###,###,###,###.00", "pt_BR");
      var valor = f.format(double.parse(inteiroListaString + '.' + decimalListaString));
      return  valor;
 
    }
  }
 
  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
 
    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );

    //_animation2 = new CurvedAnimation(
    //  parent: _controller2,
    //  curve: new Interval(0.0, 1.0, curve: Curves.linear),
    //);
 
    _frontScale = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 0.5, curve: Curves.easeIn),
    ));
    _backScale = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.easeOut),
    );
 
    _controller.forward();

    super.initState();
  }
 
  void action() {
    setState((){
        _controller.reverse();
    });   
  }
 
  void back() {
    setState((){
        _controller.forward();

    });   
  }
 
  @override
  Widget build(BuildContext context) {
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;
 
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new SingleChildScrollView(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new GestureDetector(
                  onTap: back,
                  child: new NumberDisplay(color, numeros),
                ),
                new Stack(
                  children: <Widget>[
                    new AnimatedBuilder(
                      animation: _backScale,
                      child: new Teclado(color, numeros),
                      builder: (BuildContext context, Widget child) {
                        final Matrix4 transform = new Matrix4.identity()
                          ..scale(1.0, _backScale.value, 1.0);
                        return new Transform(
                          transform: transform,
                          alignment: FractionalOffset.center,
                          child: child,
                        );
                      },
                    ),
                    new AnimatedBuilder(
                      animation: _frontScale,
                      child: new Formulario(this.color, this.numeros),
                      builder: (BuildContext context, Widget child) {
                        final Matrix4 transform = new Matrix4.identity()
                          ..scale(1.0, _frontScale.value, 1.0);
                        return new Transform(
                          transform: transform,
                          alignment: FractionalOffset.center,
                          child: child,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
 
          //new Stack(
          //  children: <Widget>[
          //    new Positioned(
          //      bottom: 16.0,
          //      left: (_width / 2) - 28,
          //      child: new ScaleTransition(
          //        alignment: FractionalOffset.center,
          //        scale: new Tween(begin: 1.0, end: 0.0).animate(_animation),
          //        child: new FloatingActionButton(
          //          backgroundColor: color,
          //          child: new Icon(Icons.check),
          //          onPressed: (){
          //            //action();
          //          }
          //        ),
          //      ),
          //    ),
          //    new Positioned(
          //      bottom: 16.0,
          //      left: (_width / 2) - 28,
          //      child: new ScaleTransition(
          //        alignment: FractionalOffset.center,
          //        scale: _animation,
          //        child: new FloatingActionButton(
          //          backgroundColor: color,
          //          child: new Icon(Icons.check),
          //          onPressed: (){
          //            action();
          //          }
          //        ),
          //      ),
          //    ),
          //  ],
          //),
          
          new Positioned(
            bottom: 36.0,
            left: (_width / 2) - 44,
            child: new ScaleTransition(
              scale: _animation,
              child: new RaisedButton(
                color: color,
                child: const Text(
                  'OK',
                  style: const TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: 24.0
                  )
                ),//new Icon(Icons.check, color: new Color(0xFFFFFFFF),),
                onPressed: (){
                  action();
                }
              ),
            ),
          )


        ]
      ),
    );
  }
}
 
class NumberDisplay extends AnimatedWidget {
  NumberDisplay(this.color, this.numbers) : super(listenable: numbers);
 
  final ValueNotifier<List<int>> numbers;
  final Color color;
 
  String numeroBrasil(List<int> numerosLista){
    if(numerosLista.length == 0) {
      return '0,00';
    }
    if(numerosLista.length == 1) {
      return '0,0' + numerosLista[0].toString();
    }
    if(numerosLista.length == 2) {
      return '0,' + numerosLista[0].toString() + numerosLista[1].toString();
    }
    if(numerosLista.length == 3 && numerosLista[0] == 0){
      return '0,' + numerosLista[1].toString() + numerosLista[2].toString();
    }
    if(numerosLista.length >= 3) {
      List<int> inteiroLista = numerosLista.sublist(0, numerosLista.length -2);
      List<int> decimalLista = numerosLista.sublist(numerosLista.length -2, numerosLista.length);
      String inteiroListaString = inteiroLista.map((i) => i.toString()).join('');
      String decimalListaString = decimalLista.map((i) => i.toString()).join('');
 
      var f = new NumberFormat("#,###,###,###,###.00", "pt_BR");
      var valor = f.format(double.parse(inteiroListaString + '.' + decimalListaString));
      return  valor;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 145.0,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.only(right: 16.0, top: 35.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(
                  'R\$  ',
                  style: new TextStyle(
                    fontFamily: 'Roboto',
                    color: new Color(0xFFFFFFFF),
                    fontSize: 20.0
                  )
                ),
                new Text(
                  numeroBrasil(this.numbers.value),
                  style: new TextStyle(
                    fontFamily: 'Roboto',
                    color: new Color(0xFFFFFFFF),
                    fontSize: 45.0
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      color: color,
    );
  }
}
 
class Teclado extends StatelessWidget {
  Teclado(this.color, this.numeros);
  final Color color;
  final ValueNotifier<List<int>> numeros;
 
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(right: 15.0, left: 15.0, top: 32.0, bottom: 0.0),
      child: new Column(
        children: <Widget>[
          new Row(          
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new FlatButton(
                textColor: color,
                child: new Text(
                  '1',
                  style: new TextStyle(
                    fontSize: 35.0,
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(1);
                },
              ),
              new FlatButton(
                textColor: color,
                child: new Text(
                  '2',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(2);
                },
              ),
              new FlatButton(
                textColor: color,
                child: new Text(
                  '3',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(3);
                },
              ),
            ],
          ),
          new Container(height: 30.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new FlatButton(
                textColor: color,
                child: new Text(
                  '4',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(4);
                },
              ),
              new FlatButton(
                textColor: color,
                child: new Text(
                  '5',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(5);
                },
              ),
              new FlatButton(
                textColor: color,
                child: new Text(
                  '6',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(6);
                },
              ),
            ],
          ),
          new Container(height: 30.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new FlatButton(
                textColor: color,
                child: new Text(
                  '7',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(7);
                },
              ),
              new FlatButton(
                textColor: color,
                child: new Text(
                  '8',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(8);
                },
              ),
              new FlatButton(
                textColor: color,
                child: new Text(
                  '9',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(9);
                },
              ),
            ],
          ),
          new Container(height: 30.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new FlatButton(
                textColor: color,
                child: new Text(
                  ' ',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {},
              ),
              new FlatButton(
                textColor: color,
                child: new Text(
                  '0',
                  style: new TextStyle(
                    fontSize: 35.0
                  ),
                ),
                onPressed: () {
                  numeros.value = new List.from(numeros.value)..add(0);
                },
              ),
              new FlatButton(
                textColor: color,
 
                child: new Icon(
                  Icons.backspace,
                  size: 35.0
                ),
                onPressed: () {
                  if(numeros.value.length > 0) {
                    numeros.value = new List.from(numeros.value)..removeLast();
                  }
                },
              ),
            ],
          ),
          //new Container(height: 30.0),

          //new Row(
          //  mainAxisAlignment: MainAxisAlignment.center,
          //  children: <Widget>[
          //    new FloatingActionButton(
          //      backgroundColor: color,
          //      child: new Icon(Icons.check),
          //      onPressed: (){
          //        action();
          //      }
          //    ),
          //  ],
          //),
          
        ],
      ),
    );
  }
}

//enum RadioGroup {
//  fixo,
//  parcelado
//}

class Formulario extends StatefulWidget {
  final Color color;
  final ValueNotifier<List<int>> numeros;

  Formulario(this.color, this.numeros);
  @override
  FormularioState createState() => new FormularioState(this.color, this.numeros);
}

typedef void MyFormCallback(String result);

class MyForm extends StatefulWidget {
  final MyFormCallback onSubmit;

  MyForm({this.onSubmit});

  @override
  _MyFormState createState() => new _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String value = "Fixa";
  int _currentValueFixo = 3;
  int _currentValueParcelado = 3;
  int _currentValue = 2;

  List fixoList = ['Diária', 'Semanal', 'Quinzenal', 'Mensal', 
                'Bimestral', 'Trimestral', 'Semestral', 'Anual'];

  List parceladoList = ['Dias', 'Semanas', 'Quinzenas', 'Meses', 
                          'Bimestres', 'Trimestres', 'Semestres', 'Anos'];
  
  

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Repetir"),
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Radio(
              groupValue: value,
              onChanged: (value) => setState(() => this.value = value),
              value: "Fixa",
            ),
            const Text("Fixa"),
            new Radio(
              groupValue: value,
              onChanged: (value) => setState(() => this.value = value),
              value: "Parcelada",
            ),
            const Text("Parcelada"),
          ],
        ),
        this.value == "Fixa"
        ?
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new TextPicker(
                initialValue: _currentValueFixo,
                listName: this.fixoList,
                onChanged: (newValue) =>
                  setState(() => _currentValueFixo = newValue)
              ),
            ],
          )
        :
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new NumberPicker.integer(
                initialValue: _currentValue,
                minValue: 2,
                maxValue: 360,
                onChanged: (newValue) =>
                    setState(() => _currentValue = newValue)),

              new TextPicker(
                initialValue: _currentValueParcelado,
                listName: this.parceladoList,
                onChanged: (newValue) =>
                  setState(() => _currentValueParcelado = newValue)
              ),
            ],
          ),

        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
            if(value == 'Fixa') {
              widget.onSubmit(value + ';' + this.fixoList[_currentValueFixo]);
            } else {
              widget.onSubmit(value + ';' +  _currentValue.toString() + ';' + 
                parceladoList[_currentValueParcelado]);
            }
            
          },
          child: new Container(
            margin: new EdgeInsets.only(right: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(
                  "OK",
                  style: new TextStyle(
                    fontSize: 16.0
                  ),
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}
typedef void MyFormCallback2(String result);

class MyForm2 extends StatefulWidget {
  final MyFormCallback2 onSubmit;

  MyForm2({this.onSubmit});

  @override
  _MyFormState2 createState() => new _MyFormState2();
}

class _MyFormState2 extends State<MyForm2> {
  int _currentValueDividido = 3;
  int _currentValue = 2;

  List periodoList = ['Dias', 'Semanas', 'Quinzenas', 'Meses', 
                          'Bimestres', 'Trimestres', 'Semestres', 'Anos'];  

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Dividir"),
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new NumberPicker.integer(
              initialValue: _currentValue,
              minValue: 2,
              maxValue: 360,
              onChanged: (newValue) =>
                  setState(() => _currentValue = newValue)),

            new TextPicker(
              initialValue: _currentValueDividido,
              listName: this.periodoList,
              onChanged: (newValue) =>
                setState(() => _currentValueDividido = newValue)
            ),
          ],
        ),

        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmit(_currentValue.toString() + ';' + 
              periodoList[_currentValueDividido]);
          },
          child: new Container(
            margin: new EdgeInsets.only(right: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(
                  "OK",
                  style: new TextStyle(
                    fontSize: 16.0
                  ),
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}

class FormularioState extends State<Formulario> {
  final Color color;
  final ValueNotifier<List<int>> numeros;

  FormularioState(this.color, this.numeros);
  //RadioGroup itemType = RadioGroup.fixo;
  DateTime _toDate = new DateTime.now();
  String _valueText = " ";
  String _valueTextCartao = " ";
  String _valueTextContaDestino = " ";
  String _valueTextTag = " ";
  List<Widget> listaCategorias = [];
  List<Widget> listaTags = [];
  List<Widget> listaContas = [];
  List<Widget> listaContasOrigem = [];
  List<Widget> listaContasDestino = [];
  List<Widget> listaCartoes = [];
  List<Widget> listaContasCartoes = [];
  List<Widget> faturasLista = [];
  Categoria categoriaDB = new Categoria();
  Tag tagDB = new Tag();
  Conta contaDB = new Conta();
  Cartao cartaoDB = new Cartao();
  Lancamento lancamentoDB = new Lancamento();
  List listaCategoriasDB = [];
  List listaTagsDB = [];
  List listaContasDB = [];
  List listaCartoesDB = [];
  bool isCard = false;
  String fechamento;
  String nomeMes;

  List cores = [];
  Palette listaCores = new Palette();
  
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  final TextEditingController _controller = new TextEditingController();

  Map formSubmit = {'tipo':'', 'valor':'' ,'data':new DateTime.now().toString(), 'idcategoria':0,
    'categoria':'', 'tag':'', 'idtag':0, 'conta':' ', 'idconta':0, 'contadestino':' ',
    'idcontadestino':0, 'cartao':' ','idcartao':0, 'descricao':'', 'repetir':'', 'dividir':'', "fatura":''};
    //falta colocar se eh cartao ou nao, e se for qual sera a fatura que sera lancada
    //se for cartao e tiver repeticao lancar o valor nas fatura corretas se for
    //  fixa lancar somente do mes atual ou lancar as parceladas tb somente no mes atual
    //conta destino nao pode ser igual a conta origem
    //se tiver repeticao e for fixa lancara somente do mes atual,
    //  e qdo for para o mes seguinte ou no relatorio lancara as repeticoes que nao
    //  foram lancadas
  void initState(){
    this.cores = listaCores.cores;

    if(color == const Color(0xFFE57373)){
      tagDB.getTagGroup('receita').then((list) {
        this.listaTagsDB = list;
      });
    } else if(this.color == const Color(0xFF00BFA5)) {
      tagDB.getTagGroup('despesa').then((list) {
        this.listaTagsDB = list;
      });
    } else {
      tagDB.getAllTag().then((list) {
        this.listaTagsDB = list;
      });
    }   

    categoriaDB.getAllCategoria().then((list) {
      setState(() {
        this.listaCategoriasDB = list;
      });
    });

    contaDB.getAllContaAtivas().then((list) {
      setState(() {
        this.listaContasDB = list;
      });
    });

    cartaoDB.getAllCartaoAtivos().then((list) {
      setState(() {
        this.listaCartoesDB = list;
      });
    });
  }

  String tagDdespesaOUreceita(color) {
    if(color == const Color(0xffe57373)){
      return 'Despesa ';
    } else {
      return 'Receita ';
    }
  }

  String despesaOUreceita(color, String frase) {
    var fraseLowerCaseList = frase.toLowerCase().split(';');
    if(fraseLowerCaseList.length == 3) {
      fraseLowerCaseList.insert(1, 'em');
    }
    if(color == const Color(0xffe57373)){
      return 'Despesa ' + fraseLowerCaseList.join(' ');
    } else if(this.color == const Color(0xff9e9e9e)) {
      return 'Transf. ' + fraseLowerCaseList.join(' ');
    } else {
      return 'Receita ' + fraseLowerCaseList.join(' ');
    }
  }

  String dividirLabel(color, String frase) {
    var fraseLowerCaseList = frase.toLowerCase().split(';');
    fraseLowerCaseList.insert(0, 'dividida em');
    if(color == const Color(0xffe57373)){
      return 'Despesa ' + fraseLowerCaseList.join(' ');
    } else if(this.color == const Color(0xff9e9e9e)) {
      return 'Transf. ' + fraseLowerCaseList.join(' ');
    } else {
      return 'Receita ' + fraseLowerCaseList.join(' ');
    }
  }

  String numeroUSA(List<int> numerosLista){
    if(numerosLista.length == 0) {
      return '0.00';
    }
    if(numerosLista.length == 1) {
      return '0.0' + numerosLista[0].toString();
    }
    if(numerosLista.length == 2) {
      return '0.' + numerosLista[0].toString() + numerosLista[1].toString();
    }
    if(numerosLista.length == 3 && numerosLista[0] == 0){
      return '0.' + numerosLista[1].toString() + numerosLista[2].toString();
    }
    if(numerosLista.length >= 3) {
      List<int> inteiroLista = numerosLista.getRange(0, numerosLista.length -2);
      List<int> decimalLista = numerosLista.getRange(numerosLista.length -2, numerosLista.length);
      String inteiroListaString = inteiroLista.map((i) => i.toString()).join('');
      String decimalListaString = decimalLista.map((i) => i.toString()).join('');

      var valor = inteiroListaString + '.' + decimalListaString;
      return valor;
    }
  }

  void showCategoriaDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        setState(() {
          _valueText = value.toString();
        });
      }
    });
  }
 
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String mesEscolhido(month) {
    switch(month) {
      case 1: return "Janeiro"; break;
      case 2: return "Fevereiro"; break;
      case 3: return "Março"; break;
      case 4: return "Abril"; break;
      case 5: return "Maio"; break;
      case 6: return "Junho"; break;
      case 7: return "Julho"; break;
      case 8: return "Agosto"; break;
      case 9: return "Setembro"; break;
      case 10:return  "Outubro"; break;
      case 11:return  "Novembro"; break;
      case 12:return  "Dezembro"; break;
    }
  }

  void showDialogCartao<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        setState(() {
          _valueTextCartao = value.toString();
          if(this.formSubmit['idcartao'] != 0) {
            this.isCard = true;
            var dia = this._toDate.day;

            if(dia >= int.parse(fechamento)) {
              var month = this._toDate.add(new Duration(days: 31)).month;
              var year = this._toDate.add(new Duration(days: 31)).year;
              this.nomeMes = capitalize(mesEscolhido(month) + ' de ' + year.toString());
              this.formSubmit["fatura"] = this.nomeMes;
            } else {
              var month = this._toDate.month;
              var year = this._toDate.year;
              this.nomeMes = capitalize(mesEscolhido(month) + ' de ' + year.toString());
              this.formSubmit["fatura"] = this.nomeMes;
            }
          } else {
            this.isCard = false;
          }
        });
      }
    });
  }

  void showDialogFaturas<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        setState(() {
          this.nomeMes = value.toString();
          this.formSubmit["fatura"] = this.nomeMes;
        });
      }
    });
  }

  void showDialogContaDestino<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        setState(() {
          _valueTextContaDestino = value.toString();
        });
      }
    });
  }

  void showTagDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        setState(() {
          _valueTextTag = value.toString();
        });
      }
    });
  }

  //void showDialogRepeat<T>({ BuildContext context, Widget child }) {
  //  showDialog<T>(
  //    context: context,
  //    child: new MyForm(),
  //  );
  //}

  //void changeItemType(RadioGroup type) {
  //  setState(() {
  //    itemType = type;
  //  });
  //}

  void onSubmit(String result) {
    this.formSubmit['repetir'] = result;
    //Navigator.pop(context, 'result');
  }

  void onSubmitDividir(String result) {
    this.formSubmit['dividir'] = result;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    final TextStyle branco = new TextStyle(
      fontFamily: 'Roboto',
      color: Colors.white12,
      fontSize:  20.0,
      fontWeight: FontWeight.w500,
      textBaseline: TextBaseline.alphabetic
    );

    List<Widget> buildListaCategorias(list) {
      this.listaCategorias = [];
      for(var i in list) {
        var id = i[0]['id'];
        var categoria = i[0]['categoria'];
        var cor = this.cores[i[0]['cor']];

        this.listaCategorias.add(
          new DialogItem(
            icon: Icons.brightness_1,
            color: cor,
            text: categoria,
            onPressed: () {
              this.formSubmit['idcategoria'] = id;
              this.formSubmit['categoria'] = categoria;
              Navigator.pop(context, categoria);
            }
          ),
        );

        if(i[1].length > 0) {
          for(var y in i[1]) {
            var id2 = y['id'];
            var categoria2 = y['categoria'];

            this.listaCategorias.add(
              new DialogItem(
                icon: Icons.subdirectory_arrow_right,
                size: 16.0,
                color: theme.disabledColor,
                text: categoria2,
                onPressed: () {
                  this.formSubmit['idcategoria'] = id2;
                  this.formSubmit['categoria'] = categoria2;
                  Navigator.pop(context, categoria2);
                }
              ),
            );
          }
        }
      }      
      return this.listaCategorias;
    }

    List<Widget> buildListaTags(list) {
      this.listaTags = [];
      for(var i in list) {
        var id = i['id'];
        var tag = i['tag'];
        var cor = this.cores[i['cor']];
        this.listaTags.add(
          new DialogItem(
            icon: Icons.brightness_1,
            color: cor,
            text: tag,
            onPressed: () {
              this.formSubmit['idtag'] = id;
              this.formSubmit['tag'] = tag;
              Navigator.pop(context, tag);
            }
          ),
        );
      }
      return this.listaTags;
    }

    List<Widget> buildListaContaCartao(listAccount, listCard) {
      this.listaContas = [];
      this.listaCartoes = [];

      this.listaContas.add( //HEADER Contas
        new Container(
          padding: new EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
          color: new Color(0xFFDFD9D9),
          child: new Text('CONTAS'),
        )
      );
      for(var i in listAccount) {
        var id = i['id'];
        var conta = i['conta'];
        var cor = this.cores[i['cor']];

        this.listaContas.add(
          new DialogItem(
            icon: Icons.brightness_1,
            color: cor,
            text: conta,
            onPressed: () {
              this.formSubmit['idconta'] = id;
              this.formSubmit['conta'] = conta;
              this.formSubmit['idcartao'] = 0;
              this.formSubmit['cartao'] = ' ';
              Navigator.pop(context, conta);
            }
          ),
        );
      }

      this.listaCartoes.add( //HEADER Cartoes
        new Container(
          padding: new EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
          color: new Color(0xFFDFD9D9),
          child: new Text('CARTÕES'),
        )
      );
      for(var i in listCard) {
        var id = i['id'];
        var cartao = i['cartao'];
        var cor = this.cores[i['cor']];
        var fechamento = i['fechamento'];

        this.listaCartoes.add(
          new DialogItem(
            icon: Icons.brightness_1,
            color: cor,
            text: cartao,
            onPressed: () {
              this.formSubmit['idcartao'] = id;
              this.formSubmit['cartao'] = cartao;
              this.fechamento = fechamento;
              this.formSubmit['idconta'] = 0;
              this.formSubmit['conta'] = ' ';
              Navigator.pop(context, cartao);
            }
          ),
        );
      }
      
      if(this.color == const Color(0xff9e9e9e)) {
        this.listaContasOrigem = this.listaContas.sublist(1, this.listaContas.length);
        return this.listaContasOrigem;
      } else {
        this.listaContasCartoes = new List.from(this.listaContas)..addAll(this.listaCartoes);
        return this.listaContasCartoes;
      }
      
    }

    List<Widget> buildListaContaDestino(listAccount) {

      this.listaContasDestino = [];

      for(var i in listAccount) {
        var id = i['id'];
        var conta = i['conta'];
        var cor = this.cores[i['cor']];

        this.listaContasDestino.add(
          new DialogItem(
            icon: Icons.brightness_1,
            color: cor,
            text: conta,
            onPressed: () {
              this.formSubmit['idcontadestino'] = id;
              lancamentoDB.idcontadestino = this.formSubmit['idcontadestino'];
              this.formSubmit['contadestino'] = conta;
              Navigator.pop(context, conta);
            }
          ),
        );
      }
      return this.listaContasDestino;
    }

    List<Widget> buildListaFatura() {
        var dia = this._toDate.day;
        this.faturasLista = [];
        if(dia >= int.parse(this.fechamento)) {
          var mesMiddle = this._toDate.add(new Duration(days: 31));
          var month = this._toDate.add(new Duration(days: 31)).month;
          var year = this._toDate.add(new Duration(days: 31)).year;

          var lista = [
            [mesMiddle.subtract(new Duration(days: 62)).month, 
            mesMiddle.subtract(new Duration(days: 62)).year],

            [mesMiddle.subtract(new Duration(days: 31)).month,
            mesMiddle.subtract(new Duration(days: 31)).year],

            [month, year],

            [mesMiddle.add(new Duration(days: 31)).month,
            mesMiddle.add(new Duration(days: 31)).year],

            [mesMiddle.add(new Duration(days: 62)).month,
            mesMiddle.add(new Duration(days: 62)).year]
          ];

          for(var i in lista) {
            var fatura = capitalize(mesEscolhido(i[0]) + ' de ' + i[1].toString());
            this.faturasLista.add(
              new DialogItem(
                text: fatura,
                onPressed: () {

                  Navigator.pop(context, fatura);
                }
              ),
            );
          }
          return this.faturasLista;
        } else {
          var mesMiddle = this._toDate;
          var month = this._toDate.month;
          var year = this._toDate.year;
          
          var lista = [
            [mesMiddle.subtract(new Duration(days: 62)).month, 
            mesMiddle.subtract(new Duration(days: 62)).year],

            [mesMiddle.subtract(new Duration(days: 31)).month,
            mesMiddle.subtract(new Duration(days: 31)).year],

            [month, year],

            [mesMiddle.add(new Duration(days: 31)).month,
            mesMiddle.add(new Duration(days: 31)).year],

            [mesMiddle.add(new Duration(days: 62)).month,
            mesMiddle.add(new Duration(days: 62)).year]
          ];

          for(var i in lista) {
            var fatura = capitalize(mesEscolhido(i[0]) + ' de ' + i[1].toString());
            this.faturasLista.add(
              new DialogItem(
                text: fatura,
                onPressed: () {

                  Navigator.pop(context, fatura);
                }
              ),
            );
          }
          return this.faturasLista;
        }
      }
 
    return new Container(
      padding: new EdgeInsets.only(right: 24.0, left: 24.0, top: 0.0, bottom: 0.0),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                child: new Row(
                  children: <Widget>[
                    this.formSubmit['repetir'] != '' ? new Container() :
                    new InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          child: new MyForm2(onSubmit: onSubmitDividir)
                        );
                      },
                      child: new Container(
                        margin: new EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: new Text(
                          this.formSubmit['dividir'] == ''
                          ?
                          'Dividir'
                          : dividirLabel(this.color, this.formSubmit['dividir']),
                          style: new TextStyle(
                            color: this.color
                          ),
                        ),
                      ),
                    ),

                    this.formSubmit['dividir'] != '' ?
                    new InkWell(
                      onTap: (){
                        setState(() {
                          this.formSubmit['dividir'] = '';
                        });
                      },
                      child: new Container(
                        margin: new EdgeInsets.only(top: 16.0, bottom: 8.0, left: 8.0),
                        child: new Icon(
                          Icons.cancel,
                          size: 18.0,
                          color: Colors.grey[400],
                        ),
                      ),
                    ) : new Container(),                    
                  ],
                ),
              ),
              
              new Container(
                child: new Row(
                  children: <Widget>[
                    this.formSubmit['dividir'] != '' ? new Container() :
                    new InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          child: new MyForm(onSubmit: onSubmit)
                        );
                      },
                      child: new Container(
                        margin: new EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: new Text(
                          this.formSubmit['repetir'] == ''
                          ?
                          'Repetir'
                          : despesaOUreceita(this.color, this.formSubmit['repetir']),
                          style: new TextStyle(
                            color: this.color
                          ),
                        ),
                      ),
                    ),

                    this.formSubmit['repetir'] != '' ?
                    new InkWell(
                      onTap: (){
                        setState(() {
                          this.formSubmit['repetir'] = '';
                        });
                      },
                      child: new Container(
                        margin: new EdgeInsets.only(top: 16.0, bottom: 8.0, left: 8.0),
                        child: new Icon(
                          Icons.cancel,
                          size: 18.0,
                          color: Colors.grey[400],
                        ),
                      ),
                    ) : new Container()
                  ],
                ),
              )
            ],
          ),

          new _DateTimePicker(
            labelText: 'Data',
            selectedDate: _toDate,
            selectDate: (DateTime date) {
              setState(() {
                this._toDate = date;
                this.formSubmit['data'] = date.toString();

                if(this.isCard) {
                  var dia = date.day;                  
                  if(dia >= int.parse(fechamento)) {
                    var month = date.add(new Duration(days: 31)).month;
                    var year = date.add(new Duration(days: 31)).year;
                    this.nomeMes = capitalize(mesEscolhido(month) + ' de ' + year.toString());
                    this.formSubmit["fatura"] = this.nomeMes;
                  } else {
                    var month = date.month;
                    var year = date.year;
                    this.nomeMes = capitalize(mesEscolhido(month) + ' de ' + year.toString());
                    this.formSubmit["fatura"] = this.nomeMes;
                  }
                }
             });
            },
          ),
 
          new Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Expanded(
                flex: 4,
                child: new _InputDropdown(
                  labelText: 'Categoria',
                  valueText: _valueText,
                  valueStyle: valueStyle,
                  onPressed: () {
                    showCategoriaDialog<String>(
                      context: context,
                      child: new SimpleDialog(
                        title: const Text('Categorias'),
                        children: buildListaCategorias(this.listaCategoriasDB)
                      )
                    );
                  },
                ),
              ),
            ],
          ),

          this.color == const Color(0xff9e9e9e) ? new Container() :
          new Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Expanded(
                flex: 4,
                child: new _InputDropdown(
                  labelText: 'Tag',
                  valueText: _valueTextTag,
                  valueStyle: valueStyle,
                  onPressed: () {
                    showTagDialog<String>(
                      context: context,
                      child: new SimpleDialog(
                        title: const Text('Tags'),
                        children: buildListaTags(this.listaTagsDB)
                      )
                    );
                  },
                ),
              ),
            ],
          ),

          new Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Expanded(
                flex: 4,
                child: new _InputDropdown2(
                  labelText: this.color == const Color(0xff9e9e9e) ? 'Conta origem' : 'Conta/Cartão',
                  labelTextPeriod: this.nomeMes,
                  valueText: _valueTextCartao,
                  valueStyle: valueStyle,
                  isCard: isCard,
                  onPressed: () {
                    showDialogCartao<String>(
                      context: context,
                      child: new SimpleDialog(
                        title: const Text('Selecione uma conta'),
                        children: buildListaContaCartao(
                          this.listaContasDB, this.listaCartoesDB
                        )
                      )
                    );
                  },
                  onPressed2: () {
                    showDialogFaturas<String>(
                      context: context,
                      child: new SimpleDialog(
                        title: const Text('Selecione uma fatura'),
                        children: buildListaFatura()
                      )
                    );
                  }
                )
              )
            ],
          ),

          this.color != const Color(0xff9e9e9e) ? new Container() :
          new Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Expanded(
                flex: 4,
                child: new _InputDropdown(
                  labelText: 'Conta destino',
                  valueText: _valueTextContaDestino,
                  valueStyle: valueStyle,
                  onPressed: () {
                    showDialogContaDestino<String>(
                      context: context,
                      child: new SimpleDialog(
                        title: const Text('Selecione uma conta'),
                        children: buildListaContaDestino(this.listaContasDB)
                      )
                    );
                  }
                )
              )
            ],
          ),

          new EnsureVisibleWhenFocused(
            focusNode: _focusNode,            
            child: new TextField(
              controller: _controller,
              maxLines: 1,
              focusNode: _focusNode,
              style: Theme.of(context).textTheme.title,
              decoration: new InputDecoration(
                labelText: "Descrição",
                isDense: true,
              ),
            ),
          ),

          new Container(
            padding: new EdgeInsets.only(top: 30.0, bottom: 16.0),
            child: new RaisedButton(
              color: this.color,
              child: const Text(
                'OK',
                style: const TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 24.0
                ),  
              ),
              onPressed: (){
                
                if(this.formSubmit['idcategoria'] == 0) {
                  print('Preencha os campos');
                }
                this.formSubmit['descricao'] = _controller.text;
                if(this.color == const Color(0xffe57373)) {
                  this.formSubmit['tipo'] = 'Despesa';
                } else if(this.color == const Color(0xff9e9e9e)) {
                  this.formSubmit['tipo'] = 'Transferência';
                } else {
                  this.formSubmit['tipo'] = 'Receita';
                }
                
                if(this.formSubmit['tag'] == '' && this.color != const Color(0xff9e9e9e)) {
                  this.formSubmit['tag'] = this.formSubmit['tipo'] + ' Variável';
                }
                var valor = this.numeroUSA(this.numeros.value);
                this.formSubmit['valor'] = valor;
                


                lancamentoDB.tipo = this.formSubmit['tipo'];
                lancamentoDB.idcategoria = this.formSubmit['idcategoria'];
                lancamentoDB.idtag = this.formSubmit['idtag'];
                lancamentoDB.idconta = this.formSubmit['idconta'];
                lancamentoDB.idcartao = this.formSubmit['idcartao'];
                lancamentoDB.data = this.formSubmit['data'];
                lancamentoDB.valor = this.formSubmit['valor'];
                lancamentoDB.descricao = this.formSubmit['descricao'];

                if(this.formSubmit['dividir'].length == 0) {
                  var listSplit = this.formSubmit['repetir'].split(";");
                  if(listSplit.length == 2) {
                    lancamentoDB.tiporepeticao = listSplit[0]; //fixo
                    lancamentoDB.periodorepeticao = listSplit[1]; //mensal
                    lancamentoDB.quantidaderepeticao = 0;
                  } else if(listSplit.length == 3) {
                    lancamentoDB.tiporepeticao = listSplit[0]; //parcelada
                    lancamentoDB.quantidaderepeticao = listSplit[1]; //2
                    lancamentoDB.periodorepeticao = listSplit[2]; //anos
                    
                  }
                } else {
                  var listSplit = this.formSubmit['dividir'].split(";");
                  lancamentoDB.tiporepeticao = "dividir";
                  lancamentoDB.quantidaderepeticao = listSplit[0]; //3
                  lancamentoDB.periodorepeticao = listSplit[1]; //meses                  
                }

                print(this.formSubmit);


                Navigator.pop(context, true);
              }
            ),
          )
          //new TextField(
          //  maxLines: 1,
          //  decoration: const InputDecoration(
          //    labelText: "Descrição",
          //    isDense: true,
          //  ),
          //  style: Theme.of(context).textTheme.title,
          //)
              
        ]
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
 
class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);
 
  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
 
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: new DateTime(2015, 8),
      lastDate: new DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }
 
  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () { _selectDate(context); },
          ),
       ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);
 
  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;
 
  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
          isDense: true,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
          ],
        ),
      ),
    );
  }
}

class _InputDropdown2 extends StatelessWidget {
  const _InputDropdown2({
    Key key,
    this.child,
    this.labelText,
    this.labelTextPeriod,
    this.valueText,
    this.valueStyle,
    this.isCard,
    this.onPressed,
    this.onPressed2 }) : super(key: key);
 
  final String labelText;
  final String labelTextPeriod;
  final String valueText;
  final TextStyle valueStyle;
  final bool isCard;
  final VoidCallback onPressed;
  final VoidCallback onPressed2;
  final Widget child;
 
  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new Stack(
        children: <Widget>[
          new InputDecorator(
            decoration: new InputDecoration(
              labelText: labelText,
              isDense: true,
            ),
            baseStyle: valueStyle,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(valueText, style: valueStyle),
              ],
            ),
          ),
          !isCard ? new Container() : 
          new Positioned.fill(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  child: new InkWell(
                    onTap: onPressed2,
                    child: new Container(
                      margin: new EdgeInsets.only(top: 12.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Text(
                            'lançado na fatura de',
                            style: new TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.black38,
                              fontSize:  12.0,
                              fontWeight: FontWeight.w500,
                              textBaseline: TextBaseline.alphabetic
                            )
                          ),
                          new Text(
                            labelTextPeriod,
                            style: new TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.greenAccent[700],
                              fontSize:  14.0,
                              fontWeight: FontWeight.w500,
                              textBaseline: TextBaseline.alphabetic
                            )
                          ),
                        ],
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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