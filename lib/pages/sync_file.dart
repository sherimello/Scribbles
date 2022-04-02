import 'dart:async';
import 'dart:convert' show LineSplitter, utf8;
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scribbles/pages/upload_emo.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/GoogleAuthClient.dart';
import '../popup_card/custom_rect_tween.dart';
import '../popup_card/hero_dialog_route.dart';

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
                        padding: const EdgeInsets.all(11.0),
                        child: GestureDetector(
                          // splashColor: Colors.white,
                          // radius: 100,
                          onTap: () async {
                            list = (await database
                                .rawQuery('SELECT * FROM Notes'));

                            for (int i = 0; i < list.length; i++) {
                              allNotes += '\n\n' +
                                  list[i]["title"]
                                      .toString()
                                      .replaceAll('\n', "endL") +
                                  '\n' +
                                  list[i]["note"]
                                      .toString()
                                      .replaceAll('\n', "endL");
                            }
                            if (allNotes.isNotEmpty) {
                              print(allNotes);
                              final box =
                                  context.findRenderObject() as RenderBox?;
                              await Share.share(allNotes,
                                  subject: 'cloud.txt',
                                  sharePositionOrigin:
                                      box!.localToGlobal(Offset.zero) &
                                          box.size);
                            } else
                              print("empty");

                            List<String> title = [], note = [];

                            LineSplitter ls = const LineSplitter();
                            List<String> lines = ls.convert(allNotes);

                            for (int i = 2; i < lines.length; i++) {
                              if (lines[i - 1] == '\n' &&
                                  lines[i - 2] == '\n') {
                                title.add(lines[i]);
                                continue;
                              }
                              if (lines[i - 1] == '\n') note.add(lines[i]);
                            }

                            String s = "";

                            for (int i = 0; i < title.length; i++) {
                              s += title[i] + note[i];
                            }

                            print(s);

                            // _downloadGoogleDriveFile("fName", "gdID");
                            // _download();
                            // _showList(context);
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
                        padding: const EdgeInsets.only(top:8.0),
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
                                  onTap: () {},
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
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(HeroDialogRoute(
                                      builder: (context) => Center(
                                        child: UploadDemo(string: widget.string)
                                      ),
                                      // settings: const RouteSettings(),
                                    ));
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
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // RichText(
                              //   textAlign: TextAlign.center,
                              //   text: const TextSpan(
                              //     children: [
                              //       WidgetSpan(
                              //         child: Icon(
                              //           Icons.sync,
                              //           size: 19,
                              //           color: Colors.black,
                              //         ),
                              //       ),
                              //       TextSpan(
                              //           text: "  sync notes",
                              //           style: TextStyle(
                              //               color: Colors.black,
                              //               fontFamily: 'varela-round.regular',
                              //               fontSize: 21,
                              //               fontWeight: FontWeight.bold)),
                              //     ],
                              //   ),
                              // ),
                            ],
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

  _write(String text, BuildContext context) async {
    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    final File file = File('${directory?.path}/my_file.txt');
    print('${directory?.path}/my_file.txt');
    file.delete().whenComplete(() async => await file
        .writeAsString(text)
        .whenComplete(() => _signInForDrive(file, context)));
  }

  Future<void> _signInForDrive(File file1, BuildContext context) async {
    final googleSignIn = GoogleSignIn.standard(scopes: [
      drive.DriveApi.driveAppdataScope,
    ]);
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;

    final client = GoogleAuthClient(headers!);
    final driveApi = drive.DriveApi(client);

    try {
      final authHeaders = await googleUser?.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders!);
      final driveApi = drive.DriveApi(authenticateClient);
      // Not allow a user to do something else
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(seconds: 2),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      // Create data here instead of loading a file
      const contents = "Technical Feeder";
      final Stream<List<int>> mediaStream =
          Future.value(allNotes.codeUnits).asStream().asBroadcastStream();
      var media = drive.Media(mediaStream, allNotes.length);

      // Set up File info
      var driveFile = drive.File();
      final timestamp = DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
      driveFile.name = "scribbles-$timestamp.txt";
      driveFile.modifiedTime = DateTime.now().toUtc();
      driveFile.parents = ["appDataFolder"];
      // Upload
      final response =
          await driveApi.files.create(driveFile, uploadMedia: media);
    } finally {
      // Remove a dialog
      Navigator.pop(context);
    }
  }

  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
  ]);

  Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      // await showMessage(context, "Sign-in first", "Error");
      return null;
    }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return driveApi;
  }

  Future<void> _showList(BuildContext context) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }

    final fileList = await driveApi.files.list(
        spaces: 'appDataFolder', $fields: 'files(id, name, modifiedTime)');
    final files = fileList.files;
    if (files == null) {
      // return showMessage(context, "Data not found", "");
    }

    final alert = AlertDialog(
      title: const Text("Item List"),
      content: SingleChildScrollView(
        child: ListBody(
          children: files!.map((e) => Text(e.name ?? "no-name")).toList(),
        ),
      ),
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  Future<void> _download() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }

    final fileList = await driveApi.files.list(
        spaces: 'appDataFolder', $fields: 'files(id, name, modifiedTime)');
    final files = fileList.files;

    final fileId = files?.asMap()[0]?.id;

    final authToken = _getAuthToken();
    // final headers = {'Authorization': 'Bearer $authToken'};
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    final url = 'https://www.googleapis.com/drive/v3/files/$fileId?alt=media';

    var httpClient = HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var decoded = utf8.decode(bytes);
    print(decoded);
  }

  // _uploadFileToGoogleDrive() async {
  //   var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
  //   var driveApi = drive.DriveApi(client);
  //   drive.File fileToUpload = drive.File();
  //   final Directory? directory = Platform.isAndroid
  //       ? await getExternalStorageDirectory() //FOR ANDROID
  //       : await getApplicationSupportDirectory();
  //   final File file = File('${directory?.path}/my_file.txt');
  //   fileToUpload.parents = ["appDataFolder"];
  //   fileToUpload.name = path.(file.absolute.path);
  //   var response = await drive.files.create(
  //     fileToUpload,
  //     uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
  //   );
  //   print(response);
  //   _listGoogleDriveFiles();
  // }
  Future<void> _downloadGoogleDriveFile(String fName, String gdID) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      return;
    }
    final fileList = await driveApi.files.list(
        spaces: 'appDataFolder', $fields: 'files(id, name, modifiedTime)');
    final files = fileList.files;

    final fileId = files?.asMap()[0]?.id;
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    var client = GoogleAuthClient(headers!);
    var _drive = drive.DriveApi(client);
    Object file = await _drive.files
        .get(fileId!, downloadOptions: drive.DownloadOptions.fullMedia);
    print((file as drive.Media).stream);

    final directory = await getExternalStorageDirectory();
    print(directory?.path);
    final saveFile = File(
        '${directory?.path}/${new DateTime.now().millisecondsSinceEpoch}$fName');
    List<int> dataStore = [];
    file.stream.listen((data) {
      print("DataReceived: ${data.length}");
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () {
      print("Task Done");
      saveFile.writeAsBytes(dataStore);
      print("File saved at ${saveFile.path}");
    }, onError: (error) {
      print("Some Error");
    });
  }

  Future<String?> _getAuthToken() async {
    final googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      // await showMessage(context, "Sign-in first", "Error");
      return null;
    }

    final client = GoogleAuthClient(headers);
    final authentication = await googleUser?.authentication;
    return authentication?.accessToken;
  }
}
