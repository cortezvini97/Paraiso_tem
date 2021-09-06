import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/PaginasLista/paginas_lista_bloc.dart';
import 'package:vcid/app/modules/PaginasLista/paginas_lista_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(PaginasListaModule());
  PaginasListaBloc bloc;

  // setUp(() {
  //     bloc = PaginasListaModule.to.get<PaginasListaBloc>();
  // });

  // group('PaginasListaBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<PaginasListaBloc>());
  //   });
  // });
}
