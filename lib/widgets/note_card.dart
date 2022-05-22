import 'package:flutter/material.dart';

import '../pages/new_note_page_design.dart';
import '../pages/note_page.dart';
import '../popup_card/custom_rect_tween.dart';
import '../popup_card/hero_dialog_route.dart';

class NoteCard extends StatelessWidget {
  final String id, string, title, note, date, theme;

  const NoteCard(this.id, this.string, this.title, this.note, this.date, this.theme, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: string,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(31),
        ),
        color: Color(int.parse(theme)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .85,
          height: MediaQuery.of(context).size.height * .65,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,19.0),
            child: SingleChildScrollView(
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
                            children:  [
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(HeroDialogRoute(
                                    builder: (context) => Center(
                                      child: NewNotePage(id, string, theme),
                                    ),
                                    // settings: const RouteSettings(),
                                  ));
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Center(
                            child: Text(
                              // t1,
                              title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 23, fontFamily: 'varela-round.regular'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Center(
                            child: Text(
                              '(' + date + ')',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                   color: Colors.white54, fontSize: 13, fontFamily: 'Rounded_Elegance'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: SelectableText(
                            // t1,
                            note,
                            showCursor: false,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14, fontFamily: 'Rounded_Elegance'),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
