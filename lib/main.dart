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
  final List<Widget> _screens = const [
    MainFeedScreen(),
    CreateContentScreen(),
    LeaderboardScreen(),
    UserProfileScreen()
  ];
  int _pageIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
// USE PAGEVIEW TO AVOID REBUILDS DUH

// https://stackoverflow.com/questions/49439047/how-to-preserve-widget-states-in-flutter-when-navigating-using-bottomnavigation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _pageIndex,
          backgroundColor: Colors.black,
          unselectedIconTheme: IconThemeData(color: Colors.blueGrey, size: 18),
          selectedIconTheme: IconThemeData(color: Color(0xFFE23FFF), size: 22),
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.play_arrow_rounded,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.leaderboard_rounded,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_2_outlined,
                ),
                label: ''),
          ]),
    );
  }
}
