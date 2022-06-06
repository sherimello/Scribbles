import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../pages/home.dart';
import '../hero_transition_handler/custom_rect_tween.dart';

class SimplifiedDeleteCard extends StatelessWidget {
  final String string, noteID, theme;

  const SimplifiedDeleteCard(this.noteID, this.string, this.theme, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String path;

    List<BoxShadow> boxShadow(double blurRadius, double offset1, double offset2,
        Color colorBottom, Color colorTop) {
      return [
        BoxShadow(
            blurRadius: blurRadius,
            spreadRadius: 0,
            offset: Offset(offset1, offset2),
            color: colorBottom,),
        BoxShadow(
            blurRadius: blurRadius,
            spreadRadius: 0,
            offset: Offset(-offset1, -offset2),
            color: colorTop,),
      ];
    }
    
    Future<void> deleteNote() async {
      var databasesPath = await getDatabasesPath();
      path = join(databasesPath, 'demo.db');
      Database database = await openDatabase(
        path,
        version: 1,
      );
      database.rawDelete('DELETE FROM Notes WHERE id = ?', [noteID]);
      if (kDebugMode) {
        print('deleted');
      }
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Home(true)), (route) => false);
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              color: Color(int.parse(theme)),
              boxShadow: boxShadow(11, 7, 7,
                const Color(0x31000000),
                 const Color(0x31ffffff))
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
