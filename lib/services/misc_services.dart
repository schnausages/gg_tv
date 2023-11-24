import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiscServices {
  static ImageProvider generateUserPfp(String pfpUrl) {
    if (pfpUrl.isEmpty) {
      return AssetImage('assets/images/def_pfp.png');
    } else {
      return NetworkImage(pfpUrl);
    }
  }
}

class UserActionServices {
  static Future updateStorageKey(
      {required String key, required dynamic newValue}) async {
    final _prefs = await SharedPreferences.getInstance();
    final _stored =
        json.decode(_prefs.getString('cachedProfile')!) as Map<String, dynamic>;
    _stored[key] = newValue;
    String _m = json.encode(_stored);
    _prefs.setString('cachedProfile', _m);
  }

  static Future<dynamic> returnStoredKeyValue({required String key}) async {
    final _prefs = await SharedPreferences.getInstance();
    final _stored =
        json.decode(_prefs.getString('cachedProfile')!) as Map<String, dynamic>;
    return _stored[key];
  }

  static Future<bool> useDailyStar() async {
    final _prefs = await SharedPreferences.getInstance();
    final _stored =
        json.decode(_prefs.getString('cachedProfile')!) as Map<String, dynamic>;
    if (_stored['star_used'] == true) {
      return false;
    } else {
      try {
        _stored['star_used'] = true;
        _stored['last_star'] = DateTime.now().millisecondsSinceEpoch;
        String _m = json.encode(_stored);
        _prefs.setString('cachedProfile', _m);
        print("PURT star used sete");

        return true;
      } catch (e) {
        print("PURT ERROR $e");
        return false;
      }
    }
  }

  static Future voteForPost(
      {required String postDocId,
      required String voteCategory,
      required String currentUserId}) async {
    //add engagement? statistic.. increment vote, replies, stars and add all for 1 score?
    await FirebaseFirestore.instance
        .collection('user_posts')
        .doc(postDocId)
        .update({voteCategory: currentUserId});
  }
}
