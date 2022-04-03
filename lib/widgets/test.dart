import 'package:flutter/material.dart';

import '../popup_card/custom_rect_tween.dart';

class WidTest extends StatelessWidget {
  const WidTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print((size.height * .65) / ((size.height * .65 * 9) / 20));
    return Hero(
        tag: "",
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .85,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: size.height * .1),
                      child: Container(
                        width: (size.height * .45 * 9) / 20,
                        height: size.height * .45,
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(11)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(.75),
                              spreadRadius: 3,
                              blurRadius: 31,
                              offset:
                                  const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset('lib/assets/images/screenshot.jpeg'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(13.0, 21, 13.0, 21),
                      child: Text(
                        'choose "Google Drive" in the next window as demonstrated in the clip above...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'varela-round.regular',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: size.width*.45,
                        height: size.height*.05,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: const BorderRadius.all(Radius.circular(11)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.25),
                              spreadRadius: 1,
                              blurRadius: 31,
                              offset:
                              const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),child: const Center(
                          child: Text(
                          'continue',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "varela-round.regular"
                            ),
                      ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
