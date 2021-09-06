import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/pedidopelozap/listaProdutos/lista_produtos_bloc.dart';
import 'package:vcid/app/modules/pedidopelozap/listaProdutos/lista_produtos_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(ListaProdutosModule());
  ListaProdutosBloc bloc;

  // setUp(() {
  //     bloc = ListaProdutosModule.to.get<ListaProdutosBloc>();
  // });

  // group('ListaProdutosBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<ListaProdutosBloc>());
  //   });
  // });
}
