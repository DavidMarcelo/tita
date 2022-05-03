import 'package:app1/pages/home.dart';
import 'package:app1/pages/login.dart';
import 'package:app1/pages/register.dart';
import 'package:app1/services/notificaciones.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
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
