import 'package:flutter/material.dart';

class SimuPlayButton extends StatefulWidget {
  final Size s;
  bool duoPlayActive;
  final Function onPress;
  SimuPlayButton(
      {super.key,
      required this.s,
      required this.onPress,
      required this.duoPlayActive});

  @override
  State<SimuPlayButton> createState() => _SimuPlayButtonState();
}

class _SimuPlayButtonState extends State<SimuPlayButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPress();
      },
      child: Container(
        height: 45,
        width: 45,
        child: Icon(
            widget.duoPlayActive
                ? Icons.double_arrow_sharp
                : Icons.keyboard_arrow_right_rounded,
            size: 32,
            color: Colors.white),
        decoration: BoxDecoration(
            color: widget.duoPlayActive ? Colors.purple : Colors.white10,
            borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

class CommentBoxWidget extends StatelessWidget {
  const CommentBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 45,
        width: 45,
        child: Icon(Icons.chat_bubble_outline_rounded,
            size: 28, color: Colors.white),
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
