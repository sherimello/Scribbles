import 'package:flutter/material.dart';

import '../pages/home.dart';
import '../pages/note_page.dart';
import '../popup_card/custom_rect_tween.dart';
import '../popup_card/hero_dialog_route.dart';

class Test extends StatelessWidget {
  final IconData icon1, icon2, icon3, mainIcon;

  const Test(this.icon1, this.icon2, this.icon3, this.mainIcon, {Key? key})
      : super(key: key);

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Hero(
          tag: '000',
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Container(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height * .5,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(29),
                    topRight: Radius.circular(29),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 11, 11, 41),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(11),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: Navigator.of(context).pop,
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        // splashColor: Colors.white,
                        // radius: 100,
                        onTap: () {
                          Navigator.of(context).push(HeroDialogRoute(
                            builder: (context) => const Center(
                              child: NotePage('000'),
                            ),
                            // settings: const RouteSettings(),
                          ));
                          // Navigator.removeRoute(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (BuildContext context) => const Home(),
                          //   ),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.post_add,
                                    size: 19,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                    text: "  create new note",
                                    style: TextStyle(
                                        fontFamily: 'varela-round.regular',
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        // splashColor: Colors.white,
                        // radius: 100,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.sync,
                                    size: 21,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                    text: "  sync",
                                    style: TextStyle(
                                        fontFamily: 'varela-round.regular',
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        // splashColor: Colors.white,
                        // radius: 100,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    size: 21,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                    text: "  profile",
                                    style: TextStyle(
                                        fontFamily: 'varela-round.regular',
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold)),
                              ],
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
        ),
      ),
    );
  }
}
