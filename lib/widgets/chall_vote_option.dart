import 'dart:async';

import 'package:animated_react_button/animated_react_button.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/services/misc_services.dart';
import 'package:gg_tv/styles.dart';
import 'package:gg_tv/widgets/base_snackbar.dart';
import 'package:gg_tv/widgets/chall/horiz_view.dart';
import 'package:gg_tv/widgets/chall/stack_view.dart';
import 'package:gg_tv/widgets/chall_simu_play.dart';
import 'package:video_player/video_player.dart';

class ChallVoteItem extends StatefulWidget {
  bool duoPlayActive;
  bool stackView;
  final Function stackViewUpdate;
  final Function duoPlayUpdate;
  final Size size;
  ChallVoteItem(
      {super.key,
      required this.stackViewUpdate,
      required this.stackView,
      required this.size,
      required this.duoPlayActive,
      required this.duoPlayUpdate});

  @override
  State<ChallVoteItem> createState() => _ChallVoteItemState();
}

class _ChallVoteItemState extends State<ChallVoteItem> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  bool stackView = false;
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
    bool _b = await UserActionServices.returnStoredKeyValue(key: 'duo_play');
    print('PURT $_b');
    if (!_b) {
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
        if (widget.duoPlayActive == false) {
          _controller1.play();
          startTimer(_controller1.value.duration.inSeconds);
        }

        // startTimer(_controller1.value.duration.inSeconds);
        // setState(() {});
      });
    _controller2 = VideoPlayerController.networkUrl(Uri.parse(
        'https://assets.mixkit.co/videos/preview/mixkit-covering-a-strawberry-with-liquid-chocolate-on-a-lilac-background-41125-large.mp4'))
      ..initialize().then((value) {
        setState(() {});
      });
    if (widget.duoPlayActive) {
      _controller1.play();
      _controller2.play();
    }

    // _incrementView();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();

    super.dispose();
  }

//sq
// Container(
//   width: 200, //Crop width
//   height: 200, //Crop height
//   child: FittedBox(
//     // alignment: Alignment.center, //Move around the crop
//     fit: BoxFit.cover,
//     clipBehavior: Clip.hardEdge,
//     child: SizedBox(
//       width: videoController.value.size.width,
//       height: videoController.value.size.height,
//       child: AspectRatio(
//         aspectRatio: videoController.value.aspectRatio,
//         child: VideoPlayer(
//           videoController,
//         ),
//       ),
//     ),
//   ),
// );
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
            const Text('Loading gameplay.,,', style: AppStyles.giga18Text),
            const SizedBox(height: 20),
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
        mainAxisAlignment: widget.stackView
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          if (!widget.stackView) Spacer(),
          if (!widget.stackView)
            HorizChallView(
                controller1: _controller1,
                controller2: _controller2,
                s: widget.size),
          if (widget.stackView)
            StackChallView(
                controller1: _controller1,
                controller2: _controller2,
                s: widget.size),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _VoteButton(
                  s: widget.size,
                  isStackView: widget.stackView,
                  isTop: true,
                ),
                _VoteButton(
                  s: widget.size,
                  isStackView: widget.stackView,
                  isTop: false,
                )
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 80.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.stackViewUpdate();
                  },
                  child: Container(
                    height: 50,
                    width: 45,
                    color: Colors.white10,
                    child: Icon(
                        !widget.stackView
                            ? Icons.horizontal_split_rounded
                            : Icons.horizontal_distribute_rounded,
                        size: 28,
                        color: Colors.white),
                  ),
                ),
                Spacer(),
                SimuPlayButton(
                    s: widget.size,
                    duoPlayActive: widget.duoPlayActive,
                    onPress: () async {
                      if (timer != null) {
                        timer!.cancel();
                      }

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
    return const SizedBox();
  }
}

class _VoteButton extends StatefulWidget {
  final Size s;
  final bool isStackView;
  final bool isTop;
  const _VoteButton(
      {super.key,
      required this.s,
      required this.isStackView,
      required this.isTop});

  @override
  State<_VoteButton> createState() => __VoteButtonState();
}

class __VoteButtonState extends State<_VoteButton> {
  final Color _reactColor = const Color(0xFF8F0EF3);
  final Color _deffault = Color(0xFF607D8B);
  bool _voted = false;
  _vote() {
    setState(() {
      _voted = !_voted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isStackView) {
      return Container(
          width: widget.s.width * .45,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: _voted ? _reactColor : _deffault),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedReactButton(
                defaultColor: const Color.fromARGB(255, 45, 57, 63),
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
    if (widget.isStackView) {
      return Container(
          width: widget.s.width * .45,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: _voted ? _reactColor : _deffault),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedReactButton(
                defaultColor: _deffault,
                reactColor: _deffault,
                iconSize: 40,
                defaultIcon: Icons.circle_outlined,
                showSplash: true,
                canVote: true,
                onPressed: () {
                  if (!_voted) {
                    _vote();
                  }
                },
              ),
              if (!_voted)
                Text(widget.isTop ? 'TOP' : 'BOTTOM',
                    style: AppStyles.giga18Text
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
              if (_voted)
                Text(753.toString(),
                    style: AppStyles.giga18Text
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 22)),
            ],
          ));
    }
    return SizedBox();
  }
}
