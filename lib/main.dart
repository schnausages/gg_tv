import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/screens/leaderboard_screen.dart';
import 'package:gg_tv/screens/main_feed.dart';
import 'package:gg_tv/screens/user_profile_screen.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  final List<Widget> _screens = const [
    MainFeedScreen(),
    CreateContentScreen(),
    LeaderboardScreen(),
    UserProfileScreen()
  ];
  int _pageIndex = 1;
  void _onItemTapped(int index) {
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
    const Color _activeColor = Color(0xFFE23FFF);
    const Color _inactiveColor = Color.fromARGB(255, 72, 65, 77);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: false,
          selectedItemColor: Color(0xFFE23FFF),
          unselectedItemColor: Colors.blueGrey,
          currentIndex: _pageIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.play_arrow_rounded), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard_rounded), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person_2), label: ''),
          ]),
      // bottomNavigationBar: Container(
      //   height: _h * .075,
      //   width: _w,
      //   color: Colors.black,
      //   child: Row(children: [
      //     GestureDetector(
      //       onTap: () => _onItemTapped(0),
      //       child: Icon(Icons.play_arrow_rounded,
      //           color: _pageIndex == 0 ? _activeColor : _inactiveColor),
      //     ),
      //     GestureDetector(
      //       onTap: () => _onItemTapped(1),
      //       child: Icon(Icons.add,
      //           color: _pageIndex == 1 ? _activeColor : _inactiveColor),
      //     ),
      //     GestureDetector(
      //       onTap: () => _onItemTapped(2),
      //       child: Icon(Icons.leaderboard_rounded,
      //           color: _pageIndex == 2 ? _activeColor : _inactiveColor),
      //     ),
      //     GestureDetector(
      //       onTap: () => _onItemTapped(3),
      //       child: Icon(Icons.person_2,
      //           color: _pageIndex == 3 ? _activeColor : _inactiveColor),
      //     )
      //   ]),
      // )
    );
  }
}
