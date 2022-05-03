import 'package:app1/pages/home.dart';
import 'package:app1/pages/login.dart';
import 'package:app1/pages/register.dart';
import 'package:app1/services/notificaciones.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel chanel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessassingBackground(RemoteMessage message) async {
  print("Inicializacion del mensaje");
  await Firebase.initializeApp();
  print("A bg message just showed ${message.messageId}");
}

Future<void> main() async {
  print("Main de inicio");
  WidgetsFlutterBinding.ensureInitialized();
  await NotificacionService.initializedApp();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("hola mundo");
    NotificacionService.messageStream.listen((message) {
      print("My app: $message");
      final snackBar = SnackBar(content: Text('Titulo de la app'));
      scaffoldKey.currentState?.showSnackBar(snackBar);
      //Navegar a otra pantalla
      navigatorKey.currentState?.pushNamed('Registrar', arguments: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, //Navegar entre pantallas
      scaffoldMessengerKey: scaffoldKey, //mostrar snacks
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (_) => Login(),
        'Registrar': (_) => Registrar(),
      },
    );
  }
}
