
import 'dart:io';

import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vcid/app/classes/cores.dart';
import 'package:image_picker/image_picker.dart';

class EnviarFotoPage extends StatefulWidget {
  final String title;
  const EnviarFotoPage({Key key, this.title = "Enviar Foto"}) : super(key: key);

  @override
  _EnviarFotoPageState createState() => _EnviarFotoPageState();
}

class _EnviarFotoPageState extends State<EnviarFotoPage>
{

  File _img;
  bool _confirmarfoto = false;
  String dropdownValue = 'Selecione';
  String nome;
  String titulo;
  bool termos = false;
  String _termosValor;
  ObjectId id1 = new ObjectId();

  Future _recuperarImagem(String origemImagem) async
  {
    File imagemSelecionada;
    switch(origemImagem)
    {
      case "camera":
        print(origemImagem);
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        print(origemImagem);
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
      default:
        print("nulo");
    }

    setState(() {
      _img = imagemSelecionada;
    });
  }

  Future _uploadImagem() async
  {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("imagens").child(nome).child(dropdownValue).child("${id1.toString()}.jpg");

    StorageUploadTask task = arquivo.putFile(_img);

    task.events.listen((StorageTaskEvent event)
    {
      if(event.type == StorageTaskEventType.success)
      {
        Fluttertoast.showToast(
            backgroundColor: Colors.green,
            textColor: Colors.white,
            msg: "Sucesso ao fazer upload.",
            toastLength: Toast.LENGTH_LONG
        );
      }
    });

    task.onComplete.then((StorageTaskSnapshot snapshot)
    {
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async
  {
    String url = await snapshot.ref.getDownloadURL();

    var data = {
      "categoria":dropdownValue,
      "nome":nome,
      "termos":_termosValor,
      "titulo":titulo,
      "url":url,
      "status":"em revisão",
    };

    DatabaseReference reference = FirebaseDatabase.instance.reference().child("fotos");
    reference.push().set(data).then((value)
    {
      setState(() {
        _img = null;
        _confirmarfoto = false;
        nome = null;
        termos = false;
        _termosValor = null;
        titulo = null;
      });
    }).catchError((error)
    {

    });

  }

  @override
  Widget build(BuildContext context)
  {
    if(_img == null)
    {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    "assets/imagens/sem_foto.jpg",
                    width: 320,
                  ),

                ),
                Container(
                    child: RaisedButton(
                      child: Text(
                        "Abrir Câmera",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      color: Cores("#252568"),
                      textColor: Colors.white,
                      onPressed: () {
                        _recuperarImagem("camera");
                      },
                    )
                ),
                Container(
                    child: RaisedButton(
                      child: Text(
                        "Abrir Galeria",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      color: Cores("#252568"),
                      textColor: Colors.white,
                      onPressed: () {
                        _recuperarImagem("galeria");
                      },
                    )
                )
              ],
            ),
          )
      );
    }else
    {
      if(_confirmarfoto == false)
      {
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Image.file(
                      _img,
                      width: 320,
                      height: 250,
                    ),

                  ),
                  Container(
                      child: RaisedButton(
                        child: Text(
                          "Confirmar Foto",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        color: Cores("#252568"),
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _confirmarfoto = true;
                          });
                        },
                      )
                  ),
                  Container(
                      child: RaisedButton(
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        color: Cores("#252568"),
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _img = null;
                          });
                        },
                      )
                  )
                ],
              ),
            )
        );
      }else
      {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Nome"
                      ),
                      onChanged: (text)
                      {
                        setState(() {
                          nome = text;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Título"
                      ),
                      onChanged: (text)
                      {
                        setState(() {
                          print(text);
                          titulo = text;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                    child:  Center(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String newValue)
                        {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['Selecione', 'Fotos de Paraíso', 'Paísagens', 'Recados', 'Curiosidades', 'Meu Pet']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Switch(
                          value: termos,
                          onChanged: (value)
                          {
                            setState(() {
                              if(termos == false)
                              {
                                termos = true;
                                _termosValor = "aceito";
                              }else
                              {
                                termos = false;
                                _termosValor = null;
                              }
                            });
                          }
                      ),
                      Text("Aceito os Termos de Privacidade")
                    ],
                  ),
                ),
                Container(
                  child: RaisedButton(
                    child: Text("Enviar Foto"),
                    color: Cores("#252568"),
                    textColor: Colors.white,
                    onPressed: ()
                    {
                      if(nome == "" || nome == null)
                      {
                        print("Campo Nome Vazio");
                        Fluttertoast.showToast(
                            backgroundColor: Cores("#252568"),
                            textColor: Colors.white,
                            msg: "Nome Indefinido",
                            toastLength: Toast.LENGTH_LONG
                        );
                      }else
                      {
                        if(titulo == "" || titulo == null)
                        {
                          Fluttertoast.showToast(
                              backgroundColor: Cores("#252568"),
                              textColor: Colors.white,
                              msg: "Título Indefinido",
                              toastLength: Toast.LENGTH_LONG
                          );
                        }else
                        {
                          if(dropdownValue == "Selecione")
                          {
                            Fluttertoast.showToast(
                                backgroundColor: Cores("#252568"),
                                textColor: Colors.white,
                                msg: "Selecione uma Categoria.",
                                toastLength: Toast.LENGTH_LONG
                            );
                          }else
                          {
                            if(termos == false)
                            {
                              Fluttertoast.showToast(
                                  backgroundColor: Cores("#252568"),
                                  textColor: Colors.white,
                                  msg: "Você deve aceitar os Termos.",
                                  toastLength: Toast.LENGTH_LONG
                              );
                            }else
                            {
                              _uploadImagem();
                            }
                          }
                        }
                      }
                    },
                  ),
                ),
                Container(
                  child: RaisedButton(
                    child: Text("Cancelar"),
                    color: Cores("#252568"),
                    textColor: Colors.white,
                    onPressed: ()
                    {
                      setState(() {
                        _confirmarfoto = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}
