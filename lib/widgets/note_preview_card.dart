import 'package:flutter/material.dart';
import 'package:scribbles/pages/note_page.dart';
import 'package:scribbles/popup_card/custom_rect_tween.dart';
import 'package:scribbles/popup_card/hero_dialog_route.dart';
import 'package:scribbles/popup_card/models.dart';
import 'package:scribbles/widgets/note_card.dart';

class PreviewCard extends StatefulWidget {
  final String title, note, id;

  const PreviewCard({Key? key, required this.id, required this.title, required this.note}) : super(key: key);

  @override
  State<PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<PreviewCard> {
  late String t1, t2, date;
  late Todo todo;

  // late Key key;
  @override
  void initState() {
    t1 =
        'jhasjkhdiuiashiudyhiausdoijasiojdojoasjioljdoiaiojsiodjoiasjiodjioajoidajsoijdojasiodjojaosjdojoias';
    t2 = "hello";
    date = '19-3-93';
    // todo = Todo(id: '');
    // key = const Key();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String id = widget.index.toString();
    return InkWell(
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(
          builder: (context) => Center(
            child: NoteCard(widget.id, widget.title, widget.note, date),
          ),
          // settings: const RouteSettings(),
        ));
      },
      child: Hero(
        tag: widget.id,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Card(
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
            // color: Colors.teal[200],
            color: Colors.orangeAccent[200],
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Spacer(),
                        RotationTransition(
                          turns: AlwaysStoppedAnimation(45 / 360),
                          child: Icon(
                            Icons.push_pin_sharp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      // t1,
                      widget.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 19, fontFamily: 'varela-round.regular'),
                    ),
                  ),Text(
                    // t1,
                    widget.note,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      date,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  )
                ],
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

  @override
  State<_TodoPopupCard> createState() => _TodoPopupCardState();
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
