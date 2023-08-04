import 'dart:ui';

import 'package:flutter/material.dart';

class PostModel {
  final String username;
  final String pfp;
  final String userId;
  final DateTime dateAdded;
  final int ups;
  final int downs;
  final int stars;
  final String url;
  final String gameTitle;
  final String gameIconUrl;
  final int views;
  Color? hexGameIconColor;

  PostModel(
      {required this.username,
      required this.pfp,
      required this.userId,
      required this.dateAdded,
      required this.ups,
      required this.downs,
      required this.stars,
      required this.url,
      required this.views,
      required this.gameIconUrl,
      required this.gameTitle,
      this.hexGameIconColor = const Color(0xFFFF2D61)});
}
  // var _c = Color(0xFFFF2D61);