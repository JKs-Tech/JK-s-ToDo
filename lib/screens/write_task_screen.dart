import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class WriteTaskScreen extends StatefulWidget {
  const WriteTaskScreen({super.key});

  @override
  State<WriteTaskScreen> createState() => _WriteTaskScreenState();
}

class _WriteTaskScreenState extends State<WriteTaskScreen> {
  final TextEditingController _titelController = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController _DecController = TextEditingController();
  final now = DateTime.now();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _fromKey = GlobalKey<FormState>();

// add task to firestore

  Future addTaskToFirestore() async {
    String uid = _auth.currentUser!.uid;
    await firestore
        .collection("tasks")
        .doc(uid)
        .collection("mytask")
        .doc(now.toString())
        .set({
      'titel': _titelController.text,
      'description': _DecController.text,
      'time': now.toString(),
    });
    Fluttertoast.showToast(
      msg: "Tas Added",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Your Task"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _fromKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titelController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please write titel";
                  } else {
                    return null;
                  }
                },
                style: GoogleFonts.aBeeZee(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Titel"),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _DecController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please write description";
                  } else {
                    return null;
                  }
                },
                style: GoogleFonts.basic(
                    fontSize: 18, fontWeight: FontWeight.w200),
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Description"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 17,
                child: ElevatedButton(
                  onPressed: () {
                    if (_fromKey.currentState!.validate()) {
                      setState(() {
                        addTaskToFirestore();
                        Navigator.pop(context);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19.0)),
                  ),
                  child: const Text(
                    "Add Task",
                    style: TextStyle(fontSize: 19),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
