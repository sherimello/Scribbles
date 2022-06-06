import 'package:flutter/material.dart';
import 'package:scribbles/hero_transition_handler/custom_rect_tween.dart';
import 'package:scribbles/hero_transition_handler/hero_dialog_route.dart';
import 'package:scribbles/hero_transition_handler/models.dart';
import 'package:scribbles/widgets/note_card.dart';
import 'package:scribbles/widgets/simplified_delete_card.dart';

class PreviewCard extends StatelessWidget {
  final String title, note, id, noteID, theme, time;

  const PreviewCard(
      {Key? key,
      required this.id,
      required this.time,
      required this.title,
      required this.note,
      required this.noteID,
      required this.theme})
      : super(key: key);

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
          bgColor: Color(int.parse(theme)),
          builder: (context) => Center(
            child: SimplifiedDeleteCard(noteID, id, theme),
            // child: DeleteCard(widget.id, widget.title, widget.note, widget.noteID),
          ),
          // settings: const RouteSettings(),
        ));
      },
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(
          builder: (context) => SafeArea(child: Center(child: NoteCard(noteID, id, title, note, time, theme))),
          // settings: const RouteSettings(),
        ));
      },
      child: Hero(
        tag: id,
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
            color: Color(int.parse(theme)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: const [
                    //       Spacer(),
                    //       RotationTransition(
                    //         turns: AlwaysStoppedAnimation(45 / 360),
                    //         child: Icon(
                    //           Icons.push_pin_sharp,
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 13, 0, 5),
                      child: Text(
                        // t1,
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            fontFamily: 'varela-round.regular'),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                          fontSize: 11,
                          fontFamily: 'Rounded_Elegance'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,13,0,8),
                      child: Text(
                        // t1,
                        note,
                        maxLines: 7,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            fontFamily: 'Rounded_Elegance',
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class _TodoPopupCard extends StatefulWidget {
  // const _TodoPopupCard({Key key, required this.todo}) : super(key: key);
  // final Todo todo;

  // const _TodoPopupCard(this.todo);

  @override  State<_TodoPopupCard> createState() => _TodoPopupCardState();
}

class _TodoPopupCardState extends State<_TodoPopupCard> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '1',
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blueGrey,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // _TodoTitle(title: todo.description),
                    const SizedBox(
                      height: 8,
                    ),
                    // if (widget.todo.items != null) ...[
                    const Divider(),
                    // _TodoItemsBox(items: todo.items),
                    // ],
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const TextField(
                        maxLines: 8,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            hintText: 'Write a note...',
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
