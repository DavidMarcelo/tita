import 'dart:io';

import 'package:app1/models/google.dart';
import 'package:app1/models/user.dart';
import 'package:app1/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app1/models/band.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel sesion = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.sesion = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  List<Band> bands = [
    Band(id: '1', name: 'Metalica1', votes: 1),
    Band(id: '2', name: 'Metalica2', votes: 2),
    Band(id: '3', name: 'Metalica3', votes: 6),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bandas',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) {
          return bandTile(bands[i]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        //onPressed: addnewBan,
        onPressed: () {
          cerrarSesion(context);
        },
      ),
    );
  }

  Widget bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(band.id);
        print(direction);
      },
      background: Container(
        padding: EdgeInsets.only(left: 10.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Borrar",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addnewBan() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                elevation: 5,
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  addBandToList(textController.text);
                  print(textController.text);
                },
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text("New band name:"),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Add"),
                isDefaultAction: true,
                onPressed: () {
                  addBandToList(textController.text);
                },
              ),
              CupertinoDialogAction(
                child: Text("Dissmis"),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> cerrarSesion(BuildContext context) async {
    print("Cerrar sesion con Google");
    GoogleAutenticacion().cerrarsesionGoogle();
    await FirebaseAuth.instance.signOut();
    print("Cerrar sesión con Facebook");
    //await FacebookAuth.i.logOut();
    print("cerratr sesion normal");
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      //Agregar el
      this.bands.add(
            new Band(
              id: DateTime.now().toString(),
              name: name,
              votes: 0,
            ),
          );
      setState(() {});
    }
    Navigator.pop(context);
  }
}
