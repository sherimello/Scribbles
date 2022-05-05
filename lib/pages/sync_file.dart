import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribbles/pages/upload_emo.dart';
import 'package:sqflite/sqflite.dart';

import '../popup_card/custom_rect_tween.dart';
import '../popup_card/hero_dialog_route.dart';
import 'home.dart';

class SyncFile extends StatefulWidget {
  final String string;

  const SyncFile(this.string, {Key? key}) : super(key: key);

  @override
  State<SyncFile> createState() => _SyncFileState();
}

class _SyncFileState extends State<SyncFile> {
  late String path;
  late Database database;
  late List<Map> list;
  int size = 0;
  late String fetchedNotes, s = '\n\n';
  List<String> title = [], note = [];

  Future<void> initiateDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'demo.db');
    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY, title NVARCHAR(MAX), note NVARCHAR(MAX))');
    });
  }

  String allNotes = '', divider = ",.,.,.,;';';';,.,.,.,";

  showData(BuildContext context) async {
    list = (await database.rawQuery('SELECT * FROM Notes'));

    for (int i = 0; i < list.length; i++) {
      allNotes += divider +
          '\n' +
          list[i]["title"].toString() +
          '\n' +
          list[i]["note"].toString() +
          '\n';
    }

    if (list.isNotEmpty) {}
    print(allNotes);
    size = list.length;
    _write(allNotes, context);
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    initiateDB();
    // _signOut();
    super.initState();
  }

  Future<void> uploadData(
      BuildContext context, List<String> title, List<String> note) async {
    await database.transaction((txn) async {
      for (int i = 0; i < title.length; i++) {
        int id1 = await txn.rawInsert(
            'INSERT INTO Notes(title, note) VALUES(?, ?)', [title[i], note[i]]);
        if (kDebugMode) {
          print('inserted1: $id1');
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  bool v = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Hero(
      tag: widget.string,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
          ),
          color: Colors.white,
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 19.0, 8, 8),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 17,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                  TextSpan(
                                      text: "  backup notes:",
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontFamily: 'varela-round.regular',
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
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
                                Navigator.of(context).push(HeroDialogRoute(
                                  builder: (context) => Center(
                                      child: UploadDemo(
                                          string: widget.string,
                                          allNotes: allNotes)
                                      // child: WidTest()
                                      ),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 11.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.add_to_drive,
                                          size: 19,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                          text: "  to Google Drive",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily:
                                                  'varela-round.regular',
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 11.0),
                            child: GestureDetector(
                              // splashColor: Colors.white,
                              // radius: 100,
                              onTap: () async {
                                // allNotes = "";
                                // getAllNotes().whenComplete(() => _write(allNotes, context));

                                makeCSVAndSaveIt();

                                setState(() {
                                  v = true;
                                });
                                Timer(const Duration(seconds: 3), () {
                                  // 5 seconds have past, you can do your work
                                  setState(() {
                                    v = false;
                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.phone_android,
                                          size: 19,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                          text: "  locally",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily:
                                                  'varela-round.regular',
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.sync,
                                      size: 17,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                  TextSpan(
                                      text: "  sync notes:",
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontFamily: 'varela-round.regular',
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final Directory? directory = Platform
                                                .isAndroid
                                            ? await getExternalStorageDirectory() //FOR ANDROID
                                            : await getApplicationSupportDirectory(); //FOR iOS
                                        final File file = File(
                                            '${directory?.path}/notes.csv');
                                        if (file.existsSync()) {
                                          copyCSVToDB(
                                              '${directory?.path}/notes.csv',
                                              context);
                                        } else {
                                          print("null");
                                        }
                                      },
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.data_usage,
                                                size: 21,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                                text: "  from app data",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'varela-round.regular',
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 3.0, 8, 19),
                                    child: GestureDetector(
                                      onTap: () async {
                                        FilePickerResult? result =
                                            await FilePicker.platform
                                                .pickFiles(type: FileType.any);
                                        if (result != null) {
                                          // File file =
                                          //     File(result.files.single.path!);
                                          // fetchedNotes =
                                          //     file.readAsStringSync();
                                          // writeDataToDB(file, context);

                                          // final csvFile = File(result.files.single.path!).openRead();

                                          copyCSVToDB(result.files.single.path!,
                                              context);
                                        } else {
                                          if (kDebugMode) {
                                            print('no file picked!');
                                            // User canceled the picker

                                          }
                                        }
                                      },
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: const TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.folder_open,
                                                size: 21,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                                text: "  choose file",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'varela-round.regular',
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.bold)),
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
                                          text: "  local backup successful...",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily:
                                                  'varela-round.regular',
                                              fontSize: size.height * .017,
                                              fontWeight: FontWeight.bold)),
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
    );
  }

  _write(String text, BuildContext context) async {
    print(allNotes);
    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    final File file = File('${directory?.path}/cloud.txt');
    print('${directory?.path}/cloud.txt');
    if (file.existsSync()) {
      file.delete().whenComplete(() async => await file.writeAsString(text));
    } else {
      await file.writeAsString(text);
    }
  }

  Future<void> copyCSVToDB(String filePath, BuildContext context) async {
    List<String> title = [], note = [];
    List<List<dynamic>> temp = [];
    final csvFile = File(path).openRead();
    temp = await csvFile
        .transform(base64.decoder)
        .transform(
          const CsvToListConverter(),
        )
        .toList();
    for (int i = 0; i < temp.length; i++) {
      title.add(temp[i][1].toString());
      note.add(temp[i][2].toString());
    }
    uploadData(context, title, note);
  }

  void writeDataToDB(File file, BuildContext context) {
    List<String> title = [], note = [];
    // print(fetchedNotes);
    LineSplitter ls = const LineSplitter();
    List<String> lines = ls.convert(fetchedNotes);

    if (lines.isEmpty) {
      print('lines is empty');
    }

    var temp = "";

    for (int i = 0; i < lines.length; i++) {
      // print('in');

      if (i > 0) {
        if (lines[i - 1] == '') {
          title.add(lines[i].replaceAll('endL', '\n'));
        } else {
          if ((lines[i] != "")) {
            temp += lines[i].replaceAll('endL', '\n');
            if (i == lines.length - 1) {
              note.add(temp);
              temp = "";
            }
          } else {
            note.add(temp);
            temp = "";
          }
        }
      }
    }

    if (kDebugMode) {
      print(title.length.toString() + " " + note.length.toString());
    }
    var x = "";
    for (int i = 0; i < note.length; i++) {
      print(title[i] + '\n' + note[i] + '\n\n');
    }
    uploadData(context, title, note);
  }

  void readFromAppData(BuildContext context) async {
    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    final File file = File('${directory?.path}/cloud.txt');
    if (file.existsSync()) {
      fetchedNotes = file.readAsStringSync();
      writeDataToDB(file, context);
    }
  }

  Future<void> getAllNotes() async {
    list = (await database.rawQuery('SELECT * FROM Notes'));

    for (int i = 0; i < list.length; i++) {
      allNotes += '\n' +
          list[i]["title"].toString().replaceAll('\n', "endL") +
          '\n' +
          list[i]["note"].toString().replaceAll('\n', "endL") +
          '\n';
    }
  }

  var fileAddress = "";
  late List<List<dynamic>> temp;

  void makeCSVAndSaveIt() async {
    List<List<dynamic>> rows = [];
    for (int i = 0; i < list.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add(list[i]["id"].toString());
      row.add(list[i]["title"].toString());
      row.add(list[i]["note"].toString());
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
  }
}
