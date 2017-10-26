import 'package:flutter/material.dart';

class CardAlertas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget alertas = new Container(
      padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[          
          new Expanded(
            child: new GestureDetector(
              child: new InkWell(
                onTap: () {
                  print('oiiiiiiiiiiiiiiii');
                },
                child: new Container(
                  decoration: new BoxDecoration(
                    border: new Border(
                      right: new BorderSide(style: BorderStyle.solid, color: new Color(0xFF9E9E9E)),
                      //top: new BorderSide(style: BorderStyle.solid, color: new Color(0xFF9E9E9E)),
                      //left: new BorderSide(style: BorderStyle.solid, color: new Color(0xFF9E9E9E)),
                      //bottom: new BorderSide(style: BorderStyle.solid, color: new Color(0xFF9E9E9E)),
                      )
                  ),
                  child: new Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '0',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 35.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF00BFA5)
                        ),
                      ),
                      new Container(
                        width: 60.0,
                        //decoration: new BoxDecoration(
                        //  border: new Border.all( color: new Color(0xFF9E9E9E)),
                        //),
                        child: new Text(
                          'contas a receber',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: new TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          new Expanded(
            child: new GestureDetector(
              child: new InkWell(
                onTap: () {
                  print('olaaaaaaa');
                },
                child: new Container(
                  decoration: new BoxDecoration(
                    //border: new Border.all( color: new Color(0xFF9E9E9E)),
                    border: new Border(right: new BorderSide(
                      style: BorderStyle.solid,
                      color: new Color(0xFF9E9E9E),
                    ))
                  ),
                  child: new Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '0',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 35.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFFF44336)
                        ),
                      ),
                      new Container(
                        width: 60.0,
                        child: new Text(
                          'contas a pagar',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: new TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E)
                          ),
                        ),
                      ),                  
                    ],
                  ),
                ),
              ),
            )
          ),
          new Expanded(
            child: new GestureDetector(
              child: new InkWell(
                onTap: () {
                  print('vammmosss');
                },                
                child: new Container(
                  child: new Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '0',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 35.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFFF44336)
                        ),
                      ),
                      new Container(
                        width: 60.0,
                        child: new Text(
                          'contas atrasadas',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: new TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          )
        ],
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
              'Alertas da semana',
                style: new TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Roboto',
                  color: new Color(0xFF757575),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            alertas,            
          ]
        ),
      ),
    );
  }

  
}