import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/models/user.dart';
import 'package:gg_tv/screens/setup/setup_flow.dart';
import 'package:gg_tv/services/auth_service.dart';
import 'package:gg_tv/services/misc_services.dart';
import 'package:gg_tv/styles.dart';
import 'package:gg_tv/widgets/base_snackbar.dart';
import 'package:gg_tv/widgets/profile_games_for_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _nameChangeActive = false;
  late TextEditingController _nameController;
  late UserModel _currentUser;
  late Future _fetchUserFuture;

  Future<bool> _updateUsername(String submittedUsername) async {
    FirebaseFirestore _fs = FirebaseFirestore.instance;
    var _usernameDocs = await _fs
        .collection('users')
        .where('username', isEqualTo: submittedUsername)
        .limit(1)
        .get()
        .then((value) => value.docs);
    if (_usernameDocs.length > 0) {
      return false;
    }
    var _userDoc = await _fs
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .get()
        .then((value) => value.docs.first);
    await _userDoc.reference.update({'username': submittedUsername});
    return true;
  }

  Future<void> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    QueryDocumentSnapshot<Map<String, dynamic>> _userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .limit(1)
            .get()
            .then((value) => value.docs.first);
    // _userData = _userDoc.data();
    // _userData.remove('last_active');
    // _userData.remove('date_added');
    _currentUser = UserModel.fromJson(_userDoc.data());
    String _profile = json.encode(_userDoc.data());
    prefs.setString('cachedProfile', _profile);
    setState(() {});
  }

  @override
  void initState() {
    _fetchUserFuture = fetchUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _W = MediaQuery.of(context).size.width;
    final double _h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: FutureBuilder(
          future: _fetchUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: MiscServices.generateUserPfp(
                                _currentUser.pfp ?? ''),
                          )),
                      height: 70,
                      width: 70,
                    ),
                    if (!_nameChangeActive)
                      GestureDetector(
                        onTap: () {
                          _nameController = TextEditingController();
                          setState(() {
                            _nameChangeActive = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(_currentUser.username,
                              style:
                                  AppStyles.giga18Text.copyWith(fontSize: 20)),
                        ),
                      ),
                    if (_nameChangeActive)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                autofocus: true,
                                controller: _nameController,
                                style:
                                    AppStyles.giga18Text.copyWith(fontSize: 16),
                                maxLength: 24,
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                    counter: SizedBox(),
                                    isDense: true,
                                    contentPadding: const EdgeInsets.all(0),
                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none),
                              ),
                            ),
                          ),
                          if (_nameController.text != _currentUser.username)
                            IconButton(
                              onPressed: () async {
                                String _newUsername =
                                    _nameController.text.toLowerCase();
                                bool _accepted =
                                    await _updateUsername(_newUsername);
                                if (_accepted) {
                                  await UserActionServices.updateStorageKey(
                                      key: 'username', newValue: _newUsername);
                                  setState(() {
                                    _currentUser.username =
                                        _nameController.text;
                                    _nameChangeActive = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      MiscWidgets.baseSnackbar(
                                          message: 'Username changed',
                                          success: true));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      MiscWidgets.baseSnackbar(
                                          message: 'Username taken',
                                          success: false));
                                }
                              },
                              iconSize: 30,
                              icon: Icon(Icons.check_circle_outline_rounded),
                              color: Color.fromARGB(255, 58, 255, 104),
                            ),
                          IconButton(
                            onPressed: () async {
                              setState(() {
                                _nameChangeActive = false;
                                _nameController.clear();
                              });
                            },
                            iconSize: 30,
                            icon: Icon(Icons.cancel),
                            color: Color.fromARGB(255, 255, 76, 66),
                          )
                        ],
                      ),
                    MaterialButton(
                        child: Text('steup'),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => SetupFlow()));
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4)),
                            child: const Icon(Icons.play_arrow_rounded),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(4)),
                            child: const Icon(Icons.video_call_rounded),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4)),
                            child: const Icon(
                                Icons.keyboard_double_arrow_right_outlined),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              size: 36,
                              color: Color.fromARGB(255, 91, 255, 42),
                            ),
                            const Text('1992', style: AppStyles.giga18Text),
                            Row(
                              children: [
                                const RotatedBox(
                                  quarterTurns: -1,
                                  child: Icon(
                                    Icons.double_arrow_rounded,
                                    size: 18,
                                    shadows: [
                                      BoxShadow(
                                          color: Colors.lightGreen,
                                          blurRadius: 4,
                                          spreadRadius: 0)
                                    ],
                                    color: Color.fromARGB(255, 91, 255, 42),
                                  ),
                                ),
                                Text('+14',
                                    style: AppStyles.giga18Text
                                        .copyWith(fontSize: 14)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(width: 20),
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 36,
                              color: Color.fromARGB(255, 255, 65, 61),
                            ),
                            Text('2283', style: AppStyles.giga18Text),
                          ],
                        ),
                        const SizedBox(width: 20),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 36,
                              color: Color.fromRGBO(255, 202, 44, 1),
                            ),
                            Text('776', style: AppStyles.giga18Text),
                          ],
                        ),
                      ],
                    ),
                    const GamesForUser(),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.5,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                        itemCount: 21,
                        itemBuilder: (context, i) {
                          return Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * .5,
                                decoration: BoxDecoration(
                                    color: Colors.amber[50],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text("${2}",
                                      style: AppStyles.giga18Text
                                          .copyWith(fontSize: 34)),
                                ),
                              ),
                              Positioned(
                                  bottom: 15,
                                  right: 10,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.play_arrow_outlined,
                                          color: Colors.white, size: 22),
                                      Text(
                                        '184',
                                        style: AppStyles.giga18Text
                                            .copyWith(fontSize: 16),
                                      )
                                    ],
                                  ))
                            ],
                          );
                        }),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            } else {
              return Center(
                  child: SizedBox(
                height: 80,
                width: 80,
                child: Image.asset('assets/images/gg_loading.gif'),
              ));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //add new user

          // var _userDoc = await FirebaseFirestore.instance
          //     .collection('users')
          //     .where('username', isEqualTo: 'blarty287')
          //     .limit(1)
          //     .get()
          //     .then((value) => value.docs.first.reference);
          // await _userDoc.collection('games_for_user').add({
          //   'game_title': 'Fortnite',
          //   'ups': 54,
          //   'downs': 3,
          //   'stars': 1,
          //   'username': 'blarty287',
          //   'user_pfp': ''
          // });
          // await _userDoc.collection('games_for_user').add({
          //   'game_title': 'Minecraft',
          //   'ups': 453,
          //   'downs': 78,
          //   'stars': 4,
          //   'username': 'blarty287',
          //   'user_pfp': ''
          // });
          // await _userDoc.collection('games_for_user').add({
          //   'game_title': 'Apex Legends',
          //   'ups': 309,
          //   'downs': 65,
          //   'stars': 1,
          //   'username': 'blarty287',
          //   'user_pfp': ''
          // });
          // addnewgame
          // var _col = Color(0xFFB3B3B3);
          // String _name = 'Roblox';
          // String _displayName = 'Roblox';
          // String _n = _name.replaceAll(' ', '');
          // String _id = _n.toLowerCase() +
          //     DateTime.now().millisecondsSinceEpoch.toString();

          // Map<String, dynamic> _game = {
          //   'game_title': _name,
          //   'quick_title': _displayName,
          //   'logo_url':
          //       'https://upload.wikimedia.org/wikipedia/commons/7/7e/Roblox_Logo_2022.jpg?20220830054427',
          //   'game_id': _id,
          //   'game_primary_color': '0xFFB3B3B3'
          // };
          // var _fs = FirebaseFirestore.instance.collection('games_metadata');
          // await _fs.add(_game);
          // ScaffoldMessenger.of(context).showSnackBar(
          //     MiscWidgets.baseSnackbar(message: 'game added', success: true));

          // showModalBottomSheet(
          //     backgroundColor: Colors.transparent,
          //     context: context,
          //     builder: (context) {
          //       return Container(
          //         height: _h * .25,
          //         width: _W,
          //         decoration: const BoxDecoration(
          //             borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(12),
          //                 topRight: Radius.circular(12)),
          //             color: Color.fromARGB(255, 19, 25, 43)),
          //         child: GestureDetector(
          //           onTap: () async {
          //             await AuthService().logOut(context);
          //           },
          //           child: Center(
          //             child: Container(
          //               width: 100,
          //               height: 55,
          //               decoration: BoxDecoration(
          //                   color: Colors.red[700],
          //                   borderRadius: BorderRadius.circular(8)),
          //               child: Center(
          //                 child: Text(
          //                   'logout',
          //                   style: AppStyles.giga18Text,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     });
        },
      ),
    );
  }
}
