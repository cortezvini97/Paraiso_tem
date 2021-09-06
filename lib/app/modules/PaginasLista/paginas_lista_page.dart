import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:vcid/app/classes/cores.dart';
import 'package:vcid/app/classes/models/paginas_models.dart';
import 'package:vcid/app/classes/widgets/cards.dart';

class PaginasListaPage extends StatefulWidget {
  final String title;
  const PaginasListaPage({Key key, this.title = "PaginasLista"})
      : super(key: key);

  @override
  _PaginasListaPageState createState() => _PaginasListaPageState();
}

class _PaginasListaPageState extends State<PaginasListaPage> {


  String _urlBase = "http://apis.vcinsidedigital.com.br/";
  String _filtro = "";
  bool _microfoneStatus = false;
  TextEditingController _filtroController = new TextEditingController();
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String resultText = "";


  void micAndroid() async
  {
    String resp = await MethodChannel("com.vcinsidedigital.mic/microfone").invokeMethod("iniciar");
    setState(() {
      _filtroController.text = resp;
      _filtro = resp;
      _paginas();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activateSpeechRecognizer();
  }

  void activateSpeechRecognizer()
  {
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.activate().then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  void start() => _speech
      .listen(locale: 'pt_BR')
      .then((result) => print('Started listening => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
    setState(() => _isListening = result);
  });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) =>
      setState(() => print("current locale: $locale"));

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) {
    setState(() {
      resultText = text;
      _filtroController.text = resultText;
      _filtro = resultText;
      _paginas();
      stop();
    });
  }

  void onRecognitionComplete() => setState(() => _isListening = false);


  Future<List<PaginasModel>> _paginas() async
  {
    if(_filtro == "" || _filtro == null) {
      http.Response response = await http.get(_urlBase +
          "3UQucPNJXaePPsxCx1ctaVY8seWXP3HHcWH/Paginas/listPaginasPorPlano/4");
      var dadosJson = json.decode(response.body);
      List<PaginasModel>paginaslista = List();
      for (var listapaginas in dadosJson) {
        PaginasModel paginasModel = PaginasModel(
            listapaginas["id"],
            listapaginas["nome"],
            listapaginas["categoria"],
            listapaginas["cidade"],
            listapaginas['contato1'],
            listapaginas['contato2'],
            listapaginas['contato3'],
            listapaginas['telefone1'],
            listapaginas['telefone2'],
            listapaginas['telefone3'],
            listapaginas["contatowhatsapp1"],
            listapaginas["contatowhatsapp2"],
            listapaginas["contatowhatsapp3"],
            listapaginas["whatsapp1"],
            listapaginas["whatsapp2"],
            listapaginas["whatsapp3"],
            listapaginas["email"],
            listapaginas["estado"],
            listapaginas["link_pagina"],
            listapaginas["link_pagina_android_ios"],
            listapaginas["link_logo"],
            listapaginas["pasta"],
            listapaginas["loja1"],
            listapaginas["loja2"],
            listapaginas["loja3"],
            listapaginas["latitude1"],
            listapaginas["latitude2"],
            listapaginas["latitude3"],
            listapaginas["longitude1"],
            listapaginas["longitude2"],
            listapaginas["longitude3"],
            listapaginas["delivery"],
            listapaginas["link_delivery_produtos"],
            listapaginas["plano"]);
        paginaslista.add(paginasModel);
      }
      return paginaslista;
    }else
    {
      http.Response response = await http.get(_urlBase + "3UQucPNJXaePPsxCx1ctaVY8seWXP3HHcWH/Paginas/listPaginasPorFiltroPlano/4/${_filtro}");
      var dadosJson = json.decode(response.body);
      List<PaginasModel>paginaslista = List();
      for (var listapaginas in dadosJson) {
        PaginasModel paginasModel = PaginasModel(
            listapaginas["id"],
            listapaginas["nome"],
            listapaginas["categoria"],
            listapaginas["cidade"],
            listapaginas['contato1'],
            listapaginas['contato2'],
            listapaginas['contato3'],
            listapaginas['telefone1'],
            listapaginas['telefone2'],
            listapaginas['telefone3'],
            listapaginas["contatowhatsapp1"],
            listapaginas["contatowhatsapp2"],
            listapaginas["contatowhatsapp3"],
            listapaginas["whatsapp1"],
            listapaginas["whatsapp2"],
            listapaginas["whatsapp3"],
            listapaginas["email"],
            listapaginas["estado"],
            listapaginas["link_pagina"],
            listapaginas["link_pagina_android_ios"],
            listapaginas["link_logo"],
            listapaginas["pasta"],
            listapaginas["loja1"],
            listapaginas["loja2"],
            listapaginas["loja3"],
            listapaginas["latitude1"],
            listapaginas["latitude2"],
            listapaginas["latitude3"],
            listapaginas["longitude1"],
            listapaginas["longitude2"],
            listapaginas["longitude3"],
            listapaginas["delivery"],
            listapaginas["link_delivery_produtos"],
            listapaginas["plano"]);
        paginaslista.add(paginasModel);
      }
      return paginaslista;
    }
  }

  _tamanhoTela()
  {
    print("width: ${MediaQuery.of(context).size.width}");
    print("Altura: ${MediaQuery.of(context).size.height}");
    if(Platform.isIOS)
    {
      if (MediaQuery.of(context).size.width == 320.0 && MediaQuery.of(context).size.height == 568.0)
      {
        var tamanhos = {"ratio":1.0,"imagemaltura":90.0, "fontesize": "nulo"};
        return tamanhos;
      } else if (MediaQuery.of(context).size.width == 375.0 && MediaQuery.of(context).size.height == 667.0)
      {
        var tamanhos = {"ratio":1.2,"imagemaltura":100.0, "fontesize": "nulo"};
        return tamanhos;

      }else if(MediaQuery.of(context).size.width == 414.0 && MediaQuery.of(context).size.height == 736.0)
      {
        var tamanhos = {"ratio":1.4,"imagemaltura":100.0, "fontesize": "nulo"};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 375.0 && MediaQuery.of(context).size.height == 812.0)
      {
        var tamanhos = {"ratio":1.2,"imagemaltura":100.0, "fontesize": "nulo"};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 414.0 && MediaQuery.of(context).size.height == 896.0)
      {
        var tamanhos = {"ratio":1.4,"imagemaltura":80.0, "fontesize": "nulo"};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 768.0 &&  MediaQuery.of(context).size.height == 1024.0)
      {

        var tamanhos = {"ratio":1.5,"imagemaltura":180.0, "fontesize":20.0};
        return tamanhos;
      }
      else if(MediaQuery.of(context).size.width == 1024.0 && MediaQuery.of(context).size.height == 1366.0)
      {
        var tamanhos = {"ratio":1.5,"imagemaltura":250.0, "fontesize":30.0};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 810.0 && MediaQuery.of(context).size.height == 1080.0)
      {
        var tamanhos = {"ratio":1.5,"imagemaltura":180.0, "fontesize":30.0};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 834.0 && MediaQuery.of(context).size.height == 1112.0)
      {
        var tamanhos = {"ratio":1.5,"imagemaltura":180.0, "fontesize":25.0};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 834.0 && MediaQuery.of(context).size.height == 1194.0)
      {
        var tamanhos = {"ratio":1.5,"imagemaltura":180.0, "fontesize":30.0};
        return tamanhos;
      }
    }
    var tamanhos = {"ratio":1.2,"imagemaltura":180.0, "fontesize":"nulo"};
    return tamanhos;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Container(
              child: TextField(
                onChanged: (text)
                {
                  setState(() {
                    _filtro = text;
                    _paginas();
                  });
                },
                controller: _filtroController,
                decoration: InputDecoration(
                  hintText: "Buscar Páginas",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.mic),
                    onPressed: () {
                      if(Platform.isIOS)
                      {
                        setState(() {
                          if (_microfoneStatus == false) {
                            _microfoneStatus = true;
                            start();
                          } else {
                            _microfoneStatus = false;
                            stop();
                          }
                        });
                      }else if (Platform.isAndroid)
                      {
                        micAndroid();
                      }
                    },
                    color: (_microfoneStatus == false) ? Cores("#000000") : Colors.blue,
                  ),
                  suffix: IconButton(icon: Icon(Icons.close), onPressed: ()
                  {
                    setState(() {
                      _filtroController.text = "";
                      _filtro = "";
                      _paginas();
                    });
                  }
                  ),
                ),
              )
          ),
          Expanded(
            child: FutureBuilder<List<PaginasModel>>(
              future: _paginas(),
              builder: (context, snapshot)
              {
                switch(snapshot.connectionState)
                {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if(snapshot.hasError)
                    {
                      return Container(
                        child: Text("error"),
                      );
                    }else
                    {
                      var tamanhoTela = _tamanhoTela();
                      return GridView.count(
                        childAspectRatio: tamanhoTela["ratio"],
                        crossAxisCount: 2,
                        children: List.generate(snapshot.data.length, (index){
                          List<PaginasModel> lista = snapshot.data;
                          PaginasModel paginas = lista[index];
                          return CardPaginas(paginas, tamanhoTela);
                        }),
                      );
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
