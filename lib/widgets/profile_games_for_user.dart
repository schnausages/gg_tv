import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/models/game.dart';
import 'package:gg_tv/styles.dart';

class GamesForUser extends StatefulWidget {
  const GamesForUser({super.key});

  @override
  State<GamesForUser> createState() => _GamesForUserState();
}

class _GamesForUserState extends State<GamesForUser> {
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchGamesData() async {
    var _gamesForUser = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: "OpTic_yupper3")
        .get()
        .then((value) => value.docs.first.reference
            .collection('games_for_user')
            .orderBy('ups', descending: true)
            .get());
    return _gamesForUser.docs;
  }

  late Future _getGamesData;
  @override
  void initState() {
    // TODO: implement initState
    _getGamesData = fetchGamesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _W = MediaQuery.of(context).size.width;
    final double _h = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: _getGamesData,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              padding: const EdgeInsets.all(12.0),
              width: _W * .9,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text('My Top Games', style: AppStyles.giga18Text)
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        GameModel _game =
                            GameModel.fromJson(snapshot.data[i].data());
                        return TopGamesTile(gameModel: _game);
                      })
                ],
              ),
            );
          } else {
            return Text('errrrrr', style: AppStyles.giga18Text);
          }
        });
  }
}

class TopGamesTile extends StatelessWidget {
  final GameModel gameModel;
  const TopGamesTile({
    required this.gameModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage(gameModel.logoUrl), fit: BoxFit.cover)),
      ),
      title: Text(gameModel.gameTitle, style: AppStyles.giga18Text),
      subtitle: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  stops: [0.0, 2.2],
                  colors: [
                    Color.fromARGB(255, 52, 251, 155),
                    AppStyles.backgroundColor
                  ],
                )),
            child: const Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 32,
              color: Color.fromARGB(255, 91, 255, 42),
            ),
          ),
          Text(gameModel.ups.toString(),
              style: AppStyles.giga18Text.copyWith(fontSize: 16)),
          const SizedBox(width: 20),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 22,
            color: Color.fromARGB(255, 255, 65, 61),
          ),
          Text(gameModel.downs.toString(),
              style: AppStyles.giga18Text.copyWith(fontSize: 12)),
          const SizedBox(width: 20),
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  stops: [0.0, 2.2],
                  colors: [
                    Color.fromARGB(255, 255, 255, 160),
                    AppStyles.backgroundColor
                  ],
                )),
            child: const Icon(
              Icons.star_rounded,
              size: 20,
              color: Color.fromRGBO(255, 202, 44, 1),
            ),
          ),
          Text(gameModel.stars.toString(),
              style: AppStyles.giga18Text.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
