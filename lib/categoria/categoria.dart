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
            icon: const Icon(Icons.add_circle),
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
            new Row(
              children: <Widget>[
                new Icon(
                  Icons.description,
                  size: 24.0
                ),
                new TextField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    isDense: true,
                  ),
                  style: Theme.of(context).textTheme.title,
                )
              ],
            ),
            this.value == "Categoria principal" ?
            new Row(
              children: <Widget>[
                new Icon(
                  Icons.palette,
                  size: 24.0
                ),
                new TextField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: "Cor",
                    isDense: true,
                  ),
                  style: Theme.of(context).textTheme.title,
                ),

              ],
            ):
            
              

          ],
        ),
      )
    );
  }
}