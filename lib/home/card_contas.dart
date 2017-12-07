import 'package:flutter/material.dart';
import '../db/database.dart';
import '../palette/palette.dart';

class CardContas extends StatefulWidget {
  @override
  CardContasState createState() => new CardContasState();
}

class CardContasState extends State<CardContas> {
  List listaDB = [];
  List<Widget> listaContas = [];
  List cores = [];
  Palette listaCores = new Palette();
  
  @override
  void initState() {
    this.cores = listaCores.cores;
    Conta contaDB = new Conta();
    contaDB.getAllContaAtivas().then(
      (list) {
        setState(() {
          this.listaDB = list;
          print(list);
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> buildListaContas(list) {
      this.listaContas.add(
        new Container(
          padding: new EdgeInsets.only(left: 18.0, top: 18.0),
          child: new Text(
          'Contas',
            style: new TextStyle(
              fontSize: 14.0,
              fontFamily: 'Roboto',
              color: new Color(0xFF757575),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      for(var i in list) {
        var id = i['id'];
        var conta = i['conta'];
        var tipo = i['tipo'];
        var saldoinicial = i['saldoinicial'];
        var cor = this.cores[i['cor']];
        var numeroCor = i['cor'];
        var ativada = i['ativada'];

        this.listaContas.add(
          new ItemConta(
            id: id,
            conta: conta,
            tipo: tipo,
            saldoinicial: saldoinicial,
            cor: cor,
            numeroCor: numeroCor,
            ativada: ativada,
            onPressed: () {}
          )
        );
      }

      return this.listaContas;
    }

    return new Container(
      padding: new EdgeInsets.only(bottom: 6.0, right: 6.0, left: 6.0),
      child: new  Card(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildListaContas(this.listaDB)
          
          //<Widget>[
          //  new Container(
          //    padding: new EdgeInsets.only(left: 18.0, top: 18.0),
          //    child: new Text(
          //    'Contas',
          //      style: new TextStyle(
          //        fontSize: 14.0,
          //        fontFamily: 'Roboto',
          //        color: new Color(0xFF757575),
          //        fontWeight: FontWeight.bold,
          //      ),
          //    ),
          //  ),
//
          //  new GestureDetector(
          //    child: new InkWell(
          //      onTap: () {
          //        print('contascontas');
          //      },
          //      child: new ListTile(
          //        leading: new CircleAvatar(
          //          backgroundImage: new AssetImage('lib/images/cef.jpg'),
          //          backgroundColor: new Color(0xFFF5F5F5),
          //          radius: 16.0,
          //        ),
          //        //leading: new Icon(
          //        //  Icons.card_giftcard
          //        //),
          //        title: new Text(
          //          'Caixa',
          //          style: new TextStyle(
          //            fontSize: 13.0,
          //            fontFamily: 'Roboto',
          //            color: new Color(0xFF212121),
          //            fontWeight: FontWeight.bold,
          //          ),
          //        ),
          //        subtitle: new Text(
          //          'Conta corrente',
          //          style: new TextStyle(
          //            fontSize: 12.0,
          //            fontFamily: 'Roboto',
          //            color: new Color(0xFF9E9E9E)
          //          ),
          //        ),
          //        trailing: new Text(
          //          'R\$ 3.051,00',
          //          style: new TextStyle(
          //            fontSize: 16.0,
          //            fontFamily: 'Roboto',
          //            color: new Color(0xFF26C6DA)
          //          ),
          //        )
          //      ), 
          //    ),
          //  ),
//
          //  //new Container(
          //  //  padding: new EdgeInsets.only(left: 74.0),
          //  //  child: new Divider(),
          //  //),
          //  new GestureDetector(
          //    child: new InkWell(
          //      onTap: () {
          //        print('contas2');
          //      },
          //      child: new ListTile(
          //        leading: new CircleAvatar(
          //          backgroundImage: new AssetImage('lib/images/itau.jpg'),
          //          backgroundColor: new Color(0xFF1A5493),
          //          radius: 16.0,
          //        ),
          //        title: new Text(
          //          'Itau',
          //          style: new TextStyle(
          //            fontSize: 13.0,
          //            fontFamily: 'Roboto',
          //            color: new Color(0xFF212121),
          //            fontWeight: FontWeight.bold,
          //          ),
          //        ),
          //        subtitle: new Text(
          //          'Conta corrente',
          //          style: new TextStyle(
          //            fontSize: 12.0,
          //            fontFamily: 'Roboto',
          //            color: new Color(0xFF9E9E9E)
          //          ),
          //        ),
          //        trailing: new Text(
          //          'R\$ 305.100,00',
          //          style: new TextStyle(
          //            fontSize: 16.0,
          //            fontFamily: 'Roboto',
          //            color: new Color(0xFF26C6DA)
          //          ),
          //        )
          //      ),
          //    ),
          //  ),
//
          //  //new Container(
          //  //  padding: new EdgeInsets.only(left: 74.0),
          //  //  child: new Divider(),
          //  //),
          //  new GestureDetector(
          //    child: new InkWell(
          //      onTap: () {
          //        print('conta3');
          //      },
          //      child: new ListTile(
          //        leading: new CircleAvatar(
          //          backgroundImage: new AssetImage('lib/images/bb.jpg'),
          //          backgroundColor: new Color(0xFFFDE100),
          //          radius: 16.0,
          //        ),
          //        //leading: new Icon(
          //        //  Icons.card_giftcard
          //        //),
          //        title: new Text(
          //          'Banco do Brasil',
          //          style: new TextStyle(
          //            fontSize: 13.0,
          //            fontFamily: 'Roboto',
          //            color: new Color(0xFF212121),
          //            fontWeight: FontWeight.bold,
          //          ),
          //        ),
          //        subtitle: new Text(
          //          'Conta corrente',
          //          style: new TextStyle(
          //            fontSize: 12.0,
          //            fontFamily: 'Roboto',
          //            color: new Color(0xFF9E9E9E)
          //          ),
          //        ),
          //        trailing: new Text(
          //          'R\$ 3.051,00',
          //          style: new TextStyle(
          //            fontSize: 16.0,
          //            fontFamily: 'Roboto',
          //            color: new Color(0xFF26C6DA)
          //          ),
          //        )
          //      )
          //    ),
          //  )
          //]
        ),
      ),
    );
  }
}

class ItemConta extends StatefulWidget {
   
  final int id;
  final String conta;
  final String tipo;
  final double saldoinicial;
  final int numeroCor;
  final Color cor;
  final int ativada;
  final VoidCallback onPressed;

  ItemConta({
    this.id,
    this.conta,
    this.tipo,
    this.saldoinicial,
    this.cor,
    this.numeroCor,
    this.ativada,
    this.onPressed,
  });

  @override
  ItemContaState createState() => new ItemContaState();
}

class ItemContaState extends State<ItemConta> {
  ItemContaState();
  Conta contaDB = new Conta();

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new InkWell(
        onTap: () {
          print('contascontas');
        },
        child: new ListTile(
          leading: new CircleAvatar(
            backgroundColor: widget.cor,
            radius: 16.0,
          ),
          title: new Text(
            widget.conta,
            style: new TextStyle(
              fontSize: 13.0,
              fontFamily: 'Roboto',
              color: new Color(0xFF212121),
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: new Text(
            widget.tipo,
            style: new TextStyle(
              fontSize: 12.0,
              fontFamily: 'Roboto',
              color: new Color(0xFF9E9E9E)
            ),
          ),
          trailing: new Text(
            'R\$ 3.051,00',
            style: new TextStyle(
              fontSize: 16.0,
              fontFamily: 'Roboto',
              color: new Color(0xFF26C6DA)
            ),
          )
        ), 
      ),
    );
  }
    //return new Container(
    //  decoration: new BoxDecoration(
    //    border: new Border(
    //      bottom: new BorderSide(
    //        style: BorderStyle.solid,
    //        color: Colors.black26,
    //      )
    //    )
    //  ),
    //  child: new Row(
    //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //    children: <Widget>[
    //      new Expanded(
    //        child: new InkWell(
    //          onTap: this.switchValue ? widget.onPressed  : () {},
    //          child: new Row(
    //            children: <Widget>[
    //              new Container(
    //                margin: new EdgeInsets.only(left: 16.0, right: 32.0),
    //                child: new Icon(Icons.brightness_1, color: this.switchValue ? widget.cor : Colors.black26),
    //              ),
    //              new Column(
    //                crossAxisAlignment: CrossAxisAlignment.start,
    //                children: <Widget>[
    //                  new Text(
    //                    widget.conta,                        
    //                    style: new TextStyle(
    //                      color: this.switchValue ? Colors.black87 : Colors.black26,
    //                      fontFamily: "Roboto",
    //                      fontSize: 14.0,
    //                      fontWeight: FontWeight.w500,
    //                      textBaseline: TextBaseline.alphabetic                        
    //                    ),
    //                  ),
    //                  new Text(
    //                    widget.tipo,                        
    //                    style: new TextStyle(
    //                      color: this.switchValue ? Colors.black54 : Colors.black26,
    //                      fontFamily: "Roboto",
    //                      fontSize: 12.0,
    //                      fontWeight: FontWeight.w400,
    //                      textBaseline: TextBaseline.alphabetic
    //                    ),
    //                  ),
    //                ],
    //              )
    //            ],
    //          ),
    //        ),
    //      ),
    //      new Switch(
    //        value: this.switchValue,
    //        onChanged: (bool value) {
    //          setState(() {
    //            contaDB.id = widget.id;
    //            contaDB.conta = widget.conta;
    //            contaDB.tipo = widget.tipo;
    //            contaDB.saldoinicial = widget.saldoinicial;
    //            contaDB.cor = widget.numeroCor;
    //            contaDB.ativada = value ? 1 : 0;
    //            this.switchValue = value;
    //            contaDB.upsertConta(contaDB);                
    //          });
    //        },
    //      )                 
    //    ],
    //  ),
    //); 
  //}  
}
