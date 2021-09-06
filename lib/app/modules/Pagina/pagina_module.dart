

import 'pagina_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'pagina_page.dart';

class PaginaModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PaginaBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => PaginaPage(paginas: args.data['paginamodule'], delivery: args.data['delivery'],)),
  ];

  static Inject get to => Inject<PaginaModule>.of();
}
