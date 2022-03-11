import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final void Function()? onClick;

  const CircularButton(
      {Key? key,
      required this.width,
      required this.height,
      required this.color,
      required this.icon,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        width: width,
        height: height,
        child: IconButton(
          splashColor: Colors.white,
          icon: icon,
          onPressed: onClick,
          enableFeedback: true,
        ),
      ),
    );
  }
}
