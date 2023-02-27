import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/auth/forget_password.dart';

class MainAuthScreen extends StatefulWidget {
  const MainAuthScreen({super.key});

  @override
  State<MainAuthScreen> createState() => _MainAuthScreenState();
}

class _MainAuthScreenState extends State<MainAuthScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  bool isLoginPage = false;
  final _fromKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obsecureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isloding = false;

//Submit signup function

  submitSignup(String username, String email, String password) async {
    setState(() {
      _isloding = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String uid = _auth.currentUser!.uid;

      await firestore
          .collection("users")
          .doc(uid)
          .set({'username': username, 'email': email, 'password': password});
      setState(() {
        _isloding = false;
      });
    } catch (e) {
      setState(() {
        _isloding = false;
      });

      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

//////////////////////////////////////////////////
/////////////////////////////////////////////////

// submit login form

  submitLogin(String email, String password) async {
    setState(() {
      _isloding = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        _isloding = false;
      });
    } catch (e) {
      setState(() {
        _isloding = false;
      });
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginPage ? "Login" : "SignUp"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _fromKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isLoginPage)
                TextFormField(
                  controller: _userController,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp("^[A-Za-z]{2,15}").hasMatch(value)) {
                      return "Enter correct username";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28)),
                    hintText: "Jakvan",
                    labelText: "Username",
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return "Enter valid email";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28)),
                  hintText: "jk@gmail.com",
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Password";
                  } else {
                    return null;
                  }
                },
                obscureText: _obsecureText,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28)),
                    hintText: "Enter Your Password",
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          _obsecureText = !_obsecureText;
                          setState(() {});
                        },
                        icon: Icon(_obsecureText
                            ? Icons.visibility_off
                            : Icons.visibility))),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 17,
                child: ElevatedButton(
                  onPressed: () {
                    if (!isLoginPage) {
                      if (_fromKey.currentState!.validate()) {
                        try {
                          setState(() {
                            submitSignup(
                                _userController.text,
                                _emailController.text,
                                _passwordController.text);
                          });
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    } else {
                      if (_fromKey.currentState!.validate()) {
                        try {
                          setState(() {
                            submitLogin(_emailController.text,
                                _passwordController.text);
                          });
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19.0)),
                  ),
                  child: _isloding
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          isLoginPage ? "Login" : "SignUp",
                          style: const TextStyle(fontSize: 19),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLoginPage
                          ? "Don't have account"
                          : "All Ready have account",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoginPage = !isLoginPage;
                        });
                      },
                      child: Text(
                        isLoginPage ? "  SignUp Now!" : "  Login Now!",
                        style: const TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 1, 119, 255)),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPassword(),
                        ));
                  },
                  child: Text(
                    isLoginPage ? "Forget Password?" : "",
                    style: TextStyle(fontSize: 16, color: Colors.red.shade700),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
