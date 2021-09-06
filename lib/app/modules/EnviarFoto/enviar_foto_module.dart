import 'enviar_foto_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'enviar_foto_page.dart';

class EnviarFotoModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => EnviarFotoBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => EnviarFotoPage()),
      ];

  static Inject get to => Inject<EnviarFotoModule>.of();
}
