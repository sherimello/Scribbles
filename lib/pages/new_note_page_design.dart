import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({Key? key}) : super(key: key);

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  double saveButtonDimen = 0;
  Color searchBarColor = Color(0xfffccd89);
  bool _isVisible = false, _isNoteCardActive = false;
  final _searchFieldController = TextEditingController(),
      _noteFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _noteFieldController.addListener(() {});
    _searchFieldController.addListener(() {});
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
            // boxShadow: [
            //   BoxShadow(
            //     blurRadius: 7,
            //     offset: const Offset(3, 3),
            //     color: Colors.grey.withOpacity(.75),
            //   ),
            //   const BoxShadow(
            //     blurRadius: 3,
            //     offset: Offset(-5, -3),
            //     color: Colors.white,
            //   ),
            // ]
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
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 351),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(55),
                                    color: searchBarColor.withOpacity(.35),
                                  ),
                                  // boxShadow: boxShadow(21, 3, 3, Colors.grey.shade300, Colors.grey.shade300)),
                                  child: Center(
                                    child: TextField(
                                      controller: _searchFieldController,
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                          hintStyle: TextStyle(
                                              color: Colors.black,
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
                                curve: Curves.easeIn,
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
                        border: Border.all(color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: SingleChildScrollView(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(child: colorPalette(0xfff8c3c3)),
                          colorPalette(0xfffdb19e),
                          colorPalette(0xffffb8d6),
                          colorPalette(0xffb6fde6),
                          colorPalette(0xfffccd89),
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
                      _noteFieldController.addListener(() {
                        _searchFieldController.addListener(() {
                          if (_noteFieldController.text.isNotEmpty &&
                              _searchFieldController.text.isNotEmpty) {
                            changeSaveButtonSize();
                          }
                          if(_searchFieldController.text.isEmpty){
                            hideSaveButton();
                          }
                        });
                        if (_noteFieldController.text.isNotEmpty &&
                            _searchFieldController.text.isNotEmpty) {
                          changeSaveButtonSize();
                        }
                        if(_noteFieldController.text.isEmpty){
                          hideSaveButton();
                        }
                      });
                      _isNoteCardActive = true;
                      // if (_searchFieldController.text.isNotEmpty) {
                      //   _isNoteCardActive = true;
                      // }
                    });
                  },
                  child: AnimatedContainer(
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 751),
                    decoration: BoxDecoration(
                        color: searchBarColor.withOpacity(.35),
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
                              controller: _noteFieldController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 1000000,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
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
                          child: const Expanded(
                            child: Center(
                              child: Text(
                                "Tap to start writing!",
                                style: TextStyle(
                                    fontSize: 21,
                                    fontFamily: "Rounded_Elegance",
                                    color: Colors.grey),
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
