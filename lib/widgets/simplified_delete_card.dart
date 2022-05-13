import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../pages/home.dart';
import '../popup_card/custom_rect_tween.dart';

class SimplifiedDeleteCard extends StatelessWidget {
  final String string, noteID;

  const SimplifiedDeleteCard(this.noteID, this.string, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String path;
    Future<void> deleteNote() async {
      var databasesPath = await getDatabasesPath();
      path = join(databasesPath, 'demo.db');
      Database database = await openDatabase(
        path,
        version: 1,
      );
      database.rawDelete('DELETE FROM Notes WHERE id = ?', [noteID]);
      print('deleted');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Home()), (route) => false);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => const Home()),
      // );
    }

    var size = MediaQuery.of(context).size;

    return Hero(
      tag: string,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: GestureDetector(
        onTap: deleteNote,
        child: SizedBox(
          width: size.width*.25,
          height: size.width*.25,
          child: Card(
            color: Colors.red,
            elevation: 11,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: size.width*.13,
            ),
          ),
        ),
      ),
    );
  }
}
