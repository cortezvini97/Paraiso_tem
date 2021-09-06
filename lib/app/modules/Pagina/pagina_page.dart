import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vcid/app/classes/cores.dart';
import 'package:vcid/app/classes/cortez_icons.dart';
import 'package:vcid/app/classes/models/paginas_models.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaginaPage extends StatefulWidget {
  final String title;
  final PaginasModel paginas;
  bool delivery = false;
  PaginaPage({Key key, this.title = "Pagina", this.paginas = null, this.delivery = false}) : super(key: key);

  @override
  _PaginaPageState createState() => _PaginaPageState();
}

class _PaginaPageState extends State<PaginaPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.delivery == true)
    {
      //Modular.to.pushNamed("/pedidopelozap", arguments: {"titulo": widget.paginas.nome, "id": widget.paginas.id});
      if(Platform.isAndroid)
      {
        _launchURL(widget.paginas.link_delivery_produtos);
      }else
      {

      }
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {


    _launchURLWhatsapp(String numero, String msg) async
    {
      var url = "whatsapp://send?phone=+55${numero}&abid=12354&text=${Uri.parse("${msg}")}";
      _launchURL(url);
    }

    _launchMaps(String latitude, String longitude, bool acao) async
    {
      if(Platform.isIOS)
      {
        if(await canLaunch("comgooglemaps://"))
        {
          showCupertinoDialog(
              context: context,
              builder: (context)
              {
                return CupertinoAlertDialog(
                  title: Text("Traçar Rota"),
                  content: Text("Você deseja abrir com o Apple Maps ou Google Maps ?"),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                        onPressed: ()
                        {
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar", style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    CupertinoActionSheetAction(
                        onPressed: () async
                        {
                          Navigator.pop(context);
                          await launch("https://maps.apple.com/?daddr=${latitude},${longitude}", forceSafariVC: true, forceWebView: false);
                        },
                        child: Text("Apple Maps")
                    ),
                    CupertinoActionSheetAction(
                      child: Text("Google Maps"),
                      onPressed: () async
                      {
                        Navigator.pop(context);
                        await launch("comgooglemaps://?saddr=&daddr=${latitude},${longitude}&directionsmode=driving");
                      },
                    )
                  ],
                );
              }
          );
        }else
        {
          await launch("https://maps.apple.com/?daddr=${latitude},${longitude}", forceSafariVC: true, forceWebView: false);
        }
      }else if(Platform.isAndroid)
      {
        if(acao == true)
        {
          await launch("google.navigation:q=${latitude},${longitude}&mode=d");
        }else
        {

        }
      }
    }

    var childButtons = List<UnicornButton>();
    var childItems = List<BottomNavigationBarItem>();

    (widget.paginas.delivery != "nulo")
        ?
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "pedidopelozap",
        currentButton: FloatingActionButton(
          heroTag: "Delivery",
          backgroundColor: Colors.blueAccent,
          mini: true,
          child: Icon(CortezIcons.delivery, color: Cores("#ffffff"),),
          onPressed: () {
            //Modular.to.pushNamed("/pedidopelozap", arguments: {"titulo": widget.paginas.nome, "id": widget.paginas.id});
            if(Platform.isAndroid)
            {
              _launchURL(widget.paginas.link_delivery_produtos);
            }else if(Platform.isIOS)
            {

            }
          },
        )))
        :null;

    (widget.paginas.latitude1 != "nulo")
        ?
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Localização",
        currentButton: FloatingActionButton(
          heroTag: "location",
          backgroundColor: Colors.blueAccent,
          mini: true,
          child: Icon(Icons.location_on),
          onPressed: ()
          {
            if(widget.paginas.latitude2 == "nulo" || widget.paginas.latitude3 == "nulo")
            {
              _launchMaps(widget.paginas.latitude1, widget.paginas.longitude1, true);
            }else
            {
              List<String> enderecos = List<String>();

              var listEndreco1 = {};
              listEndreco1["loja"] = "${widget.paginas.loja1}";
              listEndreco1["latitude"] = "${widget.paginas.latitude1}";
              listEndreco1["longitude"] = "${widget.paginas.longitude1}";
              String endrecos1_dados = json.encode(listEndreco1);


              enderecos.add(endrecos1_dados);

              var listEndreco2 = {};
              listEndreco2["loja"] = "${widget.paginas.loja2}";
              listEndreco2["latitude"] = "${widget.paginas.latitude2}";
              listEndreco2["longitude"] = "${widget.paginas.longitude2}";
              String endrecos2_dados = json.encode(listEndreco2);

              enderecos.add(endrecos2_dados);

              if(widget.paginas.latitude3 != "nulo")
              {
                var listEndreco3 = {};
                listEndreco3["loja"] = "${widget.paginas.loja3}";
                listEndreco3["latitude"] = "${widget.paginas.latitude3}";
                listEndreco3["longitude"] = "${widget.paginas.longitude3}";
                String endrecos3_dados = json.encode(listEndreco3);

                enderecos.add(endrecos3_dados);
              }

              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListaPaginaItens(enderecos, "Endereços", "${widget.paginas.nome}")));
            }
          },
        )))
        :null;

    (widget.paginas.telefone1 != "nulo")
        ?
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Ligue Agora",
        currentButton: FloatingActionButton(
          heroTag: "phone",
          backgroundColor: Colors.blueAccent,
          mini: true,
          child: Icon(Icons.phone, color: Cores("#ffffff"),),
          onPressed: () {
            if(widget.paginas.telefone2  == "nulo" || widget.paginas.telefone3 == "nulo")
            {
              _launchURL("tel://${widget.paginas.telefone1}");
            }else
            {
              List<String> telefones = List<String>();

              var listaTelefonica1 = {};

              listaTelefonica1["contato"] = "${widget.paginas.contato1}";
              listaTelefonica1["telefone"] = "${widget.paginas.telefone1}";
              String telefone1_dados = json.encode(listaTelefonica1);

              telefones.add(telefone1_dados);

              var listaTelefonica2 = {};
              listaTelefonica2["contato"] = "${widget.paginas.contato2}";
              listaTelefonica2["telefone"] = "${widget.paginas.telefone2}";
              String telefone2_dados = json.encode(listaTelefonica2);

              telefones.add(telefone2_dados);

              var listaTelefonica3 = {};
              listaTelefonica3["contato"] = "${widget.paginas.contato3}";
              listaTelefonica3["telefone"] = "${widget.paginas.telefone3}";
              String telefone3_dados = json.encode(listaTelefonica3);
              telefones.add(telefone3_dados);

              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListaPaginaItens(telefones, "Telefônica", "${widget.paginas.nome}")));
            }
          },
        )))
        :null;

    (widget.paginas.whatsapp1 != "nulo")
        ?
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Whatsapp",
        currentButton: FloatingActionButton(
          heroTag: "whatsapp",
          mini: true,
          child: Image.asset("assets/imagens/whatsapp.png"),
          onPressed: ()
          {
            if(widget.paginas.whatsapp2 == "nulo" || widget.paginas.whatsapp3 == "nulo")
            {
              _launchURLWhatsapp(widget.paginas.whatsapp1, "Olá ${widget.paginas.nome} te achamos no Paraíso Tem");

            }else
            {
              List<String> whatsapps = List<String>();

              var listaWhatsapp1 = {};

              listaWhatsapp1["contato"] = "${widget.paginas.contatowhatsapp1}";
              listaWhatsapp1["whatsapp"] = "${widget.paginas.whatsapp1}";
              String telefone1_dados = json.encode(listaWhatsapp1);

              whatsapps.add(telefone1_dados);

              var listaWhatsapp2 = {};
              listaWhatsapp2["contato"] = "${widget.paginas.contatowhatsapp2}";
              listaWhatsapp2["whatsapp"] = "${widget.paginas.whatsapp2}";
              String telefone2_dados = json.encode(listaWhatsapp2);

              whatsapps.add(telefone2_dados);

              if(widget.paginas.whatsapp3 != "nulo")
              {
                var listaWhatsapp3 = {};
                listaWhatsapp3["contato"] = "${widget.paginas.contatowhatsapp3}";
                listaWhatsapp3["whatsapp"] =
                "${widget.paginas.whatsapp3}";
                String telefone3_dados = json.encode(listaWhatsapp3);
                whatsapps.add(telefone3_dados);
              }
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListaPaginaItens(whatsapps, "Whatsapp", "${widget.paginas.nome}")));
            }
          },
        )))
        :null;

    (widget.paginas.telefone1 != "nulo")
        ?
    childItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.phone, color: Cores("#ffffff"),),
      title: Text("Ligue Agora", style: TextStyle(
          color: Cores("#ffffff")
      ),),
    ))
        :null;
    (widget.paginas.whatsapp1 != "nulo")
        ?
    childItems.add(BottomNavigationBarItem(
      icon: Image.asset("assets/imagens/whatsapp.png", width: 30, height: 30,),
      title: Text("Whatsapp", style: TextStyle(
          color: Cores("#ffffff")
      ),),
    ))
        :null;
    (widget.paginas.latitude1 != "nulo")
        ?
    childItems.add(BottomNavigationBarItem(
      icon: Icon(Icons.location_on, color: Cores("#ffffff")),
      title: Text("Localização", style: TextStyle(
          color: Cores("#ffffff")
      ),),
    ))
        :null;
    (widget.paginas.delivery != "nulo")
        ?
    childItems.add(BottomNavigationBarItem(
      icon: Icon(CortezIcons.delivery, color: Cores("#ffffff")),
      title: Text("pedidopelozap", style: TextStyle(
          color: Cores("#ffffff")
      ),),
    ))
        :null;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.paginas.nome}"),
        backgroundColor: Cores("#2c2d48"),
      ),
      body: Container(
        child: WebView(
          initialUrl: Uri.encodeFull(widget.paginas.link_pagina_android_ios),
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
      floatingActionButton: UnicornDialer(
        backgroundColor: Color.fromRGBO(0, 0, 0,0),
        parentButtonBackground: Colors.blue,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add),
        childButtons: childButtons,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Cores("#2c2d48"),
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (int index)
        {
          print("${index}");

          if(index == 0)
          {
            if(widget.paginas.telefone2  == "nulo" || widget.paginas.telefone3 == "nulo")
            {
              _launchURL("tel://${widget.paginas.telefone1}");
            }else
            {
              List<String> telefones = List<String>();

              var listaTelefonica1 = {};

              listaTelefonica1["contato"] = "${widget.paginas.contato1}";
              listaTelefonica1["telefone"] = "${widget.paginas.telefone1}";
              String telefone1_dados = json.encode(listaTelefonica1);

              telefones.add(telefone1_dados);

              var listaTelefonica2 = {};
              listaTelefonica2["contato"] = "${widget.paginas.contato2}";
              listaTelefonica2["telefone"] = "${widget.paginas.telefone2}";
              String telefone2_dados = json.encode(listaTelefonica2);

              telefones.add(telefone2_dados);

              var listaTelefonica3 = {};
              listaTelefonica3["contato"] = "${widget.paginas.contato3}";
              listaTelefonica3["telefone"] = "${widget.paginas.telefone3}";
              String telefone3_dados = json.encode(listaTelefonica3);
              telefones.add(telefone3_dados);

              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListaPaginaItens(telefones, "Telefônica", "${widget.paginas.nome}")));
            }
          }else if(index == 1)
          {
            if(widget.paginas.whatsapp2 == "nulo" || widget.paginas.whatsapp3 == "nulo")
            {
              _launchURLWhatsapp(widget.paginas.whatsapp1, "Olá ${widget.paginas.nome} te achamos no Paraíso Tem");

            }else
            {
              List<String> whatsapps = List<String>();

              var listaWhatsapp1 = {};

              listaWhatsapp1["contato"] = "${widget.paginas.contatowhatsapp1}";
              listaWhatsapp1["whatsapp"] = "${widget.paginas.whatsapp1}";
              String telefone1_dados = json.encode(listaWhatsapp1);

              whatsapps.add(telefone1_dados);

              var listaWhatsapp2 = {};
              listaWhatsapp2["contato"] = "${widget.paginas.contatowhatsapp2}";
              listaWhatsapp2["whatsapp"] = "${widget.paginas.whatsapp2}";
              String telefone2_dados = json.encode(listaWhatsapp2);

              whatsapps.add(telefone2_dados);

              if(widget.paginas.whatsapp3 != "nulo")
              {
                var listaWhatsapp3 = {};
                listaWhatsapp3["contato"] = "${widget.paginas.contatowhatsapp3}";
                listaWhatsapp3["whatsapp"] =
                "${widget.paginas.whatsapp3}";
                String telefone3_dados = json.encode(listaWhatsapp3);
                whatsapps.add(telefone3_dados);
              }
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListaPaginaItens(whatsapps, "Whatsapp", "${widget.paginas.nome}")));
            }
          }else if(index == 2)
          {
            if(widget.paginas.latitude2 == "nulo" || widget.paginas.latitude3 == "nulo")
            {
              _launchMaps(widget.paginas.latitude1, widget.paginas.longitude1, true);
            }else
            {
              List<String> enderecos = List<String>();

              var listEndreco1 = {};
              listEndreco1["loja"] = "${widget.paginas.loja1}";
              listEndreco1["latitude"] = "${widget.paginas.latitude1}";
              listEndreco1["longitude"] = "${widget.paginas.longitude1}";
              String endrecos1_dados = json.encode(listEndreco1);


              enderecos.add(endrecos1_dados);

              var listEndreco2 = {};
              listEndreco2["loja"] = "${widget.paginas.loja2}";
              listEndreco2["latitude"] = "${widget.paginas.latitude2}";
              listEndreco2["longitude"] = "${widget.paginas.longitude2}";
              String endrecos2_dados = json.encode(listEndreco2);

              enderecos.add(endrecos2_dados);

              if(widget.paginas.latitude3 != "nulo")
              {
                var listEndreco3 = {};
                listEndreco3["loja"] = "${widget.paginas.loja3}";
                listEndreco3["latitude"] = "${widget.paginas.latitude3}";
                listEndreco3["longitude"] = "${widget.paginas.longitude3}";
                String endrecos3_dados = json.encode(listEndreco3);

                enderecos.add(endrecos3_dados);
              }

              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListaPaginaItens(enderecos, "Endereços", "${widget.paginas.nome}")));
            }
          }else
          {
            //Modular.to.pushNamed("/pedidopelozap", arguments: {"titulo": widget.paginas.nome, "id": widget.paginas.id});
            if(Platform.isAndroid) {
              _launchURL(widget.paginas.link_delivery_produtos);
            }else
            {

            }
          }

        },
        items: childItems,
      ),
    );
  }
}


