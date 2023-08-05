import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gg_tv/models/user.dart';
import 'package:gg_tv/styles.dart';
import 'package:gg_tv/widgets/profile_games_for_user.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});

  final Map<String, dynamic> _testuser = {
    "username": "OpTic_yupper3",
    "user_pfp":
        "https://miro.medium.com/v2/resize:fit:720/format:webp/0*EAwg7WIIMhgnSfLf.png",
    "id": "",
    "stars": 31,
    "ups": 41,
    "downs": 3,
    "date_added": DateTime.now(),
    "bits": 0,
    "skin": '',
    "profile_boost": false,
    "followers": 3,
  };

  @override
  Widget build(BuildContext context) {
    UserModel _u = UserModel.fromJson(_testuser);
    final double _W = MediaQuery.of(context).size.width;
    final double _h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(_u.pfp!), fit: BoxFit.cover)),
            ),
            Text(_u.username.toString(),
                style: AppStyles.giga18Text.copyWith(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.play_arrow_rounded),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.video_call_rounded),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4)),
                    child:
                        const Icon(Icons.keyboard_double_arrow_right_outlined),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 36,
                      color: Color.fromARGB(255, 91, 255, 42),
                    ),
                    Text('1992', style: AppStyles.giga18Text),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 36,
                      color: Color.fromARGB(255, 255, 65, 61),
                    ),
                    Text('2283', style: AppStyles.giga18Text),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.star_rounded,
                      size: 36,
                      color: Color.fromRGBO(255, 202, 44, 1),
                    ),
                    Text('776', style: AppStyles.giga18Text),
                  ],
                ),
              ],
            ),
            const GamesForUser(),
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: 21,
                itemBuilder: (context, i) {
                  return Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .5,
                        decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text("${2}",
                              style:
                                  AppStyles.giga18Text.copyWith(fontSize: 34)),
                        ),
                      ),
                      Positioned(
                          bottom: 15,
                          right: 10,
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow_outlined,
                                  color: Colors.white, size: 22),
                              Text(
                                '184',
                                style:
                                    AppStyles.giga18Text.copyWith(fontSize: 16),
                              )
                            ],
                          ))
                    ],
                  );
                }),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var _fs = FirebaseFirestore.instance.collection('users');
          _fs.add(_testuser);
        },
      ),
    );
  }
}
