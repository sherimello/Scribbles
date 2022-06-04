import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:scribbles/classes/my_sharedpreferences.dart';
import 'package:scribbles/widgets/bottom_sheet.dart';
import 'package:scribbles/widgets/note_preview_card.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/note_map_for_cloud_fetch.dart';
import '../popup_card/custom_rect_tween.dart';
import '../popup_card/hero_dialog_route.dart';

class Home extends StatefulWidget {
  final bool shouldCloudSync;

  const Home(this.shouldCloudSync, {Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var t1 =
          'jhasjkhdiuiashiudyhiausdoijasiojdojoasjioljdoiaiojsiodjoiasjiodjioajoidajsoijdojasiodjojaosjdojoias',
      t2 = "hello",
      date = '19-3-93';
  late Database database;
  List<Map> list = [];
  List<User> cloudNotesList = [];
  String userName = "";

  late GoogleSignInAccount _currentUser;

// Get a location using getDatabasesPath
  late String path;
  int size = 0;
  bool visible = true, _isLoading = false;

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
  }

  uploadDataToFirebase() async {
    userName = await MySharedPreferences().getStringValue("userName");
    print(userName);
    final ref = FirebaseDatabase.instance.ref().child('notes');
    print(list.length);
    for (int i = 0; i < list.length; i++) {
      print(userName);
      ref
          .child(userName)
          .child((list[i]['time'].toString().replaceAll('\n', ' ')))
          .set({
            'title': list[i]['title'].toString(),
            'note': list[i]['note'].toString(),
            'theme': list[i]['theme'].toString(),
            'time': list[i]['time'].toString(),
          })
          .asStream()
          .listen((event) {}, onDone: () {
            setState(() {
              _isLoading = false;
            });
          });
    }
  }

  removeUserDataFromCloud() async {
    String userName = await MySharedPreferences().getStringValue("userName");
    await FirebaseDatabase.instance
        .ref('notes')
        .child(userName)
        .remove()
        .whenComplete(() => fetchCloudNotes().whenComplete(() {
              uploadDataToFirebase();
            }));
  }

  fetchCloudNotes() async {
    String userName = await MySharedPreferences().getStringValue("userName");
    List<String> title = [], note = [], theme = [], time = [];

    final snapshot =
        await FirebaseDatabase.instance.ref('notes').child(userName).get();
    int i = 0;
    final map = snapshot.value as Map<dynamic, dynamic>;

    map.forEach((key, value) {
      final user = User.fromMap(value);
      cloudNotesList.add(user);
      title.add(cloudNotesList[i].title);
      note.add(cloudNotesList[i].note);
      theme.add(cloudNotesList[i].theme);
      time.add(cloudNotesList[i].time);
      print("title: " + cloudNotesList[i].title);
      i++;
    });
    setState(() {
      list = list;
    });
  }

  showData() async {
    list = (await database.rawQuery('SELECT * FROM Notes'));

    if (list.isNotEmpty) {
      setState(() {
        visible = false;
      });
    }
    if (kDebugMode) {
      print(list.length);
    }
    size = list.length;
  }

  checkLoadLogic() async {
    widget.shouldCloudSync
        ? await MySharedPreferences().getStringValue("isCloudBackupOn") ==
                    "0" ||
                list.isEmpty
            ? setState(() {
                _isLoading = false;
              })
            : setState(() {
                _isLoading = true;
              })
        : null;
  }

  void universalFetchLogic() async {
    await MySharedPreferences().containsKey("isCloudBackupOn") == true
        ? await MySharedPreferences().getStringValue("isCloudBackupOn") == "1"
            ? widget.shouldCloudSync
                ? initiateDB()
                    .whenComplete(() => showData().whenComplete(() => {
                          // if (list.isEmpty)
                          //   {
                          //     checkLoadLogic()
                          //   }
                          /////////////////////////////////////////////////////////////////
                          checkUserConnection()
                              .whenComplete(() => {

                                activeConnection ? uploadDataToFirebase() : setState(() => _isLoading = false)

                          })
                        }))
                : initiateDB().whenComplete(() => showData())
            : initiateDB().whenComplete(() => showData())
        : initiateDB().whenComplete(() => showData());
  }

  @override
  void initState() {
    // TODO: implement initState
    Firebase.initializeApp();
    super.initState();
    universalFetchLogic();
    saveLastUsed();
  }

  Widget cloudBackupLoadingCard() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  bool activeConnection = false;
  String T = "";

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  Widget title() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'Scribbles',
          textAlign: TextAlign.center,
          style: TextStyle(
            // letterSpacing: 2,
            fontWeight: FontWeight.w900,
            fontSize: 21,
            fontFamily: 'varela-round.regular',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xffF8F0E3),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.fromLTRB(9.0, 9.0, 9.0, _isLoading ? 11.0 : 0.0),
                child: AnimatedContainer(
                  width: (!_isLoading) ? MediaQuery.of(context).size.width : 31,
                  height: (!_isLoading) ? AppBar().preferredSize.height : 31,
                  curve: Curves.easeInCirc,
                  decoration: BoxDecoration(
                      // color: (!_isLoading) ? Colors.black: Colors.white,
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.circular(_isLoading ? 1000 : 19)),
                  duration: const Duration(milliseconds: 350),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Visibility(visible: !_isLoading, child: title()),
                      ),
                      Visibility(
                          visible: _isLoading, child: cloudBackupLoadingCard())
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StaggeredGridView.countBuilder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        itemCount:
                            // list.isEmpty ? 0:
                            size,
                        itemBuilder: (BuildContext context, int index) =>
                            // list.isEmpty ? Container():
                            PreviewCard(
                                time: list[index]['time'].toString(),
                                theme: list[index]["theme"].toString(),
                                noteID: list[index]["id"].toString(),
                                id: index.toString(),
                                title: list[index]["title"].toString(),
                                note: list[index]["note"].toString()),
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      )),
                  Positioned(
                      bottom: 21,
                      right: 11,
                      child: Hero(
                        tag: '000',
                        createRectTween: (begin, end) {
                          return CustomRectTween(begin: begin!, end: end!);
                        },
                        child: Material(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100000),
                          ),
                          child: SizedBox(
                            width: 71,
                            height: 71,
                            child: IconButton(
                              color: Colors.black,
                              onPressed: () {
                                Navigator.of(context).push(HeroDialogRoute(
                                  builder: (context) => Center(
                                    child: Test(list),
                                  ),
                                ));
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )),
                  Visibility(
                    visible: visible,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: Image.asset(
                          "lib/assets/images/empty2.gif",
                          fit: BoxFit.cover,
                          height: s.width * .41,
                          width: s.width * .41,
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String time = "";

  void saveLastUsed() {
    String cdate2 = DateFormat("EEEEE, MMMM dd, yyyy").format(DateTime.now());
    //output:  August, 27, 2021

    String tdata = DateFormat("hh:mm:ss a").format(DateTime.now());
    // output: 07:38:57 PM
    time = cdate2 + " " + tdata;
    MySharedPreferences().setStringValue('last opened', time);
  }
}
