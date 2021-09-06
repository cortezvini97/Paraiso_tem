import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vcid/app/classes/models/categoria_produto.dart';

class CategoriaProdutoManager
{

  final Firestore db = Firestore.instance;

  String id;

  CategoriaProdutoManager();

  StreamController controller = StreamController.broadcast();


  Stream getCategorias()
  {
    var stream = db.collection("empresas").document(id).collection("categorias").orderBy("timestamp").snapshots();

    stream.listen((dados)
    {
      controller.add(dados);
      print(categoriaLista);
    });

  }

  List<CategoriaProduto> categoriaLista = [];

  void criaListaObjeto(QuerySnapshot snapshot)
  {
    categoriaLista = snapshot.documents.map((d) => CategoriaProduto.fromDocument(d)).toList();
  }

  

}