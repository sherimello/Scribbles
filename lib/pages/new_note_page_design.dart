import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../hero_transition_handler/custom_rect_tween.dart';
import 'home.dart';

class NewNotePage extends StatefulWidget {
  final String string, id, theme;

  const NewNotePage(this.id, this.string, this.theme, {Key? key})
      : super(key: key);

  // const NewNotePage({Key? key}) : super(key: key);

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  double saveButtonDimen = 0;
  late Color searchBarColor;
  bool _isVisible = false,
      _isNoteCardActive = false,
      _isNoteInUpdateMode = false,
      _isTitleAdded = false;
  final _searchFieldController = TextEditingController(),
      _noteFieldController = TextEditingController();
  late FocusNode noteFieldFocusNode, myFocusNode2;
  late Database database;
  late String path,
      initNote,
      initTitle,
      selectedColor = "0xfff7a221",
      initColor,
      time,
      timeForNoteUpdate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiateDB();
    if (widget.theme == "") {
      setState(() => searchBarColor = const Color(0xfff7a221));
    } else {
      setState(() => searchBarColor = Color(int.parse(widget.theme)));
      // searchBarColor = Color(int.parse(widget.theme));
    }
    noteFieldFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    widget.id != "000"
        ? setState(() {
            _isNoteCardActive = true;
            _isNoteInUpdateMode = true;
            _isVisible = true;
          })
        : setState(() {
            _isNoteCardActive = false;
            _isVisible = true;
          });

    myFocusNode2.addListener(() {
      //check when focus changes from notes to the title bar and make the note field placeholder image visible...
      if (myFocusNode2.hasFocus && _noteFieldController.text.isEmpty) {
        setState(() {
          _isNoteCardActive = false;
          _isVisible = true;
        });
      }
    });

    noteFieldFocusNode.addListener(() {
      if (noteFieldFocusNode.hasFocus && _searchFieldController.text.isEmpty) {
        setState(() => _isTitleAdded = false);
      }
      if (!noteFieldFocusNode.hasFocus && _noteFieldController.text.isEmpty) {
        setState(() {
          _isNoteCardActive = false;
          _isVisible = true;
        });
        // FocusManager.instance.primaryFocus?.unfocus();
      }
      if (_noteFieldController.text.isNotEmpty) {
        setState(() {
          print("1");
          _isNoteCardActive = true;
          _isVisible = false;
        });
      }
    });

    _searchFieldController.addListener(() {
      checkIfSaveButtonShouldBeSeen();
      if (_searchFieldController.text != _noteFieldController.text) {
        setState(() => _isTitleAdded = true);
      }
    });

