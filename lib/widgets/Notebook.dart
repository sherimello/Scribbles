library flutter_notebook_page;

import 'package:flutter/material.dart';

import 'Notebook_item.dart';
import 'blank_notebook_page.dart';

class NotebookPage extends StatelessWidget {
  final String item1;
  final String item2;
  final String item3;
  final String item4;
  final String item5;
  final double height;
  final double width;
  final TextStyle textStyle;

  const NotebookPage(
      {required Key key,
        required this.item1,
        required this.item2,
        required this.item3,
        required this.item4,
        required this.item5,
        required this.height,
        required this.width,
        required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    var defaultTextStyle =
        textStyle;

    var notebookHeight = height;

    return CustomPaint(
      painter: BlankNotebookPage(),
      child: SizedBox(
        width: width,
        height: notebookHeight,
        child: Container(
          margin: EdgeInsets.only(left: width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              NotebookItem(
                height: height,
                fullHeight: fullHeight,
                orientation: orientation,
                textStyle: defaultTextStyle,
                item: item1, key: key!,
              ),
              NotebookItem(
                height: height,
                fullHeight: fullHeight,
                orientation: orientation,
                textStyle: defaultTextStyle,
                item: item2, key: key!
              ),
              NotebookItem(
                height: height,
                fullHeight: fullHeight,
                orientation: orientation,
                textStyle: defaultTextStyle,
                item: item3, key: key!
              ),
              NotebookItem(
                height: height,
                fullHeight: fullHeight,
                orientation: orientation,
                textStyle: defaultTextStyle,
                item: item4, key: key!
              ),
              NotebookItem(
                height: height,
                fullHeight: fullHeight,
                orientation: orientation,
                textStyle: defaultTextStyle,
                item: item5, key: key!
              ),
            ],
          ),
        ),
      ),
    );
  }
}
