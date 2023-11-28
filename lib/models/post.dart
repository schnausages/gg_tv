import 'package:gg_tv/models/game.dart';
import 'package:gg_tv/models/user.dart';

class PostModel {
  final DateTime dateAdded;
  final List<String> ups;
  final List<String> downs;
  final List<String> stars;
  final String url;
  final int views;
  final int commentCount;
  final String description;
  final GameModel game;
  final UserModel user;

  PostModel({
    required this.user,
    required this.commentCount,
    required this.dateAdded,
    required this.ups,
    required this.downs,
    required this.stars,
    required this.url,
    required this.views,
    required this.description,
    required this.game,
  });

  // factory PostModel.fromJson(Map<String, dynamic> json) {
  //   // gameModel form json here json['game_info'}]
  //   final String username = json['username'];
  //   final String pfp = json['pfp'];
  //   final String userId = json['user_id'];
  //   final List<String> ups = json['ups'];
  //   final List<String> downs = json['downs'];
  //   final List<String> stars = json['stars'];
  //   final String gameTitle = json['game_title'];
  //   final GameModel game = json['game_details'];

  //   return PostModel(

  //   );
  // }
}
