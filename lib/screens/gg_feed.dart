import 'package:flutter/material.dart';
import 'package:gg_tv/models/post.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView.builder(
            itemCount: 12,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) {
              return FeedVideoItem(
                post: PostModel(
                    username: 'skittle_blob31',
                    pfp: 'pfp',
                    userId: 'userId',
                    dateAdded: DateTime.now(),
                    ups: ['j8e2', 'w1wwd'],
                    downs: ['ce2ec'],
                    stars: [],
                    url:
                        'https://assets.mixkit.co/videos/preview/mixkit-covering-a-strawberry-with-liquid-chocolate-on-a-lilac-background-41125-large.mp4',
                    views: 423,
                    gameIconUrl: 'gameIconUrl',
                    gameTitle: 'Modern Warfare 3'),
                downVoted: false,
                starVoted: false,
                upVoted: false,
                starPress: () async {
                  bool _starAvailable = await UserActionServices.useDailyStar();
                  if (_starAvailable) {
                    print('PURT star still available');
                    _player.setAsset('assets/sounds/star.mp3');
                    _player.play();
                  } else {
                    print('PURT star now no longer available');

                    _player.setAsset('assets/sounds/thud.mp3');
                    _player.play();
                    ScaffoldMessenger.of(context).showSnackBar(
                        MiscWidgets.baseSnackbar(
                            message: 'No daily stars left', success: false));
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
            }));
  }
}
