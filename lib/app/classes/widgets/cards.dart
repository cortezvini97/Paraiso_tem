
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vcid/app/classes/cores.dart';
import 'package:vcid/app/classes/models/categorias_models.dart';
import 'package:vcid/app/classes/models/paginas_models.dart';


class CardPaginas extends StatelessWidget
{

  PaginasModel paginas;
  var tamanhoTela;
  CardPaginas(this.paginas, this.tamanhoTela);

  _launchURLWhatsapp(String numero, String msg) async
  {
    var url = "whatsapp://send?phone=+55${numero}&abid=12354&text=${Uri.parse("${msg}")}";
    _launchURL(url);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context)
  {

    return GestureDetector(
      onTap: ()
      {
        if(paginas.plano == "4" || paginas.plano == "3" || paginas.plano == "2")
        {
          if(paginas.nome != "Promoções e Sorteio")
          {
            Modular.to.pushNamed("/pagina", arguments: {"paginamodule":paginas, "delivery":false});
          }else
          {
            Modular.to.pushNamed("/promocoes", arguments: paginas.link_pagina_android_ios);
          }
        } else if(paginas.plano == "1")
        {
          if(paginas.telefone1 != "nulo" && paginas.whatsapp1 != "nulo")
          {
            if(Platform.isAndroid)
            {
              showDialog(
                context: context,
                builder: (context)
                {
                  return AlertDialog(
                    title: Text("Escolha uma opção"),
                    content: Text("Escolha uma Opção Telefone ou Whatsapp."),
                    actions: [
                      FlatButton(
                        child: Text("Telefone"),
                        onPressed: ()
                        {
                          Modular.to.pop();
                          _launchURL("tel://${paginas.telefone1}");
                        },
                      ),
                      FlatButton(
                        
                        child: Text("Whatsapp"),
                        onPressed: ()
                        {
                          Modular.to.pop();
                          _launchURLWhatsapp(paginas.whatsapp1, "Olá ${paginas.nome} te achamos no Paraíso Tem");
                        },
                      ),
                      FlatButton(
                        child: Text("Cancelar"),
                        onPressed: ()
                        {
                          Modular.to.pop();
                        },
                      ),
                    ],
                  );
                }
              );
            }else if(Platform.isIOS)
            {
              showCupertinoDialog(
                  context: context,
                  builder: (context)
                  {
                    return CupertinoAlertDialog(
                      title: Text("Escolha uma opção"),
                      content: Text("Escolha uma Opção Telefone ou Whatsapp."),
                      insetAnimationDuration: Duration(seconds: 1),
                      actions: [
                        CupertinoActionSheetAction(
                          child: Text("Telefone"),
                          onPressed: ()
                          {
                            Modular.to.pop();
                            _launchURL("tel://${paginas.telefone1}");
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text("Whatsapp"),
                          onPressed: ()
                          {
                            Modular.to.pop();
                            _launchURLWhatsapp(paginas.whatsapp1, "Olá ${paginas.nome} te achamos no Paraíso Tem");
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text("Cancelar"),
                          onPressed: ()
                          {
                            Modular.to.pop();
                          },
                        ),
                      ],
                    );
                  }
              );
            }
          }else
          {
            if(paginas.telefone1 != "nulo")
            {
              _launchURL("tel://${paginas.telefone1}");
            }else
            {
              _launchURLWhatsapp(paginas.whatsapp1, "Olá ${paginas.nome} te achamos no Paraíso Tem");
            }
          }
        }
      },
      child: Card(
        color: Colors.white,
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(paginas.link_logo,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  //height: (MediaQuery.of(context).size.width == 1024.0)? 250 :100,
                ),
                Text(paginas.nome, style: (tamanhoTela["fontesize"] != "nulo") ? TextStyle(fontSize: tamanhoTela["fontesize"]): TextStyle())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardCategorias extends StatelessWidget
{

  CategoriasModel categorias;
  var tamanhoTela;

  CardCategorias(this.categorias, this.tamanhoTela);

  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: ()
      {
        //Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriasPaginasLista(categorias.categoria)));
        Modular.to.pushNamed("/categoriasPaginasLista", arguments: categorias.categoria);
      },
      child: Card(
        color: Colors.white,
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  //height: (MediaQuery.of(context).size.width == 1024.0)? 250 :70,
                  height: tamanhoTela['tamanhoshape'],
                  padding: EdgeInsets.all(15),
                  child: Image.network(categorias.icone_categoria,
                    width: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Cores("#052C7C"),
                  ),
                ),
                Text(categorias.categoria, style: (tamanhoTela['fontesize'] != "nulo") ? TextStyle(fontSize: tamanhoTela["fontesize"]): TextStyle())
              ],
            ),
          ),
        ),
      ),
    );
  }
}



