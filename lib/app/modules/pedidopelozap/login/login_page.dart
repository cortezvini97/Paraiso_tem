import 'package:flutter/material.dart';
import 'package:vcid/app/classes/models/managers/user_manager.dart';
import 'package:vcid/app/classes/models/user.dart';
import 'package:vcid/app/classes/vilidators.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final Usuario user = Usuario();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              //Navigator.of(context).pushReplacementNamed('/signup');
              Navigator.of(context).pushReplacementNamed('/pedidopelozap/cadastro');
            },
            textColor: Colors.white,
            child: const Text(
              'CRIAR CONTA',
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
                builder: (_, userManager, child)
                {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'E-mail'),
                        enabled: !userManager.loading,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (email)
                        {
                          if(!emailValid(email))
                            return 'E-mail Inválido';
                          return null;
                        },
                        onSaved: (email)
                        {
                          user.email = email;
                        },
                      ),

                      const SizedBox(height: 16,),
                      TextFormField(
                        decoration: const InputDecoration(hintText: 'Senha'),
                        obscureText: true,
                        enabled: !userManager.loading,
                        autocorrect: false,
                        validator: (senha)
                        {
                          if(senha.isEmpty || senha.length < 6)
                            return 'Senha Inválida';
                          return null;
                        },
                        onSaved: (senha)
                        {
                          user.password = senha;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                            onPressed: ()
                            {

                            },
                            padding: EdgeInsets.zero,
                            child: Text("Esqueci minha senha")
                        ),
                      ),
                      const SizedBox(height: 16,),
                      RaisedButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: userManager.loading ? null : ()
                        {
                          if(formKey.currentState.validate())
                          {

                            formKey.currentState.save();

                            userManager.signIn(
                              user: user,
                              onfaill: (e)
                              {
                                scaffoldkey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('Falha ao entrar: $e'),
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
                        color: Theme.of(context).primaryColor,
                        disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                        textColor: Colors.white,
                        child: userManager.loading ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Theme.of(context).primaryColor,

                        ) :Text(
                          'Entrar',
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                      )
                    ],
                  );
                }
            ),
          ),
        ),
      )
    );
  }
}
