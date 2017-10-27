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
                transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                  return new FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                }
              ));
            }
          )
        ]
      )
    );
  }
}

class NovaCategoriaPage extends StatelessWidget{
  Color azulAppbar = new Color(0xFF26C6DA);
  @override
  Widget build(BuildContext context) {
    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Nova Categoria'),
        backgroundColor: azulAppbar,
      )
    );
  }
}