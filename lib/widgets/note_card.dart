import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../pages/home.dart';
import '../pages/new_note_page_design.dart';
import '../hero_transition_handler/custom_rect_tween.dart';
import '../hero_transition_handler/hero_dialog_route.dart';

class NoteCard extends StatelessWidget {
  final String id, string, title, note, date, theme;

  const NoteCard(
      this.id, this.string, this.title, this.note, this.date, this.theme,
      {Key? key})
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
      database.rawDelete('DELETE FROM Notes WHERE time = ?', [date]);
      if (kDebugMode) {
        print('deleted');
      }
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Home(true, 'notes')), (route) => false);
    }

    List<BoxShadow> boxShadow(double blurRadius, double offset1, double offset2,
        Color colorBottom, Color colorTop) {
      return [
        BoxShadow(
          blurRadius: blurRadius,
          spreadRadius: 1,
          offset: Offset(offset1, offset2),
          color: colorBottom,
        ),
        BoxShadow(
          blurRadius: blurRadius,
          spreadRadius: 1,
          offset: Offset(-offset1, -offset2),
          color: colorTop,
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Hero(
        tag: string,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(31),
          ),
          color: Color(int.parse(theme)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .65,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(HeroDialogRoute(
                                    builder: (context) => Center(
                                      child: NewNotePage(id, string, theme),
                                    ),
                                    // settings: const RouteSettings(),
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1000),
                                      color: Color(int.parse(theme)).withOpacity(.95),
                                      boxShadow: boxShadow(
                                          11, 3, 3, const Color(0x35000000), const Color(
                                          0x35ffffff))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: GestureDetector(
                                onTap: () {
                                  deleteNote();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1000),
                                      color: Color(int.parse(theme)).withOpacity(.85),
                                      boxShadow: boxShadow(
                                          11, 3, 3, const Color(0x35000000), const Color(
                                          0x35ffffff))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                      size: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Center(
                        child: Text(
                          // t1,
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              fontFamily: 'varela-round.regular'),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(.05),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            '(' + date + ')',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                                fontFamily: 'Rounded_Elegance'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SelectableText(
                        // t1,
                        note,
                        showCursor: false,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: 'Rounded_Elegance'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
