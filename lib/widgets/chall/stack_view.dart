import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StackChallView extends StatelessWidget {
  final Size s;
  final VideoPlayerController controller1;
  final VideoPlayerController controller2;
  const StackChallView(
      {super.key,
      required this.s,
      required this.controller1,
      required this.controller2});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: s.height * .35,
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: controller1.value.size.width,
              height: controller1.value.size.height,
              child: AspectRatio(
                aspectRatio: controller1.value.aspectRatio,
                child: VideoPlayer(
                  controller1,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: s.height * .35,
          child: FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: controller2.value.size.width,
              height: controller2.value.size.height,
              child: AspectRatio(
                aspectRatio: controller2.value.aspectRatio,
                child: VideoPlayer(
                  controller2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