class ListaPaginaItens extends StatefulWidget
{


  List<String> lista = List<String>();
  String tipoLista = "";
  String pagina = "";


  ListaPaginaItens(this.lista, this.tipoLista, this.pagina);

  @override
  _ListaPaginaItensState createState() => _ListaPaginaItensState();
}

class _ListaPaginaItensState extends State<ListaPaginaItens>
{

  _launchURLWhatsapp(String numero, String msg) async
  {
    var url = "whatsapp://send?phone=+55${numero}&abid=12354&text=${Uri.parse("${msg}")}";
    await launch(url);
  }

  _launchMaps(String latitude, String longitude, bool acao) async
  {
    if(Platform.isIOS)
    {
      if(await canLaunch("comgooglemaps://"))
      {
        showCupertinoDialog(
            context: context,
            builder: (context)
            {
              return CupertinoAlertDialog(
                title: Text("Traçar Rota"),
                content: Text("Você deseja abrir com o Apple Maps ou Google Maps ?"),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                      onPressed: ()
                      {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar", style: TextStyle(fontWeight: FontWeight.bold),)
                  ),
                  CupertinoActionSheetAction(
                      onPressed: () async
                      {
                        Navigator.pop(context);
                        await launch("https://maps.apple.com/?daddr=${latitude},${longitude}", forceSafariVC: true, forceWebView: false);
                      },
                      child: Text("Apple Maps")
                  ),
                  CupertinoActionSheetAction(
                    child: Text("Google Maps"),
                    onPressed: () async
                    {
                      Navigator.pop(context);
                      await launch("comgooglemaps://?saddr=&daddr=${latitude},${longitude}&directionsmode=driving");
                    },
                  )
                ],
              );
            }
        );
      }else
      {
        await launch("https://maps.apple.com/?daddr=${latitude},${longitude}", forceSafariVC: true, forceWebView: false);
      }
    }else if(Platform.isAndroid)
    {
      if(acao == true)
      {
        await launch("google.navigation:q=${latitude},${longitude}&mode=d");
      }else
      {

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text("Lista ${widget.tipoLista} ${widget.pagina}"),
          backgroundColor: Cores("#2c2d48"),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index)
          {
            return Divider();
          },
          itemCount: widget.lista.length,
          itemBuilder: (context, index)
          {

            Map<String, dynamic> dados = json.decode(widget.lista[index]);


            if(widget.tipoLista == "Telefônica")
            {
              return ListTile(
                title: Text("${dados['contato']}"),
                subtitle: Text("${dados['telefone']}"),
                onTap: () async
                {
                  await launch("tel://${dados['telefone']}");
                },
              );
            }else if(widget.tipoLista == "Whatsapp")
            {
              return ListTile(
                title: Text("${dados['contato']}"),
                subtitle: Text("${dados['whatsapp']}"),
                onTap: ()
                {
                  _launchURLWhatsapp("${dados['whatsapp']}", "Olá ${widget.pagina} te achamos no Paraíso Tem");
                },
              );
            }else if(widget.tipoLista == "Endereços")
            {
              return ListTile(
                title: Text("${dados["loja"]}"),
                onTap: ()
                {
                  _launchMaps("${dados['latitude']}", "${dados['longitude']}", true);
                },
              );
            }
          },
        )
    );
  }
}
