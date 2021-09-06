
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'package:vcid/app/modules/pedidopelozap/login/login_bloc.dart';
import 'login_page.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => LoginBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => LoginPage()),
      ];

  static Inject get to => Inject<LoginModule>.of();
}
