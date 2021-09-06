import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/pedidopelozap/cadastro/cadastro_bloc.dart';
import 'package:vcid/app/modules/pedidopelozap/cadastro/cadastro_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(CadastroModule());
  CadastroBloc bloc;

  // setUp(() {
  //     bloc = CadastroModule.to.get<CadastroBloc>();
  // });

  // group('CadastroBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<CadastroBloc>());
  //   });
  // });
}
