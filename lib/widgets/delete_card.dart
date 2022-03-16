import 'package:flutter/material.dart';

import '../popup_card/custom_rect_tween.dart';

class DeleteCard extends StatelessWidget {
  final String string, title, note;

  const DeleteCard(this.string, this.title, this.note, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: string,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .81,
          child: Card(
            color: Colors.red,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(19)),
            ),
            elevation: 11,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 15, 8, 17),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    // alignment: WrapAlignment.center,
                    // crossAxisAlignment: WrapCrossAlignment.center,
                    // direction: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          // t1,
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              fontFamily: 'varela-round.regular'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          // t1,
                          note,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontFamily: 'Rounded_Elegance'),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 31,
                            ),
                          ))
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
}