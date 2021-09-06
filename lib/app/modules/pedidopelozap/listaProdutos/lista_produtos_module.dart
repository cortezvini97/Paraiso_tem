import 'package:vcid/app/modules/pedidopelozap/listaProdutos/lista_produtos_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'lista_produtos_page.dart';

class ListaProdutosModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => ListaProdutosBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => ListaProdutosPage(title: args.data["titulo"], id_empresa: args.data["id_empresa"], id_categoria: args.data["id_categoria"],)),
      ];

  static Inject get to => Inject<ListaProdutosModule>.of();
}
