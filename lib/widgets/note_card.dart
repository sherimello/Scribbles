import 'package:flutter/material.dart';

import '../popup_card/custom_rect_tween.dart';

class NoteCard extends StatelessWidget {
  final String string, title, note, date;

  const NoteCard(this.string, this.title, this.note, this.date, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: string,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
        color: Colors.orangeAccent[200],
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .85,
          height: MediaQuery.of(context).size.height * .65,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Spacer(),
                          Icon(
                            Icons.push_pin_sharp,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        // t1,
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                    ),
                    Text(
                      // t1,
                      note,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
