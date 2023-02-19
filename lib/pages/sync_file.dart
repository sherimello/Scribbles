import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribbles/classes/my_sharedpreferences.dart';
import 'package:scribbles/classes/task_map_for_cloud_fetch.dart';
import 'package:scribbles/pages/upload_to_drive.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/note_map_for_cloud_fetch.dart';
import '../hero_transition_handler/custom_rect_tween.dart';
import '../hero_transition_handler/hero_dialog_route.dart';
import 'home.dart';

class SyncFile extends StatefulWidget {
  final String string;

  const SyncFile(this.string, {Key? key}) : super(key: key);

  @override
  State<SyncFile> createState() => _SyncFileState();
}

class _SyncFileState extends State<SyncFile> {
  late String path;
  late Database database, database2;
  late List<Map> list, list2;
  int size = 0;
  late String fetchedNotes, s = '\n\n';
  List<String> title = [], note = [], theme = [], time = [];
  List<String> task = [], theme2 = [], time2 = [], schedule = [];
  List<bool> pending = [];
  bool _isProgressVisible = false;

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
    getAllNotes();
    // list = (await database.rawQuery('SELECT * FROM Notes'));
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
    await getAllTasks();
  }

  String allNotes = '', divider = ",.,.,.,;';';';,.,.,.,";
  String message = "";

  @override
  void initState() {
    // TODO: implement initState
    initiateDB();
    // _signOut();
    super.initState();
  }

  Future<void> uploadData(BuildContext context, List<String> title,
      List<String> note, List<String> theme, List<String> time) async {
    await database.transaction((txn) async {
      for (int i = 0; i < title.length; i++) {
        int id1 = await txn.rawInsert(
            'INSERT INTO Notes(title, note, theme, time) VALUES(?, ?, ?, ?)',
            [title[i], note[i], theme[i], time[i]]);
        if (kDebugMode) {
          print('inserted1: $id1');
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home(false, 'notes')),
      );
    });
  }

  Future<void> uploadTaskData(BuildContext context, List<String> task, List<String> theme, List<String> time, List<String> pending, List<String> schedule) async {
    await database2.transaction((txn) async {
      for (int i = 0; i < task.length; i++) {
        int id1 = await txn.rawInsert(
            'INSERT INTO Tasks(task, theme, time, pending, schedule) VALUES(?, ?, ?, ?, ?)',
            [task[i], theme[i], time[i], pending[i], schedule[i]]);
        if (kDebugMode) {
          print('inserted1: $id1');
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home(false, 'notes')),
      );
    });
  }

  bool v = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    updateDB() async {
      await database.transaction((txn) async {
        for (int i = 0; i < title.length; i++) {
          int id1 = await txn.rawInsert(
              'INSERT INTO Notes(title, note, theme, time) VALUES(?, ?, ?, ?)',
              [title[i], note[i], theme[i], time[i]]);
          if (kDebugMode) {
            print('inserted1: $id1');
          }
        }
        // setState(() {
        //   _isProgressVisible = false;
        // });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Home(false, 'notes')),
        // );
      });
    }

    updateTaskDB() async {
      print("kashem : ${task.length}");
      await database2.transaction((txn) async {
        for (int i = 0; i < task.length; i++) {
          int id1 = await txn.rawInsert(
              'INSERT INTO Tasks(task, theme, time, pending, schedule) VALUES(?, ?, ?, ?, ?)',
              [task[i], theme2[i], time2[i], pending[i], schedule[i]]);
          if (kDebugMode) {
            print('inserted1: $id1');
          }
        }
        setState(() {
          _isProgressVisible = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home(false, 'notes')),
        );
      });
    }

    uploadDataToFirebase() async {
      for (int i = 0; i < list.length; i++) {
        title.add(list[i]['title']);
        note.add(list[i]['note']);
        theme.add(list[i]['theme']);
        time.add(list[i]['time']);
      }
      String userName = await MySharedPreferences().getStringValue("userName");
      print(userName);
      final ref = FirebaseDatabase.instance.ref().child('notes');
      print(list.length);
      for (int i = 0; i < list.length; i++) {
        print(userName);
        ref
            .child(userName)
            .child((list[i]['time'].toString().replaceAll('\n', ' ')))
            .set({
          'title': title[i].toString(),
          'note': note[i].toString(),
          'theme': theme[i].toString(),
          'time': time[i].toString(),
        }).asStream();
      }
      for (int i = 0; i < list2.length; i++) {
        task.add(list2[i]['task']);
        theme2.add(list2[i]['theme']);
        time2.add(list2[i]['time']);
        pending.add(list2[i]['pending'] == 0 ? false : true);
        schedule.add(list2[i]['schedule']);
      }
      final ref2 = FirebaseDatabase.instance.ref().child('tasks');
      for (int i = 0; i < list2.length; i++) {
        ref2
            .child(userName)
            .child((list2[i]['time'].toString().replaceAll('\n', ' ')))
            .set({
          'task': task[i].toString(),
          'theme': theme2[i].toString(),
          'time': time2[i].toString(),
          'pending': pending[i].toString(),
          'schedule': schedule[i].toString(),
        }).asStream();
      }
    }

    Future<void> fetchNotesFromCloud() async {
      title.clear();
      note.clear();
      theme.clear();
      time.clear();

      String userName = await MySharedPreferences().getStringValue("userName");

      final List<User> listCloud = [];
      final snapshot =
          await FirebaseDatabase.instance.ref('notes').child(userName).get();
      int i = 0;
      final map = snapshot.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        final user = User.fromMap(value);
        listCloud.add(user);
        title.add(user.title);
        note.add(user.note);
        theme.add(user.theme);
        time.add(user.time);
        print(listCloud[i].title);
        i++;
      });
    }

    Future<void> fetchTasksFromCloud() async {
      task.clear();
      theme2.clear();
      time2.clear();
      pending.clear();
      schedule.clear();
      String userName = await MySharedPreferences().getStringValue("userName");

      final List<TaskMap> listCloud2 = [];
      final snapshot =
          await FirebaseDatabase.instance.ref('tasks').child(userName).get();
      final map = snapshot.value as Map<dynamic, dynamic>;

      map.forEach((key, value) {
        final user = TaskMap.fromMap(value);
        listCloud2.add(user);
        // title.add(user.title);
        task.add(user.task);
        theme2.add(user.theme);
        time2.add(user.time);
        pending.add(user.pending);
        schedule.add(user.schedule);
        print(user.schedule);
      });
    }

    Future<void> syncNotesAndTasksFromCloud() async {
      task.clear();
      time2.clear();
      theme2.clear();
      pending.clear();
      schedule.clear();
      await MySharedPreferences().containsKey("userName") == true
          ? uploadDataToFirebase().whenComplete(() async => {
                await database
                    .execute('DELETE FROM Notes')
                    .whenComplete(() => fetchNotesFromCloud().whenComplete(() {
                          updateDB().whenComplete(() async {
                            await database2
                                .execute('DELETE FROM Tasks')
                                .whenComplete(() async {
                              await fetchTasksFromCloud();
                              updateTaskDB();
                            });
                          });
                        }))
              })
          : {
              setState(() {
                _isProgressVisible = false;
              }),
              message = "please enable \"Cloud Backup\" first...",
              showCustomSnackBar()
            };
    }

    return WillPopScope(
      onWillPop: () async {
        _isProgressVisible ? null : Navigator.of(context).pop();
        return false;
      },
      child: AbsorbPointer(
        absorbing: _isProgressVisible,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Hero(
                  tag: widget.string,
                  createRectTween: (begin, end) {
                    return CustomRectTween(begin: begin!, end: end!);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(31),
                    ),
                    // color: const Color(0xffF8F0E3),
                    color: const Color(0xff000000),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 19.0, 8, 8),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              alignment: PlaceholderAlignment.middle,
                                              child: Icon(
                                                Icons.cloud_upload_outlined,
                                                size: size.width * .039,
                                                color: Colors.orangeAccent,
                                              ),
                                            ),
                                            TextSpan(
                                                text: "  backup notes:",
                                                style: TextStyle(
                                                    color: Colors.orangeAccent,
                                                    fontFamily:
                                                        'varela-round.regular',
                                                    fontSize: size.width * .035,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(11.0),
                                      child: GestureDetector(
                                        // splashColor: Colors.white,
                                        // radius: 100,
                                        onTap: () async {
                                          getAllNotes();
                                          getAllTasks();
                                          Navigator.of(context)
                                              .push(HeroDialogRoute(
                                            bgColor: Colors.transparent,
                                            builder: (context) => Center(
                                                child: UploadToDrive(
                                                    string: widget.string,
                                                    allNotes: allNotes)
                                                // child: WidTest()
                                                ),
                                          ));
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 11.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.add_to_drive,
                                                    size: size.width * .045,
                                                    color: Colors.white,
                                                  ),
                                                  alignment: PlaceholderAlignment.middle
                                                ),
                                                TextSpan(
                                                    text: "  to Google Drive",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'varela-round.regular',
                                                        fontSize: size.width * .045,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 11.0),
                                      child: GestureDetector(
                                        // splashColor: Colors.white,
                                        // radius: 100,
                                        onTap: () async {
                                          // allNotes = "";
                                          // getAllNotes().whenComplete(() => _write(allNotes, context));

                                          makeCSVAndSaveIt();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.phone_android,
                                                    size: size.width * .045,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text: "  locally",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'varela-round.regular',
                                                        fontSize: size.width * .045,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: size.width * .1),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.sync,
                                                size: size.width * .039,
                                                color: Colors.orangeAccent,
                                              ),
                                            ),
                                            TextSpan(
                                                text: "  sync notes:",
                                                style: TextStyle(
                                                    color: Colors.orangeAccent,
                                                    fontFamily:
                                                        'varela-round.regular',
                                                    fontSize: size.width * .035,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  final Directory? directory = Platform
                                                          .isAndroid
                                                      ? await getExternalStorageDirectory() //FOR ANDROID
                                                      : await getApplicationSupportDirectory(); //FOR iOS
                                                  final File file = File(
                                                      '${directory?.path}/notes.csv');
                                                  if (file.existsSync()) {
                                                    copyCSVToDB("1", context);
                                                  } else {
                                                    message =
                                                        " sorry no note(s) found to be synced...";
                                                    showCustomSnackBar();
                                                  }


                                                  final File file2 = File(
                                                      '${directory?.path}/tasks.csv');
                                                  if (file2.existsSync()) {
                                                    copyTaskCSVToDB("1", context);
                                                  } else {
                                                    message =
                                                        " sorry no task(s) found to be synced...";
                                                    showCustomSnackBar();
                                                  }



                                                },
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Icon(
                                                          Icons.data_usage,
                                                          size: size.width * .045,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              "  from app data",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'varela-round.regular',
                                                              fontSize: size.width * .045,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 3.0, 8, 8),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  copyCSVToDB("2", context);
                                                },
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Icon(
                                                          Icons.folder_open,
                                                          size: size.width * .045,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text: "  choose file",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'varela-round.regular',
                                                              fontSize: size.width * .045,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 8, 19),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    _isProgressVisible = true;
                                                  });
                                                  syncNotesAndTasksFromCloud();
                                                },
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Icon(
                                                          Icons
                                                              .cloud_download_outlined,
                                                          size: size.width * .045,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text: "  from cloud",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'varela-round.regular',
                                                              fontSize: size.width * .045,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
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
                              ),
                              Visibility(
                                visible: v,
                                child: Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Card(
                                      color: Colors.orangeAccent,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(0),
                                            bottom: Radius.circular(19)),
                                      ),
                                      child: SizedBox(
                                        width: size.width,
                                        height: size.height * .055,
                                        child: Center(
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    Icons.done_all,
                                                    size: size.height * .021,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text: message,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'varela-round.regular',
                                                        fontSize:
                                                            size.height * .017,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _isProgressVisible,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> copyCSVToDB(String key, BuildContext context) async {
    List<String> title = [], note = [], theme = [], time = [];
    List<List<dynamic>> temp = [];

    if (key == "1") {
      final Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory(); //FOR iOS
      final File file = File('${directory?.path}/notes.csv');

      temp = await file
          .openRead()
          .transform(utf8.decoder)
          .transform(
            const CsvToListConverter(),
          )
          .toList();
    }
    if (key == "2") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['csv'],
        type: FileType.custom,
      );
      // if (result != null) {
      String? path1 = result?.files.first.path;
      final file = File(path1!).openRead();

      temp = await file
          .transform(utf8.decoder)
          .transform(
            const CsvToListConverter(),
          )
          .toList();
    }
    for (int i = 0; i < temp.length; i++) {
      title.add(temp[i][1].toString());
      note.add(temp[i][2].toString());
      theme.add(temp[i][3].toString());
      time.add(temp[i][4].toString());
    }

    initiateDB()
        .whenComplete(() => uploadData(context, title, note, theme, time));
  }

  Future<void> copyTaskCSVToDB(String key, BuildContext context) async {
    List<String> task = [], schedule = [], theme = [], time = [], pending = [];
    List<List<dynamic>> temp = [];

    if (key == "1") {
      final Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory(); //FOR iOS
      final File file = File('${directory?.path}/tasks.csv');

      temp = await file
          .openRead()
          .transform(utf8.decoder)
          .transform(
            const CsvToListConverter(),
          )
          .toList();
    }
    if (key == "2") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['csv'],
        type: FileType.custom,
      );
      // if (result != null) {
      String? path1 = result?.files.first.path;
      final file = File(path1!).openRead();

      temp = await file
          .transform(utf8.decoder)
          .transform(
            const CsvToListConverter(),
          )
          .toList();
    }
    for (int i = 0; i < temp.length; i++) {
      task.add(temp[i][1].toString());
      theme.add(temp[i][2].toString());
      time.add(temp[i][3].toString());
      pending.add(temp[i][4].toString());
      schedule.add(temp[i][5].toString());
    }

    initiateTaskDB()
        .whenComplete(() => uploadTaskData(context, task, theme, time, pending, schedule));
  }

  Future<void> getAllNotes() async {
    list = await database.rawQuery('SELECT * FROM Notes');
    await initiateTaskDB();



    for (int i = 0; i < list.length; i++) {
      allNotes += '\n' +
          list[i]["title"].toString().replaceAll('\n', "endL") +
          '\n' +
          list[i]["note"].toString().replaceAll('\n', "endL") +
          '\n';
    }
  }

  Future<void> getAllTasks() async {
    list2 = (await database2.rawQuery('SELECT * FROM Tasks'));
  }

  var fileAddress = "";
  late List<List<dynamic>> temp;

  void makeCSVAndSaveIt() async {
    if (list.isEmpty && list2.isEmpty) {
      message = " sorry nothing to backup...";
      showCustomSnackBar();
      return;
    }
    List<List<dynamic>> rows = [];
    for (int i = 0; i < list.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add(list[i]["id"].toString());
      row.add(list[i]["title"].toString());
      row.add(list[i]["note"].toString());
      row.add(list[i]["theme"]);
      row.add(list[i]["time"].toString());
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);
    temp = const CsvToListConverter().convert(csv);

    print(temp[0][2].toString());
    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS

    final File file = File('${directory?.path}/notes.csv');
    fileAddress = '${directory?.path}/notes.csv';

    file.writeAsString(csv);




    List<List<dynamic>> rows2 = [];
    for (int i = 0; i < list2.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add(list2[i]["id"].toString());
      row.add(list2[i]["task"].toString());
      row.add(list2[i]["theme"]);
      row.add(list2[i]["time"].toString());
      row.add(list2[i]["pending"].toString());
      row.add(list2[i]["schedule"].toString());
      rows2.add(row);
    }

    String csv2 = const ListToCsvConverter().convert(rows2);
    temp = const CsvToListConverter().convert(csv2);

    print(temp[0][2].toString());
    final Directory? directory2 = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS

    final File file2 = File('${directory2?.path}/tasks.csv');
    fileAddress = '${directory2?.path}/tasks.csv';

    file2.writeAsString(csv2);
    message = "  local backup successful...";
    showCustomSnackBar();
  }

  void showCustomSnackBar() {
    setState(() {
      v = true;
    });
    Timer(const Duration(seconds: 3), () {
      // 5 seconds have past, you can do your work
      setState(() {
        v = false;
      });
    });
  }
}
