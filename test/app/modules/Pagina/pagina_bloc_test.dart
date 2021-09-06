import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/Pagina/pagina_bloc.dart';
import 'package:vcid/app/modules/Pagina/pagina_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(PaginaModule());
  PaginaBloc bloc;

  // setUp(() {
  //     bloc = PaginaModule.to.get<PaginaBloc>();
  // });

  // group('PaginaBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<PaginaBloc>());
  //   });
  // });
}
