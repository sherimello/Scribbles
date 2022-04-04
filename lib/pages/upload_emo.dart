import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../popup_card/custom_rect_tween.dart';

class UploadDemo extends StatefulWidget {
  final String string, allNotes;

  const UploadDemo({Key? key, required this.string, required this.allNotes})
      : super(key: key);
  static final snackBar = SnackBar(
    content: RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.sentiment_very_dissatisfied_outlined,
              size: 21,
              color: Colors.black,
            ),
          ),
          TextSpan(
              text: "  sorry! no notes were found...",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'varela-round.regular',
                  fontSize: 21,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    // Text('sorry! no notes were found...'),
  );

  @override
  State<UploadDemo> createState() => _UploadDemoState();
}

_write(String text, BuildContext context) async {
  final Directory? directory = Platform.isAndroid
      ? await getExternalStorageDirectory() //FOR ANDROID
      : await getApplicationSupportDirectory(); //FOR iOS
  final File file = File('${directory?.path}/cloud.txt');
  print('${directory?.path}/cloud.txt');
  if (file.existsSync()) {
    file.delete().whenComplete(() async => await file.writeAsString(text));
  }
}

class _UploadDemoState extends State<UploadDemo> {
  bool v = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print((size.height * .65) / ((size.height * .65 * 9) / 20));
    return Hero(
        tag: widget.string,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                SingleChildScrollView(
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
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(11)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.25),
                                    spreadRadius: 3,
                                    blurRadius: 31,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset('lib/assets/images/demo.gif'),
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
                            child: GestureDetector(
                              onTap: () async {
                                if (widget.allNotes.isNotEmpty) {
                                  _write(widget.allNotes, context);
                                  print(widget.allNotes);
                                  final box =
                                      context.findRenderObject() as RenderBox?;
                                  await Share.share(widget.allNotes,
                                      subject: 'cloud.txt',
                                      sharePositionOrigin:
                                          box!.localToGlobal(Offset.zero) &
                                              box.size);
                                } else {
                                  setState(() {
                                    v = true;
                                  });
                                  Timer(const Duration(seconds: 3), () {
                                    // 5 seconds have past, you can do your work
                                    setState(() {
                                      v = false;
                                    });
                                  });
                                }
                              },
                              child: Container(
                                width: size.width * .45,
                                height: size.height * .05,
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(11)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.25),
                                      spreadRadius: 1,
                                      blurRadius: 31,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'continue',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "varela-round.regular"),
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
                Visibility(
                  visible: v,
                  child: Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(0),
                              bottom: Radius.circular(19)),
                        ),
                        child: SizedBox(
                          width: size.width * .9,
                          height: size.height * .055,
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons
                                          .sentiment_very_dissatisfied_outlined,
                                      size: size.height * .021,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                      text: "  sorry! no notes were found...",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: 'varela-round.regular',
                                          fontSize: size.height * .017,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
