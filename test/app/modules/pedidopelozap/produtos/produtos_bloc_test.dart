import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/pedidopelozap/produtos/produtos_bloc.dart';
import 'package:vcid/app/modules/pedidopelozap/produtos/produtos_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(ProdutosModule());
  ProdutosBloc bloc;

  // setUp(() {
  //     bloc = ProdutosModule.to.get<ProdutosBloc>();
  // });

  // group('ProdutosBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<ProdutosBloc>());
  //   });
  // });
}
