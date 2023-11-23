import 'package:gg_tv/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey _formKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool _hidePw = true;
  final TextStyle _textStyle =
      const TextStyle(color: Colors.white, fontFamily: 'Ubuntu', fontSize: 12);
  final BoxDecoration _dec = BoxDecoration(
      borderRadius: BorderRadius.circular(12), color: Colors.black38);
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
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
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
                            cursorColor: Colors.white,
                            controller: _emailController,
                            style: const TextStyle(
                                fontFamily: 'Ubuntu', color: Colors.white),
                            decoration: const InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15),
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                          child: TextField(
                            cursorColor: Colors.white,
                            obscureText: _hidePw,
                            controller: _passwwordController,
                            textAlignVertical: TextAlignVertical.center,
                            style: const TextStyle(
                                fontFamily: 'Ubuntu', color: Colors.white),
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Consumer<AuthService>(
                      builder: ((context, auth, _) {
                        return MaterialButton(
                            color: Colors.pinkAccent[400],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              "LET ME IN",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              try {
                                print(":: exists ::::");
                                auth.signInWithEmail(
                                    // email:
                                    //     'tummybumble3910553451109@daychat.app',
                                    email: _emailController.value.text.trim(),
                                    password: _passwwordController.value.text);
                              } catch (e) {
                                infoDialog(context,
                                    message: 'Username not found');
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
