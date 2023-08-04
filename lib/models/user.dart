import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? pfp;
  String? userId;
  int? lastActive;
  bool? profileBoosted;
  int? ups;
  int? downs;
  int? stars;
  int? bits;
  int? followers;
  String? skin;

  UserModel({
    this.userId,
    this.username,
    this.pfp,
    this.bits,
    this.skin,
    this.downs,
    this.ups,
    this.stars,
    this.lastActive,
    this.followers,
    this.profileBoosted,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String userId = json['id'] ?? '';
    String pfp = json['user_pfp'] ?? '';
    String username = json['username'] ?? '';
    int bits = json['bits'] ?? 0;
    String skin = json['skin'] ?? '';
    int lastActive =
        json['last_active'] ?? DateTime.now().millisecondsSinceEpoch;
    bool profileBoosted = json['profile_boost'] ?? false;
    int followers = json['followers'] ?? 0;
    int stars = json['stars'] ?? 0;
    int ups = json['ups'] ?? 0;
    int downs = json['downs'] ?? 0;

    return UserModel(
        bits: bits,
        ups: ups,
        userId: userId,
        username: username,
        pfp: pfp,
        profileBoosted: profileBoosted,
        downs: downs,
        followers: followers,
        lastActive: lastActive,
        skin: skin,
        stars: stars);

    // isArtificial = json['is_artificial'];
  }
}
