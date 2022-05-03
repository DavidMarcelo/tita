import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class NotificacionService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String? token;

  static StreamController<String> streamControllerMessage =
      new StreamController.broadcast();

  static Stream<String> get messageStream => streamControllerMessage.stream;

  static Future backgroundhandler(RemoteMessage message) async {
    print("background handler: ${message.messageId}");
    streamControllerMessage.add(message.notification?.title ?? 'No hay titulo');
  }

  static Future onmessagehandler(RemoteMessage message) async {
    print("on message handler: ${message.messageId}");
    streamControllerMessage.add(message.notification?.title ?? 'No hay titulo');
  }

  static Future onopenmessage(RemoteMessage message) async {
    print("on open app handler: ${message.messageId}");
    streamControllerMessage.add(message.notification?.title ?? 'No hay titulo');
  }

  static Future initializedApp() async {
    //Notificaciones push
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print("TokenXD::  $token");
    //Handlers
    FirebaseMessaging.onBackgroundMessage(backgroundhandler);
    FirebaseMessaging.onMessage.listen(onmessagehandler);
    FirebaseMessaging.onMessageOpenedApp.listen(onopenmessage);

    //Local Notifications
  }

  static closeStream() {
    streamControllerMessage.close();
  }
}
