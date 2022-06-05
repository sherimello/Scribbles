import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../popup_card/custom_rect_tween.dart';

class UploadToDrive extends StatefulWidget {
  final String string, allNotes;
  final bool visible = false;

  const UploadToDrive({Key? key, required this.string, required this.allNotes})
      : super(key: key);

  static final snackBar = SnackBar(
    content: RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.sentiment_very_dissatisfied_outlined,
              size: 21,
              color: Colors.black,
            ),
          ),
          TextSpan(
              text: "  sorry! no notes were found...",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'varela-round.regular',
                  fontSize: 21,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    // Text('sorry! no notes were found...'),
  );

  @override
  State<UploadToDrive> createState() => _UploadToDriveState();
}

_write(String text, BuildContext context) async {
  final Directory? directory = Platform.isAndroid
      ? await getExternalStorageDirectory() //FOR ANDROID
      : await getApplicationSupportDirectory(); //FOR iOS
  final File file = File('${directory?.path}/cloud.txt');
  print('${directory?.path}/cloud.txt');
  if (file.existsSync()) {
    file.delete().whenComplete(() async => await file.writeAsString(text));
  }
}

class _UploadToDriveState extends State<UploadToDrive> {
  bool v = false;
  String errorMessage = "";

  late Database database;
  late List<Map<String, Object?>> list;

// Get a location using getDatabasesPath
  late String path;
  int size = 0;
  bool visible = true;

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
    list = (await database.rawQuery('SELECT * FROM Notes'));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiateDB().whenComplete(() => makeCSVAndSaveIt().whenComplete(() {
          setState(() {
            visible = true;
          });
        }));
    // makeCSVAndSaveIt();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print((size.height * .65) / ((size.height * .65 * 9) / 20));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Hero(
          tag: widget.string,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Card(
                  color: const Color(0xffF8F0E3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(31),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height * .75,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 17.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Container(
                              width: (size.height * .41 * 9) / 20,
                              height: size.height * .41,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(21)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.25),
                                    spreadRadius: 3,
                                    blurRadius: 31,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset('lib/assets/images/demo.gif'),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(13.0, 21, 13.0, 21),
                            child: Text(
                              'choose "Google Drive" in the next window as demonstrated in the clip above...',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'varela-round.regular',
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 15.0),
                            child: GestureDetector(
                              onTap: () async {
                                if (list.isNotEmpty) {
                                  final box =
                                      context.findRenderObject() as RenderBox?;
                                  Share.shareFiles([fileAddress],
                                      subject: 'notes.csv',
                                      sharePositionOrigin:
                                          box!.localToGlobal(Offset.zero) &
                                              box.size);
                                } else {
                                  setState(() {
                                    errorMessage =
                                        " sorry no note(s) to backup...";
                                    v = true;
                                  });
                                  Timer(const Duration(seconds: 3), () {
                                    // 5 seconds have past, you can do your work
                                    setState(() {
                                      v = false;
                                    });
                                  });
                                }
                              },
                              child: Container(
                                width: size.width * .45,
                                height: size.height * .05,
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.25),
                                      spreadRadius: 1,
                                      blurRadius: 31,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Visibility(
                                  visible: visible,
                                  child: const Center(
                                    child: Text(
                                      'continue',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "varela-round.regular"),
                                    ),
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
              Visibility(
                visible: v,
                child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(0),
                            bottom: Radius.circular(19)),
                      ),
                      child: SizedBox(
                        width: size.width * .9,
                        height: size.height * .055,
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.sentiment_very_dissatisfied_outlined,
                                    size: size.height * .021,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                    text: errorMessage,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'varela-round.regular',
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
    );
  }

  var fileAddress = "";
  late List<List<dynamic>> temp;

  Future<void> makeCSVAndSaveIt() async {
    if (list.isEmpty) {
      setState(() {
        errorMessage = " sorry no note(s) to backup...";
        v = true;
      });
      Timer(const Duration(seconds: 3), () {
        // 5 seconds have past, you can do your work
        setState(() {
          v = false;
        });
      });
      return;
    }
    List<List<dynamic>> rows = [];
    for (int i = 0; i < list.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add(list[i]["id"].toString());
      row.add(list[i]["title"].toString());
      row.add(list[i]["note"].toString());
      row.add(list[i]["theme"].toString());
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
  }
}
