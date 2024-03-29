import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scribbles/hero_transition_handler/custom_rect_tween.dart';
import 'package:scribbles/hero_transition_handler/hero_dialog_route.dart';
import 'package:scribbles/hero_transition_handler/models.dart';
import 'package:scribbles/widgets/simplified_delete_card.dart';
import 'package:sqflite/sqflite.dart';

import '../classes/my_sharedpreferences.dart';

class TaskPreviewCard extends StatefulWidget {
  final String id, task, theme, time, taskID, schedule;
  final bool pending;

  const TaskPreviewCard(
      {Key? key,
      required this.id,
      required this.time,
      required this.theme,
      required this.task,
      required this.pending,
      required this.taskID,
      required this.schedule})
      : super(key: key);

  @override
  State<TaskPreviewCard> createState() => _TaskPreviewCardState();
}

class _TaskPreviewCardState extends State<TaskPreviewCard> {
  late bool isChecked = widget.pending;
  late Database database;
  late String path;

  Future<void> initiateDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'tasks.db');
    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Tasks (id INTEGER PRIMARY KEY, task NVARCHAR, theme NVARCHAR, time NVARCHAR, pending BOOLEAN)');
    });
  }

  int boolToInt(bool b) => b ? 1 : 0;

  Future<void> updateData(bool newPendingState) async {
    await database.transaction((txn) async {
      database.rawUpdate('UPDATE Tasks SET pending = ? WHERE id = ?',
          [newPendingState ? 1 : 0, widget.taskID]);
    });
  }

  uploadDataToFirebase() async {
    // Firebase.initializeApp();
    String userName = await MySharedPreferences().getStringValue("userName");
    final ref2 = FirebaseDatabase.instance.ref().child('tasks');

    print(userName);
    ref2
        .child(userName)
        .child((widget.time.replaceAll('\n', ' ')))
        .set({
          'task': widget.task.toString(),
          'theme': widget.theme.toString(),
          'time': widget.time.toString(),
          'pending': isChecked == true ? "true" : "false",
          'schedule': widget.schedule,
        })
        .asStream()
        .listen((event) {}, onDone: () {
          //........................
        });
  }

  bool isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    late String t1, t2, date;
    late Todo todo;
    t1 =
        'jhasjkhdiuiashiudyhiausdoijasiojdojoasjioljdoiaiojsiodjoiasjiodjioajoidajsoijdojasiodjojaosjdojoias';
    t2 = "hello";
    date = '19-3-93';

    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onLongPress: () {
        setState(() {
          isLongPressed = true;
        });
        Navigator.of(context).push(HeroDialogRoute(
          bgColor: Color(int.parse(widget.theme)),
          builder: (context) => Center(
            child: SimplifiedDeleteCard(
                "task", widget.taskID, widget.id, widget.theme),
            // child: DeleteCard(widget.id, widget.title, widget.note, widget.noteID),
          ),
          // settings: const RouteSettings(),
        ));
      },
      onLongPressCancel: () => setState(() {
        isLongPressed = false;
      }),
      onTap: () async {
        if (isLongPressed == false) {
          setState(() {
            isChecked = !isChecked;
          });
          uploadDataToFirebase();
          print(isChecked);
          print(widget.taskID);
          await initiateDB().whenComplete(() => updateData(isChecked));
        }
      },
      child: Hero(
        tag: widget.id,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                color: isChecked
                    ? Color(int.parse(widget.theme)).withOpacity(.19)
                    : Color(int.parse(widget.theme)),
                borderRadius: BorderRadius.circular(31),
              ),
              // color: Colors.teal[200],
              // color: Colors.pink.withOpacity(.31),
              // color: Colors.orange.withOpacity(.31),
              // color: Colors.red.withOpacity(.31),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * .057,
                        height: size.width * .057,
                        child: Checkbox(
                            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(500)),
                            side: MaterialStateBorderSide.resolveWith(
                              (states) => const BorderSide(
                                  width: 2.0, color: Colors.black),
                            ),
                            activeColor: Colors.black,
                            checkColor: Color(int.parse(widget.theme)),
                            value: isChecked,
                            onChanged: (checkedState) async {
                              setState(() {
                                isChecked = checkedState!;
                              });
                              uploadDataToFirebase();
                              await initiateDB().whenComplete(() {
                                updateData(checkedState!);
                              });
                            }),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: size.width - size.width * .057 - 67,
                        child: Text.rich(TextSpan(
                            style: TextStyle(height: 0),
                            children: [
                              TextSpan(
                                text: widget.task,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    decoration: isChecked
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontFamily: 'varela-round.regular'),
                              ),
                              TextSpan(
                                text: "\n${widget.time}",
                                style: TextStyle(
                                    height: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(.55),
                                    fontSize: 11,
                                    decoration: isChecked
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontFamily: 'Rounded_Elegance'),
                              ),
                            ])),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
