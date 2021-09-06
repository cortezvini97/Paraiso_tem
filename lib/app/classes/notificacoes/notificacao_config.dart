import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vcid/app/classes/notificacoes/push_notification_factory.dart';

class NotificacaoConfig
{
  FirebaseMessaging _messaing = FirebaseMessaging();
  FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  NotificationDetails platformChannelSpecifics;

  void configuracao()
  {
    _messaing.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false));
    _messaing.onIosSettingsRegistered.listen((IosNotificationSettings settings)
    {
      print(settings);
    });

    var android = AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = IOSInitializationSettings();
    var initsettings = InitializationSettings(android, ios);
    _localNotifications.initialize(initsettings, onSelectNotification: onSelectNotification);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails('push_notification_strategy_id', 'push_notification_strategy_name', 'push_notification_strategy_description', importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    _messaing.configure(
      onMessage: (Map<String, dynamic> message)
      {
        print("${message}");
        showNotification(message);
      },
      onResume: (Map<String, dynamic> message)
      {
        print("${message}");
        if(Platform.isAndroid)
        {
          PushNotificationFactory.create(json.decode(message['data']['payload']))..execute();
        }else if(Platform.isIOS)
        {
          PushNotificationFactory.create(json.decode(message['payload']))..execute();
        }
      },
      onLaunch: (Map<String, dynamic> message)
      {
        print("${message}");
        if(Platform.isAndroid)
        {
          PushNotificationFactory.create(json.decode(message['data']['payload']))..execute();
        }else if(Platform.isIOS)
        {
          PushNotificationFactory.create(json.decode(message['payload']))..execute();
        }
      },
      onBackgroundMessage:(Platform.isIOS) ? null: background
    );
    //_messaing.subscribeToTopic("paraisotemtesteNotificacao");
    if(Platform.isAndroid)
    {
      _messaing.subscribeToTopic("paraisotempaginasAndroid");
      _messaing.subscribeToTopic("paraisotempromocoesAndroid");
      _messaing.subscribeToTopic("paraisotemglobalAndroid");
    }else if(Platform.isIOS)
    {
      _messaing.subscribeToTopic("paraisotempaginasIos");
      _messaing.subscribeToTopic("paraisotempromocoesIos");
      _messaing.subscribeToTopic("paraisotemglobalIos");
    }
  }

  static Future background(Map<String, dynamic> message)
  {
    print("${message}");
    PushNotificationFactory.create(json.decode(message['data']['payload']))..execute();
  }

  Future onSelectNotification(String payload)
  {
    print(payload);
    PushNotificationFactory.create(json.decode(payload))..execute();
  }

  showNotification(message) async
  {
    var alert;
    var payload;

    if(Platform.isAndroid)
    {
      alert = message['notification'];
      payload = message['data']['payload'];
    }else if(Platform.isIOS)
    {
      alert = message['aps']['alert'];
      payload = message['payload'];
    }
    await _localNotifications.show(0, alert['title'], alert['body'], platformChannelSpecifics, payload: payload);
  }
}