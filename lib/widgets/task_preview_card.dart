import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scribbles/hero_transition_handler/custom_rect_tween.dart';
import 'package:scribbles/hero_transition_handler/hero_dialog_route.dart';
import 'package:scribbles/hero_transition_handler/models.dart';
import 'package:scribbles/widgets/simplified_delete_card.dart';
import 'package:sqflite/sqflite.dart';

class TaskPreviewCard extends StatefulWidget {
  final String id, task, theme, time, taskID;
  final bool pending;

  const TaskPreviewCard(
      {Key? key,
      required this.id,
      required this.time,
      required this.theme,
      required this.task,
      required this.pending,
      required this.taskID})
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
          [boolToInt(newPendingState), widget.taskID]);
    });
  }

  @override
  Widget build(BuildContext context) {
    late String t1, t2, date;
    late Todo todo;
    t1 =
        'jhasjkhdiuiashiudyhiausdoijasiojdojoasjioljdoiaiojsiodjoiasjiodjioajoidajsoijdojasiodjojaosjdojoias';
    t2 = "hello";
    date = '19-3-93';
    return InkWell(
      onLongPress: () {
        Navigator.of(context).push(HeroDialogRoute(
          bgColor: Color(int.parse(widget.theme)),
          builder: (context) => Center(
            child: SimplifiedDeleteCard(widget.taskID, widget.id, widget.theme),
            // child: DeleteCard(widget.id, widget.title, widget.note, widget.noteID),
          ),
          // settings: const RouteSettings(),
        ));
      },
      onTap: () async {
        setState(() {
          isChecked = !isChecked;
        });
        print(isChecked);
        print(widget.taskID);
        await initiateDB().whenComplete(() => updateData(isChecked));
      },
      child: Hero(
        tag: widget.id,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(31),
            ),
            // color: Colors.teal[200],
            // color: Colors.pink.withOpacity(.31),
            // color: Colors.orange.withOpacity(.31),
            // color: Colors.red.withOpacity(.31),
            color: Color(int.parse(widget.theme)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 13, 0, 5),
                      child: Row(
                        children: [
                          Checkbox(
                              activeColor: Colors.white,
                              checkColor: Color(int.parse(widget.theme)),
                              value: isChecked,
                              onChanged: (checkedState) {
                                setState(() {
                                  isChecked = checkedState!;
                                });
                              }),
                          Text(
                            // t1,
                            widget.task,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                                fontFamily: 'varela-round.regular'),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.time,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                          fontSize: 11,
                          fontFamily: 'Rounded_Elegance'),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
