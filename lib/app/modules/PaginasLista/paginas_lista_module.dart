import 'paginas_lista_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'paginas_lista_page.dart';

class PaginasListaModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PaginasListaBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => PaginasListaPage()),
      ];

  static Inject get to => Inject<PaginasListaModule>.of();
}
