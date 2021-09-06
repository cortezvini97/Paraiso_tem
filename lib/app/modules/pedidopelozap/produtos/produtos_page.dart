import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/classes/models/categoria_produto.dart';
import 'package:http/http.dart' as http;
import 'package:vcid/app/classes/models/managers/categoria_produto_manager.dart';
import 'package:vcid/app/classes/widgets/pedidopelozap_components/custom_drawer.dart';
class ProdutosPage extends StatefulWidget {
  final String title;
  final String id;
  const ProdutosPage({Key key, this.title = "Produtos", this.id = ""}) : super(key: key);

  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage>
{


  CategoriaProdutoManager categoriaProdutoManager = CategoriaProdutoManager();

  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoriaProdutoManager.id = widget.id;
    categoriaProdutoManager.getCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.close),
              onPressed: ()
              {
                Modular.to.pop();
              }
          )
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: categoriaProdutoManager.controller.stream,
          builder: (context, snapshot)
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
                    child: Text("Ocorreu um erro"),
                  );
                }else
                {
                  categoriaProdutoManager.criaListaObjeto(snapshot.data);
                  return ListView.separated(
                      itemCount: categoriaProdutoManager.categoriaLista.length,
                      itemBuilder: (context, index)
                      {
                        var categoriaItem = categoriaProdutoManager.categoriaLista[index];
                        return ListTile(
                          onTap: ()
                          {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(categoriaItem.categoria)
                              )
                            );
                          },
                          title: Text(categoriaItem.categoria),
                        );
                      },
                      separatorBuilder: (context, index)
                      {
                        return Divider();
                      },
                  );
                }
            }
          },
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}
