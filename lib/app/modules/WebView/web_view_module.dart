import 'web_view_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'web_view_page.dart';

class WebViewModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => WebViewBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => WebViewPage(tituloAndUrl: args.data,)),
      ];

  static Inject get to => Inject<WebViewModule>.of();
}
