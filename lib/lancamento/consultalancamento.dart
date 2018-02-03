import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../palette/palette.dart';
import '../db/database.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/animation.dart';
import "./lancamento.dart";

class ConsultaLancamentoPage extends StatefulWidget {
  @override
  ConsultaLancamentoPageState createState() => new ConsultaLancamentoPageState();
}

class ConsultaLancamentoPageState extends State<ConsultaLancamentoPage>  with TickerProviderStateMixin {
  Color azulAppbar = new Color(0xFF26C6DA);
  Lancamento lancamentoDB = new Lancamento();
  List<Widget> listaLancamentos = [];
  List listaDB = [];
  Palette listaCores = new Palette();
  List cores = [];
  String periodoFiltro = "";
  String periodoFiltroResumido = "";
  List periodoFiltroDateTimeList = [];
  DateTime periodoFiltroDateTime = new DateTime.now();
  DateTime periodoNext = new DateTime.now();
  DateTime from;
  DateTime to;
  String periodo = "mes";
  List total = [];

  AnimationController _controller;
  Animation<double> _animation;
  Animation<double> _animation2;
  Animation<double> _animation3;
  int _angle = 90;
  bool _isRotated = true;
  Color corBrancaItem = new Color(0xFFFAFAFA);

  @override
  void initState() {
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );

