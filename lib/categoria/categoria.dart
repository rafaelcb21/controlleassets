import 'package:flutter/material.dart';

class CategoriaPage extends StatelessWidget {
  Color azulAppbar = new Color(0xFF26C6DA);
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
            onPressed: () {
              Navigator.of(context).push(new PageRouteBuilder(
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
                //transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                //  return new FadeTransition(
                //    opacity: animation,
                //    child: child,
                //  );
                //}
              ));
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
  Color colorEscolhida = new Color(0xFF000000);

  void showCorDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        setState(() {
          //_valueText = value.toString();
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
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Radio(
                  groupValue: value,
                  onChanged: (value) => setState(() => this.value = value),
                  value: "Categoria principal",
                ),
                const Text("Categoria principal"),
                new Radio(
                  groupValue: value,
                  onChanged: (value) => setState(() => this.value = value),
                  value: "Subcategoria",
                ),
                const Text("Subcategoria"),
              ],
            ),
            
            new Container(
              margin: new EdgeInsets.only(right: 16.0),
              child: new TextField(
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
                                      color: new Color(0xFFd10841),
                                      height: 46.0,
                                      width: 46.0,
                                    ),
                                    new Container(
                                      color: new Color(0xFFcdd399),
                                      height: 46.0,
                                      width: 46.0,
                                    ),
                                    new Container(
                                      color: new Color(0xFF87c0ec),
                                      height: 46.0,
                                      width: 46.0,
                                    ),
                                    new Container(
                                      color: new Color(0xFF5aaeae),
                                      height: 46.0,
                                      width: 46.0,
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
                            new Icon(Icons.lens)
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
                              new Container(
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                      color: new Color(0xFFd10841),
                                      height: 46.0,
                                      width: 46.0,
                                    ),
                                    new Container(
                                      color: new Color(0xFFcdd399),
                                      height: 46.0,
                                      width: 46.0,
                                    ),
                                    new Container(
                                      color: new Color(0xFF87c0ec),
                                      height: 46.0,
                                      width: 46.0,
                                    ),
                                    new Container(
                                      color: new Color(0xFF5aaeae),
                                      height: 46.0,
                                      width: 46.0,
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
                                'Categoria pai',
                                style: new TextStyle(
                                  color: Colors.black26,
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
            )
          ],
        ),
      )
    );
  }
}