    _noteFieldController.addListener(() {
      checkIfSaveButtonShouldBeSeen();

      if (!_isTitleAdded && _noteFieldController.text.length <= 11) {
        setState(() {
          _searchFieldController.text = _noteFieldController.text;
        });
      }
    });
  }

  checkIfSaveButtonShouldBeSeen() {
    if (_searchFieldController.text.isNotEmpty &&
        _noteFieldController.text.isNotEmpty) {
      setState(() => saveButtonDimen = 55);
    } else {
      setState(() => saveButtonDimen = 0);
    }
  }

  Future<void> initiateDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'demo.db');
    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY, title NVARCHAR, note NVARCHAR, theme NVARCHAR, time NVARCHAR)');
    });
    if (widget.id != "000") {
      List<Map> note = await database
          .rawQuery('SELECT * FROM Notes WHERE id = ?', [widget.id]);
      initNote = _noteFieldController.text = note[0]['note'].toString();
      initTitle = _searchFieldController.text = note[0]['title'].toString();
      timeForNoteUpdate = note[0]['time'].toString();
      setState(() {
        selectedColor = initColor = note[0]['theme'].toString();
        searchBarColor = Color(int.parse(selectedColor));
      });
    }
  }

  Future<void> updateData() async {
    await database.transaction((txn) async {
      database.rawUpdate(
          'UPDATE Notes SET note = ?, title = ?, theme = ?, time = ? WHERE id = ?',
          [
            _noteFieldController.text,
            _searchFieldController.text,
            selectedColor,
            timeForNoteUpdate,
            widget.id
          ]);
    });
  }

  Future<void> insertData(String title, String note) async {
    if (widget.id != "000") {
      updateData();
      return;
    }

    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Notes(title, note, theme, time) VALUES(?, ?, ?, ?)',
          [title, note, selectedColor, time]);
      print('inserted1: $id1');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchFieldController.dispose();
    _noteFieldController.dispose();
    noteFieldFocusNode.dispose();
    myFocusNode2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double newDimen = size.height * .055;

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

    noteListener() {}

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

    GestureDetector colorNamedColorPalette(
      String colorCode,
    ) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedColor = colorCode;
            searchBarColor = Color(int.parse(selectedColor));
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Color(int.parse(colorCode)),
              // boxShadow: boxShadow(7, 3, 3, Colors.grey, Colors.white),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
                child: Text(
                  colorCode,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Rounded_Elegance",
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ),
          ),
        ),
      );
    }

    GestureDetector roundedColorPalette(int color) {
      return GestureDetector(
        onTap: () {
          setState(() {
            searchBarColor = Color(color);
            selectedColor = color.toString();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(3.5),
          child: Container(
            width: size.height * .037,
            height: size.height * .037,
            child: Center(
              child: Container(
                width: size.height * .037,
                height: size.height * .037,
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
        ),
      );
    }

    return Hero(
      tag: widget.string,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: size.height - MediaQuery.of(context).padding.top,
              width: size.width,
              color: const Color(0xffF8F0E3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(11, 11, 11, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, false);
                            // changeSaveButtonSize();
                          },
                          child: Align(
                            alignment: const Alignment(-1, 0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Icon(
                                Icons.arrow_back,
                                color: searchBarColor,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 19.0),
                                  child: AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: const Duration(milliseconds: 351),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(17),
                                        color: searchBarColor,
                                      ),
                                      // boxShadow: boxShadow(21, 3, 3, Colors.grey.shade300, Colors.grey.shade300)),
                                      child: Center(
                                        child: TextField(
                                          focusNode: myFocusNode2,
                                          controller: _searchFieldController,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Rounded_Elegance",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
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
                                    // hideSaveButton();

                                    String cdate2 =
                                        DateFormat("EEEEE, MMMM dd, yyyy")
                                            .format(DateTime.now());
                                    //output:  August, 27, 2021

                                    String tdata = DateFormat("hh:mm:ss a")
                                        .format(DateTime.now());
                                    // output: 07:38:57 PM
                                    time = cdate2 + "\n" + tdata;
                                    if (kDebugMode) {
                                      print(time);
                                    }

                                    widget.id != "000"
                                        ? (initNote !=
                                                        _noteFieldController
                                                            .text ||
                                                    initTitle !=
                                                        _searchFieldController
                                                            .text) ||
                                                selectedColor != initColor
                                            ? updateData().whenComplete(
                                                () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const Home(
                                                                  true, 'notes')),
                                                    ))
                                            : Navigator.pop(context, false)
                                        : _noteFieldController.text.isNotEmpty &&
                                                _searchFieldController
                                                    .text.isNotEmpty
                                            ? insertData(
                                                    _searchFieldController.text,
                                                    _noteFieldController.text)
                                                .whenComplete(() => {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Home(true,
                                                                    'notes')),
                                                      )
                                                    })
                                            : Navigator.pop(context, false);
                                  },
                                  child: AnimatedContainer(
                                    width: _isNoteInUpdateMode
                                        ? size.height * .055 > 65
                                            ? 65
                                            : size.height * .065
                                        : saveButtonDimen,
                                    height: _isNoteInUpdateMode
                                        ? size.height * .065 > 65
                                            ? 65
                                            : size.height * .065
                                        : saveButtonDimen,
                                    curve: Curves.fastOutSlowIn,
                                    child: Visibility(
                                        visible:
                                            saveButtonDimen == 55 ? true : false,
                                        child: Center(
                                            child: Icon(
                                          Icons.done_all,
                                          color: searchBarColor,
                                        ))),
                                    decoration: BoxDecoration(
                                      color: searchBarColor.withOpacity(.25),
                                      border: Border.all(
                                          color: Colors.grey.shade100, width: 1),
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    // boxShadow: boxShadow(
                                    //     9, 3, 3, Colors.grey, Colors.white)),
                                    duration: const Duration(milliseconds: 195),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(11, size.height * 0.01, 11, 0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.format_paint,
                              size: 15,
                              color: searchBarColor,
                            ),
                          ),
                          const TextSpan(
                              text: "  choose a note theme:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Rounded_Elegance",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ]),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.0),
                    child: Center(
                      child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // colorNamedColorPalette("0xfff7a221"),
                              // colorNamedColorPalette("0xffb44c4b"),
                              // colorNamedColorPalette("0xffd2ad7e"),
                              // colorNamedColorPalette("0xff02708b"),
                              // colorNamedColorPalette("0xffe78848"),
                              roundedColorPalette(0xffe78848),
                              roundedColorPalette(0xffb44c4b),
                              roundedColorPalette(0xffd2ad7e),
                              roundedColorPalette(0xfff7a221),
                              roundedColorPalette(0xff02708b),
                            ],
                          )),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(31, 0, 11, size.height * .015),
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
                                text: "  what's on your mind?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Rounded_Elegance",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ]),
                        )),
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(11, 0, 11, 11),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isNoteCardActive = true;
                                noteFieldFocusNode.requestFocus();
                                /////////////////////////////////////////////////////////////////////////////////////
                              });
                            },
                            child: AnimatedContainer(
                              curve: Curves.fastOutSlowIn,
                              duration: const Duration(milliseconds: 751),
                              decoration: BoxDecoration(
                                color: searchBarColor,
                                borderRadius: BorderRadius.circular(31),
                                // boxShadow: boxShadow(7, 7, 7, Colors.grey, Colors.white)
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(9.5),
                                    child: Visibility(
                                      visible: _isNoteCardActive,
                                      child: TextField(
                                        focusNode: noteFieldFocusNode,
                                        controller: _noteFieldController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 1000000,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Rounded_Elegance",
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
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
                                                left: 15,
                                                bottom: 11,
                                                top: 11,
                                                right: 15),
                                            hintText: "so it was 19/3/1993..."),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !_isNoteCardActive,
                                    child: const SizedBox.expand(
                                      child: Center(
                                        child: Text(
                                          "Tap to start writing!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontFamily: "Rounded_Elegance",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        // child: Column(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.center,
                                        //   children: [
                                        //     Padding(
                                        //       padding: const EdgeInsets.all(13.0),
                                        //       child: ClipRRect(
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   1000.0),
                                        //           child: Image.asset(
                                        //             "lib/assets/images/tap.gif",
                                        //             color: searchBarColor,
                                        //             colorBlendMode:
                                        //                 BlendMode.screen,
                                        //             width: size.width * .15,
                                        //             height: size.width * .15,
                                        //             fit: BoxFit.cover,
                                        //           )),
                                        //     ),
                                        //     const Text(
                                        //       "Tap to start writing!",
                                        //       style: TextStyle(
                                        //           fontSize: 17,
                                        //           fontFamily: "Rounded_Elegance",
                                        //           fontWeight: FontWeight.bold,
                                        //           color: Colors.white),
                                        //     ),
                                        //   ],
                                        // ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
