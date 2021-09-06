import 'package:vcid/app/modules/CategoriasPaginasLista/categorias_paginas_lista_module.dart';
import 'package:vcid/app/modules/EnviarFoto/enviar_foto_module.dart';
import 'package:vcid/app/modules/Pagina/pagina_module.dart';
import 'package:vcid/app/modules/Promocoes/promocoes_module.dart';
import 'package:vcid/app/modules/WebView/web_view_module.dart';
import 'package:vcid/app/modules/pedidopelozap/cadastro/cadastro_module.dart';
import 'package:vcid/app/modules/pedidopelozap/listaProdutos/lista_produtos_module.dart';
import 'package:vcid/app/modules/pedidopelozap/login/login_module.dart';
import 'package:vcid/app/modules/pedidopelozap/pedidopelozapbase/pedidopelozapbase_module.dart';
import 'package:vcid/app/modules/pedidopelozap/produto/produto_module.dart';
import 'package:vcid/app/modules/pedidopelozap/produtos/produtos_module.dart';

import 'app_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:vcid/app/app_widget.dart';
import 'package:vcid/app/modules/home/home_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AppBloc()),
      ];

  @override
  List<Router> get routers => [
    Router(Modular.initialRoute, module: HomeModule()),
    Router("/categoriasPaginasLista", module: CategoriasPaginasListaModule()),
    Router("/pagina", module: PaginaModule()),
    Router("/paginaweb", module: WebViewModule()),
    Router("/enviarFotos", module: EnviarFotoModule()),
    Router("/promocoes", module: PromocoesModule()),
    Router("/pedidopelozap", module: PedidopelozapbaseModule()),
    Router("/pedidopelozap/produtos", module: ProdutosModule()),
    Router("/pedidopelozap/listaProdutos", module: ListaProdutosModule()),
    Router("/pedidopelozap/produto", module: ProdutoModule()),
    Router("/pedidopelozap/login", module: LoginModule()),
    Router("/pedidopelozap/cadastro", module: CadastroModule())
  ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
