import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:vcid/app/classes/cores.dart';
import 'package:vcid/app/classes/models/categorias_models.dart';
import 'package:vcid/app/classes/widgets/cards.dart';

class CategoriasListaPage extends StatefulWidget {
  final String title;
  const CategoriasListaPage({Key key, this.title = "CategoriasLista"})
      : super(key: key);

  @override
  _CategoriasListaPageState createState() => _CategoriasListaPageState();
}

class _CategoriasListaPageState extends State<CategoriasListaPage>
{

  String _urlBase = "http://apis.vcinsidedigital.com.br/";
  String _filtro = "";
  bool _microfoneStatus = false;
  TextEditingController _filtroController = new TextEditingController();
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String resultText = "";


  _tamanhoTela()
  {

    print("Altura: ${MediaQuery.of(context).size.height}");
    print("largura: ${MediaQuery.of(context).size.width}");

    if(Platform.isIOS)
    {
      if (MediaQuery.of(context).size.width == 320.0 && MediaQuery.of(context).size.height == 568.0)
      {
        var tamanhos = {"ratio":1.0,"imagemaltura":70.0, "fontesize": "nulo", "tamanhoshape": 70.0};
        return tamanhos;
      } else if (MediaQuery.of(context).size.width == 375.0 && MediaQuery.of(context).size.height == 667.0)
      {
        var tamanhos = {"ratio":1.2,"imagemaltura":70.0, "fontesize": "nulo", "tamanhoshape": 70.0};
        return tamanhos;

      }else if(MediaQuery.of(context).size.width == 414.0 && MediaQuery.of(context).size.height == 736.0)
      {
        var tamanhos = {"ratio":1.4,"imagemaltura":70.0, "fontesize": "nulo", "tamanhoshape": 70.0};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 375.0 && MediaQuery.of(context).size.height == 812.0)
      {
        var tamanhos = {"ratio":1.2,"imagemaltura":70.0, "fontesize": "nulo", "tamanhoshape": 70.0};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 414.0 && MediaQuery.of(context).size.height == 896.0)
      {
        var tamanhos = {"ratio":1.4,"imagemaltura":70.0, "fontesize": "nulo", "tamanhoshape": 70.0};
        return tamanhos;
      }
      //Ipads
      else if(MediaQuery.of(context).size.width == 768.0 &&  MediaQuery.of(context).size.height == 1024.0)
      {
        //Ipad Air, Ipad Air 2, Ipad Pro (9.7-inch), Ipad(5th generation), Ipad(6th generation)(3rd generation)
        var tamanhos = {"ratio":1.5,"imagemaltura":70.0, "fontesize":20.0, "tamanhoshape": 150.0};
        return tamanhos;
      }
      else if(MediaQuery.of(context).size.width == 1024.0 && MediaQuery.of(context).size.height == 1366.0)
      {
        //Ipad Pro (12.9-inch), Ipad Pro (12.9-inch)(2nd generation), Ipad Pro (12.9-Inch)
        var tamanhos = {"ratio":1.5,"imagemaltura":250.0, "fontesize":30.0, "tamanhoshape": 250.0};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 810.0 && MediaQuery.of(context).size.height == 1080.0)
      {
        var tamanhos = {"ratio":1.5,"imagemaltura":70.0, "fontesize":30.0, "tamanhoshape": 250.0};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 834.0 && MediaQuery.of(context).size.height == 1112.0)
      {
        //Ipad Pro (10.5-Inch)
        var tamanhos = {"ratio":1.5,"imagemaltura":70.0, "fontesize":30.0, "tamanhoshape": 150.0};
        return tamanhos;
      }else if(MediaQuery.of(context).size.width == 834.0 && MediaQuery.of(context).size.height == 1194.0)
      {
        //Ipad Pro(11-inch), Ipad Air 3rd Generation
        var tamanhos = {"ratio":1.5,"imagemaltura":70.0, "fontesize":30.0, "tamanhoshape": 150.0};
        return tamanhos;
      }
    }
    var tamanhos = {"ratio":1.2,"imagemaltura":70.0, "fontesize": "nulo", "tamanhoshape": 70.0};
    return tamanhos;
  }

  void micAndroid() async
  {
    String resp = await MethodChannel("com.vcinsidedigital.mic/microfone").invokeMethod("iniciar");
    setState(() {
      _filtroController.text = resp;
      _filtro = resp;
      _categorias();
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
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
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
      _categorias();
      stop();
    });
  }

  void onRecognitionComplete() => setState(() => _isListening = false);


  Future<List<CategoriasModel>> _categorias() async
  {
    if(_filtro == "" || _filtro == null) {
      http.Response response = await http.get(_urlBase +
          "3UQucPNJXaePPsxCx1ctaVY8seWXP3HHcWH/Categorias/listCategoriasAll");
      var dadosJson = json.decode(response.body);


      List<CategoriasModel>categoriasListas = List();
      for (var listacategorias in dadosJson) {
        CategoriasModel categoriasModel = new CategoriasModel(listacategorias["id"], listacategorias["categoria"], listacategorias["icone_categoria"]);
        categoriasListas.add(categoriasModel);
      }
      return categoriasListas;
    }else
    {
      http.Response response = await http.get(_urlBase +
          "3UQucPNJXaePPsxCx1ctaVY8seWXP3HHcWH/Categorias/listCategoriasFiltro/"+_filtro);
      var dadosJson = json.decode(response.body);


      List<CategoriasModel>categoriasListas = List();
      for (var listacategorias in dadosJson) {
        CategoriasModel categoriasModel = new CategoriasModel(listacategorias["id"], listacategorias["categoria"], listacategorias["icone_categoria"]);
        categoriasListas.add(categoriasModel);
      }
      return categoriasListas;
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            child: TextField(
              onChanged: (text)
              {
                setState(() {
                  _filtro = text;
                  _categorias();
                });
              },
              controller: _filtroController,
              decoration: InputDecoration(
                  hintText: "Buscar Categorias",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.mic),
                    onPressed: () {
                      if(Platform.isIOS)
                      {
                        setState(() {
                          if (_microfoneStatus == false)
                          {
                            _microfoneStatus = true;
                            start();
                          } else {
                            _microfoneStatus = false;
                            stop();
                          }
                        });
                      }else if(Platform.isAndroid)
                      {
                        micAndroid();
                      }
                    },
                    color: (_microfoneStatus == false) ? Cores("#000000") : Colors.blue,
                  ),
                  suffix: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: ()
                      {
                        setState(() {
                          _filtroController.text = "";
                          _filtro = "";
                          _categorias();
                        });
                      }
                  )
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CategoriasModel>>(
              future: _categorias(),
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
                      var tamanho_tela = _tamanhoTela();
                      return GridView.count(
                        childAspectRatio: tamanho_tela['ratio'],
                        crossAxisCount: 2,
                        children: List.generate(snapshot.data.length, (index){
                          List<CategoriasModel> lista = snapshot.data;
                          CategoriasModel categorias = lista[index];
                          return CardCategorias(categorias, tamanho_tela);
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
