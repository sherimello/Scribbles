import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class OlderClasses {
  String fetchedNotes = "";
  late Database database;

  void readFromAppData(BuildContext context) async {
    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS
    final File file = File('${directory?.path}/cloud.txt');
    if (file.existsSync()) {
      var fetchedNotes = file.readAsStringSync();
      writeDataToDB(file, context);
    }
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
    });
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
