import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vcid/app/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vcid/app/classes/android_permissions.dart';

import 'app/classes/notificacoes/notificacao_config.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  if(Platform.isAndroid)
  {
    AndroidPermissions().requestPermission();
  }
  NotificacaoConfig().configuracao();
  runApp(ModularApp(
    module: AppModule(),
    )
  );
}