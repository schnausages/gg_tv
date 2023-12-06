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
  Future duoPlayMgmt() async {
    bool _active =
        await UserActionServices.returnStoredKeyValue(key: 'duo_play') ?? false;
    setState(() {
      _duoPlayActive = _active;
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
                print("PURT DUO PLAY NOW ON? $_duoPlayActive");
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
