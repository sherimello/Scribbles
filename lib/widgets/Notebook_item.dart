import 'package:flutter/material.dart';

class NotebookItem extends StatelessWidget {
  final double height;
  final double fullHeight;
  final Orientation orientation;
  final String item;
  final TextStyle textStyle;

  const NotebookItem(
      {required Key key,
        required this.height,
        required this.fullHeight,
        required this.orientation,
        required this.item,
        required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: height),
      child: Text(
        item,
        style: textStyle,
      ),
    );
  }
}
