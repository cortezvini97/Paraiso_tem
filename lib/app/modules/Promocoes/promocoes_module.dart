import 'promocoes_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'promocoes_page.dart';

class PromocoesModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PromocoesBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => PromocoesPage(url: args.data,)),
      ];

  static Inject get to => Inject<PromocoesModule>.of();
}
