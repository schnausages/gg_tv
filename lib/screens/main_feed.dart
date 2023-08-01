import 'package:animated_react_button/animated_react_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({super.key});

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  late VideoPlayerController _controller;
  final SizedBox _box = const SizedBox(height: 10);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.play();
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
                      const Positioned(
                          bottom: 80,
                          child: Text(
                            'aceTAY_2 on Valorant',
                            style: TextStyle(
                                fontFamily: 'Giga',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                      Positioned(
                          right: 10,
                          top: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedReactButton(
                                  defaultColor: Colors.blueGrey,
                                  reactColor: Color.fromRGBO(255, 202, 44, 1),
                                  iconSize: 42,
                                  defaultIcon: Icons.star_rounded,
                                  showSplash: true,
                                  onPressed: () {
                                    //like
                                  }),
                              _box,
                              AnimatedReactButton(
                                  defaultColor: Colors.blueGrey,
                                  reactColor: Color.fromARGB(255, 91, 255, 42),
                                  iconSize: 54,
                                  defaultIcon: Icons.keyboard_arrow_up_rounded,
                                  showSplash: true,
                                  onPressed: () {
                                    //like
                                  }),
                              _box,
                              AnimatedReactButton(
                                  defaultColor: Colors.blueGrey,
                                  reactColor: Color.fromARGB(255, 255, 65, 61),
                                  iconSize: 54,
                                  defaultIcon:
                                      Icons.keyboard_arrow_down_rounded,
                                  showSplash: true,
                                  onPressed: () {
                                    //like
                                  }),
                              _box,
                              Icon(Icons.chat_bubble_outline_rounded,
                                  color: Colors.white)
                            ],
                          ))
                    ],
                  );
                })
            : const CircularProgressIndicator(
                color: Colors.pink,
              ));
  }
}
