import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriaProduto
{

  String categoria;
  int timestamp;

  CategoriaProduto();

  CategoriaProduto.fromDocument(DocumentSnapshot documentSnapshot)
  {
    categoria = documentSnapshot.data["categoria"] as String;
    timestamp = documentSnapshot.data["timestamp"] as int;
  }

}