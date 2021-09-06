import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  var tituloAndUrl;
  WebViewPage({Key key, this.tituloAndUrl}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _myController;
  bool _loadedPage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _loadedPage = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tituloAndUrl['titulo']),
      ),
      body: Builder(
          builder: (BuildContext context) {
            return Stack(
              children: <Widget>[
                WebView(
                  initialUrl: widget.tituloAndUrl['url'],
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller){
                    _myController = controller;
                  },
                  javascriptChannels: <JavascriptChannel>[
                    _toasterJavascriptChannel(context),
                  ].toSet(),
                  onPageFinished: (url)
                  {
                    _myController.evaluateJavascript("javascript:(function() { " +
                        "var head = document.getElementById('cabecalho-inicial').style.display='none'; " +
                        "})()");
                  },
                )
              ],
            );
          }
      ),
    );
  }


  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}


