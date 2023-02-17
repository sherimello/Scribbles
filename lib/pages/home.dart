import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:scribbles/classes/my_sharedpreferences.dart';
import 'package:scribbles/pages/task_creation_page.dart';
import 'package:scribbles/widgets/bottom_sheet.dart';
import 'package:scribbles/widgets/note_preview_card.dart';
import 'package:scribbles/widgets/update_prompt.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/note_map_for_cloud_fetch.dart';
import '../classes/notificationservice.dart';
import '../hero_transition_handler/custom_rect_tween.dart';
import '../hero_transition_handler/hero_dialog_route.dart';
import '../widgets/task_preview_card.dart';
import 'new_note_page_design.dart';

class Home extends StatefulWidget {
  final bool shouldCloudSync;
  final String whatToShow;

  const Home(this.shouldCloudSync, this.whatToShow, {Key? key})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
String listWidget = 'notes';
bool visible = false;

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  var t1 =
          'jhasjkhdiuiashiudyhiausdoijasiojdojoasjioljdoiaiojsiodjoiasjiodjioajoidajsoijdojasiodjojaosjdojoias',
      t2 = "hello",
      date = '19-3-93';
  late Database database;
  List<Map> nList = [], tList = [];
  List<User> cloudNotesList = [];
  String userName = "";
  bool showProfilePicture = false;

  late GoogleSignInAccount _currentUser;

// Get a location using getDatabasesPath
  late String path, profilePicture = "";
  int nSize = 0, tSize = 0;
  bool _isLoading = false;

  checkForUpdates() async {
    if (await MySharedPreferences().containsKey("disable update auto prompt") ==
        false) {
      var snapshot = await FirebaseDatabase.instance
          .ref('app update')
          .child("version code")
          .get();
      if (snapshot.value.toString() != "1.5") {
        snapshot = await FirebaseDatabase.instance
            .ref('app update')
            .child("url")
            .get()
            .whenComplete(() {
          Navigator.of(this.context).push(HeroDialogRoute(
            builder: (context) => Center(
              child: UpdatePrompt(
                url: snapshot.value.toString(),
              ),
            ),
          ));
        });
      }
    }
  }

