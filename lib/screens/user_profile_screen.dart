import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile screen'),
      ),
      body: Column(
        children: [
          Icon(Icons.person, color: Colors.pink, size: 54),
          Text('usren1313'),
        ],
      ),
    );
  }
}
