import 'package:animated_react_button/animated_react_button.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/models/post.dart';
import 'package:gg_tv/services/misc_services.dart';
import 'package:gg_tv/styles.dart';
import 'package:gg_tv/widgets/base_snackbar.dart';
import 'package:gg_tv/widgets/misc/pull_pill.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'misc/info_sheet.dart';

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
  bool _expanded = false;
  late int _engagementMetric;
  Future<bool> _incrementView() async {
    await Future.delayed(const Duration(seconds: 1));

    return true;
  }

  @override
  void initState() {
    super.initState();
    _engagementMetric = widget.post.downs.length +
        widget.post.ups.length +
        (widget.post.stars.length * 2) +
        widget.post.commentCount;
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    _MetricChips(
                      plays: 431,
                      engagementIndex: _engagementMetric,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: MiscServices.generateUserPfp(
                                      widget.post.user.pfp!),
                                  fit: BoxFit.cover)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.post.user.username,
                                  style: AppStyles.giga18Text),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(widget.post.game.gameTitle,
                                      style: AppStyles.giga18Text
                                          .copyWith(fontSize: 14)),
                                ],
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        if (widget.post.description.isNotEmpty && !_expanded)
                          GestureDetector(
                            onTap: () async {
                              _controller.pause();
                              setState(() {
                                _expanded = true;
                              });
                              await showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.black12,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  builder: (context) {
                                    return _FeedVideoExpansionDetail(
                                      description: widget.post.description,
                                      username: widget.post.user.username,
                                    );
                                  }).then((value) {
                                setState(() {
                                  _expanded = false;
                                });
                                _controller.play();
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 50,
                              decoration: BoxDecoration(color: Colors.white10),
                              child: Center(
                                child: const Icon(Icons.arrow_drop_up_rounded,
                                    size: 38, color: Colors.white),
                              ),
                            ),
                          ),

                        //comments sheet
                        if (!_expanded)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 26.0),
                            child: GestureDetector(
                              onTap: () async {
                                _controller.pause();
                                setState(() {
                                  _expanded = true;
                                });
                                await showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.black12,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    builder: (context) {
                                      return Text('comments here');
                                    }).then((value) {
                                  setState(() {
                                    _expanded = false;
                                  });
                                  _controller.play();
                                });
                              },
                              child: Container(
                                width: 45,
                                height: 50,
                                decoration:
                                    BoxDecoration(color: Colors.white10),
                                child: Center(
                                  child: const Icon(Icons.chat_bubble_rounded,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              )),
          if (!_expanded)
            Positioned(
                right: 10,
                bottom: 135,
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
                      upCount: widget.post.ups.length,
                      downCount: widget.post.downs.length,
                      starCount: widget.post.stars.length,
                    ),
                  ],
                )),
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
  final int upCount;
  final int downCount;
  final int starCount;

  const _VideoActionItems(
      {super.key,
      required this.post,
      required this.canVoteStar,
      required this.starPress,
      required this.upPress,
      required this.downPress,
      required this.upVoted,
      required this.downVoted,
      required this.starVoted,
      required this.upCount,
      required this.downCount,
      required this.starCount});

  @override
  State<_VideoActionItems> createState() => __VideoActionItemsState();
}

class __VideoActionItemsState extends State<_VideoActionItems>
    with AutomaticKeepAliveClientMixin {
  final SizedBox _box = const SizedBox(height: 12);
  bool voted = false; // add user voted if user is in up or down
  bool isStarred = false;
  late int _upCount;
  late int _downCount;
  late int _starCount;

  @override
  void initState() {
    voted = widget.upVoted || widget.downVoted;
    isStarred = widget.starVoted;
    _upCount = widget.upCount;
    _downCount = widget.downCount;
    _starCount = widget.starCount;
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
              const Color.fromARGB(255, 253, 237, 18),
              Colors.white
            ],
            canVote: widget.canVoteStar,
            onPressed: () {
              if (!widget.starVoted || widget.canVoteStar) {
                widget.starPress();

                setState(() {
                  isStarred = true;
                  _starCount++;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    MiscWidgets.baseSnackbar(
                        message: 'No daily stars left', success: false));
              }
            }),
        Text(_starCount.toString(),
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
                  _upCount++;
                });
            }),
        Text(_upCount.toString(),
            style: AppStyles.giga18Text.copyWith(fontWeight: FontWeight.w500)),
        _box,
        AnimatedReactButton(
            defaultColor: Colors.blueGrey,
            reactColor: const Color.fromARGB(255, 255, 65, 61),
            iconSize: 54,
            defaultIcon: Icons.keyboard_arrow_down_rounded,
            showSplash: true,
            // canVote: true,
            colors: [
              Colors.red,
              const Color.fromARGB(255, 135, 0, 0),
              Colors.black
            ],
            onPressed: () {
              widget.downPress();
              if (!widget.downVoted)
                setState(() {
                  voted = true;
                  _downCount++;
                });
            }),
        Text(_downCount.toString(),
            style: AppStyles.giga18Text.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 50),
        _box,
        if (widget.post.game.logoUrl!.isNotEmpty)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(widget.post.game.logoUrl!),
                    fit: BoxFit.cover)),
          ),
        if (widget.post.game.logoUrl!.isEmpty)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.post.game.primaryColorHex,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                widget.post.game.fallbackLetter,
                style: AppStyles.giga18Text,
              ),
            ),
          )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _FeedVideoExpansionDetail extends StatelessWidget {
  final String username;
  final String description;
  const _FeedVideoExpansionDetail(
      {super.key, required this.username, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: const PullPill(pillColor: Colors.white70),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .325,
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [Text(username)],
                      ),
                    ),
                    Text(
                      description,
                      style: AppStyles.giga18Text.copyWith(fontSize: 14),
                      softWrap: true,
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}

class _MetricChips extends StatelessWidget {
  final int plays;
  final int engagementIndex;
  const _MetricChips(
      {super.key, required this.plays, required this.engagementIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
          decoration: BoxDecoration(
              color: Colors.white12, borderRadius: BorderRadius.circular(2)),
          child: Row(
            children: [
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
              Text(plays.toString())
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            buildInfoSheet(context,
                headerText: 'Post engagement',
                infoText:
                    'Total engagement represents all up, down, and star votes (which count as 2) plus the total comment count',
                actionButtonText: 'Visit Shop',
                onActionButtonPress: () {});
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(2)),
              child: Row(
                children: [
                  Icon(Icons.trending_up_rounded,
                      color: Colors.white, size: 18),
                  Text(engagementIndex.toString())
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
