
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'package:vcid/app/modules/pedidopelozap/cadastro/cadastro_bloc.dart';
import 'cadastro_page.dart';

class CadastroModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => CadastroBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => CadastroPage()),
      ];

  static Inject get to => Inject<CadastroModule>.of();
}
