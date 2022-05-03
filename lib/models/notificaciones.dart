import 'package:firebase_messaging/firebase_messaging.dart';

class Notificaciones {
  FirebaseMessaging mensaje = FirebaseMessaging.instance;

  initNotificacionts() {
    mensaje.requestPermission();
    //Token de la base de datos
    //mensaje.getToken();
  }
}
