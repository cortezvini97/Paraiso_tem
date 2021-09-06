import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/Promocoes/promocoes_bloc.dart';
import 'package:vcid/app/modules/Promocoes/promocoes_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(PromocoesModule());
  PromocoesBloc bloc;

  // setUp(() {
  //     bloc = PromocoesModule.to.get<PromocoesBloc>();
  // });

  // group('PromocoesBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<PromocoesBloc>());
  //   });
  // });
}
