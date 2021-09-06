import 'package:vcid/app/classes/models/produtos_models.dart';
import 'package:vcid/app/modules/pedidopelozap/produto/produto_bloc.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'produto_page.dart';

class ProdutoModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => ProdutoBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => ProdutoPage(produto: args.data["produto"], id_empresa: args.data["idempresa"],)),
      ];

  static Inject get to => Inject<ProdutoModule>.of();
}
