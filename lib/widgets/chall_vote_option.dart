import 'dart:async';

import 'package:animated_react_button/animated_react_button.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/styles.dart';
import 'package:gg_tv/widgets/base_snackbar.dart';
import 'package:gg_tv/widgets/chall_simu_play.dart';
import 'package:video_player/video_player.dart';

class ChallVoteItem extends StatefulWidget {
  bool duoPlayActive;
  final Function duoPlayUpdate;
  final Size size;
  ChallVoteItem(
      {super.key,
      required this.size,
      required this.duoPlayActive,
      required this.duoPlayUpdate});

  @override
  State<ChallVoteItem> createState() => _ChallVoteItemState();
}

class _ChallVoteItemState extends State<ChallVoteItem> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  Timer? timer;
  void startTimer(int videoLengthSeconds) {
    const Duration duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (Timer timer) {
      if (!mounted) return;
      if (timer.tick >= videoLengthSeconds + 1) {
        print("PURT HUR $videoLengthSeconds");
        timer.cancel();
        _controller1.pause();
        _controller1.seekTo(Duration.zero);
        _controller2.play();
        setState(() {});
      } else {
        // setState(() {});
      }
    });
  }

  Future<bool> _simuPlayOn() async {
    if (!widget.duoPlayActive) {
      widget.duoPlayUpdate();
      await _controller1.seekTo(Duration.zero);
      await _controller2.seekTo(Duration.zero);
      await _controller1.play();
      await _controller2.play();
      return true;
    } else {
      _controller2.pause();
      _controller1.pause();
      await _controller1.seekTo(Duration.zero);
      await _controller2.seekTo(Duration.zero);
      _controller1.play();
      startTimer(_controller1.value.duration.inSeconds);
      widget.duoPlayUpdate();
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    _controller1 = VideoPlayerController.networkUrl(Uri.parse(
        'https://assets.mixkit.co/videos/preview/mixkit-covering-a-strawberry-with-liquid-chocolate-on-a-lilac-background-41125-large.mp4'))
      ..initialize().then((value) {
        startTimer(_controller1.value.duration.inSeconds);
        // setState(() {});
      });
    _controller2 = VideoPlayerController.networkUrl(Uri.parse(
        'https://assets.mixkit.co/videos/preview/mixkit-covering-a-strawberry-with-liquid-chocolate-on-a-lilac-background-41125-large.mp4'))
      ..initialize().then((value) {
        setState(() {});
      });

    _controller1.play();

    // _incrementView();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _w = widget.size.width * .475;
    final _h = widget.size.height * .45;
    if (!_controller1.value.isInitialized &&
        !_controller2.value.isInitialized) {
      return Container(
        decoration: const BoxDecoration(color: Color(0xFF0F0F0F)),
        width: _w * 2,
        height: _h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Loading gameplay.,,', style: AppStyles.giga18Text),
            SizedBox(height: 20),
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset('assets/images/gg_loading.gif'),
            ),
          ],
        ),
      );
    }

    if (_controller1.value.isInitialized && _controller2.value.isInitialized) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                    width: _w,
                    height: _h,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_controller1),
                            SizedBox(
                              width: _w,
                              height: 10,
                              child: VideoProgressIndicator(_controller1,
                                  allowScrubbing: false,
                                  colors: VideoProgressColors(
                                      backgroundColor: Colors.white12,
                                      playedColor: Colors.red)),
                            )
                          ],
                        ))),
              ),
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                    width: _w,
                    height: _h,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_controller2),
                            SizedBox(
                              width: _w,
                              height: 10,
                              child: VideoProgressIndicator(_controller2,
                                  allowScrubbing: false,
                                  colors: VideoProgressColors(
                                      backgroundColor: Colors.white12,
                                      playedColor: Colors.red)),
                            )
                          ],
                        ))),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _VoteButton(
                  s: widget.size,
                ),
                _VoteButton(
                  s: widget.size,
                )
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, bottom: 85.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SimuPlayButton(
                    s: widget.size,
                    duoPlayActive: widget.duoPlayActive,
                    onPress: () async {
                      timer!.cancel();
                      bool _simuPlay = await _simuPlayOn();
                      if (_simuPlay) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            MiscWidgets.baseSnackbar(
                                message: 'Duo play on', success: true));
                      }
                    }),
                const SizedBox(width: 8),
                const CommentBoxWidget()
              ],
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }
}

class _VoteButton extends StatefulWidget {
  final Size s;
  const _VoteButton({super.key, required this.s});

  @override
  State<_VoteButton> createState() => __VoteButtonState();
}

class __VoteButtonState extends State<_VoteButton> {
  final Color _reactColor = Color(0xFF8F0EF3);
  bool _voted = false;
  _vote() {
    setState(() {
      _voted = !_voted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.s.width * .45,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: _voted ? _reactColor : Colors.blueGrey),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedReactButton(
              defaultColor: const Color.fromARGB(255, 84, 106, 118),
              reactColor: _reactColor,
              iconSize: 40,
              defaultIcon: Icons.add_box_rounded,
              showSplash: true,

              canVote: true, //check if user can vote
              onPressed: () {
                if (!_voted) {
                  _vote();
                }
              },
            ),
            if (_voted)
              Text(753.toString(),
                  style: AppStyles.giga18Text
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 22)),
          ],
        ));
  }
}
