import 'package:flutter/material.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({Key? key}) : super(key: key);

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  double saveButtonDimen = 0;
  Color searchBarColor = const Color(0xfff7a221);
  bool _isVisible = false, _isNoteCardActive = false;
  final _searchFieldController = TextEditingController(),
      _noteFieldController = TextEditingController();
  late FocusNode myFocusNode, myFocusNode2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double newDimen = size.height * .055;
    // double newDimen = 55;

    noteCardActiveStatus(bool _isActive) {
      setState(() {
        _isVisible = true;
        newDimen > 55 ? saveButtonDimen = newDimen : saveButtonDimen = 55;
      });
    }

    changeSaveButtonSize() {
      setState(() {
        _isVisible = true;
        newDimen > 55 ? saveButtonDimen = newDimen : saveButtonDimen = 55;
      });
    }

    hideSaveButton() {
      setState(() {
        _isVisible = false;
        saveButtonDimen = 0;
      });
    }

    List<BoxShadow> boxShadow(double blurRadius, double offset1, double offset2,
        Color colorBottom, Color colorTop) {
      return [
        BoxShadow(
          blurRadius: blurRadius,
          offset: Offset(offset1, offset2),
          color: colorBottom.withOpacity(.5),
        ),
        BoxShadow(
          blurRadius: blurRadius,
          offset: Offset(-offset1, -offset2),
          color: colorTop,
        ),
      ];
    }

    GestureDetector colorPalette(int color) {
      return GestureDetector(
        onTap: () {
          setState(() {
            searchBarColor = Color(color);
          });
        },
        child: Container(
          width: size.height * .045,
          height: size.height * .045,
          child: Center(
            child: Container(
              width: size.height * .015,
              height: size.height * .015,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color(color),
              ),
            ),
          ),
          decoration: BoxDecoration(
            // border: Border.all(width: 0, color: Colors.black26),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.grey.shade100, width: 1),
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(
                (size.width * .07 > 11.0) ? 15 : size.width * .039),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isVisible = true;
                          newDimen > 55
                              ? saveButtonDimen = newDimen
                              : saveButtonDimen = 55;
                        });
                      },
                      child: const Align(
                        alignment: Alignment(-1, 0),
                        child: Padding(
                          padding: EdgeInsets.only(right: 3.0),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: const Duration(milliseconds: 351),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(55),
                                    color: searchBarColor,
                                  ),
                                  // boxShadow: boxShadow(21, 3, 3, Colors.grey.shade300, Colors.grey.shade300)),
                                  child: Center(
                                    child: TextField(
                                      focusNode: myFocusNode2,
                                      controller: _searchFieldController,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Rounded_Elegance",
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              left: 15,
                                              bottom: 11,
                                              top: 11,
                                              right: 15),
                                          hintText: "note title..."),
                                    ),
                                  )),
                            ),
                          ),
                          Align(
                            alignment: const Alignment(1, 0),
                            child: GestureDetector(
                              onTap: () {
                                hideSaveButton();
                              },
                              child: AnimatedContainer(
                                width: saveButtonDimen,
                                height: saveButtonDimen,
                                curve: Curves.fastOutSlowIn,
                                child: Visibility(
                                    visible: _isVisible,
                                    child: const Center(
                                        child: Icon(Icons.done_all))),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade100, width: 1),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: boxShadow(
                                        9, 3, 3, Colors.grey, Colors.white)),
                                duration: const Duration(milliseconds: 195),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding:
                        EdgeInsets.fromLTRB(8.0, size.height * 0.025, 8.0, 0.0),
                    child: RichText(
                      text: TextSpan(children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.format_paint,
                            size: 15,
                            color: searchBarColor,
                          ),
                        ),
                        const TextSpan(
                            text: "  choose note theme:",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Rounded_Elegance",
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ]),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * .025),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: searchBarColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: SingleChildScrollView(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(child: colorPalette(0xffe78848)),
                          colorPalette(0xffb44c4b),
                          colorPalette(0xffd2ad7e),
                          colorPalette(0xfff7a221),
                          colorPalette(0xff02708b),
                        ],
                      )),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, size.height * .025),
                    child: RichText(
                      text: TextSpan(children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.note,
                            size: 15,
                            color: searchBarColor,
                          ),
                        ),
                        const TextSpan(
                            text: "  write your heart:",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Rounded_Elegance",
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ]),
                    )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isNoteCardActive = true;
                      myFocusNode.requestFocus();
                      _noteFieldController.addListener(() {
                        _searchFieldController.addListener(() {
                          if (_noteFieldController.text.isNotEmpty &&
                              _searchFieldController.text.isNotEmpty) {
                            changeSaveButtonSize();
                          }
                          if (_searchFieldController.text.isEmpty) {
                            hideSaveButton();
                          }
                        });
                        if (_noteFieldController.text.isNotEmpty &&
                            _searchFieldController.text.isNotEmpty) {
                          changeSaveButtonSize();
                        }
                        if (_noteFieldController.text.isEmpty) {
                          hideSaveButton();
                        }
                        if (!myFocusNode.hasFocus) {
                          _isNoteCardActive = false;
                        }
                        myFocusNode.addListener(() {
                          if (!myFocusNode.hasFocus &&
                              _noteFieldController.text.isEmpty) {
                            setState(() {
                              _isNoteCardActive = false;
                            });
                            // FocusManager.instance.primaryFocus?.unfocus();
                          }if(_noteFieldController.text.isNotEmpty) {
                            setState(() {
                              print("1");
                              _isNoteCardActive = true;
                            });
                          }
                        });

                        myFocusNode2.addListener(() {
                          if (myFocusNode2.hasFocus &&
                              _noteFieldController.text.isEmpty) {
                            setState(() {
                              _isNoteCardActive = false;
                            });
                          } if(_noteFieldController.text.isNotEmpty) {
                            setState(() {
                              print("1");
                              _isNoteCardActive = true;
                            });
                          }
                        });
                      });
                    });
                  },
                  child: AnimatedContainer(
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 751),
                    decoration: BoxDecoration(
                        color: searchBarColor,
                        borderRadius: BorderRadius.circular(25),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.5)
                        // boxShadow: boxShadow(7, 7, 7, Colors.grey, Colors.white)
                        ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(9.5),
                          child: Visibility(
                            visible: _isNoteCardActive,
                            child: TextField(
                              focusNode: myFocusNode,
                              controller: _noteFieldController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 1000000,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Colors.white54,
                                      fontFamily: "Rounded_Elegance",
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "so it was 19/3/1993..."),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !_isNoteCardActive,
                          child: Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(1000.0),
                                        child: Image.asset(
                                          "lib/assets/images/tap.gif",
                                          width: size.width * .15,
                                          height: size.width * .15,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  const Text(
                                    "Tap to start writing!",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: "Rounded_Elegance",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
