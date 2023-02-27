import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie/screens/home_screen.dart';

// ignore: must_be_immutable
class EditScreen extends StatefulWidget {
  String titel;
  String description;
  // ignore: prefer_typing_uninitialized_variables
  var doc;
  // ignore: prefer_typing_uninitialized_variables
  var index;
  String uid;
  EditScreen(
      {super.key,
      required this.titel,
      required this.description,
      required this.uid,
      required this.doc,
      required this.index});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final now = DateTime.now();

// update task
  // ignore: non_constant_identifier_names
  Future UpdateTaskToFirestore() async {
    String uid = _auth.currentUser!.uid;
    firestore.collection("tasks").doc(uid).collection('mytask').snapshots();

    CollectionReference reference =
        firestore.collection("tasks").doc(uid).collection("mytask");

    reference.doc(widget.doc[widget.index]["time"]).update({
      'titel': _titelController.text,
      'description': _descriptionController.text,
    });

    Fluttertoast.showToast(
      msg: "Task Updated",
    );
  }

  @override
  Widget build(BuildContext context) {
    _titelController.text = widget.titel;
    _descriptionController.text = widget.description;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Task"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                UpdateTaskToFirestore();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ));
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    style: GoogleFonts.aBeeZee(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                    controller: _titelController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    style: GoogleFonts.basic(
                        fontSize: 18, fontWeight: FontWeight.w200),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                    controller: _descriptionController,
                    maxLines: 6,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 40,
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 17,
                child: ElevatedButton(
                  onPressed: () {
                    UpdateTaskToFirestore();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19.0)),
                  ),
                  child: const Text(
                    "Update Task",
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
