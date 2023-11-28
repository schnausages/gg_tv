import 'package:flutter/material.dart';

class GameModel {
  final String gameTitle;
  final String? logoUrl;
  final String fallbackLetter;
  final Color primaryColorHex;
  final String gameId;

  GameModel(
      {required this.gameTitle,
      required this.logoUrl,
      required this.gameId,
      required this.fallbackLetter,
      required this.primaryColorHex});

  factory GameModel.fromJson(Map<String, dynamic> json) {
    Color _c = Color(int.parse(json['game_primary_color'] ?? '0xFFFF2D61'));
    String gameTitle = json['game_title'];
    String logoUrl = json['logo_url'] ?? '';
    String gameId = json['game_id'];
    String fallbackLetter = json['game_title'].toString()[0];
    Color primaryColorHex = _c;

    return GameModel(
        gameTitle: gameTitle,
        logoUrl: logoUrl,
        gameId: gameId,
        fallbackLetter: fallbackLetter,
        primaryColorHex: primaryColorHex);
    // isArtificial = json['is_artificial'];
  }
// add toJson so when user clicka  game on content creation upload itll add to post?
}

// var c = Color(0xFF0BD7FA);
