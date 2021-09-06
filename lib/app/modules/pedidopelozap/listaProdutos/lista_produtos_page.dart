import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vcid/app/classes/models/produtos_models.dart';
import 'package:http/http.dart' as http;
import 'package:vcid/app/classes/widgets/pedidopelozap_components/ProdutosTlle.dart';
class ListaProdutosPage extends StatefulWidget {
  final String title;
  final String id_empresa;
  final String id_categoria;
  const ListaProdutosPage({Key key, this.title = "", this.id_empresa, this.id_categoria})
      : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage>
{


  StreamController _controller = StreamController.broadcast();
  final Firestore db = Firestore.instance;

  Stream<DocumentSnapshot> _status()
  {
    var stream = db.collection("empresas").document(widget.id_empresa).snapshots();

    stream.listen((dados)
    {
      setState(() {
        _controller.add(dados);
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _status();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 16,),
            StreamBuilder(
              stream: _controller.stream,
              builder: (_, snapshot)
              {
                switch(snapshot.connectionState)
                {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if(snapshot.hasError)
                    {
                      return Center(
                        child: Text("Erro"),
                      );
                    }else
                    {
                      DocumentSnapshot dados = snapshot.data;

                      var status = dados.data["status"];
                      return status == "aberto" ? Center(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.green,
                          child: Text(
                            'Aberto',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ):Center(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.red,
                          child: Text(
                            'Fechado',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      );
                    }
                }
              },
            ),
            SizedBox(height: 16,),

          ],
        )
      ),
    );
  }
}
