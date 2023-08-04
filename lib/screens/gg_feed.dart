import 'package:animated_react_button/animated_react_button.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/styles.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({super.key});

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  late VideoPlayerController _controller;
  final SizedBox _box = const SizedBox(height: 4);
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://assets.mixkit.co/videos/preview/mixkit-covering-a-strawberry-with-liquid-chocolate-on-a-lilac-background-41125-large.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.play();
    _incrementView();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<bool> _incrementView() async {
    await Future.delayed(Duration(seconds: 1));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _controller.value.isInitialized
            ? PageView.builder(
                itemCount: 12,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                  return Stack(
                    children: [
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                              width: _controller.value.size.width,
                              height: _controller.value.size.height,
                              child: VideoPlayer(_controller)),
                        ),
                      ),
                      // https://cdn.bleacherreport.net/images/team_logos/328x328/valorant.png
                      Positioned(
                          bottom: 80,
                          left: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'aceTAY_2',
                                style: TextStyle(
                                    fontFamily: 'Giga',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    'on Valorant',
                                    style: TextStyle(
                                        fontFamily: 'Giga',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              )
                            ],
                          )),
                      Positioned(
                          right: 0,
                          top: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedReactButton(
                                  defaultColor: Colors.blueGrey,
                                  reactColor:
                                      const Color.fromRGBO(255, 202, 44, 1),
                                  iconSize: 42,
                                  defaultIcon: Icons.star_rounded,
                                  showSplash: true,
                                  onPressed: () {
                                    _player.setAsset('assets/sounds/star.mp3');
                                    _player.play();
                                    //like
                                  }),
                              _box,
                              AnimatedReactButton(
                                  defaultColor: Colors.blueGrey,
                                  reactColor:
                                      const Color.fromARGB(255, 91, 255, 42),
                                  iconSize: 54,
                                  defaultIcon: Icons.keyboard_arrow_up_rounded,
                                  showSplash: true,
                                  onPressed: () {
                                    //like
                                    _player.setAsset('assets/sounds/up.mp3');

                                    _player.play();
                                  }),
                              _box,
                              AnimatedReactButton(
                                  defaultColor: Colors.blueGrey,
                                  reactColor:
                                      const Color.fromARGB(255, 255, 65, 61),
                                  iconSize: 54,
                                  defaultIcon:
                                      Icons.keyboard_arrow_down_rounded,
                                  showSplash: true,
                                  onPressed: () {
                                    _player.setAsset('assets/sounds/thud.mp3');
                                    _player.play();
                                    //like
                                  }),
                              _box,
                              Icon(Icons.play_arrow_rounded,
                                  color: Colors.white),
                              Text(
                                '343',
                                style: AppStyles.giga18Text,
                              ),
                              _box,
                              const Icon(Icons.chat_bubble_outline_rounded,
                                  color: Colors.white),
                              _box,
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                        image: NetworkImage(
                                            'https://cdn.bleacherreport.net/images/team_logos/328x328/valorant.png'),
                                        fit: BoxFit.cover)),
                              )
                            ],
                          ))
                    ],
                  );
                })
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              ));
  }
}
