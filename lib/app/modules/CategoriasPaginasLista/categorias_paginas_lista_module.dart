import 'categorias_paginas_lista_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'categorias_paginas_lista_page.dart';

class CategoriasPaginasListaModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => CategoriasPaginasListaBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute,
            child: (_, args) => CategoriasPaginasListaPage(title: args.data,)),
      ];

  static Inject get to => Inject<CategoriasPaginasListaModule>.of();
}
