import 'package:flutter/material.dart';
import 'package:scribbles/hero_transition_handler/custom_rect_tween.dart';
import 'package:scribbles/hero_transition_handler/hero_dialog_route.dart';
import 'package:scribbles/hero_transition_handler/models.dart';
import 'package:scribbles/widgets/note_card.dart';
import 'package:scribbles/widgets/simplified_delete_card.dart';

class TaskPreviewCard extends StatefulWidget {
  final String title, id, noteID, theme, time;

  const TaskPreviewCard(
      {Key? key,
        required this.id,
        required this.time,
        required this.title,
        required this.noteID,
        required this.theme})
      : super(key: key);

  @override
  State<TaskPreviewCard> createState() => _TaskPreviewCardState();
}

class _TaskPreviewCardState extends State<TaskPreviewCard> {
  late bool isChecked = false;

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
            child: SimplifiedDeleteCard(widget.noteID, widget.id, widget.theme),
            // child: DeleteCard(widget.id, widget.title, widget.note, widget.noteID),
          ),
          // settings: const RouteSettings(),
        ));
      },
      onTap: () {
        // Navigator.of(context).push(HeroDialogRoute(
          // builder: (context) => SafeArea(child: Center(child: NoteCard(noteID, id, title, note, time, theme))),
          // settings: const RouteSettings(),
        // ));
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
                              value: isChecked, onChanged: (checkedState){
                            setState((){
                              isChecked = checkedState!;
                            });
                          }),
                          Text(
                            // t1,
                            widget.title,
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