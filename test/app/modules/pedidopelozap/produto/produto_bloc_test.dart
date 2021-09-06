import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/pedidopelozap/produto/produto_bloc.dart';
import 'package:vcid/app/modules/pedidopelozap/produto/produto_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(ProdutoModule());
  ProdutoBloc bloc;

  // setUp(() {
  //     bloc = ProdutoModule.to.get<ProdutoBloc>();
  // });

  // group('ProdutoBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<ProdutoBloc>());
  //   });
  // });
}
