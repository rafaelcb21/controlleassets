import "package:flutter/material.dart";

class CardSaldo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.only(bottom: 3.0, right: 6.0, left: 6.0, top: 12.0),
      child: new Card(
        child: new GestureDetector(
          child: new InkWell(
            onTap: () {
              print('saldo');
            },
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Container(
                  padding: new EdgeInsets.only(top: 18.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        'R\$  ',
                        style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF26C6DA),
                        )
                      ),
                      new Text(
                        '3.435,23',
                        style: new TextStyle(
                          fontSize: 35.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF26C6DA)
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  padding: new EdgeInsets.only(top: 3.0, bottom: 3.0),
                  child: new Text(
                    'saldo geral',
                    style: new TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF757575),
                    ),
                  ),
                ),
                
                new Container(
                  padding: new EdgeInsets.only(left: 32.0, right: 32.0),
                  child: new Divider(),
                ),

                new Container(
                  padding: new EdgeInsets.only(top: 3.0),
                  child: new Text(
                    '20/05 - 19/06',
                    style: new TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF212121),
                    ),
                  ),
                ),

                new Container(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 6.0, bottom: 3.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        'Receita:',
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF757575),
                        ),
                      ),
                      new Text(
                        'R\$ 3.051,00',
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF00BFA5),
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 3.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        'Despesa:',
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF757575),
                        ),
                      ),
                      new Text(
                        'R\$ 2.587,00',
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFFF44336),
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 18.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        'Resultado:',
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF757575),
                        ),
                      ),
                      new Text(
                        'R\$ 464,00',
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF00BFA5),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }  
}