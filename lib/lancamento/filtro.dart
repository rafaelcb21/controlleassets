import 'package:flutter/material.dart';
import '../palette/palette.dart';
import '../db/database.dart';
import './lancamento.dart';
import '../conta/conta.dart';

class FullScreenFiltro extends StatefulWidget {
  @override
  FullScreenFiltroState createState() => new FullScreenFiltroState();
}

class FullScreenFiltroState extends State<FullScreenFiltro> {
  Color azulAppbar = new Color(0xFF26C6DA);
  
  List listaLancamento = [
    'Despesas', 'Despesas pagas', 'Despesas não pagas',
    'Receitas', 'Receitas recebidas', 'Receitas não recebidas',
    'Transferências', 'Transf. transferidas', 'Transf. não transferidas'
  ];

  List listaLctoFixoParcelado = [
    'Lcto fixos', 'Lcto parcelados',
    'Lcto não fixos', 'Lcto não parcelados',
    'Lcto não fixos e não parc.',
    'Lcto fixos e parcelados'
  ];

  List listaPgtoCartao = ['Cartão pago', 'Cartão não pago'];

  List listaLancamentoDialog = [];
  List listaLancamentoFixaParcelada = [];
  List listaLancamentoPgtoCartao = [];
  List listaContas = [];
  List listaCartoes = [];
  List listaContasCartoes = [];
  List listaCategorias = [];
  List listaTags = [];   
  List cores = [];
  Palette listaCores = new Palette();
  List listaContasDB = [];
  List listaCartoesDB = [];
  List listaCategoriasDB = [];
  List listaTagsDB = [];
  List idsTodasAsContas = [];
  List idsTodosOsCartoes = [];
  
  String _valueTextContaCartao = ' ';
  String _valueTextCategoria = ' ';
  String _valueTextTag = ' ';
  String _valueTextLancamento = ' ';
  String _valueTextLctoFixaParcelada = ' ';
  String _valueTextPgtoCartao = ' ';

  int idconta = 0;
  int idcartao = 0;
  int idcategoria = 0;
  int idtag = 0;

  bool ehCartao = false;

  Categoria categoriaDB = new Categoria();
  Tag tagDB = new Tag();
  Conta contaDB = new Conta();
  Cartao cartaoDB = new Cartao();

  @override
  void initState() {
    this.cores = listaCores.cores;
    contaDB.getAllContaAtivas().then((list) {
      setState(() {
        this.listaContasDB = list;
      });
    });

    cartaoDB.getAllCartaoAtivos().then((list) {
      setState(() {
        this.listaCartoesDB = list;
      });
    });

    categoriaDB.getAllCategoria().then((list) {
      setState(() {
        this.listaCategoriasDB = list;
      });
    });

    tagDB.getAllTag().then((list) {
      this.listaTagsDB = list;
    });
  }

