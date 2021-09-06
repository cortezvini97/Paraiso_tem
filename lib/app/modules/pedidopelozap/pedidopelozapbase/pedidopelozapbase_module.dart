import 'package:vcid/app/modules/pedidopelozap/pedidopelozapbase/pedidopelozapbase_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'pedidopelozapbase_page.dart';

class PedidopelozapbaseModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PedidopelozapbaseBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => PedidopelozapbasePage(title: args.data["titulo"], id: args.data["id"])),
      ];

  static Inject get to => Inject<PedidopelozapbaseModule>.of();
}
