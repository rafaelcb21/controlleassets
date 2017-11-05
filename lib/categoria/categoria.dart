import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../db/database.dart';

class CategoriaPage extends StatefulWidget {
  @override
  CategoriaPageState createState() => new CategoriaPageState();
}

class CategoriaPageState extends State<CategoriaPage>{
  Color azulAppbar = new Color(0xFF26C6DA);
  Categoria categoriaDB = new Categoria();

  @override
  void initState() {
    categoriaDB.getAllCategoria();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Categorias'),
        backgroundColor: azulAppbar,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.add),
            color: new Color(0xFFFFFFFF),
            onPressed: () async {
              await Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new NovaCategoriaPage();
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
              categoriaDB.getAllCategoria();
            }
          )
        ]
      )
    );
  }
}

class NovaCategoriaPage extends StatefulWidget {
  @override
  NovaCategoriaPageState createState() => new NovaCategoriaPageState();
}

class NovaCategoriaPageState extends State<NovaCategoriaPage>{
  Color azulAppbar = new Color(0xFF26C6DA);
  String value = "Categoria principal";
  String categoriaPai = "Categoria pai";
  Color colorEscolhida = new Color(0xFF000000);
  final TextEditingController _controller = new TextEditingController();
  Categoria categoriaDB = new Categoria();
  
  List cores = [
    const Color(0xFF000000),
    const Color(0xFFd10841),
    const Color(0xFFcdd399),
    const Color(0xFF87c0ec),
    const Color(0xFF5aaeae)
  ];

  @override
  void initState() {
    categoriaDB.cor = 0;
  }

  void showCorDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        setState(() {
          
        });
      }
    });
  }

  void showCategoriaDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        setState(() {
          
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Nova Categoria'),
        backgroundColor: azulAppbar,
      ),
      body: new Container(
        margin: new EdgeInsets.only(top: 16.0),
        child: new ListView(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  groupValue: value,
                  onChanged: (value) => setState(() {
                    this.value = value;
                    this.categoriaPai = 'Categoria pai';
                    categoriaDB.idcategoriapai = 0;
                  }),
                  value: "Categoria principal",
                ),
                const Text("Categoria principal"),
                new Radio(
                  groupValue: value,
                  //onChanged: (value) => setState(() => this.value = value),
                  onChanged: (value) => setState(() {
                    this.value = value;
                    categoriaDB.getAllCategoria();
                  }),

                  value: "Subcategoria",
                ),
                const Text("Subcategoria"),
              ],
            ),
            
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
            this.value == "Categoria principal" ?
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
                      onTap: (){
                        showCorDialog<String>(
                          context: context,
                          child: new SimpleDialog(
                            title: const Text('Selecione uma cor'),
                            children: <Widget>[
                              new Container(
                                //margin: new EdgeInsets.only(left: 16.0, right: 16.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      color: cores[1],
                                      height: 46.0,
                                      width: 46.0,
                                      child: new InkWell(
                                        onTap: (){
                                          this.colorEscolhida = cores[1];
                                          categoriaDB.cor = 1;
                                          Navigator.pop(context, 1);
                                        },
                                      ),
                                    ),
                                    new Container(
                                      color: cores[2],
                                      height: 46.0,
                                      width: 46.0,
                                      child: new InkWell(
                                        onTap: (){
                                          this.colorEscolhida = cores[2];
                                          categoriaDB.cor = 2;
                                          Navigator.pop(context, 2);
                                        },
                                      ),
                                    ),
                                    new Container(
                                      color: cores[3],
                                      height: 46.0,
                                      width: 46.0,
                                      child: new InkWell(
                                        onTap: (){
                                          this.colorEscolhida = cores[3];
                                          categoriaDB.cor = 3;
                                          Navigator.pop(context, 3);
                                        },
                                      ),
                                    ),
                                    new Container(
                                      color: cores[4],
                                      height: 46.0,
                                      width: 46.0,
                                      child: new InkWell(
                                        onTap: (){
                                          this.colorEscolhida = cores[4];
                                          categoriaDB.cor = 4;
                                          Navigator.pop(context, 4);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ]
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
            ) :

            new Container(
              margin: new EdgeInsets.only(left: 12.0, right: 16.0, top: 16.0),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.label,
                    size: 24.0,
                    color: Colors.black45,
                  ),
                  new Expanded(
                    child: new InkWell(
                      onTap: (){
                        showCorDialog<String>(
                          context: context,
                          child: new SimpleDialog(
                            title: const Text('Categorias'),
                            children: <Widget>[
                              new DialogItem(
                                icon: Icons.brightness_1,
                                color: new Color(0xFFFFA500),
                                text: 'Alimentação',
                                onPressed: () {
                                  setState((){
                                    this.categoriaPai = 'Alimentação';
                                  });
                                  Navigator.pop(context, 'Alimentação');
                                }
                              ),
                              new DialogItem(
                                icon: Icons.brightness_1,
                                color: new Color(0xFF279605),
                                text: 'Cartão',
                                onPressed: () {
                                  setState((){
                                    this.categoriaPai = 'Cartão';
                                  });
                                  Navigator.pop(context, 'Cartão');
                                }
                              ),
                              new DialogItem(
                                icon: Icons.brightness_1,
                                color: new Color(0xFF005959),
                                text: 'Educação',
                                onPressed: () {
                                  setState((){
                                    this.categoriaPai = 'Educação';
                                  });                                  
                                  Navigator.pop(context);
                                }
                              )                              
                            ]
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
                                this.categoriaPai,
                                style: new TextStyle(
                                  color: this.categoriaPai == "Categoria pai" ? Colors.black26 : Colors.black87,
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
                    onPressed: (){                      
                      categoriaDB.categoria = _controller.text;
                      categoriaDB.ativada = 1;
                      this.categoriaPai == 'Categoria pai' ?
                        categoriaDB.idcategoriapai = 0 : categoriaDB.idcategoriapai = 1;
                      //var result = categoriaDB.getCategoriaByName(categoriaDB.categoria);

                      var result = categoriaDB.countCategoria(categoriaDB.categoria);
                      
                      result.then((data) {
                        if(data) {
                          showCategoriaDialog<String>(
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
                                        "Essa categoria já existe",
                                        style: new TextStyle(
                                          color: Colors.black26,
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
                        } else {
                          categoriaDB.upsertCategoria(categoriaDB);                      
                          Navigator.pop(context);
                        }
                      });
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