  void showDialogLancamento<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          _valueTextLancamento = value.toString();
        });
      }
    });
  }

  void showDialogLctoFixaParcelada<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          _valueTextLctoFixaParcelada = value.toString();
        });
      }
    });
  }
  
  void showDialogPgtoCartao<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          _valueTextPgtoCartao = value.toString();
        });
      }
    });
  }

  void showDialogContaCartao<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          _valueTextContaCartao = value.toString();
        });
      }
    });
  }

  void showDialogCategoria<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          _valueTextCategoria = value.toString();
        });
      }
    });
  }

  void showDialogTag<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          _valueTextTag = value.toString();
        });
      }
    });
  }

  
  List<Widget> buildListaLancamento(list) {
    this.listaLancamentoDialog = [];
    for(var text in list) {
      this.listaLancamentoDialog.add(
        new DialogItemSimples(
          size: 12.0,
          text: text,
          onPressed: () {
            Navigator.pop(context, text);
          }
        ),
      );
    }    
    return this.listaLancamentoDialog;
  }

  List<Widget> buildListaFixaParcelada(list) {
    this.listaLancamentoFixaParcelada = [];
    for(var text in list) {
      this.listaLancamentoFixaParcelada.add(
        new DialogItemSimples(
          size: 12.0,
          text: text,
          onPressed: () {
            Navigator.pop(context, text);
          }
        ),
      );
    }    
    return this.listaLancamentoFixaParcelada;
  }  

  List<Widget> buildListaPgtoCartao(list) {
    this.listaLancamentoPgtoCartao = [];
    for(var text in list) {
      this.listaLancamentoPgtoCartao.add(
        new DialogItemSimples(
          size: 12.0,
          text: text,
          onPressed: () {
            Navigator.pop(context, text);
          }
        ),
      );
    }    
    return this.listaLancamentoPgtoCartao;
  }

  List<Widget> buildListaContaCartao(listAccount, listCard) {
    this.listaContas = [];
    this.listaCartoes = [];
    this.idsTodasAsContas = [];
    this.idsTodosOsCartoes = [];

    this.listaContas.add( //HEADER Contas
      new Container(
        padding: new EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
        color: new Color(0xFFDFD9D9),
        child: new Text('CONTAS'),
      )
    );

    for(var i in listAccount) {
      this.idsTodasAsContas.add(i['id']);
      var conta = i['conta'];
      var cor = this.cores[i['cor']];
      this.listaContas.add(
        new DialogItem(
          icon: Icons.brightness_1,
          color: cor,
          text: conta,
          onPressed: () {
            this.ehCartao = false;
            _valueTextPgtoCartao = ' ';
            this.idconta =  i['id'];
            this.idcartao = 0;
            Navigator.pop(context, conta);
          }
        ),
      );
    }
    this.listaContas.add(
      new DialogItem(
        icon: Icons.brightness_1,
        color: Colors.black,
        text: 'Todas as contas',
        onPressed: () {
          this.ehCartao = false;
          _valueTextPgtoCartao = ' ';
          this.idcartao = 0;
          Navigator.pop(context, 'Todas as contas');
        }
      ),
    );
    
    this.listaCartoes.add( //HEADER Cartoes
      new Container(
        padding: new EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
        color: new Color(0xFFDFD9D9),
        child: new Text('CARTÕES'),
      )
    );

    for(var i in listCard) {
      this.idsTodosOsCartoes.add(i['id']);      
      var cartao = i['cartao'];
      var cor = this.cores[i['cor']];
      this.listaCartoes.add(
        new DialogItem(
          icon: Icons.brightness_1,
          color: cor,
          text: cartao,
          onPressed: () {
            this.ehCartao = true;
            _valueTextLancamento = ' ';
            _valueTextLctoFixaParcelada = ' ';
            _valueTextCategoria = ' ';
            _valueTextTag = ' ';
            this.idconta = 0;
            this.idcategoria = 0;
            this.idtag = 0;
            this.idcartao =  i['id'];
            Navigator.pop(context, cartao);
          }
        ),
      );
    }
    this.listaCartoes.add(
      new DialogItem(
        icon: Icons.brightness_1,
        color: Colors.black,
        text: 'Todos os cartões',
        onPressed: () {
          this.ehCartao = true;
          _valueTextLancamento = ' ';
          _valueTextLctoFixaParcelada = ' ';
          _valueTextCategoria = ' ';
          _valueTextTag = ' ';
          this.idconta = 0;
          this.idcategoria = 0;
          this.idtag = 0;
          Navigator.pop(context, 'Todos os cartões');
        }
      ),
    );
    
    this.listaContasCartoes = new List.from(this.listaContas)..addAll(this.listaCartoes);
    return this.listaContasCartoes;
  }


  List<Widget> buildListaCategorias(list) {
    this.listaCategorias = [];
    for(var i in list) {
      var categoria = i[0]['categoria'];
      var cor = this.cores[i[0]['cor']];
      this.listaCategorias.add(
        new DialogItem(
          icon: Icons.brightness_1,
          color: cor,
          text: categoria,
          onPressed: () {
            this.idcategoria = i[0]['id'];
            Navigator.pop(context, categoria);
          }
        ),
      );
      if(i[1].length > 0) {
        for(var y in i[1]) {
          var categoria2 = y['categoria'];
          this.listaCategorias.add(
            new DialogItem(
              icon: Icons.subdirectory_arrow_right,
              size: 16.0,
              color: Theme.of(context).disabledColor,
              text: categoria2,
              onPressed: () {
                this.idcategoria =  y['id'];
                Navigator.pop(context, categoria2);
              }
            ),
          );
        }
      }
    }

    return this.listaCategorias;
  }

  List<Widget> buildListaTags(list) {
    this.listaTags = [];
    for(var i in list) {
      var tag = i['tag'];
      var cor = this.cores[i['cor']];
      this.listaTags.add(
        new DialogItem(
          icon: Icons.brightness_1,
          color: cor,
          text: tag,
          onPressed: () {
            this.idtag =  i['id'];
            Navigator.pop(context, tag);
          }
        ),
      );
    }
    
    return this.listaTags;
  }



  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Filtro'),
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
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.all(16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown3(
                    labelText: 'Conta/Cartão',
                    valueText: _valueTextContaCartao,
                    valueStyle: valueStyle,
                    //isCard: false,
                    onPressed: () {
                      showDialogContaCartao<String>(
                        context: context,
                        child: new SimpleDialog(
                          title: const Text('Selecione uma conta'),
                          children: buildListaContaCartao(this.listaContasDB, this.listaCartoesDB)
                        )
                      );
                    },
                    onPressed2: () {
                      setState(() {
                        this._valueTextContaCartao = ' ';
                        this.idconta = 0;
                        this.idcartao = 0;
                      });
                    }
                  ),
                ),

                ehCartao ? new Container() : 
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown3(
                    labelText: 'Tipo de lançamento',
                    valueText: _valueTextLancamento,
                    valueStyle: valueStyle,
                    //isCard: false,
                    onPressed: () {
                      showDialogLancamento<String>(
                        context: context,
                        child: new SimpleDialog(
                          title: const Text('Selecione um lançamento'),
                          children: buildListaLancamento(listaLancamento)
                        )
                      );
                    },
                    onPressed2: () {
                      setState(() {
                        this._valueTextLancamento = ' ';
                      });
                    }
                  ),
                ),
                
                ehCartao ? new Container() : 
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown3(
                    labelText: 'Lançamentos Fixos/Parcelados',
                    valueText: _valueTextLctoFixaParcelada,
                    valueStyle: valueStyle,
                    //isCard: false,
                    onPressed: () {
                      showDialogLctoFixaParcelada<String>(
                        context: context,
                        child: new SimpleDialog(
                          title: const Text('Selecione um lançamento'),
                          children: buildListaFixaParcelada(listaLctoFixoParcelado)
                        )
                      );
                    },
                    onPressed2: () {
                      setState(() {
                        this._valueTextLctoFixaParcelada = ' ';
                      });
                    }
                  ),
                ),

                !ehCartao ? new Container() : 
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown3(
                    labelText: 'Tipos de pagamento',
                    valueText: _valueTextPgtoCartao,
                    valueStyle: valueStyle,
                    //isCard: false,
                    onPressed: () {
                      showDialogPgtoCartao<String>(
                        context: context,
                        child: new SimpleDialog(
                          title: const Text('Selecione um pgto'),
                          children: buildListaPgtoCartao(listaPgtoCartao)
                        )
                      );
                    },
                    onPressed2: () {
                      setState(() {
                        this._valueTextPgtoCartao = ' ';
                      });
                    }
                  ),
                ),

                ehCartao ? new Container() : 
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown3(
                    labelText: 'Categoria',
                    valueText: _valueTextCategoria,
                    valueStyle: valueStyle,
                    onPressed: () {
                      showDialogCategoria<String>(
                        context: context,
                        child: new SimpleDialog(
                          title: const Text('Categorias'),
                          children: buildListaCategorias(this.listaCategoriasDB)
                        )
                      );
                    },
                    onPressed2: () {
                      setState(() {
                        this._valueTextCategoria = ' ';
                        this.idcategoria = 0;
                      });
                    }
                  ),
                ),

                ehCartao ? new Container() : 
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown3(
                    labelText: 'Tag',
                    valueText: _valueTextTag,
                    valueStyle: valueStyle,
                    onPressed: () {
                      showDialogTag<String>(
                        context: context,
                        child: new SimpleDialog(
                          title: const Text('Tags'),
                          children: buildListaTags(this.listaTagsDB)
                        )
                      );
                    },
                    onPressed2: () {
                      setState(() {
                        this._valueTextTag = ' ';
                        this.idtag = 0;
                      });
                    }
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
                          
                          if(!this.ehCartao) {
                            Navigator.pop(context, [
                              [_valueTextContaCartao, idconta],
                              _valueTextLancamento,
                              _valueTextLctoFixaParcelada,
                              [_valueTextCategoria, this.idcategoria],
                              [_valueTextTag, this.idtag],
                              this.idsTodasAsContas,
                              this.ehCartao
                            ]);
                          } else {
                            Navigator.pop(context, [
                              [_valueTextContaCartao, idcartao],
                              _valueTextPgtoCartao,
                              this.idsTodosOsCartoes,
                              this.ehCartao
                            ]);
                          }
                        }                    
                      ),
                    ],
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}