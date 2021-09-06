import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/CategoriasLista/categorias_lista_bloc.dart';
import 'package:vcid/app/modules/CategoriasLista/categorias_lista_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(CategoriasListaModule());
  CategoriasListaBloc bloc;

  // setUp(() {
  //     bloc = CategoriasListaModule.to.get<CategoriasListaBloc>();
  // });

  // group('CategoriasListaBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<CategoriasListaBloc>());
  //   });
  // });
}
