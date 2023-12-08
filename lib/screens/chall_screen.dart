import 'package:flutter/material.dart';
import 'package:gg_tv/services/misc_services.dart';
import 'package:gg_tv/widgets/chall_vote_option.dart';

class ChallScreen extends StatefulWidget {
  const ChallScreen({super.key});

  @override
  State<ChallScreen> createState() => _ChallScreenState();
}

class _ChallScreenState extends State<ChallScreen> {
  late Future _getDuoPlay;
  bool _duoPlayActive = false;
  bool _stackView = false;
  Future duoPlayMgmt() async {
    bool _active =
        await UserActionServices.returnStoredKeyValue(key: 'duo_play') ?? false;
    bool _stack = await UserActionServices.returnStoredKeyValue(
            key: 'stack_chall_view') ??
        false;
    setState(() {
      _duoPlayActive = _active;
      _stackView = _stack;
    });
  }

  @override
  void initState() {
    _getDuoPlay = duoPlayMgmt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _s = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder(
            future: _getDuoPlay,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  width: _s.width,
                  height: _s.height,
                  child: PageView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemBuilder: (context, i) {
                        return ChallVoteItem(
                          size: _s,
                          duoPlayActive: _duoPlayActive,
                          stackView: _stackView,
                          stackViewUpdate: () async {
                            await UserActionServices.updateStorageKey(
                                key: 'stack_chall_view', newValue: !_stackView);
                            setState(() {
                              _stackView = !_stackView;
                            });
                          },
                          duoPlayUpdate: () async {
                            await UserActionServices.updateStorageKey(
                                    key: 'duo_play', newValue: !_duoPlayActive)
                                .then((value) {
                              setState(() {
                                _duoPlayActive = !_duoPlayActive;
                              });
                            });
                          },
                        );
                      }),
                );
              } else {
                return const SizedBox();
              }
            })));
  }
}