    _animation2 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.5, 1.0, curve: Curves.linear),
    );

    _animation3 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.8, 1.0, curve: Curves.linear),
    );
    _controller.reverse();

    setState(() {
      String periodoInicial = criarPeriodoFiltro(this.periodo);
      lancamentoDB.lancamentoDeFixo(this.periodo, periodoInicial).then((data) {
        if(this.periodo == 'mes') {
          lancamentoDB.getLancamentoMes(new DateTime.now()).then(
            (list) {
              setState(() {
                if(list.length > 0) {
                  this.listaDB = list[0];
                  this.periodoFiltro = list[1][1];

                }            
              });
            } //[[11 de dezembro, [{idcategoria: 8, idconta: 1, fatura: null, hash
          );
        }
      });
           
    });
  }

  String criarPeriodoFiltro(periodo) {
    String diaLabelInicio = "";
    if(periodo == 'mes') {
      DateTime hoje = new DateTime.now();
      int mes = hoje.month;
      int ano = hoje.year;
      //pega o ultimo dia do mes anterior para conseguir o ultimo dia do mes atual
      DateTime periodoAtual = new DateTime(ano, mes, 0);
      var hojeMesDescrito = new DateFormat.yMMMM("pt_BR").format(periodoAtual).toString();
      return hojeMesDescrito;
    }

    return '';    
  }

  void showDialogPeriodos<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        setState(() {
          //lancamentoDB.getLancamentoMes(this.periodoNext).then(
          //  (list) {
          //    setState(() {
          //      if(list.length > 0) {
          //        this.listaDB = list[0];
          //        this.periodoFiltro = list[1][1];
          //      }            
          //    });
          //  }
          //);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;
    final double _height = logicalSize.height;
    

    List<Widget> buildLancamentos(lista) {
      this.total = [];
      this.listaLancamentos = [new Container(
        padding: new EdgeInsets.only(bottom: 66.0),
      )];

      for(var i = 0; i < lista.length; i++) {
        ///Dia
        this.listaLancamentos.add(
          new Container(
            padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0, top: 5.0),
            decoration: new BoxDecoration(
              border: new Border(
                bottom: new BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.black12,
                ),
              )
            ),
            child: new Row(
              children: <Widget>[
                new Text(
                  lista[i][0][2], //dia ex: 1 de fevereiro
                  style: new TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Roboto',
                    color: new Color(0xFF9E9E9E)
                  ),
                ),
              ],
            ),
          )
        );

        //for(var u = 0; u < lista[i].length; u++) {
        for(var listaLaunch in lista[i]) {
          if(listaLaunch[3] == 'semCartao') {
            String valor = '';
            String textoPago = '';
            int pago = listaLaunch[5];
            int id = listaLaunch[8];
            String data = listaLaunch[9];
            String hash = listaLaunch[6];
            String tipo = listaLaunch[10];
            double valorLaunch = listaLaunch[7];
            String categoria = listaLaunch[4];
            String descricao = listaLaunch[1];
            
            this.total.add(valorLaunch);

            if(tipo == "Despesa") {
              
              var f = new NumberFormat.currency(locale: "pt_BR", symbol: "", decimalDigits: 2);
              valor = f.format(valorLaunch);
              if(pago == 0){
                textoPago = "não pago";
              } else {
                textoPago = "pago";
              }
            } else {
              var f = new NumberFormat.currency(locale: 'pt_BR', symbol: "", decimalDigits: 2);
              valor = f.format(valorLaunch);

              if(pago == 0 && tipo == "Receita"){
                textoPago = "não recebido";
              } else if(pago == 0 && tipo == "Transferência") {
                textoPago = "não transferido";
              } else if(pago == 1 && tipo == "Receita") {
                textoPago = "recebido";
              } else if(pago == 1 && tipo == "Transferência") {
                textoPago = "transferido";
              }
            }   
          
            this.listaLancamentos.add(
              new ItemLancamento(
                key: new ObjectKey(id),
                id: id,
                tipo: tipo,
                categoria: categoria,
                //idtag: lista[i][1][u]['idtag'],
                //idconta: lista[i][1][u]['idconta'],
                //idcontadestino: lista[i][1][u]['idcontadestino'],
                //idcartao: lista[i][1][u]['idcartao'],
                valor: valor,
                data: data,
                descricao: descricao,
                //tiporepeticao: lista[i][1][u]['tiporepeticao'],
                //periodorepeticao: lista[i][1][u]['periodorepeticao'],
                //quantidaderepeticao: lista[i][1][u]['quantidaderepeticao'],
                //fatura: lista[i][1][u]['fatura'],
                pago: pago,
                textoPago: textoPago,
                hash: hash,
                onPressed: () {
                  
                  lancamentoDB.getLancamento(id).then(
                    (list) async {                        
                      lancamentoDB.idcategoria = list[0]['idcategoria'];
                      lancamentoDB.idconta = list[0]['idconta'];
                      lancamentoDB.fatura = list[0]['fatura'];
                      lancamentoDB.hash = list[0]['hash'];
                      lancamentoDB.valor = list[0]['valor'];
                      lancamentoDB.data = list[0]['data'];
                      lancamentoDB.idcontadestino = list[0]['idcontadestino'];
                      lancamentoDB.idtag = list[0]['idtag'];
                      lancamentoDB.pago = list[0]['pago'];
                      lancamentoDB.descricao = list[0]['descricao'];
                      lancamentoDB.id = list[0]['id'];
                      lancamentoDB.quantidaderepeticao = list[0]['quantidaderepeticao'];
                      lancamentoDB.idcartao = list[0]['idcartao'];
                      lancamentoDB.tipo = list[0]['tipo'];
                      lancamentoDB.datafatura = list[0]['datafatura'];
                      lancamentoDB.periodorepeticao = list[0]['periodorepeticao'];
                      lancamentoDB.tiporepeticao = list[0]['tiporepeticao'];

                      Color corLancamento;

                      if(list[0]['tipo'] == 'Despesa') {
                        corLancamento = new Color(0xFFE57373);
                      } else if(list[0]['tipo'] == 'Transferência') {
                        corLancamento = new Color(0xFF9E9E9E);
                      } else {
                        corLancamento = new Color(0xFF00BFA5);
                      }

                      List resultado = await Navigator.of(context).push(new PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return new LancamentoPage(true, lancamentoDB, corLancamento, this.periodo, this.periodoFiltro, [this.from, this.to]);
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

                      if(resultado != null) {
                        if(resultado[0]) {
                          setState(() {
                            if(this.periodo == 'hoje') {
                              lancamentoDB.getLancamentoHoje(this.periodoFiltroDateTime).then(
                                (list) {
                                  setState(() {
                                    this.periodo = "hoje";
                                    if(list.length > 0) {
                                      this.listaDB = list[0];
                                      this.periodoFiltro = list[1][1];
                                      this.periodoFiltroDateTime = list[1][0][0];
                                    }            
                                  });
                                }
                              );
                            } else if (this.periodo == 'semana') {
                              lancamentoDB.getLancamentoSemana(this.periodoFiltroDateTime).then(
                                (list) {
                                  setState(() {
                                    this.periodo = "semana";
                                    if(list.length > 0) {
                                      this.listaDB = list[0];
                                      this.periodoFiltro = list[1][1];
                                      this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                      this.periodoFiltroDateTime = list[1][0][0];
                                    }
                                  });
                                }
                              );
                            } else if(this.periodo == 'mes') {
                              lancamentoDB.getLancamentoMes(this.periodoFiltroDateTime).then(
                                (list) {
                                  this.periodo = "mes";
                                  setState(() {                                  
                                    if(list.length > 0) {
                                      this.listaDB = list[0];
                                      this.periodoFiltro = list[1][1];
                                      this.periodoFiltroDateTime = list[1][0][0];
                                    }            
                                  });
                                }
                              );
                            } else if(this.periodo == 'periodo') {
                              lancamentoDB.getLancamentoPeriodo(this.periodoFiltroDateTimeList[0], this.periodoFiltroDateTimeList[1]).then(
                                (list) {
                                  setState(() {
                                    if(list.length > 0) {
                                      this.listaDB = list[0];
                                      this.periodoFiltro = list[1][1];
                                      this.periodoFiltroResumido =
                                        list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                        + " à " + 
                                        list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                                      this.periodoFiltroDateTimeList = list[1][0][0];
                                    }
                                  });
                                }
                              );
                            }                            
                          });
                        }
                      }
                    }
                  );
                },
                onPressed2: () async {
                  void showDeleteDialog<T>({ BuildContext context, Widget child }) {
                    showDialog<List>(
                      context: context,
                      child: child,
                    )
                    .then<Null>((List value) {
                      if (value != null) {
                        setState(() {
                          this.listaDB = value[0][0];
                          this.periodoFiltro = value[0][1][1];

                          if(value[0][1] != 'periodo') {                              
                            this.periodoFiltroDateTime = value[0][1][0][0];
                          } else {
                            this.periodoFiltroResumido =
                              value[0][1][1].substring(0, 7) + value[0][1][1].substring(12, 14)
                                + " à " + 
                              value[0][1][1].substring(17, 24) + value[0][1][1].substring(29, 31);
                            this.periodoFiltroDateTimeList = value[0][1][0][0];
                          }
                        });
                      }                      
                    });
                  }

                  if(hash == null) {
                    showDeleteDialog<DialogOptionsAction>(
                      context: context,
                      child: new AlertDialog(
                        title: const Text('Deletar Lançamento'),
                        content: new Text(
                            'Deseja deletar esse lançamento?',
                            softWrap: true,
                            style: new TextStyle(
                              color: Colors.black45,
                              fontSize: 16.0,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                            )
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: const Text('CANCEL'),
                            onPressed: () {                                
                              Navigator.pop(context);
                            }
                          ),
                          new FlatButton(
                            child: const Text('OK'),
                            onPressed: () {
                              lancamentoDB.deleteLancamentoNaoRepetidos(id).then((data) {
                                if(this.periodo == "hoje") {
                                  lancamentoDB.getLancamentoHoje(this.periodoNext).then(
                                    (list) {
                                      setState(() {
                                        if(list.length > 0) {
                                          Navigator.pop(context, [list]);
                                        }
                                      });
                                    }
                                  );
                                } else if(this.periodo == "semana") {
                                  lancamentoDB.getLancamentoSemana(this.periodoNext).then(
                                    (list) {
                                      setState(() {
                                        if(list.length > 0) {
                                          Navigator.pop(context, [list]);
                                        }
                                      });
                                    }
                                  );
                                } else if(this.periodo == "mes") {
                                  lancamentoDB.getLancamentoMes(this.periodoNext).then(
                                    (list) {
                                      setState(() {
                                        if(list.length > 0) {
                                          Navigator.pop(context, [list]);
                                        }
                                      });
                                    }
                                  );
                                } else if(this.periodo == "periodo") {
                                  lancamentoDB.getLancamentoPeriodo(this.from, this.to).then(
                                    (list) {
                                      setState(() {
                                        if(list.length > 0) {
                                          Navigator.pop(context, [list, 'periodo']);
                                        }
                                      }
                                    );
                                  });
                                }
                              });
                            }
                          )
                        ]
                      )
                    );
                  } else {
                    showDeleteDialog<DialogOptionsAction>(
                      context: context,
                      child: new AlertDialog(
                        title: const Text('Deletar Lançamento'),
                        content: new Container(
                          height: 120.0,
                          child: new Column(
                            children: <Widget>[
                              new GestureDetector(
                                onTap: (){
                                  lancamentoDB.deleteLancamento(id).then((data) {
                                    if(this.periodo == "hoje") {
                                      lancamentoDB.getLancamentoHoje(this.periodoNext).then(
                                        (list) {
                                          setState(() {
                                            if(list.length > 0) {
                                              Navigator.pop(context, [list, 'hoje']);
                                            }
                                          });
                                        }
                                      );
                                    } else if(this.periodo == "semana") {
                                      lancamentoDB.getLancamentoSemana(this.periodoNext).then(
                                        (list) {
                                          setState(() {
                                            if(list.length > 0) {
                                              Navigator.pop(context, [list, 'semana']);
                                            }
                                          });
                                        }
                                      );
                                    } else if(this.periodo == "mes") {
                                      lancamentoDB.getLancamentoMes(this.periodoNext).then(
                                        (list) {
                                          setState(() {
                                            if(list.length > 0) {
                                              Navigator.pop(context, [list, 'mes']);
                                            }
                                          });
                                        }
                                      );
                                    } else if(this.periodo == "periodo") {
                                      lancamentoDB.getLancamentoPeriodo(this.from, this.to).then(
                                        (list) {
                                          setState(() {
                                            if(list.length > 0) {
                                              Navigator.pop(context, [list, 'periodo']);
                                            }
                                          }
                                        );
                                      });
                                    }
                                  });
                                },                                    
                                child: new Container(
                                  margin: new EdgeInsets.only(bottom: 16.0),
                                  padding: new EdgeInsets.only(left: 16.0, right: 16.0),                                
                                  width: 250.0,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    color: new Color(0xFF9E9E9E),
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        'Apenas esse',
                                        softWrap: true,
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500,
                                        )
                                      ),
                                    ],
                                  )
                                ),
                              ),
                              new GestureDetector(
                                onTap: (){
                                  lancamentoDB.deleteLancamentoRepetidos(data, hash).then((data) {
                                    if(this.periodo == "hoje") {
                                      lancamentoDB.getLancamentoHoje(this.periodoNext).then(
                                        (list) {
                                          setState(() {
                                            if(list.length > 0) {
                                              this.listaDB = list[0];
                                              this.periodoFiltro = list[1][1];
                                              this.periodoFiltroDateTime = list[1][0][0];
                                            }
                                          });
                                        }
                                      );
                                    } else if(this.periodo == "semana") {
                                      lancamentoDB.getLancamentoSemana(this.periodoNext).then(
                                        (list) {
                                          setState(() {
                                            if(list.length > 0) {
                                              this.listaDB = list[0];
                                              this.periodoFiltro = list[1][1];
                                              this.periodoFiltroDateTime = list[1][0][0];
                                            }
                                          });
                                        }
                                      );
                                    } else if(this.periodo == "mes") {
                                      lancamentoDB.getLancamentoMes(this.periodoNext).then(
                                        (list) {
                                          setState(() {
                                            if(list.length > 0) {
                                              this.listaDB = list[0];
                                              this.periodoFiltro = list[1][1];
                                              this.periodoFiltroDateTime = list[1][0][0];
                                            }
                                          });
                                        }
                                      );
                                    } else if(this.periodo == "periodo") {
                                      lancamentoDB.getLancamentoPeriodo(this.from, this.to).then(
                                        (list) {
                                          setState(() {
                                            if(list.length > 0) {
                                              this.listaDB = list[0];
                                              this.periodoFiltro = list[1][1];
                                              this.periodoFiltroResumido =
                                                list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                                  + " à " + 
                                                list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                                              this.periodoFiltroDateTimeList = list[1][0][0];
                                            }
                                          });
                                        }
                                      );
                                    }
                                    Navigator.pop(context);
                                  });
                                },
                                child: new Container(
                                  margin: new EdgeInsets.only(bottom: 16.0),
                                  padding: new EdgeInsets.only(left: 16.0, right: 16.0),                                
                                  width: 250.0,
                                  height: 40.0,
                                  decoration: new BoxDecoration(
                                    color: new Color(0xFF9E9E9E),
                                    borderRadius: new BorderRadius.circular(3.0)
                                  ),
                                  child: new Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        'Esse e os próximos',
                                        softWrap: true,
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontFamily: "Roboto",
                                          fontWeight: FontWeight.w500,
                                        )
                                      ),
                                    ],
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    );
                  }
                },
                onPressed3: () {
                  lancamentoDB.updateLancamentoPago(id, pago).then((data) {
                    if(this.periodo == "hoje") {
                      lancamentoDB.getLancamentoHoje(this.periodoNext).then(
                        (list) {
                          setState(() {
                            if(list.length > 0) {
                              this.listaDB = list[0];
                              this.periodoFiltro = list[1][1];
                              this.periodoFiltroDateTime = list[1][0][0];
                            }
                          });
                        }
                      );
                    } else if(this.periodo == "semana") {
                      lancamentoDB.getLancamentoSemana(this.periodoNext).then(
                        (list) {
                          setState(() {
                            if(list.length > 0) {
                              this.listaDB = list[0];
                              this.periodoFiltro = list[1][1];
                              this.periodoFiltroDateTime = list[1][0][0];
                            }
                          });
                        }
                      );
                    } else if(this.periodo == "mes") {
                      lancamentoDB.getLancamentoMes(this.periodoNext).then(
                        (list) {
                          setState(() {
                            if(list.length > 0) {
                              this.listaDB = list[0];
                              this.periodoFiltro = list[1][1];
                              this.periodoFiltroDateTime = list[1][0][0];
                            }
                          });
                        }
                      );
                    } else if(this.periodo == "periodo") {
                      lancamentoDB.getLancamentoPeriodo(this.from, this.to).then(
                        (list) {
                          setState(() {
                            if(list.length > 0) {
                              this.listaDB = list[0];
                              this.periodoFiltro = list[1][1];
                              this.periodoFiltroResumido =
                                list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                  + " à " + 
                                list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                              this.periodoFiltroDateTimeList = list[1][0][0];
                            }
                          });
                        }
                      );
                    }
                  });
                },
              )
            );
          } else if(listaLaunch[3] == 'comCartao') {
            String valor = '';
            String textoPago = '';
            String tipo = listaLaunch[3];
            double valorLaunch = listaLaunch[5];
            int pago = listaLaunch[7];
            String categoria = listaLaunch[4];
            String descricao = listaLaunch[1];
            List ids = listaLaunch[8];

            this.total.add(valorLaunch);

            //var data = new DateFormat("yyyy-MM-dd").parse(STRING);
            //var dataFormatada = new DateFormat.yMMMM("pt_BR").format(DATETIME).toString();

            String data = new DateFormat("yyyy-MM-dd").format(listaLaunch[0]);
            
            if(valorLaunch < 0) {
              var f = new NumberFormat.currency(locale: "pt_BR", symbol: "", decimalDigits: 2);
              valor = f.format(valorLaunch);
              if(pago == 0){
                textoPago = "não pago";
              } else {
                textoPago = "pago";
              }
            } else if(valorLaunch > 0) {
              var f = new NumberFormat.currency(locale: 'pt_BR', symbol: "", decimalDigits: 2);
              valor = f.format(valorLaunch);
              if(pago == 0){
                textoPago = "não recebido";
              } else {
                textoPago = "recebido";
              }
            }

            this.listaLancamentos.add(
              new ItemLancamentoCartao(
                key: new ObjectKey(ids[0]),
                ids: ids,
                tipo: tipo,
                categoria: "cartão " + categoria,
                valor: valor,
                valorOriginal: valorLaunch,
                data: data.toString(),
                descricao: descricao,
                pago: pago,
                textoPago: textoPago,
                
                onPressed2: () {
                  lancamentoDB.updateLancamentoPagoFatura(ids, pago).then((data) {
                    if(this.periodo == "hoje") {
                      lancamentoDB.getLancamentoHoje(this.periodoNext).then(
                        (list) {
                          setState(() {
                            if(list.length > 0) {
                              this.listaDB = list[0];
                              this.periodoFiltro = list[1][1];
                              this.periodoFiltroDateTime = list[1][0][0];
                            }
                          });
                        }
                      );
                    } else if(this.periodo == "semana") {
                      lancamentoDB.getLancamentoSemana(this.periodoNext).then(
                        (list) {
                          setState(() {
                            if(list.length > 0) {
                              this.listaDB = list[0];
                              this.periodoFiltro = list[1][1];
                              this.periodoFiltroDateTime = list[1][0][0];
                            }
                          });
                        }
                      );
                    } else if(this.periodo == "mes") {
                      lancamentoDB.getLancamentoMes(this.periodoNext).then(
                        (list) {
                          setState(() {
                            if(list.length > 0) {
                              this.listaDB = list[0];
                              this.periodoFiltro = list[1][1];
                              this.periodoFiltroDateTime = list[1][0][0];
                            }
                          });
                        }
                      );
                    } else if(this.periodo == "periodo") {
                      lancamentoDB.getLancamentoPeriodo(this.from, this.to).then(
                        (list) {
                          setState(() {
                            if(list.length > 0) {
                              this.listaDB = list[0];
                              this.periodoFiltro = list[1][1];
                              this.periodoFiltroResumido =
                                list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                  + " à " + 
                                list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                              this.periodoFiltroDateTimeList = list[1][0][0];
                            }
                          });
                        }
                      );
                    }
                  });
                },
              )
            );
          }
        }
      }

      this.listaLancamentos.add(
        new Container(
          padding: new EdgeInsets.only(top: 130.0),
        )
      );

      return this.listaLancamentos;
    }

    void _rotate(){
      setState((){
        if(_isRotated) {
          _angle = 45;
          _isRotated = false;
          _controller.forward(from: 0.0);
        } else {
          _angle = 90;
          _isRotated = true;
          _controller.reverse(from: 1.0);
        }
      });
    }

    List totalLista(List listaValores) {
      if(listaValores.length != 0) {
        double total = listaValores.reduce((a, b) => a + b);
        var f = new NumberFormat.currency(locale: "pt_BR", symbol: "", decimalDigits: 2);
        var valor = 'R\$ ' + f.format(total);

        if(total < 0) {
          return [valor, new Color(0xFFE57373)];
        } else {
          return [valor, new Color(0xFF00BFA5)];
        }
      }

      return ['R\$ 0,00', new Color(0xFF00BFA5)];
      
    }

    return new Scaffold( 
      appBar: new AppBar(
        title: new Text('Lancamentos'),
        backgroundColor: azulAppbar,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.filter_list),
            color: new Color(0xFFFFFFFF),
            onPressed: () {}
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          this.listaDB == [] ? new Container() : 
          new ListView(
            padding: new EdgeInsets.only(top: 16.0),
            children: buildLancamentos(this.listaDB)
          ),
//////////////////////////////////
          new Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            child: new Column(
              children: <Widget>[
                ///FIltro
                new Container(
                  padding: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 12.0),
                  decoration: new BoxDecoration(
                    color: this.corBrancaItem,
                    border: new Border(
                      bottom: new BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.black12,
                      ),
                    )
                  ),
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        'Filtro:  ',
                        style: new TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF9E9E9E)
                        ),
                      ),
                    ],
                  ),
                ),

                ///Mes
                new Container(
                  padding: new EdgeInsets.only(bottom: 9.0, top: 9.0),
                  decoration: new BoxDecoration(
                    color: this.corBrancaItem,
                    border: new Border(
                      bottom: new BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.black12,
                      ),
                    )
                  ),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        margin: new EdgeInsets.only(left: 8.0),
                        child: new InkWell(
                          onTap: (){
                            setState(() {
                              var listaFiltro = lancamentoDB.nextPeriod(this.periodoFiltro, false, this.periodo);
                              this.periodoNext = listaFiltro[1];

                              if(this.periodo == 'periodo') {
                                this.from = listaFiltro[0];
                                this.to = listaFiltro[1];
                              }

                              if(this.periodo == "hoje") {
                                lancamentoDB.getLancamentoHoje(this.periodoNext).then(
                                  (list) {
                                    setState(() {
                                      if(list.length > 0) {
                                        this.listaDB = list[0];
                                        this.periodoFiltro = list[1][1];
                                        this.periodoFiltroDateTime = list[1][0][0];
                                      }
                                    });
                                  }
                                );
                              } else if(this.periodo == "semana") {
                                lancamentoDB.getLancamentoSemana(this.periodoNext).then(
                                  (list) {
                                    setState(() {
                                      if(list.length > 0) {
                                        this.listaDB = list[0];
                                        this.periodoFiltro = list[1][1];
                                        this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                        this.periodoFiltroDateTime = list[1][0][0];
                                      }
                                    });
                                  }
                                );
                              } else if(this.periodo == "mes") {
                                lancamentoDB.getLancamentoMes(this.periodoNext).then(
                                  (list) {
                                    setState(() {
                                      if(list.length > 0) {
                                        this.listaDB = list[0];
                                        this.periodoFiltro = list[1][1];
                                        this.periodoFiltroResumido = this.periodoFiltro;
                                        this.periodoFiltroDateTime = list[1][0][0];
                                      }
                                    });
                                  }
                                );
                              } else if(this.periodo == "periodo") {
                                lancamentoDB.getLancamentoPeriodo(this.from, this.to).then(
                                  (list) {
                                    setState(() {
                                      if(list.length > 0) {
                                        this.listaDB = list[0];
                                        this.periodoFiltro = list[1][1];
                                        //23 Dez de 2017 à 29 Dez de 2018
                                        //this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                        this.periodoFiltroResumido = //23 Dez 17 à 29 Dez 18
                                          list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                          + " à " + 
                                          list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                                        this.periodoFiltroDateTimeList = list[1][0][0];
                                      }
                                    });
                                  }
                                );
                              }                         
                            });
                          },
                          child: new Icon(
                            Icons.keyboard_arrow_left,
                            color: new Color(0xFF9E9E9E),
                            size: 28.0,
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new InkWell(
                              onTap: (){
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
                                      new DialogItem(
                                        text: "Hoje",
                                        onPressed: () {
                                          lancamentoDB.getLancamentoHoje(new DateTime.now()).then(
                                            (list) {
                                              setState(() {
                                                this.periodo = "hoje";
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }            
                                              });
                                            }
                                          );
                                          Navigator.pop(context, new DateTime.now());
                                        }
                                      ),
                                      new DialogItem(
                                        text: "Esta semana",
                                        onPressed: () {
                                          //DateTime agoraDate = new DateTime.now();
                                          //lancamentoDB.getLancamentoSemana(new DateTime(agoraDate.year, agoraDate.month, agoraDate.day)).then(
                                          lancamentoDB.getLancamentoSemana(new DateTime.now()).then(
                                            (list) {
                                              setState(() {
                                                this.periodo = "semana";
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }
                                              });
                                            }
                                          );
                                          Navigator.pop(context, new DateTime.now());
                                        }
                                      ),
                                      new DialogItem(
                                        text: "Este mes",
                                        onPressed: () {
                                          lancamentoDB.getLancamentoMes(new DateTime.now()).then(
                                            (list) {
                                              setState(() {
                                                this.periodo = "mes";
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }
                                              });
                                            }
                                          );
                                          Navigator.pop(context, new DateTime.now());
                                        }
                                      ),
                                      new DialogItem(
                                        text: "Escolher periodo",
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
                                            lancamentoDB.getLancamentoPeriodo(this.from, this.to).then(
                                              (list) {
                                                setState(() {
                                                  this.periodo = list[1][2];
                                                  if(list.length > 0) {                                            
                                                    this.listaDB = list[0];
                                                    this.periodoFiltro = list[1][1];
                                                    this.periodoFiltroDateTimeList = list[1][0][0];
                                                    //this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                                    
                                                    if(this.periodo == "periodo") {
                                                      this.periodoFiltroResumido = //23 Dez 17 à 29 Dez 18
                                                      list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                                      + " à " + 
                                                      list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                                                    } else if(this.periodo == "mes") {
                                                      this.periodoFiltroResumido = this.periodoFiltro;
                                                    } else if(this.periodo == "semana") {
                                                      this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                                    }
                                                  }
                                                });
                                              }
                                            );
                                          }
                                        }
                                      ),
                                    ]
                                  )
                                );
                              },
                              child: new Text(                          
                                this.periodoFiltro.length > 17 ? this.periodoFiltroResumido : this.periodoFiltro,
                                style: new TextStyle(
                                  fontSize: 16.0,
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        margin: new EdgeInsets.only(right: 8.0),
                        child: new InkWell(
                          onTap: () {
                            setState(() {
                              var listaFiltro = lancamentoDB.nextPeriod(this.periodoFiltro, true, this.periodo);
                              this.periodoNext = listaFiltro[1];

                              if(this.periodo == 'periodo') {
                                this.from = listaFiltro[0];
                                this.to = listaFiltro[1];
                              } 

                              lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                if(this.periodo == "hoje") {
                                  lancamentoDB.getLancamentoHoje(this.periodoNext).then(
                                    (list) {
                                      setState(() {
                                        if(list.length > 0) {
                                          this.listaDB = list[0];
                                          this.periodoFiltro = list[1][1];
                                          this.periodoFiltroDateTime = list[1][0][0];
                                        }
                                      });
                                    }
                                  );
                                } else if(this.periodo == "semana") {
                                  lancamentoDB.getLancamentoSemana(this.periodoNext).then(
                                    (list) {
                                      setState(() {
                                        if(list.length > 0) {
                                          this.listaDB = list[0];
                                          this.periodoFiltro = list[1][1];
                                          this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                          this.periodoFiltroDateTime = list[1][0][0];
                                        }
                                      });
                                    }
                                  );
                                } else if(this.periodo == "mes") {
                                  lancamentoDB.getLancamentoMes(this.periodoNext).then(
                                    (list) {
                                      setState(() {
                                        if(list.length > 0) {
                                          this.listaDB = list[0];
                                          this.periodoFiltro = list[1][1];
                                          this.periodoFiltroResumido = this.periodoFiltro;
                                          this.periodoFiltroDateTime = list[1][0][0];
                                        }
                                      });
                                    }
                                  );
                                } else if(this.periodo == "periodo") {
                                  lancamentoDB.getLancamentoPeriodo(this.from, this.to).then(
                                    (list) {
                                      setState(() {
                                        if(list.length > 0) {
                                          this.listaDB = list[0];
                                          this.periodoFiltro = list[1][1];
                                          //this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                          this.periodoFiltroResumido = //23 Dez 17 à 29 Dez 18
                                            list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                            + " à " + 
                                            list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                                          this.periodoFiltroDateTimeList = list[1][0][0];
                                        }
                                      });
                                    }
                                  );
                                } 
                              });
                            });
                          },
                          child: new Icon(
                            Icons.keyboard_arrow_right,
                            color: new Color(0xFF9E9E9E),
                            size: 28.0,
                          ),
                        ),
                      )
                    ]
                  ),
                )
              ]
            )
          ),

          new Positioned(
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            child: new Container(
              padding: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
              decoration: new BoxDecoration(
                color: new Color(0xFFFAFAFA),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                  )
                ],
                border: new Border(
                  top: new BorderSide(
                    style: BorderStyle.solid,
                    color: Colors.black12,
                  ),
                )
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'Total: ',
                    style: new TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF9E9E9E)
                    ),
                  ),
                  new Text(
                    totalLista(this.total)[0],
                    style: new TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Roboto',
                      color: totalLista(this.total)[1],
                    ),
                  )
                ],
              )
            )
          ),

          // float button
          new Positioned(
            bottom: 0.0,
            child: new GestureDetector(
              onTap: _rotate,
              child: new AnimatedBuilder(
                animation: _animation,
                builder: (BuildContext context, Widget child) {
                  return new Container(
                    height: _height,
                    child: new CustomPaint(
                      painter: new Sky(_width, _height * _animation.value),
                      child: new Container(
                        height: _isRotated ? 0.0 : _height * _animation.value,
                        width: _isRotated ? 0.0 : _width,
                      ),
                    ),
                  );
                }
              ),
            )
          ),
          new Positioned(
            bottom: 200.0 + 46.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: _animation3,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Text(
                        'transferência',
                        style: new TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF9E9E9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ), 
                    ),
                  ),
                  
                  new ScaleTransition(
                    scale: _animation3,
                    alignment: FractionalOffset.center,
                    child: new Material(
                      color: new Color(0xFF9E9E9E),
                      type: MaterialType.circle,
                      elevation: 6.0,
                      child: new GestureDetector(
                        child: new Container(
                          width: 40.0,
                          height: 40.0,
                          child: new InkWell(
                            onTap: ()  async {
                              if(_angle == 45.0){
                                _rotate();
                                
                                List resultado = await Navigator.of(context).push(new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new LancamentoPage(false, new Lancamento(), new Color(0xFF9E9E9E), '', '', []);
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

                                if(resultado != null) {
                                  if(resultado[0]) {
                                    setState(() {
                                      if(this.periodo == 'hoje') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoHoje(this.periodoFiltroDateTime).then(
                                            (list) {
                                              setState(() {
                                                this.periodo = "hoje";
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }            
                                              });
                                            }
                                          );
                                        });
                                      } else if (this.periodo == 'semana') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoSemana(this.periodoFiltroDateTime).then(
                                            (list) {
                                              setState(() {
                                                this.periodo = "semana";
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }
                                              });
                                            }
                                          );
                                        });

                                      } else if(this.periodo == 'mes') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoMes(this.periodoFiltroDateTime).then(
                                            (list) {
                                              this.periodo = "mes";
                                              setState(() {                                  
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }            
                                              });
                                            }
                                          );
                                        });
                                        
                                      } else if(this.periodo == 'periodo') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoPeriodo(this.periodoFiltroDateTimeList[0], this.periodoFiltroDateTimeList[1]).then(
                                            (list) {
                                              setState(() {
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroResumido =
                                                    list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                                    + " à " + 
                                                    list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                                                  this.periodoFiltroDateTimeList = list[1][0][0];
                                                }
                                              });
                                            }
                                          );
                                        });
                                      }
                                    });
                                  }
                                }
                              }
                            },
                            child: new Center(
                              child: new Icon(
                                Icons.add,
                                color: new Color(0xFFFFFFFF),
                              ),                      
                            ),
                          )
                        ),
                      )
                    ),
                  ),
                ],
              ),
            )
          ),
          
          new Positioned(
            bottom: 144.0 + 46.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: _animation2,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Text(
                        'receita',
                        style: new TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF9E9E9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ), 
                    ),
                  ),

                  new ScaleTransition(
                    scale: _animation2,
                    alignment: FractionalOffset.center,
                    child: new Material(
                      color: new Color(0xFF00BFA5),
                      type: MaterialType.circle,
                      elevation: 6.0,
                      child: new GestureDetector(
                        child: new Container(
                          width: 40.0,
                          height: 40.0,
                          child: new InkWell(
                            onTap: () async {
                              if(_angle == 45.0) {
                                _rotate();
                                
                                List resultado = await Navigator.of(context).push(new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new LancamentoPage(false, new Lancamento(), new Color(0xFF00BFA5), '', '', []);
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

                                if(resultado != null) {
                                  if(resultado[0]) {
                                    setState(() {
                                      if(this.periodo == 'hoje') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoHoje(this.periodoFiltroDateTime).then(
                                            (list) {
                                              setState(() {
                                                this.periodo = "hoje";
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }            
                                              });
                                            }
                                          );
                                        });
                                      } else if (this.periodo == 'semana') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoSemana(this.periodoFiltroDateTime).then(
                                            (list) {
                                              setState(() {
                                                this.periodo = "semana";
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }
                                              });
                                            }
                                          );
                                        });
                                      } else if(this.periodo == 'mes') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoMes(this.periodoFiltroDateTime).then(
                                            (list) {
                                              this.periodo = "mes";
                                              setState(() {                                  
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }            
                                              });
                                            }
                                          );
                                        });
                                      } else if(this.periodo == 'periodo') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoPeriodo(this.periodoFiltroDateTimeList[0], this.periodoFiltroDateTimeList[1]).then(
                                            (list) {
                                              setState(() {
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroResumido =
                                                    list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                                    + " à " + 
                                                    list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                                                  this.periodoFiltroDateTimeList = list[1][0][0];
                                                }
                                              });
                                            }
                                          );
                                        });
                                      }
                                    });
                                  }
                                }
                              }
                            },
                            child: new Center(
                              child: new Icon(
                                Icons.add,
                                color: new Color(0xFFFFFFFF),
                              ),
                            ),
                          )
                        ),
                      )
                    ),
                  ), 
                ],
              ),
            )
          ),
          new Positioned(
            bottom: 88.0 + 46.0,
            right: 24.0,
            child: new Container(
              child: new Row(
                children: <Widget>[
                  new ScaleTransition(
                    scale: _animation,
                    alignment: FractionalOffset.center,
                    child: new Container(
                      margin: new EdgeInsets.only(right: 16.0),
                      child: new Text(
                        'despesa',
                        style: new TextStyle(
                          fontSize: 13.0,
                          fontFamily: 'Roboto',
                          color: new Color(0xFF9E9E9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ), 
                    ),
                  ),
                  
                  new ScaleTransition(
                    scale: _animation,
                    alignment: FractionalOffset.center,
                    child: new Material(
                      color: new Color(0xFFE57373),
                      type: MaterialType.circle,
                      elevation: 6.0,
                      child: new GestureDetector(
                        child: new Container(
                          width: 40.0,
                          height: 40.0,
                          child: new InkWell(
                            onTap: () async {
                              if(_angle == 45.0){
                                _rotate();
                                
                                List resultado = await Navigator.of(context).push(new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new LancamentoPage(false, new Lancamento(), new Color(0xFFE57373), '', '', []);
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

                                if(resultado != null) {
                                  if(resultado[0]) {
                                    setState(() {
                                      if(this.periodo == 'hoje') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoHoje(this.periodoFiltroDateTime).then(
                                            (list) {
                                              setState(() {
                                                this.periodo = "hoje";
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }            
                                              });
                                            }
                                          );
                                        });                                        
                                      } else if (this.periodo == 'semana') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoSemana(this.periodoFiltroDateTime).then(
                                            (list) {
                                              setState(() {
                                                this.periodo = "semana";
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroResumido = list[1][1].substring(0, 6) + " à " + list[1][1].substring(17, 24);
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }
                                              });
                                            }
                                          );
                                        });
                                      } else if(this.periodo == 'mes') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoMes(this.periodoFiltroDateTime).then(
                                            (list) {
                                              this.periodo = "mes";
                                              setState(() {                                  
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroDateTime = list[1][0][0];
                                                }            
                                              });
                                            }
                                          );
                                        });
                                      } else if(this.periodo == 'periodo') {
                                        lancamentoDB.lancamentoDeFixo(this.periodo, this.periodoFiltro).then((data) {
                                          lancamentoDB.getLancamentoPeriodo(this.periodoFiltroDateTimeList[0], this.periodoFiltroDateTimeList[1]).then(
                                            (list) {
                                              setState(() {
                                                if(list.length > 0) {
                                                  this.listaDB = list[0];
                                                  this.periodoFiltro = list[1][1];
                                                  this.periodoFiltroResumido =
                                                    list[1][1].substring(0, 7) + list[1][1].substring(12, 14)
                                                    + " à " + 
                                                    list[1][1].substring(17, 24) + list[1][1].substring(29, 31);
                                                  this.periodoFiltroDateTimeList = list[1][0][0];
                                                }
                                              });
                                            }
                                          );
                                        });
                                      }
                                    });
                                  }
                                }
                              }
                            },
                            child: new Center(
                              child: new Icon(
                                Icons.add,
                                color: new Color(0xFFFFFFFF),
                              ),                      
                            ),
                          )
                        ),
                      )
                    ),
                  ), 
                ],
              ),
            )
          ),
          
          new Positioned(
            bottom: 16.0 + 46.0,
            right: 16.0,
            child: new Material(
              color: new Color(0xFFE57373),
              type: MaterialType.circle,
              elevation: 6.0,
              child: new GestureDetector(
                child: new Container(
                  width: 56.0,
                  height: 56.00,
                  child: new InkWell(
                    onTap: _rotate,
                    child: new Center(
                      child: new RotationTransition(
                        turns: new AlwaysStoppedAnimation(_angle / 360),
                        child: new Icon(
                          Icons.add,
                          color: new Color(0xFFFFFFFF),
                        ),
                      )
                    ),
                  )
                ),
              )
            ),
          ),
          /////////////////////////////
        ],
      )
    );
  }
}

