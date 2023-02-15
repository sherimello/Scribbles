import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scribbles/classes/my_sharedpreferences.dart';
import 'package:scribbles/widgets/profile_stats_model.dart';
import 'package:sqflite/sqflite.dart';

import '../hero_transition_handler/custom_rect_tween.dart';
import 'home.dart';

class Profile extends StatefulWidget {
  final String tag;

  const Profile({Key? key, required this.tag}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool shouldShowCloudDeleteAlertBox = false, shouldShowProgressIndicator = false;
  late String path, lastOpened = "...", totalTasks = "...", totalNotes = "...";
  late Database database, database2;
  late List<Map> list, list2;

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
    // await MySharedPreferences().containsKey('last opened') == true
    //     ? setState(() async {
    //   lastOpened =
    //   await MySharedPreferences().getStringValue('last opened');
    // })
    //     : null;
  }

  Future<void> initiateTaskDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'tasks.db');
    // open the database
    database2 = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Tasks (id INTEGER PRIMARY KEY, task NVARCHAR, theme NVARCHAR, time NVARCHAR, pending BOOLEAN, schedule NVARCHAR)');
    });
    list2 = (await database2.rawQuery('SELECT * FROM Tasks'));
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    int tempTotalWords = 0;
    initiateDB().whenComplete(() => {
          // for (int i = 0; i < list.length; i++)
          //   {
          //     tempTotalWords += (list[i]['title'].toString().length +
          //         list[i]['note'].toString().length)
          //   },
          initiateTaskDB().whenComplete(() {
            setState(() {
              totalTasks = list2.length.toString();
              totalNotes = list.length.toString();
            });
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Card(
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
                                          title: 'total tasks',
                                          value: totalTasks),
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
                            onTap: () {
                              setState(() {
                                shouldShowCloudDeleteAlertBox = true;
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
                                        database2
                                            .execute('DELETE FROM Tasks')
                                            .whenComplete(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Home(false, 'notes')),
                                          );
                                        })
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
            Visibility(
              visible: shouldShowCloudDeleteAlertBox,
              child: AlertDialog(
                elevation: 55,
                actionsAlignment: MainAxisAlignment.center,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(31)),
                title: Text(
                  'for real?',
                  style: TextStyle(
                      fontFamily: "varela-round.regular",
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                // To display the title it is optional
                content: Text(
                  'you are about to remove all your note(s) and task(s) from cloud storage. this change is permanent and cannot be reversed from our end. please make sure you are fully aware of what you are about to do.',
                  style: TextStyle(
                      fontFamily: 'Rounded_Elegance',
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                actionsPadding: EdgeInsets.only(bottom: 31, top: 11),
                alignment: Alignment.center,
                // Message which will be pop up on the screen
                // Action widget which will provide the user to acknowledge the choice
                actions: [
                  GestureDetector(
                    onTap: () => setState(() {
                      shouldShowCloudDeleteAlertBox = false;
                    }),
                    child: Container(
                      // FlatButton widget is used to make a text to work like a button
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(11)),
                      // function used to perform after pressing the button
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 11.0, vertical: 7),
                        child: Text(
                          'cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 0,
                              color: Colors.white,
                              fontFamily: 'varela-round.regular',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        shouldShowProgressIndicator = true;
                      });
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
                              .whenComplete(() async => {
                                    await FirebaseDatabase.instance
                                        .ref('tasks')
                                        .child(userName)
                                        .remove()
                                        .whenComplete(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Home(false, 'notes')),
                                      );
                                    })
                                  });
                    },
                    child: Container(
                      // FlatButton widget is used to make a text to work like a button
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(11)),
                      // function used to perform after pressing the button
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 11.0, vertical: 7),
                        child: Text(
                          'accept',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              height: 0,
                              color: Colors.white,
                              fontFamily: 'varela-round.regular',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: shouldShowProgressIndicator,
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
