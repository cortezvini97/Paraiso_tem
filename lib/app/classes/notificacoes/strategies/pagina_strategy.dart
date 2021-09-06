
import 'dart:convert';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/classes/models/paginas_models.dart';
import 'package:vcid/app/classes/notificacoes/strategies/i_push_strategy.dart';
import 'package:http/http.dart' as http;

class PaginaStrategy implements IPushNotificationStrategy
{

  Future<PaginasModel> _pagina(id) async
  {
    String _url_base = "https://apis.vcinsidedigital.com.br";
    http.Response response = await http.get(_url_base + "/3UQucPNJXaePPsxCx1ctaVY8seWXP3HHcWH/Paginas/listPagina/${id}");

    var dados = json.decode(response.body);

    PaginasModel paginasModel = PaginasModel(
        dados["id"],
        dados["nome"],
        dados["categoria"],
        dados["cidade"],
        dados['contato1'],
        dados['contato2'],
        dados['contato3'],
        dados['telefone1'],
        dados['telefone2'],
        dados['telefone3'],
        dados["contatowhatsapp1"],
        dados["contatowhatsapp2"],
        dados["contatowhatsapp3"],
        dados["whatsapp1"],
        dados["whatsapp2"],
        dados["whatsapp3"],
        dados["email"],
        dados["estado"],
        dados["link_pagina"],
        dados["link_pagina_android_ios"],
        dados["link_logo"],
        dados["pasta"],
        dados["loja1"],
        dados["loja2"],
        dados["loja3"],
        dados["latitude1"],
        dados["latitude2"],
        dados["latitude3"],
        dados["longitude1"],
        dados["longitude2"],
        dados["longitude3"],
        dados["delivery"],
        dados["link_delivery_produtos"],
        dados["plano"]);

    Modular.to.pushNamed("/pagina", arguments: {"paginamodule": paginasModel, "delivery": false});
  }

  @override
  void execute(Map<String, dynamic> payload)
  {
    _pagina(payload["id"]);
  }

}