class ItemLancamento extends StatefulWidget {   
  final int id;
  final String tipo;
  final String categoria;
  //final int idtag;
  //final int idconta;
  //final int idcontadestino;
  //final int idcartao;
  final String valor;
  final String data;
  final String descricao;
  //final String tiporepeticao;
  //final String periodorepeticao;
  //final int quantidaderepeticao;
  //final String fatura;
  final int pago;
  final String textoPago;
  final String hash;
  final VoidCallback onPressed;
  final VoidCallback onPressed2;
  final VoidCallback onPressed3;

  ItemLancamento({
    Key key,
    this.id,
    this.tipo,
    this.categoria,
    //this.idtag,
    //this.idconta,
    //this.idcontadestino,
    //this.idcartao,
    this.valor,
    this.data,
    this.descricao,
    //this.tiporepeticao,
    //this.periodorepeticao,
    //this.quantidaderepeticao,
    //this.fatura,
    this.pago,
    this.textoPago,
    this.hash,
    this.onPressed,
    this.onPressed2,
    this.onPressed3,}) : super(key: key);

  @override
  ItemLancamentoState createState() => new ItemLancamentoState();
}

enum DialogOptionsAction {
  cancel,
  ok
}

class ItemLancamentoState extends State<ItemLancamento> with TickerProviderStateMixin {
  ItemLancamentoState();

