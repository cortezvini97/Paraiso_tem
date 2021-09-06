import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/pedidopelozap/pedidopelozapbase/pedidopelozapbase_bloc.dart';
import 'package:vcid/app/modules/pedidopelozap/pedidopelozapbase/pedidopelozapbase_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(PedidopelozapbaseModule());
  PedidopelozapbaseBloc bloc;

  // setUp(() {
  //     bloc = PedidopelozapbaseModule.to.get<PedidopelozapbaseBloc>();
  // });

  // group('PedidopelozapbaseBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<PedidopelozapbaseBloc>());
  //   });
  // });
}
