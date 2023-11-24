import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //bool isAuth = false;
  String? _token;
  Map<String, dynamic>? userInformation;

  bool get isAuth {
    return _token != null;
  }

  String? get token {
    //if expire date isnt null and its after now...return a token
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    FirebaseFirestore _fs = FirebaseFirestore.instance;
    print('RUNNING SIGN IN EMAIL');
    final res = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user!;

    if (res.user != null) {
      _token = user.uid;
      Map<String, dynamic> _userMap = {};
      QueryDocumentSnapshot<Map<String, dynamic>> _userDoc = await _fs
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .limit(1)
          .get()
          .then((value) => value.docs.first);
      _userMap = _userDoc.data();
      _userMap.remove('last_active');
      _userMap.remove('date_added');
      final prefs = await SharedPreferences.getInstance();
      String _profile = json.encode(_userMap);
      prefs.setString('cachedProfile', _profile);
      // if (!prefs.containsKey('userPrefs')) {
      //   Map<String, dynamic> _userPrefs = {};
      //   String _prefSettings = json.encode(_userPrefs);
      //   prefs.setString('userPrefs', _prefSettings);
      // }

      notifyListeners();

      print('LOG IN OK');
      _userDoc.reference.update({'last_active': DateTime.now()});
    }

    // var _isBanned = await isBanned(userId: _data['id']);

    // if (_isBanned == true) {
    //   return;
    // }

    //return user;
  }

  Future createUserInFS(String userID, String email, String username) async {
    //check if exists
    Map<String, dynamic> _newUser = {
      'date_added': DateTime.now(),
      'last_active': DateTime.now(),
      'email': email,
      'ups': 0,
      'downs': 0,
      'bits': 0,
      'stars': 0,
      'profile_boost': false,
      'followers': 0,
      'username': 'qcjl93c3',
      'user_pfp': '',
      'id': userID
    };
    var _userDoc =
        await FirebaseFirestore.instance.collection('users').add(_newUser);
    await _userDoc.collection('games_for_user').add({'game_title': null});
    int _millisecDate = DateTime.now()
        .subtract(const Duration(days: 10))
        .millisecondsSinceEpoch;
    _newUser.remove('date_added');
    _newUser.addAll({'star_used': false});
    _newUser.addAll({'last_star': _millisecDate});

    final prefs = await SharedPreferences.getInstance();
    String prefsMap = json.encode(_newUser);
    prefs.setString('cachedProfile', prefsMap);
    print('::: CREATED UZER');
  }

  Future<Object> signUpWithEmail(
      {required String email,
      required String password,
      required String username}) async {
    print('RUNNING SIGN UP WORL $email and $password =====!!!');
    try {
      UserCredential res = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User user = res.user!;

      _token = user.uid;
      await createUserInFS(user.uid, email, username);
      notifyListeners();

      return user;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  Future<void> tryAutoLogin() async {
    print('TRYING AUTO LOGIN');

    final _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey('cachedProfile')) {
      print('::: NO CACHED PROFILE FOUND !!!!!!');
      return;
    }
    final extractedData =
        json.decode(_prefs.getString('cachedProfile')!) as Map<String, dynamic>;
    // var _isBanned = await isBanned(userId: extractedData['id']);

    // if (_isBanned == true) {
    //   return;
    // }
    int _millsecLastStar = extractedData['last_star'] ?? 000000000000;
    DateTime _lastStarTimestamp =
        DateTime.fromMillisecondsSinceEpoch(_millsecLastStar);
    print(
        "${_lastStarTimestamp.difference(DateTime.now()).inSeconds > 10} PURT hur date check with LAST_STAR OF ${_lastStarTimestamp}");
    if (DateTime.now().difference(_lastStarTimestamp).inSeconds > 10) {
      print("PURT SETTING FALSE");
      extractedData['star_used'] = false;
    }

    // var _lastStarDate = DateT

    String _profileData = json.encode(extractedData);
    _prefs.setString('cachedProfile', _profileData);

    _token = extractedData['id'];

    if (_token == null) {
      return;
    }

    try {
      print('::: C>>>>> TRYING TO ADD LAST ACTIVE INFO to!!!!!!');
      FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: extractedData['id'])
          .get()
          .then((snapshot) async {
        var userDoc = snapshot.docs.first;
        Timestamp lastActiveTimestamp =
            userDoc.data()['last_active'] ?? Timestamp.fromDate(DateTime.now());
        DateTime lastActiveDate = lastActiveTimestamp.toDate();
        print(lastActiveDate.difference(DateTime.now()).inDays);
        if (lastActiveDate.difference(DateTime.now()).inDays < 0) {
          await userDoc.reference.update({'last_active': DateTime.now()});
        }
      });
    } catch (e) {}
    // if (!_dcPrefs.containsKey('userPrefs')) {
    //   Map<String, dynamic> _userPrefs = {
    //     'content_filter': true,
    //     'theme': 'frontpage'
    //   };

    //   String _prefSettings = json.encode(_userPrefs);
    //   _dcPrefs.setString('userPrefs', _prefSettings);
    // }

    notifyListeners();
    return;
  }

  Future<void> logOut(BuildContext context) async {
    _token = null;
    print('LOGGING OUT');
    final prefs = await SharedPreferences.getInstance();

    firebaseAuth.signOut();

    await prefs.clear();
    notifyListeners();
  }
}
