import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../palette/palette.dart';
import '../db/database.dart';

class TagPage extends StatefulWidget {
  @override
  TagPageState createState() => new TagPageState();
}

class TagPageState extends State<TagPage>{
  Color azulAppbar = new Color(0xFF26C6DA);
  Tag tagDB = new Tag();
  List<Widget> listaTags = [];
  List listaDB = [];
  Palette listaCores = new Palette();
  List cores = [];

  @override
  void initState() {
    this.cores = listaCores.cores;
    tagDB.getAllTag().then(
      (list) {
        setState(() {
          this.listaDB = list;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> buildListaTags(list) {
      this.listaTags = [];

      for(var i in list) {
        var id = i['id'];
        var tag = i['tag'];
        var cor = this.cores[i['cor']];
        var numeroCor = i['cor'];
        var ativada = i['ativada'];
        var relacionada = i['relacionada'];

        this.listaTags.add(
          new ItemTag(
            key: new Key(i),
            id: id,
            tag: tag,
            relacionada: relacionada,
            cor: cor,
            numeroCor: numeroCor,
            ativada: ativada,
            onPressed: () async {
              Tag tagEditar = new Tag();
              tagEditar.id = id;
              tagEditar.tag = tag;
              tagEditar.relacionada = relacionada;
              tagEditar.cor = numeroCor;
              tagEditar.ativada = ativada;

              await Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new NovaTagPage(true, tagEditar);
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
              tagDB.getAllTag().then(
                (list) {
                  setState(() {
                    this.listaDB = list;
                  });
                }
              );
            },
            onPressed3: () async {
              void showDeleteDialog<T>({ BuildContext context, Widget child }) {
                showDialog<T>(
                  context: context,
                  child: child,
                )
                .then<Null>((T value) { });
              }

              showDeleteDialog<DialogOptionsAction>(
                context: context,
                child: new AlertDialog(
                  title: const Text('Deletar Tag'),
                  content: new Text(
                      'Deseja deletar essa tag?',
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
                        tagDB.deleteTag(id).then(
                          (list) {
                            setState(() {
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
            }
          )
        );    
      }
      return this.listaTags;
    }

    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Tags'),
        backgroundColor: azulAppbar,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.add),
            color: new Color(0xFFFFFFFF),
            onPressed: () async {
              await Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new NovaTagPage(false, new Tag());
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
              tagDB.getAllTag().then(
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
        children: buildListaTags(this.listaDB)
      )
    );
  }
}

class NovaTagPage extends StatefulWidget {
  NovaTagPage(this.editar, this.tagDBEditar);

  bool editar;
  Tag tagDBEditar;

  @override
  NovaTagPageState createState() => new NovaTagPageState(this.editar, this.tagDBEditar);
}

class NovaTagPageState extends State<NovaTagPage>{
  NovaTagPageState(this.editar, this.tagDBEditar);

  bool editar;
  Color azulAppbar = new Color(0xFF26C6DA);
  Color colorEscolhida;
  final TextEditingController _controller = new TextEditingController();
  Tag tagDB = new Tag();
  Tag tagDBEditar= new Tag();
  List listaCategoria;
  List<Widget> palette;
  bool x;
  Palette listaCores = new Palette();
  List cores = [];
  String relacionado;

  @override
  void initState() {
    this.cores = listaCores.cores;
    setState(() {
      if(editar) {
        tagDB.id = tagDBEditar.id;
        tagDB.tag = tagDBEditar.tag;
        tagDB.relacionada = tagDBEditar.relacionada;
        _controller.text = tagDBEditar.tag;

        tagDB.ativada = tagDBEditar.ativada;
        tagDB.cor = tagDBEditar.cor;
        this.colorEscolhida = this.cores[tagDBEditar.cor];
        this.relacionado = relacionadaEdit(tagDB.relacionada);

      } else {
        tagDB.cor = 3;
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

  void showTagDialog<T>({ BuildContext context, Widget child }) {
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

  void onSubmit(String result) {
    tagDB.relacionada = result;
    switch(result) {
      case 'despesa':
        this.relacionado = "Despesa";
        break;
      case 'receita':
        this.relacionado = "Receita";
        break;
      case 'todos':
        this.relacionado = "Todos";
        break;
      default:
        break;
    }
    //Navigator.pop(context, 'result');
  }

  String relacionadaEdit(String result) {
    switch(result) {
      case 'despesa':
        return "Despesa";
        break;
      case 'receita':
        return "Receita";
        break;
      case 'todos':
        return "Todos";
        break;

    }
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
                      tagDB.cor = i;
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
                      tagDB.cor = i+1;
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
                      tagDB.cor = i+2;
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
                      tagDB.cor = i+3;
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
        title: new Text('Nova Tag'),
        backgroundColor: azulAppbar,
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.only(right: 16.0),
              child: new TextField(
                controller: _controller,
                maxLines: 1,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.description),
                  labelText: "Nome",
                ),
                style: Theme.of(context).textTheme.title,
              ),
            ),
            
            new Container(
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

            new Container(
              margin: new EdgeInsets.only(left: 12.0, right: 16.0, top: 32.0),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.label,
                    size: 24.0,
                    color: Colors.black45,
                  ),
                  new Expanded(
                    child: new InkWell(
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          child: new MyForm(onSubmit: onSubmit)
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
                                this.relacionado == null ? 'Relacionar à:' : this.relacionado,
                                style: new TextStyle(
                                  color: this.relacionado == null ? Colors.black26 : Colors.black87,
                                  fontSize: 20.0,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                )
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                ],
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
                      tagDB.tag = _controller.text;
                      tagDB.ativada = 1;

                      if(tagDB.tag.length > 0 && tagDB.relacionada != null) {
                        this.x = true;
                      } else { this.x = false; }

                      if(this.x) {
                        tagDB.upsertTag(tagDB);
                        Navigator.pop(context);
                      } else {
                        showTagDialog<String>(
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

class ItemTag extends StatefulWidget {
   
  final int id;
  final String tag;
  final int numeroCor;
  final String relacionada;
  final Color cor;
  final int ativada;
  final VoidCallback onPressed;
  final VoidCallback onPressed3;

  ItemTag({
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
  ItemTagState createState() => new ItemTagState();
}

enum DialogOptionsAction {
  cancel,
  ok
}

class ItemTagState extends State<ItemTag> with TickerProviderStateMixin {
  ItemTagState();

  Tag tagDB = new Tag();
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

typedef void MyFormCallback(String result);

class MyForm extends StatefulWidget {
  final MyFormCallback onSubmit;

  MyForm({this.onSubmit});

  @override
  _MyFormState createState() => new _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String value = "despesa";

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      title: new Text("Relacionar à:"),
      children: <Widget>[
        new Container(
          margin: new EdgeInsets.only(left: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Row(              
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Radio(
                    groupValue: value,
                    onChanged: (value) => setState(() => this.value = value),
                    value: "despesa",
                  ),
                  const Text("Despesa")                
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Radio(
                    groupValue: value,
                    onChanged: (value) => setState(() => this.value = value),
                    value: "receita",
                  ),
                  const Text("Receita")
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Radio(
                    groupValue: value,
                    onChanged: (value) => setState(() => this.value = value),
                    value: "todos",
                  ),
                  const Text("Todos")                
                ],
              ),
            ],
          ),          
        ),
        

        new FlatButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmit(value);
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