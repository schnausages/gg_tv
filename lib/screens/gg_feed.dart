import 'package:flutter/material.dart';
import 'package:gg_tv/models/game.dart';
import 'package:gg_tv/models/post.dart';
import 'package:gg_tv/models/user.dart';
import 'package:gg_tv/services/misc_services.dart';
import 'package:gg_tv/widgets/base_snackbar.dart';
import 'package:gg_tv/widgets/feed_video.dart';
import 'package:just_audio/just_audio.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({super.key});

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  final _player = AudioPlayer();
  bool _dailyStarUsed = false;
  late Future starLoad;

  Future<void> getDailyStar() async {
    print("PURT DAILY USED gmmm");
    try {
      bool _b = await UserActionServices.returnStoredKeyValue(key: 'star_used')
          as bool;

      _dailyStarUsed = _b;
      print('PURT sucksess $_b');
    } catch (e) {
      print("PURT $e");
    }
  }

  @override
  void initState() {
    starLoad = getDailyStar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
            future: starLoad,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return PageView.builder(
                    itemCount: 12,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) {
                      return FeedVideoItem(
                        post: PostModel(
                            user: UserModel(
                                userId: '',
                                username: 'skittle_blob31',
                                pfp: ''),
                            dateAdded: DateTime.now(),
                            ups: ['j8e2', 'w1wwd'],
                            downs: ['ce2ec', 'f434f3v3', 'f4343f443'],
                            stars: ['wd23d23'],
                            commentCount: 12,
                            description:
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n\nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages.\n\nMore recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                            url:
                                'https://assets.mixkit.co/videos/preview/mixkit-covering-a-strawberry-with-liquid-chocolate-on-a-lilac-background-41125-large.mp4',
                            views: 423,
                            game: GameModel(
                                gameTitle: 'Modern Warfare 3',
                                fallbackLetter: 'C',
                                gameId: '',
                                logoUrl:
                                    'https://cdn2.steamgriddb.com/file/sgdb-cdn/icon/d8732349cbe3ba46021a86345bb98c4c/32/256x256.png',
                                primaryColorHex: Color(0xFFFF2D61))),
                        downVoted: false,
                        starVoted: false,
                        upVoted: false,
                        canVoteStar: !_dailyStarUsed,
                        starPress: () async {
                          if (!_dailyStarUsed) {
                            _dailyStarUsed = true;
                            print('PURT star still available');
                            await UserActionServices.updateStorageKey(
                                key: 'daily_star', newValue: true);

                            _player.setAsset('assets/sounds/star.mp3');
                            _player.play();
                          } else {
                            print('PURT star now no longer available');

                            _player.setAsset('assets/sounds/thud.mp3');
                            _player.play();
                            ScaffoldMessenger.of(context).showSnackBar(
                                MiscWidgets.baseSnackbar(
                                    message: 'No daily stars left',
                                    success: false));
                          }
                        },
                        upPress: () {
                          _player.setAsset('assets/sounds/up.mp3');

                          _player.play();
                        },
                        downPress: () {
                          _player.setAsset('assets/sounds/thud.mp3');
                          _player.play();
                        },
                      );
                    });
              } else {
                return SizedBox();
              }
            }));
  }
}