  Future<void> initiateTasksDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'tasks.db');
    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Tasks (id INTEGER PRIMARY KEY, task NVARCHAR, theme NVARCHAR, time NVARCHAR, pending BOOLEAN, schedule NVARCHAR)');
    });
  }

  Future<void> initiateNotesDB() async {
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
    print(nList.length);
    for (int i = 0; i < nList.length; i++) {
      print(userName);
      ref
          .child(userName)
          .child((nList[i]['time'].toString().replaceAll('\n', ' ')))
          .set({
            'title': nList[i]['title'].toString(),
            'note': nList[i]['note'].toString(),
            'theme': nList[i]['theme'].toString(),
            'time': nList[i]['time'].toString(),
          })
          .asStream()
          .listen((event) {}, onDone: () async {
            // setState(() {
            //   _isLoading = false;
            // });
          });
    }
    await initiateTasksDB().whenComplete(() => showTasksData().whenComplete(() {
          final ref2 = FirebaseDatabase.instance.ref().child('tasks');
          print("hello: ${tList.length}");
          for (int i = 0; i < tList.length; i++) {
            print(userName);
            ref2
                .child(userName)
                .child((tList[i]['time'].toString().replaceAll('\n', ' ')))
                .set({
                  'task': tList[i]['task'].toString(),
                  'theme': tList[i]['theme'].toString(),
                  'time': tList[i]['time'].toString(),
                  'pending': (tList[i]['pending']) == 0 ? "false" : "true",
                  'schedule': tList[i]['schedule'].toString(),
                })
                .asStream()
                .listen((event) {}, onDone: () {
                  setState(() {
                    _isLoading = false;
                  });
                });
          }
        }));
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
      nList = nList;
    });
  }

  showNotesData() async {
    nList = (await database.rawQuery('SELECT * FROM Notes'));

    setState(() {
      nList = nList;
      nSize = nList.length;
    });
    // print(nList.length);

    setState(() {
      if (nList.isEmpty) {
        setState(() {
          visible = true;
        });
      } else {
        setState(() {
          visible = false;
        });
      }
    });

    if (kDebugMode) {
      print(nList.length);
    }
  }

  Future<void> showTasksData() async {
    tList = (await database.rawQuery('SELECT * FROM Tasks'));
    setState(() {
      tList = tList;
      tSize = tList.length;
    });

    bindNotificationToTasks();

    if (tList.isEmpty) {
      setState(() {
        visible = true;
      });
    } else {
      setState(() {
        visible = false;
      });
    }
    if (kDebugMode) {
      print(tList.length);
    }

    // print(tList[0]["pending"]);
  }

  bindNotificationToTasks() {
    for (int i = 0; i < tList.length; i++) {
      if (tList[i]['schedule'] != "undefined") {
        String year = tList[i]["schedule"].toString().substring(0, 4);
        String month = tList[i]["schedule"].toString().substring(5, 7);
        String day = tList[i]["schedule"].toString().substring(8, 10);
        String hour = tList[i]["schedule"].toString().substring(11, 13);
        String minute = tList[i]["schedule"].toString().substring(14, 16);
        print(year);
        print(month);
        print(day);
        print(hour);
        print(minute);

        NotificationService().showNotification(
            tList[i]['id'],
            tList[i]['task'],
            int.parse(year),
            int.parse(month),
            int.parse(day),
            int.parse(hour),
            int.parse(minute));
      }
    }
  }

  checkIfUserLoggedIn() async {
    await MySharedPreferences().getStringValue("isCloudBackupOn") == "1"
        ? {
            profilePicture =
                await MySharedPreferences().getStringValue("profilePicture"),
            setState(() {
              showProfilePicture = true;
              profilePicture = profilePicture;
            })
          }
        : setState(() {
            showProfilePicture = false;
          });
    print("dp: $showProfilePicture");
  }

  checkLoadLogic() async {
    widget.shouldCloudSync
        ? await MySharedPreferences().getStringValue("isCloudBackupOn") ==
                    "0" ||
                nList.isEmpty
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
                ? initiateNotesDB()
                    .whenComplete(() => showNotesData().whenComplete(() => {
                          checkUserConnection().whenComplete(() => {
                                activeConnection
                                    ? uploadDataToFirebase()
                                    : setState(() => _isLoading = false)
                              })
                        }))
                : initiateNotesDB().whenComplete(() => showNotesData())
            : initiateNotesDB().whenComplete(() => showNotesData())
        : initiateNotesDB().whenComplete(() => showNotesData());
  }

  Padding notesList() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4.0,
        ),
        child: StaggeredGridView.countBuilder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          itemCount:
              // list.isEmpty ? 0:
              nList.isEmpty ? 0 : nList.length,
          itemBuilder: (BuildContext context, int index) =>
              // list.isEmpty ? Container():
              Padding(
            padding: index == 0 || index == 1
                ? EdgeInsets.only(
                    top: 22 + MediaQuery.of(context).size.width * .125)
                : EdgeInsets.zero,
            child: NotePreviewCard(
                time: nList[nList.length - 1 - index]['time'].toString(),
                theme: nList[nList.length - 1 - index]["theme"].toString(),
                noteID: nList[nList.length - 1 - index]["id"].toString(),
                id: (nList.length - 1 - index).toString(),
                title: nList[nList.length - 1 - index]["title"].toString(),
                note: nList[nList.length - 1 - index]["note"].toString()),
          ),
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
        ));
  }

  Widget tasksList() {
    return StaggeredGridView.countBuilder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 1,
      itemCount:
          // list.isEmpty ? 0:
          tSize,
      itemBuilder: (BuildContext context, int index) =>
          // list.isEmpty ? Container():
          Padding(
        padding: index == 0
            ? EdgeInsets.only(top: 56 + MediaQuery.of(context).size.width * .05)
            : EdgeInsets.zero,
        child: TaskPreviewCard(
          time: tList[tList.length - 1 - index]['time'].toString(),
          theme: tList[tList.length - 1 - index]["theme"].toString(),
          taskID: tList[tList.length - 1 - index]["id"].toString(),
          id: (tList.length - 1 - index).toString(),
          task: tList[tList.length - 1 - index]["task"].toString(),
          pending: intToBool(tList[tList.length - 1 - index]["pending"]),
          schedule: tList[tList.length - 1 - index]["schedule"],
        ),
      ),
      staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 0.0,
    );
  }

  bool intToBool(int a) => a == 0 ? false : true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      requestPermission();
      // setState(() {
      //   status = requestPermission();
      // });
    }
  }

  Future<bool> requestPermission() async {
    WidgetsFlutterBinding.ensureInitialized();
    Future<bool> Pstatus =
        AwesomeNotifications().requestPermissionToSendNotifications();

    if (await Pstatus == true) {
      //permission granted...
    } else {
      requestPermission();
      // exit(1);
    }
    return Pstatus;
    // We didn't ask for permission yet or the permission has been denied before but not permanently.
  }

  @override
  void initState() {
    // TODO: implement initState
    // Firebase.initializeApp();
    super.initState();
    checkForUpdates();
    checkIfUserLoggedIn();
    // requestPermission();
    initiateNotesDB();
    initiateTasksDB();
    universalFetchLogic();
    saveLastUsed();
    setState(() {
      listWidget = widget.whatToShow;
    });
    if (listWidget == "tasks") {
      initiateTasksDB().whenComplete(() => showTasksData());
      setState(() {
        isNotesPressed = false;
      });
    }
    print(listWidget);
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
      padding: EdgeInsets.all(0.0),
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

  bool isNotesPressed = true;

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;

    bool isPortraitMode() {
      return s.height > s.width ? true : false;
    }

    List<BoxShadow> boxShadow(double blurRadius, double offset1, double offset2,
        Color colorBottom, Color colorTop, bool isInSet) {
      return [
        BoxShadow(
            blurRadius: blurRadius,
            spreadRadius: 0,
            offset: Offset(offset1, offset2),
            color: colorBottom,
            inset: isInSet),
        BoxShadow(
            blurRadius: blurRadius,
            spreadRadius: 0,
            offset: Offset(-offset1, -offset2),
            color: colorTop,
            inset: isInSet),
      ];
    }

    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 255),
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xffF8F0E3),
        child: SafeArea(
          bottom: false,
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(children: [
                  listWidget != 'tasks'
                      ? notesList()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(31),
                            child: tasksList(),
                          ),
                        ),
                  Positioned(
                      bottom: 21,
                      right: 11,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Material(
                              shadowColor: Colors.black,
                              elevation: 11,
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: SizedBox(
                                width: size.width * .13,
                                height: size.width * .13,
                                child: IconButton(
                                  color: Colors.black,
                                  onPressed: () async {
                                    await requestPermission() == true
                                        ? {
                                            if (listWidget == 'notes')
                                              {
                                                Navigator.of(context)
                                                    .push(HeroDialogRoute(
                                                  builder: (context) =>
                                                      const Center(
                                                    child: NewNotePage(
                                                        '000', '000', ""),
                                                  ),
                                                  // settings: const RouteSettings(),
                                                ))
                                              }
                                            else
                                              {
                                                Navigator.of(context)
                                                    .push(HeroDialogRoute(
                                                  builder: (context) =>
                                                      const Center(
                                                    child:
                                                        TaskCreationPage("000"),
                                                  ),
                                                  // settings: const RouteSettings(),
                                                ))
                                              }
                                          }
                                        : null;
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: size.width * .049,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * .0075,
                            ),
                            Hero(
                              tag: '000',
                              createRectTween: (begin, end) {
                                return CustomRectTween(
                                    begin: begin!, end: end!);
                              },
                              child: Material(
                                elevation: 11,
                                shadowColor: Colors.black,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                                child: SizedBox(
                                  width: size.width * .13,
                                  height: size.width * .13,
                                  child: IconButton(
                                    color: Colors.black,
                                    onPressed: () async {
                                      await requestPermission() == true
                                          ? Navigator.of(context)
                                              .push(HeroDialogRoute(
                                              builder: (context) => Center(
                                                child: Test(nList),
                                              ),
                                            ))
                                          : null;
                                    },
                                    icon: Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                      size: size.width * .049,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Visibility(
                    visible: listWidget == 'notes'
                        ? nList.isEmpty
                            ? true
                            : false
                        : tList.isEmpty
                            ? true
                            : false,
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * .05, vertical: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Visibility(
                      visible: showProfilePicture ? true : false,
                      child: Container(
                        width: size.width * .125,
                        height: size.width * .125,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: Colors.black),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: Image.network(profilePicture),
                        ),
                      ),
                    ),
                    Container(
                      width: showProfilePicture
                          ? size.width - size.width * .245
                          // ? size.width -
                          //     size.width * .1 -
                          //     79 +
                          //     MediaQuery.of(context).size.width * .05
                          : size.width - size.width * .1,
                      height: size.width * .125,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100)),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * .01),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() {
                                listWidget = 'notes';
                                if (!isNotesPressed) {
                                  initiateNotesDB()
                                      .whenComplete(() => showNotesData());
                                  isNotesPressed = !isNotesPressed;
                                }
                              }),
                              child: Container(
                                width: showProfilePicture
                                    ? ((size.width -
                                                size.width * .245 -
                                                size.width * .02) *
                                            .5) -
                                        size.width * .005
                                    // ? MediaQuery
                                    // .of(context)
                                    // .size
                                    // .width * .5 -
                                    // (size.width * .05 +
                                    //     11 +
                                    //     ((39 +
                                    //         MediaQuery
                                    //             .of(context)
                                    //             .size
                                    //             .width *
                                    //             .05) *
                                    //         .5))
                                    : MediaQuery.of(context).size.width * .5 -
                                        (size.width * .05 + 11),
                                height: size.width * .05 + 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: isNotesPressed
                                        ? const Color(0xffF8F0E3)
                                            .withOpacity(.19)
                                        : const Color(0xffF8F0E3)),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                          height: 0,
                                          color: isNotesPressed
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: size.width * .031,
                                          fontFamily: "Rounded_Elegance",
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        WidgetSpan(
                                            child: Icon(
                                              Icons.note_outlined,
                                              size: size.width * .05,
                                              color: isNotesPressed
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            alignment:
                                                PlaceholderAlignment.bottom),
                                        TextSpan(
                                          text: "  notes",
                                          style: TextStyle(
                                              height: 0,
                                              color: isNotesPressed
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: size.width * .031,
                                              fontFamily: "Rounded_Elegance",
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                listWidget = 'tasks';
                                if (isNotesPressed) {
                                  initiateTasksDB()
                                      .whenComplete(() => showTasksData());
                                  isNotesPressed = false;
                                }
                              }),
                              child: Container(
                                width: showProfilePicture
                                    ? ((size.width -
                                                size.width * .245 -
                                                size.width * .02) *
                                            .5) -
                                        size.width * .005
                                    // ? MediaQuery
                                    // .of(context)
                                    // .size
                                    // .width * .5 -
                                    // (size.width * .05 +
                                    //     11 +
                                    //     ((39 +
                                    //         MediaQuery
                                    //             .of(context)
                                    //             .size
                                    //             .width *
                                    //             .05) *
                                    //         .5))
                                    : MediaQuery.of(context).size.width * .5 -
                                        (size.width * .05 + 11),
                                height: size.width * .05 + 18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: isNotesPressed
                                        ? const Color(0xffF8F0E3)
                                        : const Color(0xffF8F0E3)
                                            .withOpacity(.19)),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text.rich(
                                    TextSpan(
                                        style: TextStyle(
                                            height: 0,
                                            color: !isNotesPressed
                                                ? Colors.white
                                                : Colors.black,
                                            fontFamily: "Rounded_Elegance",
                                            fontSize: size.width * .031,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          WidgetSpan(
                                              child: Icon(
                                                Icons.task_outlined,
                                                size: size.width * .05,
                                                color: !isNotesPressed
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              alignment:
                                                  PlaceholderAlignment.bottom),
                                          TextSpan(
                                            text: "  tasks",
                                            style: TextStyle(
                                                height: 0,
                                                color: !isNotesPressed
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: size.width * .031,
                                                fontFamily: "Rounded_Elegance",
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // child: Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.fromLTRB(11, 7, 5.5, 7),
                //       child: GestureDetector(
                //         onTap: () => setState(() {
                //           listWidget = 'notes';
                //           if (!isNotesPressed) {
                //             initiateNotesDB()
                //                 .whenComplete(() => showNotesData());
                //             isNotesPressed = !isNotesPressed;
                //           }
                //         }),
                //         child: AnimatedContainer(
                //           width:
                //               isPortraitMode() ? s.width * .35 : s.height * .35,
                //           height: AppBar().preferredSize.height * .75,
                //           duration: const Duration(milliseconds: 255),
                //           decoration: BoxDecoration(
                //               color: const Color(0xffe1dacf),
                //               borderRadius: BorderRadius.circular(13),
                //               boxShadow: boxShadow(
                //                   !isNotesPressed ? 7 : 5,
                //                   5,
                //                   5,
                //                   isNotesPressed
                //                       ? const Color(0x55000000)
                //                       : const Color(0x55000000),
                //                   isNotesPressed
                //                       ? const Color(0xffffffff)
                //                       : const Color(0xffffffff),
                //                   isNotesPressed ? true : false)),
                //           child: Center(
                //             child: AnimatedDefaultTextStyle(
                //               duration: const Duration(milliseconds: 255),
                //               style: isNotesPressed
                //                   ? const TextStyle(
                //                       fontFamily: "varela-round.regular",
                //                       fontSize: 15,
                //                       color: Colors.black,
                //                       fontWeight: FontWeight.bold)
                //                   : const TextStyle(
                //                       fontFamily: "varela-round.regular",
                //                       fontSize: 13,
                //                       color: Colors.black45,
                //                       fontWeight: FontWeight.bold),
                //               child: const Text(
                //                 'notes',
                //                 textAlign: TextAlign.center,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.fromLTRB(5.5, 3, 11, 3),
                //       child: GestureDetector(
                //         onTap: () => setState(() {
                //           listWidget = 'tasks';
                //           if (isNotesPressed) {
                //             initiateTasksDB()
                //                 .whenComplete(() => showTasksData());
                //             isNotesPressed = !isNotesPressed;
                //           }
                //         }),
                //         child: AnimatedContainer(
                //           width:
                //               isPortraitMode() ? s.width * .35 : s.height * .35,
                //           height: AppBar().preferredSize.height * .75,
                //           duration: const Duration(milliseconds: 255),
                //           decoration: BoxDecoration(
                //               color: const Color(0xffe1dacf),
                //               borderRadius: BorderRadius.circular(13),
                //               boxShadow: boxShadow(
                //                   !isNotesPressed ? 5 : 7,
                //                   5,
                //                   5,
                //                   isNotesPressed
                //                       ? const Color(0x55000000)
                //                       : const Color(0x55000000),
                //                   isNotesPressed
                //                       ? const Color(0xffffffff)
                //                       : const Color(0xffffffff),
                //                   isNotesPressed ? false : true)),
                //           child: Center(
                //             child: AnimatedDefaultTextStyle(
                //               duration: const Duration(milliseconds: 255),
                //               style: !isNotesPressed
                //                   ? const TextStyle(
                //                       fontFamily: "varela-round.regular",
                //                       fontSize: 15,
                //                       color: Colors.black,
                //                       fontWeight: FontWeight.bold)
                //                   : const TextStyle(
                //                       fontFamily: "varela-round.regular",
                //                       fontSize: 13,
                //                       color: Colors.black45,
                //                       fontWeight: FontWeight.bold),
                //               child: const Text(
                //                 'tasks',
                //                 textAlign: TextAlign.center,
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
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
