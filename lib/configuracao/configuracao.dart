import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import '../lancamento/consultalancamento.dart';
import '../lancamento/lancamento.dart';
import 'package:intl/intl.dart';

class ConfiguracaoPage extends StatefulWidget {
  @override
  ConfiguracaoPageState createState() => new ConfiguracaoPageState();
}

class ConfiguracaoPageState extends State<ConfiguracaoPage> {
  Color azulAppbar = new Color(0xFF26C6DA);
  String _valueText = "Mensal";
  String diaLabelInicio = "";
  String diaLabelFim = "";
  String label = "";
  
  DateTime from;
  DateTime to;

  @override
  void initState() {

  }

  void showDialogPeriodos<T>({ BuildContext context, Widget child }) {
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

  String dataPeriodo(DateTime from, DateTime to) {

    var anoMesDiaInicio = new DateFormat.yMMMd("pt_BR").format(from);
    List yMMMdInicio = anoMesDiaInicio.split(' ');
    yMMMdInicio[0].length == 1 ? diaLabelInicio = '0' + yMMMdInicio[0] : diaLabelInicio = yMMMdInicio[0];

    var anoMesDiaFim = new DateFormat.yMMMd("pt_BR").format(to);
    List yMMMdFim = anoMesDiaFim.split(' ');
    yMMMdFim[0].length == 1 ? diaLabelFim = '0' + yMMMdFim[0] : diaLabelFim = yMMMdFim[0];

    String diaMesInicio = diaLabelInicio + ' ' + yMMMdInicio[2][0].toUpperCase() + yMMMdInicio[2].substring(1); // 23 Dez
    String diaMesFim = diaLabelFim + ' ' + yMMMdFim[2][0].toUpperCase() + yMMMdFim[2].substring(1); // 29 Dez

    label = diaMesInicio + " à " + diaMesFim; // 23 Dez à 29 Dez

    return label;

  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Configurações'),
        backgroundColor: azulAppbar,
      ),
      body: new ListView(
        //padding: new EdgeInsets.only(top: 8.0, right: 0.0, left: 0.0),
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
            child: new InputDropdown(
              labelText: 'Escolha seu periodo',
              valueText: _valueText,
              valueStyle: valueStyle,
              onPressed: () {
                showDialogPeriodos<String>(
                  context: context,
                  child: new SimpleDialog(
                    title: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text('Periodos'),
                      ],
                    ),
                    children: <Widget>[
                      new DialogItemConsulta(
                        text: "Diário",
                        onPressed: () {
                          setState(() {
                            _valueText = "Diário";
                          });                       
                          Navigator.pop(context, new DateTime.now());
                        }
                      ),
                      new DialogItemConsulta(
                        text: "Semanal",
                        onPressed: () {
                          setState(() {
                            _valueText = "Semanal";
                          }); 
                          Navigator.pop(context, new DateTime.now());
                        }
                      ),
                      new DialogItemConsulta(
                        text: "Mensal",
                        onPressed: () {
                          setState(() {
                            _valueText = "Mensal";
                          }); 
                          Navigator.pop(context, new DateTime.now());
                        }
                      ),
                      new DialogItemConsulta(
                        text: "Periodo",
                        onPressed: () async {
                          Navigator.pop(context);
                          List fromAndTo = await Navigator.of(context).push(new PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new FullScreenPeriodoDate();
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

                        
                          if(fromAndTo != null) {
                            this.from = fromAndTo[0];
                            this.to = fromAndTo[1];

                            setState(() {
                            _valueText = dataPeriodo(this.from, this.to);
                            });                           
                            
                          }
                        }
                      ),
                    ]
                  )
                );
              },
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 70.0, right: 70.0, top: 100.0, bottom: 16.0),
            child: new RaisedButton(
              onPressed: () {},
              color: azulAppbar,
              child: const Text(
                'Salvar',
                style: const TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 24.0
                ),  
              ),
            )
          )
        ]
      )
    );
  }
}

