import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/CategoriasPaginasLista/categorias_paginas_lista_bloc.dart';
import 'package:vcid/app/modules/CategoriasPaginasLista/categorias_paginas_lista_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(CategoriasPaginasListaModule());
  CategoriasPaginasListaBloc bloc;

  // setUp(() {
  //     bloc = CategoriasPaginasListaModule.to.get<CategoriasPaginasListaBloc>();
  // });

  // group('CategoriasPaginasListaBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<CategoriasPaginasListaBloc>());
  //   });
  // });
}
