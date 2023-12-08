import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/models/user.dart';
import 'package:gg_tv/styles.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedIndex = 0;
  String selectedGame = 'Fortnite';
  late Future _getLeaderboard;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getGameLeaderboard(
      String gameTitle) async {
    var query = await FirebaseFirestore.instance
        .collectionGroup('games_for_user')
        .where('game_title', isEqualTo: gameTitle)
        .orderBy('ups', descending: true)
        .get();
    return query.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 45),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppStyles.backgroundColor,
            title: Text(
              '$selectedGame Leaders',
              style: AppStyles.giga18Text.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: FutureBuilder(
            future: getGameLeaderboard(selectedGame),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          children: [
                            GestureDetector(
                              onTap: () {
                                getGameLeaderboard('Fortnite');
                                setState(() {
                                  selectedGame = 'Fortnite';
                                  _selectedIndex = 0;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: _selectedIndex == 0
                                          ? const Color.fromARGB(
                                              255, 255, 42, 113)
                                          : Colors.white10,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      'Fortnite',
                                      style: AppStyles.giga18Text
                                          .copyWith(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                getGameLeaderboard('Minecraft');

                                setState(() {
                                  selectedGame = 'Minecraft';
                                  _selectedIndex = 1;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: _selectedIndex == 1
                                          ? const Color.fromARGB(
                                              255, 255, 42, 113)
                                          : Colors.white10,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      'Minecraft',
                                      style: AppStyles.giga18Text
                                          .copyWith(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                getGameLeaderboard('Apex Legends');

                                setState(() {
                                  selectedGame = 'Apex Legends';
                                  _selectedIndex = 2;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: _selectedIndex == 2
                                          ? const Color.fromARGB(
                                              255, 255, 42, 113)
                                          : Colors.white10,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      'Apex Legends',
                                      style: AppStyles.giga18Text
                                          .copyWith(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * .75),
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemBuilder: (context, i) {
                            UserModel _u =
                                UserModel.fromJson(snapshot.data![i].data());
                            // UserModel _u = UserModel(
                            //     userId: '',
                            //     username: snapshot.data![i]['username'],
                            //     pfp: snapshot.data![i]['user_pfp'],
                            //     ups: snapshot.data![i]['ups'],
                            //     stars: snapshot.data![i]['stars'],
                            //     downs: snapshot.data![i]['downs']);
                            return LeaderboardTile(
                              user: _u,
                            );
                          }),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: SizedBox(
                    height: 60,
                    width: 80,
                    child: Image.asset('assets/images/gg_loading.gif'),
                  ),
                );
              }
            }));
  }
}

class LeaderboardTile extends StatelessWidget {
  final UserModel user;
  const LeaderboardTile({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      leading: user.pfp != null
          ? Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(user.pfp!), fit: BoxFit.cover)),
            )
          : Icon(Icons.person, color: Colors.white),
      title: Text(user.username, style: AppStyles.giga18Text),
      subtitle: Row(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 32,
              shadows: [
                BoxShadow(
                    color: Color.fromARGB(255, 52, 251, 155),
                    blurRadius: 4,
                    spreadRadius: 0)
              ],
              color: Color.fromARGB(255, 91, 255, 42),
            ),
          ),
          Text(user.ups.toString(),
              style: AppStyles.giga18Text.copyWith(fontSize: 16)),
          const SizedBox(width: 20),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 22,
            // color: Color.fromARGB(255, 255, 65, 61),
            color: Color.fromARGB(255, 128, 128, 128),
          ),
          Text(user.downs.toString(),
              style: AppStyles.giga18Text.copyWith(fontSize: 12)),
          const SizedBox(width: 20),
          const Icon(
            Icons.star_rounded,
            size: 20,
            // color: Color.fromRGBO(255, 202, 44, 1),
            color: Color.fromARGB(255, 128, 128, 128),
          ),
          Text(user.stars.toString(),
              style: AppStyles.giga18Text.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
