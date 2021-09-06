import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcid/app/classes/models/managers/user_manager.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180,
      child: Consumer<UserManager>(
          builder: (_, userManager, __)
          {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Confira nossos\nprodutos',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userManager.isLogged ?'Olá, ${userManager.usuario.nome}':'',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    if(userManager.isLogged)
                    {
                      userManager.signOut();
                    } else {
                      Navigator.of(context).pushNamed('/pedidopelozap/login');
                    }
                  },
                  child: Text(
                    userManager.isLogged ? 'Sair' : 'Entre ou cadastre-se',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }
      )
    );
  }
}
