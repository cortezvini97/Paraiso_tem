import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vcid/app/classes/cores.dart';
import 'package:vcid/app/classes/cortez_icons.dart';
import 'package:vcid/app/classes/models/paginas_models.dart';
import 'package:vcid/app/classes/widgets/scaffold_tabs.dart';
import 'package:vcid/app/modules/CategoriasLista/categorias_lista_page.dart';
import 'package:vcid/app/modules/PaginasLista/paginas_lista_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget
{
  final String title;
  const HomePage({Key key, this.title = "Paraíso Tem"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage>
{
  var carregando = true;
  String code = "";

  _launch(url) async
  {
    if (await canLaunch(url))
    {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool permissaoCamera;
  bool permissaoStorage;

  void vereficaPermisaoCamera() async
  {
    PermissionStatus camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    if (camera != PermissionStatus.granted)
    {
        setState(() {
          permissaoCamera = false;
        });
    }else
    {
      setState(() {
        permissaoCamera = true;
      });
    }
  }

  void vereficaPermisaoStorage() async
  {
    PermissionStatus storage = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (storage != PermissionStatus.granted)
    {
      setState(() {
        permissaoStorage = false;
      });
    }else
    {
      permissaoStorage = true;
    }
  }


  _launchUrlSafari(String url)
  {
    MethodChannel("com.vcinsidedigital.paraisotem/web").invokeMethod("web",  {"url": url});
  }


  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    vereficaPermisaoCamera();
    vereficaPermisaoStorage();
    if(carregando == true)
    {
      Future.delayed(Duration(seconds: 3), ()
      {
        DatabaseReference reference = FirebaseDatabase.instance.reference().child("versoes");
        if(Platform.isAndroid)
        {
          reference.child("-LpYW2vFe5FpZEmB7k9n").once().then((DataSnapshot snapshot)
          {
            //print(snapshot.value['code']);
            String versaoNovaCodeString = snapshot.value['code'];
            String versaoNovaNome = snapshot.value['name'];
            var versaoNovaCode = double.parse(versaoNovaCodeString);

            checkVersao(versaoNovaCode, versaoNovaNome);

          });
        }else if(Platform.isIOS)
        {
          reference.child("-LrokuRriPUIkJYe0y5E").once().then((DataSnapshot snapshot)
          {
            //print(snapshot.value['code']);
            String versaoNovaCodeString = snapshot.value['code'];
            String versaoNovaNome = snapshot.value['name'];
            var versaoNovaCode = double.parse(versaoNovaCodeString);

            checkVersao(versaoNovaCode, versaoNovaNome);

          });
        }
      });
    }
  }


  void checkVersao(double versaoNovaCode, String versaoNovaNome) async
  {
    PackageInfo info = await PackageInfo.fromPlatform();

    if(Platform.isAndroid)
    {
      String versaoAtualCodeString = info.buildNumber;
      String versaoAtualName = info.version;
      var versaoAtualCode = int.parse(versaoAtualCodeString);

      if(versaoNovaCode > versaoAtualCode)
      {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context)
            {
              return AlertDialog(
                title: Text("Atualização"),
                content: Text("Seu aplicativo encontrasse na versão ${versaoAtualName}, uma nova versão está disponível  (${versaoNovaNome}), click em atualizar. para conticuar."),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async
                    {
                      Navigator.pop(context);
                      setState(() {
                        carregando = false;
                      });
                      await launch("https://play.google.com/store/apps/details?id=com.vcinsidedigital.vcid");
                    },
                    child: Text("Atualizar"),
                  )
                ],
              );
            }
        );
      }else
      {
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        setState(() {
          carregando = false;
        });
      }

    }else if(Platform.isIOS)
    {
      String versaoAtualCodeString = info.buildNumber;
      String versaoAtualName = info.version;
      var versaoAtualCode = int.parse(versaoAtualCodeString);
      if(versaoNovaCode > versaoAtualCode)
      {
        showCupertinoDialog(
            context: context,
            builder: (context)
            {
              return CupertinoAlertDialog(
                title: Text("Atualização"),
                content: Text("Seu aplicativo encontrasse na versão ${versaoAtualName}, uma nova versão está disponível  (${versaoNovaNome}), click em atualizar. para conticuar."),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text("Atualizar"),
                    onPressed: () async
                    {
                      Navigator.pop(context);
                      await launch("https://apps.apple.com/br/app/para%C3%ADso-tem/id1484848980?l=pt&ls=1");
                      setState(() {
                        carregando = false;
                      });
                    },
                  )
                ],
              );
            }
        );

      }else
      {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  Future<void> scanQrCode() async
  {
    try {
      await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.DEFAULT).then((String code)
      {
            var code_replace = code.replaceAll("/", "-");
            //print(code);
            _pagina(code);
      });
    } on PlatformException {
      return 'Failed to get platform version.';
    }
  }


  Future<PaginasModel> _pagina(String url) async
  {
    String _url_base = "https://apis.vcinsidedigital.com.br";

    http.Response response = await http.get(_url_base + "/3UQucPNJXaePPsxCx1ctaVY8seWXP3HHcWH/Paginas/listPaginaPorUrl/${url}");

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

      if(paginasModel.plano == "4" || paginasModel.plano == "3")
      {
        if (paginasModel.delivery == "ativo")
        {
          Modular.to.pushNamed("/pagina",
              arguments: {"paginamodule": paginasModel, "delivery": true});
        }else
        {
          Modular.to.pushNamed("/pagina", arguments: {"paginamodule": paginasModel, "delivery": false});
        }
      }

  }

  @override
  Widget build(BuildContext context)
  {
    if(carregando == false)
    {
      return ScaffoldTabs(
        title: "Paraíso Tem",
        tabs: <Tab>[
          Tab(
            icon: Icon(Icons.home),
            text: "Páginas",
          ),
          Tab(
            icon: Icon(Icons.list),
            text: "Categorias",
          )
        ],
        views: [
          PaginasListaPage(),
          CategoriasListaPage()
        ],
        indicatorTabsColor: Cores("#FFFFFF"),
        floattingActionButton: FloatingActionButton.extended(
            onPressed: ()
            {
              scanQrCode();
            },
            label: Text("QR Code"),
            backgroundColor: Colors.lightBlue,
            icon: Icon(Icons.camera),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: null,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/imagens/guia_digital_paraiso.png",
                        ),
                        fit: BoxFit.cover)),
              ),
              /*Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Termos", style: TextStyle(
                    color: Cores("#909090"), fontWeight: FontWeight.bold),),
              ),
              ListTile(
                title: Text("Termos e Privacidade"),
                onTap: ()
                {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Termos e Privacidade";
                  titulo_url['url'] = "https://vcinsidedigital.com.br/guiassp-politicaeprivacidade";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),*/
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Fotos", style: TextStyle(
                    color: Cores("#909090"), fontWeight: FontWeight.bold),),
              ),
              ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Enviar Foto"),
                  onTap: () {
                    if(Platform.isAndroid)
                    {
                      if (permissaoCamera == true && permissaoStorage == true)
                      {
                        Modular.to.pushNamed("/enviarFotos");
                      } else
                      {

                      }
                    }else if(Platform.isIOS)
                    {
                      Modular.to.pushNamed("/enviarFotos");
                    }
                  }
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Fotos de Paraíso"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Fotos de Paraíso";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/fotos_paraiso.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                  title: Text("Memórias de Paraíso"),
                  leading: Icon(CortezIcons.caneta),
                  onTap: () {
                    var titulo_url = {};
                    titulo_url['titulo'] = "Memórias de Paraíso";
                    titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                    Modular.to.pushNamed("/paginaweb", arguments: titulo_url);

                  }
              ),
              ListTile(
                title: Text("Personalidades de Paraíso"),
                leading: Icon(CortezIcons.rede),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Personalidades de Paraíso";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              /*Divider(),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Mural", style: TextStyle(
                    color: Cores("#909090"), fontWeight: FontWeight.bold),),
              ),
              ListTile(
                leading: Icon(CortezIcons.coment),
                title: Text("Recados e Correio Elegante"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Recados e Correio Elegante";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.binoculars),
                title: Text("Paisagens e Flores"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Paisagens e Flores";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.curious),
                title: Text("Curiosidades - Memes"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Curiosidades - Memes";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.dog),
                title: Text("Meu Pet"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Meu Pet";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/fotos_pets.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),*/
              Divider(),
              /*Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Social", style: TextStyle(
                    color: Cores("#909090"), fontWeight: FontWeight.bold),),
              ),
              ListTile(
                leading: Icon(CortezIcons.dog),
                title: Text("Mão Amiga"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Mão Amiga";
                  titulo_url['url'] = "https://www.paraisotem.com.br/mao_amiga.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.princess),
                title: Text("Miss Paraíso"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Miss Paraíso";
                  titulo_url['url'] = "https://www.paraisotem.com.br/miss.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.football),
                title: Text("Copa Paraíso de Futsal"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Copa Paraíso de Futsal";
                  titulo_url['url'] = "https://www.paraisotem.com.br/copa_paraiso_futsal.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.bike),
                title: Text("Motociclismo Solidário"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Motociclismo Solidário";
                  titulo_url['url'] = "https://www.paraisotem.com.br/motociclismo_solidario.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Blog", style: TextStyle(
                    color: Cores("#909090"), fontWeight: FontWeight.bold),),
              ),
              ListTile(
                leading: Icon(CortezIcons.football),
                title: Text("Esportes"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Esportes";
                  titulo_url['url'] = "https://paraisotem.com.br/menus/blogs.php?categoria=esportes";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.lawyer),
                title: Text("Direito"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Direito";
                  titulo_url['url'] = "https://paraisotem.com.br/menus/blogs.php?categoria=direito";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.benefit),
                title: Text("Saúde"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Saúde";
                  titulo_url['url'] = "https://paraisotem.com.br/menus/blogs.php?categoria=saude";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.computer),
                title: Text("Tecnologia"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Tecnologia";
                  titulo_url['url'] = "https://paraisotem.com.br/menus/blogs.php?categoria=tecnologia";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.chef),
                title: Text("Receitas"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Receitas";
                  titulo_url['url'] = "https://sacolaocenterparaiso.com.br/receitas.php#conteudo";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.atomic),
                title: Text("Ciências"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Ciências";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/blogs.php?categoria=ciencia";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.engrenagem),
                title: Text("Engenharia"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Engenharia";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/blogs.php?categoria=Engenharia";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.planeta),
                title: Text("Astronomia e Astrofísica"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Astronomia e Astrofísica";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/blogs.php?categoria=Astronomia%20e%20Astrofísica";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              Divider(),*/
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Úteis", style: TextStyle(
                    color: Cores("#909090"), fontWeight: FontWeight.bold),),
              ),
              /*ListTile(
                leading: Icon(CortezIcons.perdidos),
                title: Text("Achados e Perdidos"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Achados e Perdidos";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),*/
              ListTile(
                leading: Icon(CortezIcons.fecho_eclair),
                title: Text("Busca CEP"),
                onTap: () {
                 _launch("https://cepmais.com.br/");
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.storm),
                title: Text("Clima e Tempo"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Clima e Tempo";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/previsao_tempo.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              /*ListTile(
                leading: Icon(CortezIcons.bus),
                title: Text("Horário de ônibus"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Achados e Perdidos";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),*/
              /*ListTile(
                leading: Icon(CortezIcons.luto),
                title: Text("Notas de Falecimento"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Notas de Falecimento";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.servicos_publico),
                title: Text("Serviços Públicos"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Serviços Públicos";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text("Telefones"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Telefones";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.work),
                title: Text("Vagas de Emprego"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Vagas de Emprego";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.portfolio),
                title: Text("Cadastro de Currículos"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Achados e Perdidos";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/recados.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text("Entretenimentos", style: TextStyle(
                    color: Cores("#909090"), fontWeight: FontWeight.bold),),
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text("Eventos"),
                onTap: () {
                  var titulo_url = {};
                  titulo_url['titulo'] = "Eventos";
                  titulo_url['url'] = "https://www.paraisotem.com.br/menus/eventos.php";
                  Modular.to.pushNamed("/paginaweb", arguments: titulo_url);
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.warning),
                title: Text("Notícias"),
                onTap: ()
                {
                  if(Platform.isAndroid)
                  {
                    _launch("https://www.paraisotem.com.br/menus/noticias.php");
                  }else if(Platform.isIOS)
                  {
                    _launchUrlSafari("https://www.paraisotem.com.br/menus/noticias.php");
                  }
                },
              ),
              ListTile(
                title: Text("Revistas"),
                leading: Icon(
                    CortezIcons.magazines
                ),
                onTap: () {
                  if(Platform.isAndroid)
                  {
                    _launch("https://www.paraisotem.com.br/menus/noticias.php");
                  }else if(Platform.isIOS)
                  {
                    _launchUrlSafari("https://www.paraisotem.com.br/menus/noticias.php");
                  }
                },
              ),
              ListTile(
                leading: Icon(CortezIcons.tv),
                title: Text("TV Ao Vivo"),
                onTap: () {
                  if(Platform.isAndroid)
                  {
                    _launch("https://www.paraisotem.com.br/menus/revistas.php");
                  }else if(Platform.isIOS)
                  {
                    _launchUrlSafari("https://www.paraisotem.com.br/menus/revistas.php");
                  }
                },
              ),*/
              ListTile(
                title: Text("Rádios"),
                leading: Icon(CortezIcons.radio),
                onTap: ()
                {
                  if(Platform.isAndroid)
                  {
                    _launch("https://www.paraisotem.com.br/menus/radios.php");
                  }else if(Platform.isIOS)
                  {
                    _launchUrlSafari("https://www.paraisotem.com.br/menus/radios.php");
                  }
                },
              )
            ],
          ),
        ),
      );
    }else
    {
      return Scaffold(
        body: Center(
          child: Container(
            child: Image.asset(
                "assets/imagens/logo.png",
                width: 250,
                height: 250,
            ),
          ),
        ),
      );
    }
  }
}
