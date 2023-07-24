import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaders'),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
            itemCount: 21,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            itemBuilder: (context, i) {
              return const ListTile(
                leading: Icon(
                  Icons.gamepad,
                  color: Colors.yellowAccent,
                ),
                title: Text('Gamer_user131'),
                subtitle: Text('Game is here otes?'),
              );
            }),
      ),
    );
  }
}
