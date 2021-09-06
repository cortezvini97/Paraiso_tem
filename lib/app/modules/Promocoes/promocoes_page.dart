import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PromocoesPage extends StatefulWidget {
  final String title;
  final String url;
  const PromocoesPage({Key key, this.title = "Promoções e Sorteio", this.url}) : super(key: key);

  @override
  _PromocoesPageState createState() => _PromocoesPageState();
}

class _PromocoesPageState extends State<PromocoesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child:  WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        )
      )
    );
  }
}
