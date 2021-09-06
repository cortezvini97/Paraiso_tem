import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/EnviarFoto/enviar_foto_bloc.dart';
import 'package:vcid/app/modules/EnviarFoto/enviar_foto_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(EnviarFotoModule());
  EnviarFotoBloc bloc;

  // setUp(() {
  //     bloc = EnviarFotoModule.to.get<EnviarFotoBloc>();
  // });

  // group('EnviarFotoBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<EnviarFotoBloc>());
  //   });
  // });
}
