import 'package:app1/models/google.dart';
import 'package:app1/pages/home.dart';
import 'package:app1/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auth_buttons/auth_buttons.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final forKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwController = new TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your Email";
        }
        //Registra user for emial validator
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]").hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 10),
        hintText: "Correo electronico",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final passwField = TextFormField(
      autofocus: false,
      controller: passwController,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Password is required for login";
        }
        if (!regex.hasMatch(value)) {
          return "Please enter valid password (min. 6 Character)";
        }
      },
      onSaved: (value) {
        passwController.text = value!;
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 10),
        hintText: "Contraseña",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(25),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          iniciarSesion(emailController.text, passwController.text);
        },
        child: Text(
          "Iniciar sesion",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
    final googleBtn = GoogleAuthButton(
      text: "Iniciar sesión con Google",
      darkMode: false,
      onPressed: () async {
        print("Iniciando sesion");
        User? user = await GoogleAutenticacion.iniciarSesion(context: context);
        if (user == null) {
          Fluttertoast.showToast(msg: "No se pudo inicar sesión");
        } else {
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      },
      /*style: AuthButtonStyle(
        iconType: AuthIconType.outlined,
      ),*/
    );
    /*final facebookButton = ElevatedButton(
      child: Text("Iniciar sesión con Facebook"),
      onPressed: () async {
        final resultado =
            await FacebookAuth.i.login(permissions: ["Perfil", "email"]);
        if (resultado.status == LoginStatus.success) {
          final requesData = await FacebookAuth.i.getUserData(
            fields: "email, name",
          );
          setState(() {});
        }
      },
    );*/
    final googleButton = MaterialButton(
      onPressed: () async {
        print("Iniciando sesion");
        User? user = await GoogleAutenticacion.iniciarSesion(context: context);
        if (user == null) {
          Fluttertoast.showToast(msg: "No se pudo inicar sesión");
        } else {
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
        //print(user?.);
      },
      color: Colors.blue,
      child: Icon(FontAwesomeIcons.google),
      textColor: Colors.white,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: forKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    //facebookButton,
                    googleBtn,
                    SizedBox(
                      height: 20,
                    ),
                    googleButton,
                    SizedBox(
                      height: 20,
                    ),
                    emailField,
                    SizedBox(
                      height: 20,
                    ),
                    passwField,
                    SizedBox(
                      height: 20,
                    ),
                    loginButton,
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("¿No tienes una cuenta?  "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => Registrar()),
                            );
                          },
                          child: Text(
                            "Registrar.",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void iniciarSesion(String email, String password) async {
    if (forKey.currentState!.validate()) {
      await auth
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then(
            (uid) => {
              Fluttertoast.showToast(msg: "Login Successful"),
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              )
            },
          )
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
