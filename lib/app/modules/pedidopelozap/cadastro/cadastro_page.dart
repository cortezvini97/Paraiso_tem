import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcid/app/classes/models/managers/user_manager.dart';
import 'package:vcid/app/classes/models/user.dart';
import 'package:vcid/app/classes/vilidators.dart';

class CadastroPage extends StatefulWidget {
  final String title;
  const CadastroPage({Key key, this.title = "Cadastro"}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage>
{

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final Usuario usuario = Usuario();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldkey,
      appBar: AppBar(
        title: const Text("Criar Conta"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: formkey,
              child: Consumer<UserManager>(
                builder: (_, userManager, __)
                {
                  return ListView(
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                          decoration: InputDecoration(hintText: "Nome Completo"),
                          enabled: !userManager.loading,
                          validator: (nome)
                          {
                            if(nome.isEmpty)
                              return "Campo Obrigatório";
                            else if(nome.trim().split(" ").length <= 1)
                              return "Preencha seu nome completo.";
                            return null;
                          },
                          onSaved: (nome) => usuario.nome = nome
                      ),
                      const SizedBox(height: 16,),
                      TextFormField(
                          decoration: InputDecoration(hintText: "E-mail"),
                          keyboardType: TextInputType.emailAddress,
                          enabled: !userManager.loading,
                          validator: (email)
                          {
                            if(email.isEmpty)
                              return "Campo Obrigatório";
                            else if(!emailValid(email))
                              return "E-mail inválido";
                            return null;
                          },
                          onSaved: (email) => usuario.email = email
                      ),
                      const SizedBox(height: 16,),
                      TextFormField(
                          decoration: InputDecoration(hintText: "Senha"),
                          obscureText: true,
                          enabled: !userManager.loading,
                          validator: (senha)
                          {
                            if(senha.isEmpty)
                              return "Campo Obrigatório";
                            else if(senha.length < 6)
                              return "Senha muito curta";
                            return null;
                          },
                          onSaved: (pass) => usuario.password = pass
                      ),
                      const SizedBox(height: 16,),
                      TextFormField(
                          decoration: InputDecoration(hintText: "Repita a Senha"),
                          obscureText: true,
                          enabled: !userManager.loading,
                          validator: (senha)
                          {
                            if(senha.isEmpty)
                              return "Campo Obrigatório";
                            else if(senha.length < 6)
                              return "Senha muito curta";
                            return null;
                          },
                          onSaved: (pass) => usuario.confirmPassword = pass
                      ),
                      const SizedBox(height: 16,),
                      SizedBox(
                        height: 44,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                          textColor: Colors.white,
                          onPressed: userManager.loading ? null: ()
                          {
                            if(formkey.currentState.validate())
                            {
                              formkey.currentState.save();

                              if(usuario.password != usuario.confirmPassword)
                              {
                                scaffoldkey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text("Senhas não coincidem!"),
                                      backgroundColor: Colors.red,
                                    )
                                );
                                return;
                              }
                              userManager.signUp(
                                  user: usuario,
                                  onfaill: (e)
                                  {
                                    scaffoldkey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text("Falha ao entrar: $e"),
                                          backgroundColor: Colors.red,
                                        )
                                    );
                                  },
                                  onSuccess: ()
                                  {
                                    Navigator.of(context).pop();
                                  }
                              );
                            }
                          },
                          child: userManager.loading ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            backgroundColor: Theme.of(context).primaryColor,
                          ):Text(
                            'Criar Conta',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  );
                },
              )
          ),
        ),
      ),
    );
  }
}
