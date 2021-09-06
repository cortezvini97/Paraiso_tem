import 'package:vcid/app/modules/pedidopelozap/produtos/produtos_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'produtos_page.dart';

class ProdutosModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => ProdutosBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => ProdutosPage(title: args.data["titulo"], id: args.data["id"])),
      ];

  static Inject get to => Inject<ProdutosModule>.of();
}
