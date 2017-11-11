import 'package:flutter/material.dart';
import '../db/database.dart';

class CategoriaPage extends StatefulWidget {
  @override
  CategoriaPageState createState() => new CategoriaPageState();
}

class CategoriaPageState extends State<CategoriaPage>{
  Color azulAppbar = new Color(0xFF26C6DA);
  Categoria categoriaDB = new Categoria();
  List<Widget> listaCategorias = [];
  List listaDB = [];

  List cores = [
    const Color(0xFF000000),
    const Color(0xFFd10841),
    const Color(0xFFcdd399),
    const Color(0xFF87c0ec),
    const Color(0xFF5aaeae)
  ];  

  @override
  void initState() {
    categoriaDB.getAllCategoria().then(
      (list) {
        setState(() {
          this.listaDB = list;
          //print(list);
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> buildListaCategorias(list) {
      this.listaCategorias = [];

      for(var i in list) {
        var id = i[0]['id'];
        var categoria = i[0]['categoria'];
        var cor = this.cores[i[0]['cor']];
        var numeroCor = i[0]['cor'];
        var idcategoriapai = i[0]['idcategoriapai'];
        var ativada = i[0]['ativada'];

        this.listaCategorias.add(
          new ItemCategoria(
            filho: false,
            id: id,
            categoria: categoria,
            cor: cor,
            numeroCor: numeroCor,
            idcategoriapai: idcategoriapai,
            ativada: ativada,
            onPressed: () async {
              Categoria categoriaEditar = new Categoria();
              categoriaEditar.id = id;
              categoriaEditar.categoria = categoria;
              categoriaEditar.idcategoriapai = idcategoriapai;
              categoriaEditar.cor = numeroCor;
              categoriaEditar.ativada = ativada;

              await Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new NovaCategoriaPage(true, categoriaEditar);
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
              categoriaDB.getAllCategoria().then(
                (list) {
                  setState(() {
                    this.listaDB = list;
                  });
                }
              );
            },

            onPressed2: () async {
              Categoria categoriaAddSubcategoria = new Categoria();
              categoriaAddSubcategoria.idcategoriapai = id;

              await Navigator.of(context).push(new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return new NovaCategoriaPage(false, categoriaAddSubcategoria);
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
              categoriaDB.getAllCategoria().then(
                (list) {
                  setState(() {
                    this.listaDB = list;
                  });
                }
              );
            },

          )
        );  

        if(i[1].length > 0) {
          for(var y in i[1]) {
            var id2 = y['id'];
            var categoria2 = y['categoria'];
            var cor2 = this.cores[y['cor']];
            var numeroCor2 = y['cor'];
            var idcategoriapai2 = y['idcategoriapai'];
            var ativada2 = y['ativada'];

            this.listaCategorias.add(
              //new ItemCategoria(true, id2, categoria2, cor2, numeroCor2, idcategoriapai2, ativada2)
              new ItemCategoria(
                filho: true,
                id: id2,
                categoria: categoria2,
                cor: cor2,
                numeroCor: numeroCor2,
                idcategoriapai: idcategoriapai2,
                ativada: ativada2,
                onPressed: () async {
                  Categoria categoriaEditar = new Categoria();
                  categoriaEditar.id = id2;
                  categoriaEditar.categoria = categoria2;
                  categoriaEditar.idcategoriapai = idcategoriapai2;
                  categoriaEditar.cor = numeroCor2;
                  categoriaEditar.ativada = ativada2;

                  await Navigator.of(context).push(new PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return new NovaCategoriaPage(true, categoriaEditar);
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
                  categoriaDB.getAllCategoria().then(
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
        }      
      }
      return this.listaCategorias;
    }

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
                  return new NovaCategoriaPage(false, new Categoria());
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
              categoriaDB.getAllCategoria().then(
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
        children: buildListaCategorias(this.listaDB)
      )
    );
  }
}

class NovaCategoriaPage extends StatefulWidget {
  NovaCategoriaPage(this.editar, this.categoriaDBEditar);

  bool editar;
  Categoria categoriaDBEditar;

  @override
  NovaCategoriaPageState createState() => new NovaCategoriaPageState(this.editar, this.categoriaDBEditar);
}

class NovaCategoriaPageState extends State<NovaCategoriaPage>{
  NovaCategoriaPageState(this.editar, this.categoriaDBEditar);

  bool editar;
  Color azulAppbar = new Color(0xFF26C6DA);
  String value;
  String categoriaPai = "Categoria pai";
  int categoriaPaiId;
  Color colorEscolhida;
  final TextEditingController _controller = new TextEditingController();
  Categoria categoriaDB = new Categoria();
  Categoria categoriaDBEditar= new Categoria();
  List listaCategoria;
  int number;
  List<Widget> tiles;
  bool x, y;
  
  List cores = [
    const Color(0xFF000000),
    const Color(0xFFd10841),
    const Color(0xFFcdd399),
    const Color(0xFF87c0ec),
    const Color(0xFF5aaeae)
  ];

  @override
  void initState() {
    setState(() {
      if(editar) {
        categoriaDB.id = categoriaDBEditar.id;
        categoriaDB.categoria = categoriaDBEditar.categoria;
        _controller.text = categoriaDBEditar.categoria;

        categoriaDB.ativada = categoriaDBEditar.ativada;
        categoriaDB.cor = categoriaDBEditar.cor;
        this.colorEscolhida = this.cores[categoriaDBEditar.cor];
        categoriaDB.idcategoriapai = categoriaDBEditar.idcategoriapai;
        
        if(categoriaDB.idcategoriapai == 0) {
          this.value = "Categoria principal";
        } else {
          this.value = "Subcategoria";
          categoriaDB.getCategoria(categoriaDBEditar.idcategoriapai).then(
            (data) {             
              setState(() {
                this.categoriaPai = data;
                categoriaDB.idcategoriapai = categoriaDBEditar.idcategoriapai;
                this.categoriaPaiId = categoriaDBEditar.idcategoriapai;              
                categoriaDB.getOnlyCategoriaPai().then((list) {
                  setState(() {
                    if(list.length > 0 && list != null) {
                      this.number = list[0][0]['COUNT(*)'];
                      this.listaCategoria = list[1];
                    }
                  });
                });
              });

              //categoriaDB.idcategoriapai = categoriaDBEditar.idcategoriapai;
            }
          );
        }

        categoriaDB.getOnlyCategoriaPaiLess(categoriaDB.id).then((list) {
          setState(() {
            if(list.length > 0 && list != null) {
              this.number = list[0][0]['COUNT(*)'];              
              this.listaCategoria = list[1];
            }
          });
        });

      } else if (!editar && categoriaDBEditar.idcategoriapai != null) {
        this.value = "Subcategoria";
        categoriaDB.cor = 0;
        this.colorEscolhida = new Color(0xFF000000);
        categoriaDB.getCategoria(categoriaDBEditar.idcategoriapai).then(
          (data) {
            setState(() {
              this.categoriaPai = data;
              categoriaDB.idcategoriapai = categoriaDBEditar.idcategoriapai;
              this.categoriaPaiId = categoriaDBEditar.idcategoriapai;              
              categoriaDB.getOnlyCategoriaPai().then((list) {
                setState(() {
                  if(list.length > 0 && list != null) {
                    this.number = list[0][0]['COUNT(*)'];
                    this.listaCategoria = list[1];
                  }
                });
              });
            });            
          }
        );

      } else {
        this.value = "Categoria principal";
        categoriaDB.cor = 0;
        this.colorEscolhida = new Color(0xFF000000);

        categoriaDB.getOnlyCategoriaPai().then((list) {
          setState(() {
            if(list.length > 0 && list != null) {
              this.number = list[0][0]['COUNT(*)'];
              this.listaCategoria = list[1];
            }
          });
        });
      }
    });    
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

  void showChoseDialog<T>({ BuildContext context, Widget child }) {
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

    List<Widget> buildTile(int counter) {
      this.tiles = [];
      if(counter != null) {
        for(var i = 0; i < counter; i++) {
          this.tiles.add(
            new DialogItem(
              icon: Icons.brightness_1,
              color: this.cores[
                this.listaCategoria[i]['cor']
              ],
              text: this.listaCategoria[i]['categoria'],
              onPressed: () {
                setState((){
                  this.categoriaPai = this.listaCategoria[i]['categoria'];
                  this.categoriaPaiId = this.listaCategoria[i]['id'];
                });
                Navigator.pop(context, this.listaCategoria[i]['categoria']);
              }
            )
          );
        }
      }
      return this.tiles;
    }

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
                    categoriaDB.idcategoriapai = editar ? categoriaDBEditar.idcategoriapai : 0;
                  }),
                  value: "Categoria principal",
                ),
                const Text("Categoria principal"),
                new Radio(
                  groupValue: value,
                  onChanged: (value) => setState(() {
                    this.value = value;
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
                      onTap: () {
                        showChoseDialog<String>(
                          context: context,
                          child: new SimpleDialog(
                            title: const Text('Categorias'),
                            children: buildTile(this.number)
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
                    onPressed: () {
                      categoriaDB.categoria = _controller.text;
                      categoriaDB.ativada = 1;
                      this.categoriaPai == 'Categoria pai' ?
                        categoriaDB.idcategoriapai = 0 : categoriaDB.idcategoriapai = this.categoriaPaiId;
                      //var result = categoriaDB.getCategoriaByName(categoriaDB.categoria);

                      if(categoriaDB.categoria.length > 0) {
                        this.x = true;
                      } else { this.x = false; }

                      if(this.value == "Subcategoria" && categoriaDB.idcategoriapai != 0) {
                        this.y = true;
                      } else if(this.value == "Categoria principal" && categoriaDB.idcategoriapai == 0) {
                        this.y = true;
                      } else { this.y = false; }

                      if(this.x == true && this.y == true) {
                        var result = categoriaDB.countCategoria(categoriaDB.categoria, editar);
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
                                          softWrap: true,
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
                      } else {
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
                                      "Preencha os campos",
                                      softWrap: true,
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

class ItemCategoria extends StatefulWidget {
   
  final bool filho;
  final int id;
  final String categoria;
  final int numeroCor;
  final Color cor;
  final int idcategoriapai;
  final int ativada;
  final VoidCallback onPressed;
  final VoidCallback onPressed2;

  ItemCategoria({
    Key key,
    this.filho,
    this.id,
    this.categoria,
    this.cor,
    this.numeroCor,
    this.idcategoriapai,
    this.ativada,
    this.onPressed,
    this.onPressed2}) : super(key: key);  

  @override
  ItemCategoriaState createState() => new ItemCategoriaState();
}

class ItemCategoriaState extends State<ItemCategoria> with TickerProviderStateMixin {
  Categoria categoriaDB = new Categoria();

  ItemCategoriaState();

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border(
          top: widget.filho ? new BorderSide(style: BorderStyle.none) : new BorderSide(style: BorderStyle.solid, color: Colors.black26),
        )
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
    
                  //  Categoria categoriaEditar = new Categoria();
                  //  categoriaEditar.id = this.id;
                  //  categoriaEditar.categoria = this.categoria;
                  //  categoriaEditar.idcategoriapai = this.idcategoriapai;
                  //  categoriaEditar.cor = this.numeroCor;
                  //  categoriaEditar.ativada = this.ativada;
//
                  //  await Navigator.of(context).push(new PageRouteBuilder(
                  //    opaque: false,
                  //    pageBuilder: (BuildContext context, _, __) {
                  //      return new NovaCategoriaPage(true, categoriaEditar);
                  //    },
                  //    transitionsBuilder: (
                  //      BuildContext context,
                  //      Animation<double> animation,
                  //      Animation<double> secondaryAnimation,
                  //      Widget child,
                  //    ) {
                  //      return new SlideTransition(
                  //        position: new Tween<Offset>(
                  //          begin:  const Offset(1.0, 0.0),
                  //          end: Offset.zero,
                  //        ).animate(animation),
                  //        child: child,
                  //      );
                  //    }
                  //  ));
                  //  categoriaDB.getAllCategoria().then(
                  //    (list) {
                  //      setState(() {
                  //        print(list);
                  //      });
                  //    }
                  //  );
                  //},

                  child: 
                    new Container(
                      margin: new EdgeInsets.only(left: 16.0),
                      padding: widget.filho ? new EdgeInsets.only(right: 40.0, top: 11.5, bottom: 11.5) : new EdgeInsets.only(right: 40.0, top: 4.5, bottom: 4.5),
                      child: new Row(
                        children: <Widget>[
                          new Container(
                            margin: widget.filho ? new EdgeInsets.only(right: 15.0, left: 16.0) : new EdgeInsets.only(right: 16.0),
                            child: new Icon(
                              widget.filho ? Icons.subdirectory_arrow_right : Icons.brightness_1,
                              color: widget.filho ? Colors.black54 : widget.cor,
                              size: widget.filho ? 20.0 : 35.0,
                            ),  
                          ),
                          new Text(
                            widget.categoria,
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
                //  }
                //),
                widget.filho ? new Container() :
                new InkWell(
                  onTap: widget.onPressed2,
                  child: new Container(
                    margin: new EdgeInsets.only(right: 16.0),
                    padding: new EdgeInsets.only(top: 15.0, bottom: 15.0, left: 10.0),
                    child: new Text(
                      "+ subcategoria",
                      style: new TextStyle(
                        color: Colors.black26,
                        fontSize: 12.0,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )                
              ],
            ),
          )
        ],
      ),
    );
  }
}