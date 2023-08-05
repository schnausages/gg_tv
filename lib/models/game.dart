import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  final String gameTitle;
  final String logoUrl;
  final int ups;
  final int downs;
  final int stars;

  GameModel(
      {required this.gameTitle,
      required this.logoUrl,
      required this.downs,
      required this.stars,
      required this.ups});

  factory GameModel.fromJson(Map<String, dynamic> json) {
    String gameTitle = json['game_title'] ?? 'Game';
    String logoUrl = json['logo_url'];
    int ups = json['ups'];
    int downs = json['downs'];
    int stars = json['stars'];

    return GameModel(
      gameTitle: gameTitle,
      logoUrl: logoUrl,
      stars: stars,
      downs: downs,
      ups: ups,
    );
    // isArtificial = json['is_artificial'];
  }
// add toJson so when user clicka  game on content creation upload itll add to post?
}

// var c = Color(0xFF0BD7FA);
