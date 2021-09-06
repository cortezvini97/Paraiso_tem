import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:vcid/app/classes/cores.dart';
import 'package:vcid/app/classes/models/managers/user_manager.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {

    final ThemeData tema = ThemeData(
        primaryColor: Cores("#052C7C"),
        accentColor:  Cores("#052C7C")
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserManager(),
            lazy: false,
        )
      ],
      child: MaterialApp(
        navigatorKey: Modular.navigatorKey,
        title: 'Paraíso Tem',
        theme: tema,
        initialRoute: '/',
        onGenerateRoute: Modular.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
