import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcid/app/classes/models/managers/page_manager.dart';


class DrawerTile extends StatelessWidget
{
  const DrawerTile({this.iconData, this.titulo, this.page});

  final IconData iconData;
  final String titulo;
  final int page;



  @override
  Widget build(BuildContext context)
  {
    final int paginaAtual = context.watch<PageManager>().page;
    final Color corActive = Colors.green;
    return InkWell(
      onTap: ()
      {
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                  iconData,
                size: 32,
                color: paginaAtual == page ? corActive :Colors.grey[700],
              ),
            ),
            Text(
                titulo,
              style: TextStyle(
                fontSize: 16,
                color: paginaAtual == page ? corActive :Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }
}
