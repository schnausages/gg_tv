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

  final Map<String, dynamic> _testuser = {
    "username": "OpTic_yupper3",
    "user_pfp":
        "https://miro.medium.com/v2/resize:fit:720/format:webp/0*EAwg7WIIMhgnSfLf.png",
    "id": "",
    "stars": 31,
    "ups": 41,
    "downs": 3,
    "bits": 0,
    "skin": '',
    "profile_boost": false,
    "followers": 3,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Valorant Leaders',
          style: AppStyles.giga18Text.copyWith(fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  itemBuilder: ((context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: _selectedIndex == index
                                    ? const Color.fromARGB(255, 255, 42, 113)
                                    : Colors.white10,
                                borderRadius: BorderRadius.circular(4)),
                            child: Center(
                              child: Text(
                                'Fortnite',
                                style:
                                    AppStyles.giga18Text.copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ))),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .75),
            child: ListView.builder(
                itemCount: 21,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                itemBuilder: (context, i) {
                  UserModel _u = UserModel.fromJson(_testuser);
                  return LeaderboardTile(
                    user: _u,
                  );
                }),
          ),
        ],
      ),
    );
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
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage(user.pfp!), fit: BoxFit.cover)),
      ),
      title: Text(user.username!, style: AppStyles.giga18Text),
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
