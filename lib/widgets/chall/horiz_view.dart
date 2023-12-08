import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HorizChallView extends StatelessWidget {
  final Size s;
  final VideoPlayerController controller1;
  final VideoPlayerController controller2;

  const HorizChallView(
      {super.key,
      required this.controller1,
      required this.controller2,
      required this.s});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
              width: s.width * .5,
              height: s.height * .5,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(controller1),
                      SizedBox(
                        width: s.width,
                        height: 15,
                        child: VideoProgressIndicator(controller1,
                            allowScrubbing: false,
                            colors: const VideoProgressColors(
                                backgroundColor: Colors.white12,
                                playedColor: Color(0xFFFF5B50))),
                      )
                    ],
                  ))),
        ),
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
              width: s.width * .5,
              height: s.height * .5,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(controller2),
                      SizedBox(
                        width: s.width,
                        height: 15,
                        child: VideoProgressIndicator(controller2,
                            allowScrubbing: false,
                            colors: const VideoProgressColors(
                                backgroundColor: Colors.white12,
                                playedColor: Color(0xFFFF5B50))),
                      )
                    ],
                  ))),
        ),
      ],
    );
  }
}
