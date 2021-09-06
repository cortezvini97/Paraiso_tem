import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vcid/app/classes/helpers/format_preco.dart';
import 'package:vcid/app/classes/models/produtos_models.dart';

class ProdutoPage extends StatefulWidget {
  final String title;
  final Produto produto;
  final id_empresa;
  const ProdutoPage({Key key, this.title = "Produto", this.produto, this.id_empresa}) : super(key: key);

  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage>
{

  StreamController _controller = StreamController.broadcast();
  final Firestore db = Firestore.instance;

  Stream<DocumentSnapshot> _status()
  {
    var stream = db.collection("empresas").document(widget.id_empresa).snapshots();

    stream.listen((dados)
    {
      setState(() {
        _controller.add(dados);
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _status();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto.modelo),
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (_, snapshot)
        {
          switch(snapshot.connectionState)
          {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasError)
              {
                return Center(
                  child: Text("Error"),
                );
              }else
              {
                DocumentSnapshot dados = snapshot.data;

                var status = dados.data["status"];

                return ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(widget.produto.imagem),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            widget.produto.modelo,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'A partir de',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13
                              ),
                            ),
                          ),
                          widget.produto.promocao > 0 ?
                          Text(
                            FormatPreco.formataMoeda(widget.produto.preco_venda),
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ):Row(
                            children: <Widget>[
                              Text(
                                FormatPreco.formataMoeda(widget.produto.preco_venda),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.lineThrough
                                ),
                              ),
                              const SizedBox(width: 12,),
                              Text(
                                'Por',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12,),
                              Text(
                                FormatPreco.formataMoeda(widget.produto.preco_promocao),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: Text(
                              'Descrição',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Text(
                            widget.produto.descricao,
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                          SizedBox(height: 16,),
                          SizedBox(
                              height: 44,
                              child: RaisedButton(
                                onPressed: status == "aberto" ? ()
                                {

                                }:null,
                                textColor: Colors.white,
                                disabledColor: Colors.red,
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                    status == 'aberto' ?'Adicionar no Carrinho':'Fechado',
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }
          }
        },
      )
    );
  }
}
