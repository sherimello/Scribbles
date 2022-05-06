import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  late Database database;
  late List<Map<String, Object?>> list;
  late List<List<dynamic>> temp;

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
          'CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY, title NVARCHAR(MAX), note NVARCHAR(MAX))');
    });
  }

  showData() async {
    list = (await database.rawQuery('SELECT * FROM Notes'));

    setState(() {
      if (list.isNotEmpty) {
        visible = false;
      }
      print(list.length);
      size = list.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(initiateDB()
        .whenComplete(() => showData())
        .whenComplete(() => convert()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () async {
                final box =
                context.findRenderObject() as RenderBox?;
                Share.shareFiles([fileAddress],
                    subject: 'notes.csv',
                    sharePositionOrigin:
                    box!.localToGlobal(Offset.zero) &
                    box.size);

                // Share.share(widget.allNotes,
                //     subject: 'cloud.txt',
                //     sharePositionOrigin:
                //     box!.localToGlobal(Offset.zero) &
                //     box.size);
                // await FlutterShare.shareFile(
                //     title: 'Notes.csv',
                //     fileType: '*/csv',
                //     filePath: fileAddress
                // );
              },
              child: FutureBuilder(
                future: convert(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  // print(snapshot.data.toString());
                  return snapshot.hasData
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: snapshot.data!
                          .map(
                            (data) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  data[0].toString(),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  data[1].toString(),
                                ),
                              ), Flexible(
                                child: Text(
                                  data[2].toString(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  )
                      : const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  var fileAddress = "";

  Future<List<List<dynamic>>> convert() async {
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

    List<List<dynamic>> rows = [];
    for (int i = 0; i < list.length; i++) {
//row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add(list[i]["id"].toString());
      row.add(list[i]["title"].toString());
      row.add(list[i]["note"].toString());
      rows.add(row);
    }
// convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(rows);
    temp = const CsvToListConverter().convert(csv);

    print(temp[0][2].toString());

    //store file in documents folder

    // String dir = (await getExternalStorageDirectory())!.absolute.path + "/documents";
    // var file = dir;
    // File f = File(file+"filename.csv");
    // fileAddress = file+"filename.csv";

    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    final File file = File('${directory?.path}/notes.csv');
    fileAddress = '${directory?.path}/notes.csv';

    // FilePickerResult? result = await FilePicker.platform
    // .pickFiles(
    //   allowedExtensions: ['csv'],
    //   type: FileType.custom,
    // );

// convert rows to String and write as csv file

    file.writeAsString(csv);

    return const CsvToListConverter().convert(csv);
  }
}
