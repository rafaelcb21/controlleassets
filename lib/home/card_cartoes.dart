import 'package:flutter/material.dart';

class CardCartoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget cartao = new GestureDetector(
      child: new InkWell(
        onTap: () {
          print('cartacartao');
        },
        child: new Container(
          padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: new Row(        
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.only(right: 24.0),
                child: new CircleAvatar(
                  backgroundImage: new AssetImage('lib/images/amex.png'), //0xFF306FC5 amex
                  backgroundColor: new Color(0xFF306FC5), //0xFFF5F5F5
                  radius: 16.0,
                )
              ),
              new Expanded(
                child: new Container(
                  padding: new EdgeInsets.only(right: 13.0),
                  child: new Text(
                    'Platinum Caixa',
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
            ],
          )
        )
      ),
    );

    return new Container(
      padding: new EdgeInsets.only(bottom: 6.0, right: 6.0, left: 6.0),
      child: new  Card(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.only(left: 18.0, top: 18.0),
              child: new Text(
              'Cartões de crédito',
                style: new TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Roboto',
                  color: new Color(0xFF757575),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            cartao,
            cartao
          ]
        ),
      ),
    );
  }
}