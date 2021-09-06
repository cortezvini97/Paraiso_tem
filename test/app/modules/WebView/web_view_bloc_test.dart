import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/app_module.dart';
import 'package:vcid/app/modules/WebView/web_view_bloc.dart';
import 'package:vcid/app/modules/WebView/web_view_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(WebViewModule());
  WebViewBloc bloc;

  // setUp(() {
  //     bloc = WebViewModule.to.get<WebViewBloc>();
  // });

  // group('WebViewBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<WebViewBloc>());
  //   });
  // });
}
