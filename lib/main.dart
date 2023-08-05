import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gg_tv/screens/leaderboard_screen.dart';
import 'package:gg_tv/screens/gg_feed.dart';
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
      home: const TabBasePage(),
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

  Widget _playArrow(int index) {
    if (index == 0) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.play_arrow_rounded,
            color: _activeColor,
            size: 36,
          ),
          const Icon(
            Icons.play_arrow_rounded,
            color: Color.fromARGB(255, 250, 222, 255),
            size: 26,
          ),
        ],
      );
    } else {
      return Icon(
        Icons.play_arrow_rounded,
        color: _inactiveColor,
        size: 24,
      );
    }
  }

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
              height: 55,
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
                      child: _playArrow(_pageIndex),
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