  Lancamento lancamentoDB = new Lancamento();
  AnimationController _controller;
  Animation<double> _animation;
  bool startFling = true;
  double abertura;

  void initState() {
    super.initState();
    _controller = new AnimationController(duration: 
      const Duration(milliseconds: 246), vsync: this);

    _animation = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.0, 1.0, curve: Curves.linear),
    );
  }

  void _move(DragUpdateDetails details) {
    final double delta = details.primaryDelta / 304;
    _controller.value -= delta;
  }

  void _settle(DragEndDetails details) {
    if(this.startFling) {
      _controller.fling(velocity: 1.0);
      this.startFling = false;
    } else if(!this.startFling){
      _controller.fling(velocity: -1.0);
      this.startFling = true;
    }
  }

  void showDeleteDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) { });
  }

  @override
  Widget build(BuildContext context) {
    final ui.Size logicalSize = MediaQuery.of(context).size;
    final double _width = logicalSize.width;
    this.abertura = -(48.0/_width);

    Color corDoItem;
    Color corBrancaItem = new Color(0xFFFAFAFA);
    int dia = new DateTime.now().day;
    int mes = new DateTime.now().month;
    int ano = new DateTime.now().year;
    DateTime hoje = new DateTime(ano, mes, dia);


    if(
      DateTime.parse(widget.data).isBefore(hoje) &&
      widget.pago == 0
    ) {
      corDoItem = Colors.amber[50];
    } else if(DateTime.parse(widget.data).compareTo(hoje) == 0){
      corDoItem = corBrancaItem;
    } else {
      corDoItem = corBrancaItem;
    }

    return new GestureDetector(
      onHorizontalDragUpdate: _move,
      onHorizontalDragEnd: _settle,
      child: new Stack(
        children: <Widget>[
          new Positioned.fill(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                    color: new Color(0xFFE57373),
                  ),
                  padding: new EdgeInsets.all(12.0),
                  child: new GestureDetector(
                    onTap: widget.onPressed2,
                    child: new Icon(
                      Icons.delete,
                      color: new Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          new SlideTransition(
            position: new Tween<Offset>(
              begin:  Offset.zero,
              end: new Offset(this.abertura, 0.0),
            ).animate(_animation),
            child: new Container(
              padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
              decoration: new BoxDecoration(
                color: corDoItem,
                border: new Border(
                  bottom: new BorderSide(
                    style: BorderStyle.solid,
                    color: Colors.black12,
                  ),
                )
              ),
              child: new Row(
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.only(right: 8.0),
                    child: new Icon(
                      widget.tipo != "Transferência" ? Icons.brightness_1 : Icons.swap_horizontal_circle,
                      color: widget.tipo != "Despesa" ? new Color(0xFF00BFA5) : new Color(0xFFE57373),
                      size: 10.0,
                    ),
                  ),
                  new Expanded(
                    child: new InkWell(
                      onTap: widget.onPressed,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            widget.descricao,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF212121),
                            ),
                          ),
                          new Text(
                            widget.categoria,
                            style: new TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF9E9E9E)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    padding: new EdgeInsets.only(left: 8.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          //widget.tipo != "Despesa" ? widget.valor.toString() : widget.valor,
                          widget.valor,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Roboto',
                            color: widget.tipo == "Despesa" ? new Color(0xFFE57373) : new Color(0xFF00BFA5),
                          ),
                        ),
                        new Text(
                          widget.textoPago,
                          style: new TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Roboto',
                            color: new Color(0xFF9E9E9E)
                          ),
                        ),
                      ],
                    ),
                  ),
                      
                  new InkWell(
                    onTap: widget.onPressed3,
                    child: new Container(
                      padding: new EdgeInsets.only(left: 10.0),
                      child: new Icon(
                        widget.pago == 0 ? Icons.thumb_down : Icons.thumb_up,
                        color: widget.pago == 0 ? new Color(0xFFE57373) : new Color(0xFF00BFA5),
                        size: 24.0,
                      ),
                    ),
                  )                
                ],
              ),
            )
          ),
        ],
      )
    );
  }
}

