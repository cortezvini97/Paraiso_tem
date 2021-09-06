import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcid/app/classes/models/managers/page_manager.dart';
import 'package:vcid/app/classes/widgets/pedidopelozap_components/custom_drawer.dart';
import 'package:vcid/app/modules/pedidopelozap/login/login_page.dart';
import 'package:vcid/app/modules/pedidopelozap/produtos/produtos_page.dart';

class PedidopelozapbasePage extends StatefulWidget {
  final String title;
  final String id;
  const PedidopelozapbasePage({Key key, this.title = "Pedidopelozapbase", this.id})
      : super(key: key);

  @override
  _PedidopelozapbasePageState createState() => _PedidopelozapbasePageState();
}

class _PedidopelozapbasePageState extends State<PedidopelozapbasePage>
{

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ProdutosPage(title: widget.title, id: widget.id,),
          Scaffold(
            appBar: AppBar(title: Text("Home1"),),
            drawer: CustomDrawer(),
          ),
          Scaffold(
            appBar: AppBar(title: Text("Home2"),),
            drawer: CustomDrawer(),
          ),
          Scaffold(
            appBar: AppBar(title: Text("Home3"),),
            drawer: CustomDrawer(),
          ),
        ],
      ),
    );
  }
}
