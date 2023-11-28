import 'package:flutter/material.dart';

class PullPill extends StatelessWidget {
  final Color pillColor;
  const PullPill({super.key, this.pillColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 7,
      decoration: BoxDecoration(
          color: pillColor, borderRadius: BorderRadius.circular(12)),
    );
  }
}
