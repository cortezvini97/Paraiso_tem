import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:vcid/app/classes/helpers/firebase_errors.dart';
import 'package:vcid/app/classes/models/user.dart';

class UserManager extends ChangeNotifier
{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  bool _loading = false;
  bool get loading => _loading;

  Usuario usuario;

  bool get isLogged => usuario != null;

  UserManager()
  {
    _currentUser();
  }

  Future<void> signIn({Usuario user, Function onfaill, Function onSuccess}) async
  {
    loading = true;
    try
    {
      AuthResult result = await auth.signInWithEmailAndPassword(email: user.email, password: user.password);

      await _currentUser(usuarioFirebase: result.user);

      onSuccess();

    }on PlatformException catch(e)
    {
      onfaill(getErrorString(e.code));
    }
    loading = false;
  }


  Future<void> signUp({Usuario user, Function onfaill, Function onSuccess}) async
  {
    loading = true;
    try
    {
      final AuthResult result = await auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
      //usuario = result.user;
      user.id = result.user.uid;


      usuario = user;

      await user.saveData();
      onSuccess();
    } on PlatformException catch(e)
    {
      onfaill(e.code);
    }
    loading = false;
  }

  set loading(bool value)
  {
    _loading = value;
    notifyListeners();
  }

  Future<void> _currentUser({FirebaseUser usuarioFirebase}) async
  {
    final FirebaseUser user = usuarioFirebase ?? await auth.currentUser();
    if(user != null)
    {
      final DocumentSnapshot docUser = await firestore.collection("users").document(user.uid).get();
      usuario = Usuario.fromDocument(docUser);
      print(usuario.nome);
      notifyListeners();
    }
  }

  void signOut()
  {
    auth.signOut();
    usuario = null;
    notifyListeners();
  }

}