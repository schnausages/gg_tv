import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/models/game.dart';
import 'package:gg_tv/styles.dart';

enum LoadStatus { notloading, loading }

class SetupFlow extends StatefulWidget {
  const SetupFlow({super.key});

  @override
  State<SetupFlow> createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {
  List<GameModel> _selectedGames = [];
  List<int> _selectedIndexes = [];
  final PageController _pageController = PageController();
  late Future<List<GameModel>> _getMyGames;
  LoadStatus _loadStatus = LoadStatus.notloading;
  final List<double> _gradientDoubles = [0.03, 0.2];

  Future<List<GameModel>> fetchGameOptions() async {
    List<GameModel> _gameList = [];
    var _gamesForUser =
        await FirebaseFirestore.instance.collection('games_metadata').get();
    _gamesForUser.docs.forEach((element) {
      GameModel _game = GameModel.fromJson(element.data());
      _gameList.add(_game);
    });

    print("PURT $_gameList");

    return _gameList;
  }

  Future<bool> _putGamesForUser(List<GameModel> gamesForUser) async {
    _loadStatus = LoadStatus.loading;

    QueryDocumentSnapshot<Map<String, dynamic>> _userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .limit(1)
            .get()
            .then((value) => value.docs.first);
    CollectionReference<Map<String, dynamic>> _ref =
        _userDoc.reference.collection('games_for_user');
    for (var eachGame in gamesForUser) {
      await _ref.add({
        'game_title': eachGame.gameTitle,
        'logo_url': eachGame.logoUrl,
        'ups': 0,
        'downs': 0,
        'stars': 0,
        'post_count': 0,
      });
    }
    _loadStatus = LoadStatus.notloading;
    return true;
  }

  // then submit games_for_user to subcollection with selected games

  @override
  void initState() {
    _getMyGames = fetchGameOptions();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _h = MediaQuery.of(context).size.height;
    final double _w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pick Your Main Games',
          style: AppStyles.giga18Text,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: _getMyGames,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox(
                      width: double.infinity,
                      height: _h * .7,
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 6.0),
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  // color: Colors.white10,
                                  gradient: LinearGradient(
                                      colors: [
                                        snapshot.data![index].primaryColorHex,
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topCenter,
                                      stops: _gradientDoubles),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    if (!_selectedIndexes.contains(index))
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            image: DecorationImage(
                                              image: NetworkImage(snapshot
                                                  .data![index].logoUrl!),
                                            )),
                                      ),
                                    if (_selectedIndexes.contains(index))
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Color.fromARGB(
                                                255, 8, 201, 30)),
                                        child: Center(
                                            child: Icon(Icons.check,
                                                color: Colors.white)),
                                      ),
                                    SizedBox(
                                      width: _w * .5,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 6.0),
                                        child: Text(
                                            snapshot.data![index].gameTitle,
                                            overflow: TextOverflow.fade,
                                            style: AppStyles.giga18Text),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        if (!_selectedIndexes.contains(index)) {
                                          _selectedIndexes.add(index);
                                          _selectedGames
                                              .add(snapshot.data![index]);
                                        } else if (_selectedIndexes
                                            .contains(index)) {
                                          _selectedIndexes.remove(index);
                                          _selectedGames
                                              .remove(snapshot.data![index]);
                                        }

                                        setState(() {});
                                      },
                                      icon: !_selectedIndexes.contains(index)
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      239, 83, 80, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ))
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white10,
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })),
                    );
                  } else {
                    return Center(
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Image.asset('assets/images/gg_loading.gif'),
                      ),
                    );
                  }
                })),
            if (_selectedIndexes.isNotEmpty)
              MaterialButton(
                color: Colors.pink,
                minWidth: 200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                elevation: 0,
                onPressed: () async {
                  setState(() {});
                  if (_loadStatus == LoadStatus.notloading) {
                    await _putGamesForUser(_selectedGames);
                    Navigator.pop(context);
                  }
                },
                child: _loadStatus == LoadStatus.notloading
                    ? const Text("LET'S GO", style: AppStyles.giga18Text)
                    : SizedBox(
                        height: 25,
                        width: 60,
                        child: Image.asset('assets/images/gg_loading.gif'),
                      ),
              ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("I'll do it later",
                    style: AppStyles.giga18Text
                        .copyWith(fontSize: 14, color: Colors.blueGrey)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
