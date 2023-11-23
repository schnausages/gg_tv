import 'package:flutter/material.dart';
import 'package:gg_tv/screens/auth_screens/sign_in.dart';
import 'package:gg_tv/screens/auth_screens/sign_up.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PageController _controller = PageController();
  int _ind = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/auth_bg.jpg'),
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerRight)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: const [SignInScreen(), SignUpScreen()],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 55),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color:
                            _ind == 0 ? Colors.pinkAccent[400] : Colors.white10,
                        elevation: 0,
                        child: Text('SIGN IN',
                            style: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: Colors.white,
                                fontWeight:
                                    _ind == 0 ? FontWeight.bold : null)),
                        onPressed: () {
                          setState(() {
                            _ind = 0;
                          });
                          _controller.jumpToPage(0);
                        }),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color:
                            _ind == 1 ? Colors.pinkAccent[400] : Colors.white10,
                        elevation: 0,
                        child: Text('SIGN UP',
                            style: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: Colors.white,
                                fontWeight:
                                    _ind == 1 ? FontWeight.bold : null)),
                        onPressed: () {
                          setState(() {
                            _ind = 1;
                          });
                          _controller.jumpToPage(1);
                        })
                  ],
                ),
              )
            ],
          )),
    );
  }
}
