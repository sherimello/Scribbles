import 'package:flutter/material.dart';

import '../popup_card/custom_rect_tween.dart';

class UploadDemo extends StatelessWidget {
  final String string;

  const UploadDemo({Key? key, required this.string}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: string,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
                color: Colors.white,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*.75,
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width*.45,
                                height: MediaQuery.of(context).size.height*.45,
                                child: Image.asset('lib/assets/images/screenshot.jpeg',
                                    fit: BoxFit.cover,),
                              )
                            ]))))));
  }
}
