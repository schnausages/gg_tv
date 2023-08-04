import 'package:flutter/material.dart';
import 'package:gg_tv/models/user.dart';
import 'package:gg_tv/styles.dart';

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
                    child: Icon(Icons.play_arrow_rounded),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(4)),
                    child: Icon(Icons.video_call_rounded),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4)),
                    child: Icon(Icons.keyboard_double_arrow_right_outlined),
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
            Container(
              padding: const EdgeInsets.all(12.0),
              width: _W * .9,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    children: const [Text('My Top Games')],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, i) {
                        return TopGamesTile(user: _u);
                      })
                ],
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: 21,
                itemBuilder: (context, i) {
                  return Container(
                    height: MediaQuery.of(context).size.height * .5,
                    decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text("${2}",
                          style: AppStyles.giga18Text.copyWith(fontSize: 34)),
                    ),
                  );
                }),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class TopGamesTile extends StatelessWidget {
  final UserModel user;
  const TopGamesTile({
    required this.user,
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
            image: const DecorationImage(
                image: NetworkImage(
                    'https://cdn.bleacherreport.net/images/team_logos/328x328/valorant.png'),
                fit: BoxFit.cover)),
      ),
      title: const Text('Valorant', style: AppStyles.giga18Text),
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
          Text('1329', style: AppStyles.giga18Text.copyWith(fontSize: 16)),
          const SizedBox(width: 20),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 22,
            color: Color.fromARGB(255, 255, 65, 61),
          ),
          Text('43', style: AppStyles.giga18Text.copyWith(fontSize: 12)),
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
          Text('201', style: AppStyles.giga18Text.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
