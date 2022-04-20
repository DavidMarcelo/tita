import 'package:app1/models/user.dart';
import 'package:app1/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:app1/models/band.dart';

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

  ListTile bandTile(Band band) {
    return ListTile(
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
    );
  }

  addnewBan() {
    /*showCupertinoDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New band name:'),
        );
      },
    );*/
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New band name:'),
          content: TextField(),
          actions: [
            MaterialButton(child: Text('Add'), onPressed: () {}),
          ],
        );
      },
    );
  }

  Future<void> cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }
}
