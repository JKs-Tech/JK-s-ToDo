// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie/screens/details_screen.dart';
import 'package:movie/screens/edit_screen.dart';
import 'package:movie/screens/write_task_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid1 = "jk";
  @override
  void initState() {
    getUid();
    super.initState();
  }

  getUid() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser!.uid;
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
                FirebaseAuth.instance.signOut();
                setState(() {});
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Text("ToDo"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Task"),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 20,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WriteTaskScreen(),
              ));
        },
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: firestore
              .collection('tasks')
              .doc(uid1)
              .collection('mytask')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else {
              final docs = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.only(top: 10, left: 6, right: 6),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: docs.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                          description: docs[index]
                                              ['description'],
                                          titel: docs[index]['titel'],
                                          doc: docs,
                                          index: index),
                                    ));
                              },
                              child: Container(
                                height: 135,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 72, 74, 79),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(18),
                                      topLeft: Radius.circular(18),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            docs[index]['titel'],
                                            style: GoogleFonts.aBeeZee(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            docs[index]['description'],
                                            style: GoogleFonts.basic(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w200),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 73, 67, 50),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(18),
                                    bottomLeft: Radius.circular(18),
                                  )),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await firestore
                                          .collection("tasks")
                                          .doc(uid1)
                                          .collection('mytask')
                                          .doc(docs[index]['time'])
                                          .delete();
                                      Fluttertoast.showToast(
                                        msg: "Task Deleted",
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                  titel: docs[index]['titel'],
                                                  description: docs[index]
                                                      ['description'],
                                                  uid: uid1,
                                                  doc: docs,
                                                  index: index),
                                            ));
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              );
            }
          },
        ),
      ),
    );
  }
}
