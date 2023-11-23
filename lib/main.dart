import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gg_tv/screens/auth_screens/landing_screen.dart';
import 'package:gg_tv/screens/leaderboard_screen.dart';
import 'package:gg_tv/screens/gg_feed.dart';
import 'package:gg_tv/screens/user_profile_screen.dart';
import 'package:gg_tv/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/create_content_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AuthService())],
      child: Consumer<AuthService>(
          builder: (ctx, auth, _) => MaterialApp(
                darkTheme: ThemeData.dark(),
                debugShowCheckedModeBanner: false,
                home: auth.isAuth
                    // ? TabBarScreen()
                    ? TabBasePage()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const LaunchWaitingScreen()
                                : const LandingScreen()),
              )),
    );
  }
}

class TabBasePage extends StatefulWidget {
  const TabBasePage({super.key});

  @override
  State<TabBasePage> createState() => _TabBasePageState();
}

class _TabBasePageState extends State<TabBasePage> {
  late PageController _pageController;
  final List<Widget> _screens = [
    const MainFeedScreen(),
    const LeaderboardScreen(),
    const CreateContentScreen(),
    const LeaderboardScreen(),
    UserProfileScreen()
  ];
  int _pageIndex = 1;
  final Color _activeColor = const Color(0xFFE23FFF);
  final Color _inactiveColor = const Color.fromARGB(255, 72, 65, 77);

  void _onItemTapped(int index) {
    print(index);
    _pageController.jumpToPage(index);
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }
// USE PAGEVIEW TO AVOID REBUILDS DUH

// https://stackoverflow.com/questions/49439047/how-to-preserve-widget-states-in-flutter-when-navigating-using-bottomnavigation
  @override
  Widget build(BuildContext context) {
    final double _h = MediaQuery.of(context).size.height * .1;
    final double _w = MediaQuery.of(context).size.width;
    final double _buttonWidth = _w * .2;

    return Scaffold(
        resizeToAvoidBottomInset: false, //test thesefor nav bar
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _screens,
            ),
            Container(
              width: _w,
              height: 70,
              decoration: BoxDecoration(
                  color: _pageIndex == 0
                      ? Colors.transparent
                      : const Color.fromARGB(255, 30, 29, 31),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )),
              child: Row(
                children: [
                  SizedBox(
                    width: _buttonWidth,
                    height: 55,
                    child: MaterialButton(
                      onPressed: () => _onItemTapped(0),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 34,
                        color: _pageIndex == 0 ? _activeColor : _inactiveColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _buttonWidth,
                    height: 55,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(12))),
                      onPressed: () => _onItemTapped(1),
                      child: Icon(
                        Icons.leaderboard_rounded,
                        color: _pageIndex == 1 ? _activeColor : _inactiveColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: _buttonWidth,
                    height: 55,
                    child: MaterialButton(
                      onPressed: () => _onItemTapped(2),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/svgs/plus.svg',
                          color: Colors.white70,
                        ),
                      ),
                      // icon: Icon(Icons.add,
                      //     color: _pageIndex == 2 ? _activeColor : _inactiveColor),
                    ),
                  ),
                  SizedBox(
                    width: _buttonWidth,
                    height: 55,
                    child: MaterialButton(
                      onPressed: () => _onItemTapped(3),
                      child: Icon(Icons.leaderboard_rounded,
                          color:
                              _pageIndex == 3 ? _activeColor : _inactiveColor),
                    ),
                  ),
                  SizedBox(
                    width: _buttonWidth,
                    height: 55,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(12))),
                      onPressed: () => _onItemTapped(4),
                      child: Icon(Icons.person_2,
                          color:
                              _pageIndex == 4 ? _activeColor : _inactiveColor),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class LaunchWaitingScreen extends StatelessWidget {
  const LaunchWaitingScreen({Key? key}) : super(key: key);
  static const List<String> _messages = [
    'Go for Ws',
    'Take no Ls',
    'Celebrate Ws'
  ];

  String generateWelcome(int second) {
    if (second > 40) {
      return _messages[2];
    } else if (second > 20) {
      return _messages[1];
    } else {
      return _messages[0];
    }
  }

  LinearGradient generateGradient(int second) {
    if (second > 40) {
      return const LinearGradient(
          colors: [Colors.deepPurpleAccent, Color.fromRGBO(74, 20, 140, 1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter);
    } else if (second > 20) {
      return const LinearGradient(
          colors: [Colors.cyanAccent, Color.fromRGBO(83, 109, 254, 1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter);
    } else {
      return const LinearGradient(
          colors: [Colors.pinkAccent, Colors.deepPurple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter);
    }
  }

  @override
  Widget build(BuildContext context) {
    int _second = DateTime.now().second;
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(gradient: generateGradient(_second)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 100,
            height: 100,
            child: Platform.isIOS
                ? const CupertinoActivityIndicator(radius: 20)
                : const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          const Text(
            'WorL',
            softWrap: true,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Ubuntu',
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            generateWelcome(_second),
            softWrap: true,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Ubuntu',
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }
}
