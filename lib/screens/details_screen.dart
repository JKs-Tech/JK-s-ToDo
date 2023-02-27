import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie/screens/edit_screen.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatefulWidget {
  String titel;
  String description;

  // ignore: prefer_typing_uninitialized_variables
  var doc;
  // ignore: prefer_typing_uninitialized_variables
  var index;

  DetailsScreen(
      {super.key,
      required this.description,
      required this.titel,
      required this.doc,
      required this.index});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid1 = "";
  @override
  void initState() {
    getUid();
    super.initState();
    setState(() {});
  }

  getUid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    setState(() {});
    uid1 = uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditScreen(
                        uid: uid1,
                        titel: widget.titel,
                        description: widget.description,
                        doc: widget.doc,
                        index: widget.index,
                      ),
                    ));
                setState(() {});
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                setState(() {});
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () async {
                await firestore
                    .collection("tasks")
                    .doc(uid1)
                    .collection('mytask')
                    .doc(widget.doc[widget.index]['time'])
                    .delete();
                Fluttertoast.showToast(
                  msg: "Task Deleted",
                );
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                setState(() {});
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.titel,
                          style: GoogleFonts.aBeeZee(fontSize: 23),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SingleChildScrollView(
                          child: Text(
                            widget.description,
                            style: GoogleFonts.basic(fontSize: 19),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
