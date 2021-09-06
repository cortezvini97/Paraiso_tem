import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Usuario
{

  Usuario({this.email, this.password, this.nome});

  Usuario.fromDocument(DocumentSnapshot document)
  {
    final data = document.data;

    id = document.documentID;
    nome = data["nome"] as String;
    email = data["email"] as String;

  }

  String id;
  String nome;
  String email;
  String password;
  String confirmPassword;

  Future<void> saveData() async
  {
    final DatabaseReference database = FirebaseDatabase.instance.reference().child("usuarios");
    await Firestore.instance.collection("users").document(id).setData(toMap());
    await database.child(id).set({
      'admin':false,
      'id':id,
      'email':email,
    });
  }

  Map<String, dynamic> toMap()
  {
    return {
      "nome":nome,
      "email":email
    };
  }

}