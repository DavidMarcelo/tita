import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAutenticacion {
  static Future<User?> iniciarSesion({required BuildContext context}) async {
    print("Funcion de inicio de sesion con google");
    FirebaseAuth autenticacion = FirebaseAuth.instance;
    User? user;

    GoogleSignIn objGoogleSignIn = GoogleSignIn();
    GoogleSignInAccount? objGoogleSingInAccount =
        await objGoogleSignIn.signIn();
    if (objGoogleSingInAccount != null) {
      print("Diferente de nulo");
      GoogleSignInAuthentication objGoogleSignInAuthentication =
          await objGoogleSingInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: objGoogleSignInAuthentication.accessToken,
        idToken: objGoogleSignInAuthentication.idToken,
      );
      print("fin del if");
      try {
        print("try");
        UserCredential userCredential =
            await autenticacion.signInWithCredential(credential);

        user = userCredential.user;
        return user;
      } on FirebaseAuthException catch (e) {
        print("Error de Auth con google :  $e");
      }
    }
  }

  Future<void> cerrarsesionGoogle() async {
    print("Funcion cerrar sesion con google");
    FirebaseAuth autenticacion = FirebaseAuth.instance;
    User? user;
    GoogleSignIn objGoogleSignIn = GoogleSignIn();
    await objGoogleSignIn.signOut();
  }
}
