import 'package:flutter/material.dart';
import 'package:vcid/app/classes/widgets/pedidopelozap_components/drawer_tile.dart';

import 'custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(

              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 103, 236, 241),
                  Colors.white
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              DrawerTile(iconData: Icons.list, titulo: "Produtos", page: 0,),
              DrawerTile(iconData: Icons.shopping_cart, titulo: "Carrinho", page: 1,),
              DrawerTile(iconData: Icons.playlist_add_check, titulo: "Meus Pedidos", page: 2,),
              DrawerTile(iconData: Icons.settings, titulo: "Configurações", page: 3,),
            ],
          ),
        ],
      )
    );
  }
}
