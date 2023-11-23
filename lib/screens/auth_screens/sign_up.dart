import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gg_tv/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool _hidePw = true;
  final TextStyle _textStyle =
      const TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontSize: 16);
  final BoxDecoration _dec = BoxDecoration(
      borderRadius: BorderRadius.circular(12), color: Colors.black38);

  _checkUsernameAvailability(String s) async {
    var _userExists = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: s)
        .limit(1)
        .get();
    if (_userExists.docs.length > 0) {
      return false;
    } else {
      return true;
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/auth_bg.jpg'),
        fit: BoxFit.cover,
        alignment: Alignment.centerLeft,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
                    // Column(
                    //   children: [
                    //     const Row(
                    //       children: [
                    //         Text('USERNAME',
                    //             style: TextStyle(
                    //                 fontFamily: 'Ubuntu',
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.bold))
                    //       ],
                    //     ),
                    //     const SizedBox(height: 8),
                    //     Container(
                    //       decoration: _dec,
                    //       child: TextFormField(
                    //         cursorColor: Colors.white,
                    //         controller: _usernameController,
                    //         // maxLength: 18,
                    //         style: _textStyle,
                    //         decoration: const InputDecoration(
                    //             contentPadding: const EdgeInsets.only(left: 15),
                    //             border: InputBorder.none,
                    //             disabledBorder: InputBorder.none),

                    //         validator: (val) {
                    //           if (val!.length < 3) {
                    //             return 'Username too short';
                    //           }

                    //           if (val.length > 24) {
                    //             return 'Username too long';
                    //           }
                    //           if (val.contains('@')) {
                    //             return 'No @ in username please';
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 15),
                    Column(
                      children: [
                        const Row(
                          children: [
                            Text('EMAIL',
                                style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: _dec,
                          child: TextFormField(
                            controller: _emailController,
                            cursorColor: Colors.white,
                            style: _textStyle,
                            decoration: const InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15),
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none),
                            validator: (val) {
                              if (!val!.contains('@')) {
                                return 'Invalid email';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        const Row(
                          children: [
                            Text('PASSWORD',
                                style: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: _dec,
                          child: TextFormField(
                            obscureText: _hidePw,
                            controller: _passwwordController,
                            cursorColor: Colors.white,
                            style: _textStyle,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _hidePw = !_hidePw;
                                      });
                                    },
                                    icon: const Icon(Icons.visibility,
                                        color: Colors.white54)),
                                disabledBorder: InputBorder.none),
                            validator: (val) {
                              if (val!.length < 3) {
                                return 'Password too short';
                              }

                              if (val == 'password' ||
                                  val == 'Password' ||
                                  val == 'PASSWORD') {
                                return "Please don't use that password";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Consumer<AuthService>(
                      builder: ((context, auth, _) {
                        return MaterialButton(
                            color: Colors.pinkAccent[400],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              "LET'S GO",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              bool _isValid = _formKey.currentState!.validate();
                              if (_isValid) {
                                String _tUsername = _emailController.value.text
                                        .substring(0, 8) +
                                    generateRandomString(8) +
                                    DateTime.now().millisecond.toString();

                                var _res = await auth.signUpWithEmail(
                                    email: _emailController.value.text,
                                    password: _passwwordController.value.text,
                                    username: _tUsername);
                                if (_res.runtimeType == User) {
                                  print("PURT AUTHED");
                                }
                                if (_res.runtimeType != User) {
                                  print("PURT EXCEPTION");

                                  infoDialog(context,
                                      message: 'Auth Exception');
                                }
                              }
                            });
                      }),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

infoDialog(BuildContext context, {required String message}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 12, 27, 35),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22))),
          title: const Text('Error',
              style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          content: Text(message,
              style:
                  const TextStyle(fontFamily: 'Ubuntu', color: Colors.white)),
        );
      });
}
