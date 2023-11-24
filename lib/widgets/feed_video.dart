import 'package:animated_react_button/animated_react_button.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/models/post.dart';
import 'package:gg_tv/styles.dart';
import 'package:gg_tv/widgets/base_snackbar.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FeedVideoItem extends StatefulWidget {
  final PostModel post;
  final Function starPress;
  final Function upPress;
  final Function downPress;
  final bool upVoted;
  final bool downVoted;
  final bool starVoted;
  final bool canVoteStar;

  const FeedVideoItem(
      {super.key,
      required this.post,
      required this.starPress,
      required this.upPress,
      required this.downPress,
      required this.upVoted,
      required this.canVoteStar,
      required this.downVoted,
      required this.starVoted});

  @override
  State<FeedVideoItem> createState() => _FeedVideoItemState();
}

class _FeedVideoItemState extends State<FeedVideoItem> {
  late VideoPlayerController _controller;

  Future<bool> _incrementView() async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.post.url))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.setLooping(true);
    // _controller.play();
    // _incrementView();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(_controller),
      onVisibilityChanged: (vis) {
        if (vis.visibleFraction < 0.1 &&
            mounted &&
            _controller.value.isInitialized) {
          _controller.pause();
          _controller.seekTo(const Duration(seconds: 0));
        }
        if (vis.visibleFraction > 0.8 &&
            mounted &&
            _controller.value.isInitialized) {
          _controller.play();
        }
      },
      child: Stack(
        children: [
          if (_controller.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller)),
              ),
            ),
          if (!_controller.value.isInitialized)
            Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: Image.asset('assets/images/gg_loading.gif'),
              ),
            ),
          // https://cdn.bleacherreport.net/images/team_logos/328x328/valorant.png
          Positioned(
              bottom: 80,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.username,
                    style: const TextStyle(
                        fontFamily: 'Giga',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'on ${widget.post.gameTitle}',
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
                  _VideoActionItems(
                    post: widget.post,
                    starPress: widget.starPress,
                    canVoteStar: widget.canVoteStar,
                    upPress: widget.upPress,
                    downPress: widget.downPress,
                    downVoted: widget.downVoted,
                    starVoted: widget.starVoted,
                    upVoted: widget.upVoted,
                  ),
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
      ),
    );
  }
}

class _VideoActionItems extends StatefulWidget {
  final PostModel post;
  final Function starPress;
  final Function upPress;
  final Function downPress;
  final bool upVoted;
  final bool canVoteStar;
  final bool downVoted;
  final bool starVoted;

  const _VideoActionItems(
      {super.key,
      required this.post,
      required this.canVoteStar,
      required this.starPress,
      required this.upPress,
      required this.downPress,
      required this.upVoted,
      required this.downVoted,
      required this.starVoted});

  @override
  State<_VideoActionItems> createState() => __VideoActionItemsState();
}

class __VideoActionItemsState extends State<_VideoActionItems>
    with AutomaticKeepAliveClientMixin {
  final SizedBox _box = const SizedBox(height: 4);
  bool voted = false; // add user voted if user is in up or down
  bool isStarred = false;

  @override
  void initState() {
    voted = widget.upVoted || widget.downVoted;
    isStarred = widget.starVoted;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedReactButton(
            defaultColor: Colors.blueGrey,
            reactColor: const Color.fromRGBO(255, 202, 44, 1),
            iconSize: 42,
            defaultIcon: Icons.star_rounded,
            showSplash: true,
            colors: [
              Colors.yellow,
              Color.fromARGB(255, 253, 237, 18),
              Colors.white
            ],
            canVote: widget.canVoteStar,
            onPressed: () {
              if (!widget.starVoted || widget.canVoteStar) {
                widget.starPress();
                isStarred = true;
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    MiscWidgets.baseSnackbar(
                        message: 'No daily stars left', success: false));
              }
            }),
        Text('123',
            style: AppStyles.giga18Text.copyWith(fontWeight: FontWeight.w500)),
        _box,
        AnimatedReactButton(
            defaultColor: Colors.blueGrey,
            reactColor: const Color.fromARGB(255, 91, 255, 42),
            iconSize: 54,
            defaultIcon: Icons.keyboard_arrow_up_rounded,
            showSplash: true,
            // canVote: true,
            onPressed: () {
              widget.upPress();
              if (!widget.upVoted)
                setState(() {
                  voted = true;
                });
            }),
        Text('3434',
            style: AppStyles.giga18Text.copyWith(fontWeight: FontWeight.w500)),
        _box,
        AnimatedReactButton(
            defaultColor: Colors.blueGrey,
            reactColor: const Color.fromARGB(255, 255, 65, 61),
            iconSize: 54,
            defaultIcon: Icons.keyboard_arrow_down_rounded,
            showSplash: true,
            // canVote: true,
            colors: [Colors.red, Color.fromARGB(255, 135, 0, 0), Colors.black],
            onPressed: () {
              widget.downPress();
              if (!widget.downVoted)
                setState(() {
                  voted = true;
                });
            }),
        Text('69',
            style: AppStyles.giga18Text.copyWith(fontWeight: FontWeight.w500)),
        SizedBox(height: 50),
        _box,
        const Icon(Icons.play_arrow_rounded,
            shadows: [
              BoxShadow(blurRadius: 4, spreadRadius: 0, color: Colors.black38)
            ],
            color: Colors.white,
            size: 30),
        Text(
          '343',
          style: AppStyles.giga18Text.copyWith(fontSize: 16),
        ),
        _box,
        const Icon(
          Icons.chat_bubble_outline_rounded,
          color: Colors.white,
          shadows: [
            BoxShadow(blurRadius: 4, spreadRadius: 0, color: Colors.black38)
          ],
          size: 30,
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
