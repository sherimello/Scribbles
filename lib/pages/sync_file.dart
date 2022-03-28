import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../popup_card/custom_rect_tween.dart';

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

  showData() async {
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
    _write(allNotes);
  }

  @override
  void initState() {
    // TODO: implement initState
    initiateDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 19.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          // splashColor: Colors.white,
                          // radius: 100,
                          onTap: () {
                            showData();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 19,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                      text: "  backup notes",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'varela-round.regular',
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          // splashColor: Colors.white,
                          // radius: 100,
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.sync,
                                      size: 19,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                      text: "  sync notes",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'varela-round.regular',
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
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
      ),
    );
  }

  _write(String text) async {
    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    final File file = File('${directory?.path}/my_file.txt');
    print('${directory?.path}/my_file.txt');
    file.delete().whenComplete(() async => await file.writeAsString(text));
  }
}
