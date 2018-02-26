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
  String filtroLancamento = 'Todos os lançamentos';
  String filtroConta = 'Todas as contas';
  String filtrocARTAO = 'Todos os cartões';
  String filtroCategoria = 'Todas as categorias';
  String filtroTag = 'Todas as tags';
  
  List listaLancamento = [
    'Despesas', 'Despesas pagas', 'Despesas não pagas',
    'Receitas', 'Receitas recebidas', 'Receitas não recebidas',
    'Transferências', 'Transferências transferidas', 'Transferências não transferidas',
    'Lançamentos fixos', 'Lançamentos parcelados',
    'Lançamentos não fixos', 'Lançamentos não parcelados',
    'Lanç. não fixos e não parcelados',
    'Lançamentos fixos e parcelados',
    'Cartões', 'Sem cartões',
    'Todos os lançamentos', 'Nenhum lançamento'
  ];

  List listaLancamentoDialog = [];
  List listaContas = [];
  List listaCartoes = [];
  List listaCategorias = [];
  List listaTags = [];   
  List cores = [];
  Palette listaCores = new Palette();
  List listaContasDB = [];
  List listaCartoesDB = [];
  List listaCategoriasDB = [];
  List listaTagsDB = [];
  
  String _valueTextConta = 'Todas as contas';
  String _valueTextCartao = 'Todos os cartões';
  String _valueTextCategoria = 'Todas as categorias';
  String _valueTextTag = 'Todas as tags';
  String _valueTextLancamento = 'Todos os lançamentos';

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

  void showDialogConta<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          _valueTextConta = value.toString();
        });
      }
    });
  }

  void showDialogCartao<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      child: child,
    )
    .then<Null>((T value) {
      if (value != null) {
        setState(() {
          _valueTextCartao = value.toString();
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

  List<Widget> buildListaConta(listAccount) {
    this.listaContas = [];

    for(var i in listAccount) {
      var conta = i['conta'];
      var cor = this.cores[i['cor']];
      this.listaContas.add(
        new DialogItem(
          icon: Icons.brightness_1,
          color: cor,
          text: conta,
          onPressed: () {
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
          Navigator.pop(context, 'Todas as contas');
        }
      ),
    );
    this.listaContas.add(
      new DialogItem(
        icon: Icons.brightness_1,
        color: Colors.black12,
        text: 'Nenhuma conta',
        onPressed: () {
          Navigator.pop(context, 'Nenhuma conta');
        }
      ),
    );
    return this.listaContas;
  }

  List<Widget> buildListaCartao(listCard) {
    this.listaCartoes = [];

    for(var i in listCard) {
      var cartao = i['cartao'];
      var cor = this.cores[i['cor']];
      this.listaCartoes.add(
        new DialogItem(
          icon: Icons.brightness_1,
          color: cor,
          text: cartao,
          onPressed: () {
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
          Navigator.pop(context, 'Todos os cartões');
        }
      ),
    );
    this.listaCartoes.add(
      new DialogItem(
        icon: Icons.brightness_1,
        color: Colors.black12,
        text: 'Nenhum cartão',
        onPressed: () {
          Navigator.pop(context, 'Nenhum cartão');
        }
      ),
    );
    return this.listaCartoes;
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
                Navigator.pop(context, categoria2);
              }
            ),
          );
        }
      }
    }
    this.listaCategorias.add(
      new DialogItem(
        icon: Icons.brightness_1,
        color: Colors.black,
        text: 'Todas as categorias',
        onPressed: () {
          Navigator.pop(context, 'Todas as categorias');
        }
      ),
    );
    this.listaCategorias.add(
      new DialogItem(
        icon: Icons.brightness_1,
        color: Colors.black12,
        text: 'Nenhuma categoria',
        onPressed: () {
          Navigator.pop(context, 'Nenhuma categoria');
        }
      ),
    );

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
            Navigator.pop(context, tag);
          }
        ),
      );
    }
    this.listaTags.add(
      new DialogItem(
        icon: Icons.brightness_1,
        color: Colors.black,
        text: 'Todas as tags',
        onPressed: () {
          Navigator.pop(context, 'Todas as tags');
        }
      ),
    );
    this.listaTags.add(
      new DialogItem(
        icon: Icons.brightness_1,
        color: Colors.black12,
        text: 'Nenhuma tag',
        onPressed: () {
          Navigator.pop(context, 'Nenhuma tag');
        }
      ),
    );
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
                  child: new InputDropdown2(
                    labelText: 'Tipo de lançamento',
                    valueText: _valueTextLancamento,
                    valueStyle: valueStyle,
                    isCard: false,
                    onPressed: () {
                      showDialogLancamento<String>(
                        context: context,
                        child: new SimpleDialog(
                          title: const Text('Selecione um lançamento'),
                          children: buildListaLancamento(listaLancamento)
                        )
                      );
                    },
                  ),
                ),
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown2(
                    labelText: 'Conta',
                    valueText: _valueTextConta,
                    valueStyle: valueStyle,
                    isCard: false,
                    onPressed: () {
                      showDialogConta<String>(
                        context: context,
                        child: new SimpleDialog(
                          title: const Text('Selecione uma conta'),
                          children: buildListaConta(this.listaContasDB)
                        )
                      );
                    },
                  ),
                ),
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown2(
                    labelText: 'Cartão',
                    valueText: _valueTextCartao,
                    valueStyle: valueStyle,
                    isCard: false,
                    onPressed: () {
                      showDialogCartao<String>(
                        context: context,
                        child: new SimpleDialog(
                          title: const Text('Selecione um cartão'),
                          children: buildListaCartao(this.listaCartoesDB)
                        )
                      );
                    },
                  ),
                ),
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown(
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
                  ),
                ),
                new Container(
                  padding: new EdgeInsets.only(bottom: 8.0),
                  child: new InputDropdown2(
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
                          print([
                            _valueTextLancamento,
                            _valueTextConta,
                            _valueTextCartao,
                            _valueTextCategoria,
                            _valueTextTag
                          ]);
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