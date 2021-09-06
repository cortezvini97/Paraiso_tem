import 'categorias_lista_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'categorias_lista_page.dart';

class CategoriasListaModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => CategoriasListaBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => CategoriasListaPage()),
      ];

  static Inject get to => Inject<CategoriasListaModule>.of();
}