class ItemLancamentoCartao extends StatefulWidget {   
  final List ids;
  final String tipo;
  final String categoria;
  final String valor;
  final double valorOriginal;
  final String data;
  final String descricao;
  final int pago;  
  final String textoPago;
  final VoidCallback onPressed;
  final VoidCallback onPressed2;

  ItemLancamentoCartao({
    Key key,
    this.ids,
    this.tipo,
    this.categoria,
    this.valor,
    this.valorOriginal,
    this.data,
    this.descricao,
    this.pago,
    this.textoPago,
    this.onPressed,
    this.onPressed2,}) : super(key: key);

  @override
  ItemLancamentoCartaoState createState() => new ItemLancamentoCartaoState();
}

class ItemLancamentoCartaoState extends State<ItemLancamentoCartao> {
  ItemLancamentoCartaoState();

  Lancamento lancamentoDB = new Lancamento();

  void showDeleteDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {});
  }

  

  @override
  Widget build(BuildContext context) {
    Color corDoItem;
    Color corBrancaItem = new Color(0xFFFAFAFA);
    int dia = new DateTime.now().day;
    int mes = new DateTime.now().month;
    int ano = new DateTime.now().year;
    DateTime hoje = new DateTime(ano, mes, dia);


    if(
      DateTime.parse(widget.data).isBefore(hoje) &&
      widget.pago == 0
    ) {
      corDoItem = Colors.amber[50];
    } else if(DateTime.parse(widget.data).compareTo(hoje) == 0){
      corDoItem = corBrancaItem;
    } else {
      corDoItem = corBrancaItem;
    }

    return new Container(
      padding: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
      decoration: new BoxDecoration(
        color: corDoItem,
        border: new Border(
          bottom: new BorderSide(
            style: BorderStyle.solid,
            color: Colors.black12,
          ),
        )
      ),
      child: new Row(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.only(right: 8.0),
            child: new Icon(
              Icons.insert_drive_file,
              color: Colors.black26,
              size: 10.0,
            ),
          ),
          new Expanded(
            child: new InkWell(
              onTap: widget.onPressed,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    widget.descricao,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF212121),
                    ),
                  ),
                  new Text(
                    widget.categoria,
                    style: new TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF9E9E9E)
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Container(
            padding: new EdgeInsets.only(left: 8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  widget.valor,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Roboto',
                    color: widget.valorOriginal < 0 ? new Color(0xFFE57373) : new Color(0xFF00BFA5),
                  ),
                ),
                new Text(
                  widget.textoPago,
                  style: new TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Roboto',
                    color: new Color(0xFF9E9E9E)
                  ),
                ),
              ],
            ),
          ),
              
          new InkWell(
            onTap: widget.onPressed2,
            child: new Container(
              padding: new EdgeInsets.only(left: 10.0),
              child: new Icon(
                widget.pago == 0 ? Icons.thumb_down : Icons.thumb_up,
                color: widget.pago == 0 ? new Color(0xFFE57373) : new Color(0xFF00BFA5),
                size: 24.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DialogItem extends StatelessWidget {
  DialogItem({ Key key, this.text, this.onPressed }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
 
  @override
  Widget build(BuildContext context) {
    return new SimpleDialogOption(
      onPressed: onPressed,
      child: new Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(text),            
          ],
        ),
      )
    );
  }
}

class FullScreenPeriodoDate extends StatefulWidget {
  @override
  FullScreenPeriodoDateState createState() => new FullScreenPeriodoDateState();
}

class FullScreenPeriodoDateState extends State<FullScreenPeriodoDate> {
  Color azulAppbar = new Color(0xFF26C6DA);

  String dateString = new DateTime.now().toString().substring(0,10);
  DateTime _fromDateTime;
  DateTime _toDateTime;
  int ano, mes, dia;
  bool _allDayValue = false;
  bool _saveNeeded = false;

  @override
  void initState() {    
    this.ano = int.parse(this.dateString.substring(0, 4));
    this.mes = int.parse(this.dateString.substring(5, 7));
    this.dia = int.parse(this.dateString.substring(8, 10));
    this._fromDateTime = new DateTime(ano, mes, dia);
    this._toDateTime = new DateTime(ano, mes, dia);
  }

  void showDateErroDialog<T>({ BuildContext context, Widget child }) {
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Período'),
        backgroundColor: azulAppbar,
        leading: new GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: new Container(
            child: new Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
        //actions: <Widget> [
        //  new FlatButton(
        //    child: new Text('OK', style: theme.textTheme.body1.copyWith(color: Colors.white)),
        //    onPressed: () {
        //      Navigator.pop(context, [_fromDateTime, _toDateTime]);
        //    }
        //  )
        //]
      ),
      body: new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              margin: new EdgeInsets.all(16.0),
              child: new _DateTimePicker(
                labelText: 'de',
                selectedDate: _fromDateTime,
                selectDate: (DateTime date) {
                  setState((){
                    _fromDateTime = date;
                  });
                },              
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: new _DateTimePicker(
                labelText: 'à',
                selectedDate: _toDateTime,
                selectDate: (DateTime date) {
                  setState((){
                    _toDateTime = date;
                  });
                },              
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(top: 24.0),
              child: new RaisedButton(
                color: this.azulAppbar,
                child: const Text(
                  'OK',
                  style: const TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: 24.0
                  ),  
                ),
                onPressed: () {
                  if(_fromDateTime.isAfter(_toDateTime)) {
                    showDateErroDialog<String>(
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
                                  "Data inicial maior\nque a data final",
                                  softWrap: true,
                                  style: new TextStyle(
                                    color: Colors.black45,
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
                    Navigator.pop(context, [_fromDateTime, _toDateTime]);
                  }                  
                }
              ),
            )
          ],
        ),
      )
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);
 
  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
 
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: new DateTime(2015, 8),
      lastDate: new DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }
 
  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () { _selectDate(context); },
          ),
       ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);
 
  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;
 
  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
          isDense: true,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
          ],
        ),
      ),
    );
  }
}

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class Sky extends CustomPainter {
  final double _width;
  double _rectHeight;

  Sky(this._width, this._rectHeight);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      new Rect.fromLTRB(
        0.0, size.height - _rectHeight, this._width, size.height
      ),
      new Paint()..color = new Color.fromRGBO(255, 255, 255, 0.9)
    );
  }

  @override
  bool shouldRepaint(Sky oldDelegate) {
    return _width != oldDelegate._width || _rectHeight != oldDelegate._rectHeight;
  }
}



