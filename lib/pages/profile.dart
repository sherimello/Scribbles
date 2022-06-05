import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scribbles/classes/my_sharedpreferences.dart';
import 'package:scribbles/widgets/profile_stats_model.dart';
import 'package:sqflite/sqflite.dart';

import '../popup_card/custom_rect_tween.dart';
import 'home.dart';

class Profile extends StatefulWidget {
  final String tag;

  const Profile({Key? key, required this.tag}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String path, lastOpened = "...", totalWords = "...", totalNotes = "...";
  late Database database;
  late List<Map> list;

  Future<void> initiateDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'demo.db');
    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY, title NVARCHAR, note NVARCHAR, theme NVARCHAR, time NVARCHAR)');
    });
    list = await database.rawQuery('SELECT * FROM Notes');
    await MySharedPreferences().containsKey('last opened') == true
        ? setState(() async {
            lastOpened =
                await MySharedPreferences().getStringValue('last opened');
          })
        : null;
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    int tempTotalWords = 0;
    initiateDB().whenComplete(() => {
          for (int i = 0; i < list.length; i++)
            {
              tempTotalWords += (list[i]['title'].toString().length +
                  list[i]['note'].toString().length)
            },
          setState(() {
            totalWords = tempTotalWords.toString();
            totalNotes = list.length.toString();
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Hero(
        tag: widget.tag,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Card(
          elevation: 0,
          color: const Color(0xffF8F0E3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(31),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(7.0, 7.0, 7.0, 29.0),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(21)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(21),
                          child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  StatsModel(
                                      title: 'total characters',
                                      value: totalWords),
                                  StatsModel(
                                      title: 'total notes',
                                      value: totalNotes),
                                  // StatsModel(title: 'last used', value: lastOpened),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: GestureDetector(
                        onTap: () async {
                          String userName = await MySharedPreferences()
                              .getStringValue("userName");
                          userName.isEmpty
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'please turn cloud backup "on" first...')))
                              : await FirebaseDatabase.instance
                                  .ref('notes')
                                  .child(userName)
                                  .remove()
                                  .whenComplete(() => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Home(false)),
                                        )
                                      });
                        },
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000)),
                          color: Colors.red.withOpacity(.85),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.cloud_off_rounded,
                              size: MediaQuery.of(context).size.width * .17,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'delete cloud backup',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Rounded_Elegance',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: GestureDetector(
                        onTap: () async {
                          await database
                              .execute('DELETE FROM Notes')
                              .whenComplete(() => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Home(false)),
                                    )
                                  });
                        },
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000)),
                          color: Colors.orange.withOpacity(.85),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.delete_forever_outlined,
                              size: MediaQuery.of(context).size.width * .17,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'delete local database',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Rounded_Elegance',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
