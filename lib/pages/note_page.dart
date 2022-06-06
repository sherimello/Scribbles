import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scribbles/pages/home.dart';
import 'package:scribbles/hero_transition_handler/custom_rect_tween.dart';
import 'package:sqflite/sqflite.dart';

class NotePage extends StatefulWidget {
  final String string, id;

  const NotePage(this.id, this.string, {Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late double textScale;
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusNode2 = FocusNode();
  TextEditingController myController = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  late Database database;

  late String path, initNote, initTitle;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    myController.addListener(_printLatestValue);
    initiateDB();
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
          'CREATE TABLE IF NOT EXISTS Notes (id INTEGER PRIMARY KEY, title NVARCHAR, note NVARCHAR)');
    });
    if (widget.id != "000") {
      List<Map> note = await database
          .rawQuery('SELECT * FROM Notes WHERE id = ?', [widget.id]);
      initNote = myController.text = note[0]['note'].toString();
      initTitle = myController2.text = note[0]['title'].toString();
    }
  }

  Future<void> updateData() async {
    await database.transaction((txn) async {
      database.rawUpdate('UPDATE Notes SET note = ?, title = ? WHERE id = ?',
          [myController.text, myController2.text, widget.id]);
    });
  }

  Future<void> insertData(String title, String note) async {
    if (widget.id != "000") {
      updateData();
      return;
    }

    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Notes(title, note) VALUES(?, ?)', [title, note]);
      print('inserted1: $id1');
    });
  }

  void _printLatestValue() {
    if (myFocusNode.hasFocus) {
      // myFocusNode2.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // double gap = height * .025;
    double gap = 21.0;
    textScale = MediaQuery.textScaleFactorOf(context);

    return WillPopScope(
      onWillPop: () async {
        widget.id != "000"
            ? (initNote != myController.text || initTitle != myController2.text)
                ? updateData()
                : Navigator.pop(context, false)
            : myController.text.isNotEmpty
                ? insertData(myController2.text, myController.text)
                    .whenComplete(() => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home(false)),
                          )
                        })
                : Navigator.pop(context, false);

        return false;
      },
      child: Hero(
        tag: widget.string,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 3,
              backgroundColor: Colors.black,
              title: const Text(
                'Scribbles',
                style: TextStyle(
                  // letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                  fontSize: 21,
                  fontFamily: 'varela-round.regular',
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Colors.orangeAccent[100],
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Stack(fit: StackFit.passthrough, children: [
                  CustomPaint(
                    foregroundPainter: CustomPage(gap, 1),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, ((3.0 * gap) - 31) / 2, 17, 0),
                          child: TextField(
                            // keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.center,
                            maxLines: 1,
                            focusNode: myFocusNode2,
                            controller: myController2,
                            style: TextStyle(
                              fontSize: 17,
                              height: gap / 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'varela-round.regular',
                            ),
                            decoration: const InputDecoration(
                              hintText: ' title here...',
                              hintStyle: TextStyle(
                                fontFamily: 'varela-round.regular',
                                fontWeight: FontWeight.w900,
                              ),
                              isCollapsed: true,
                              prefixIcon: Icon(
                                Icons.title,
                                size: 27,
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minWidth: 47,
                                minHeight: 35,
                              ),
                              contentPadding: EdgeInsets.only(left: 17),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ((3.0 * gap) - 31) / 2),
                          child: Expanded(
                            flex: 0,
                            child: TextField(
                              controller: myController,
                              focusNode: myFocusNode,
                              keyboardType: TextInputType.multiline,
                              textAlignVertical: TextAlignVertical.bottom,
                              maxLines: null,
                              minLines: null,
                              style: TextStyle(
                                  fontSize: 14,
                                  // letterSpacing: 0,
                                  height: gap / 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Rounded_Elegance'),
                              decoration: const InputDecoration(
                                isCollapsed: true,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 17),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.0 * gap),
                    child: SizedBox(
                      width: double.infinity,
                      height: height - 3.0 * gap,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            myFocusNode.requestFocus();
                          });
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Container(
                      width: width,
                      height: height,
                      color: Colors.black87,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                23,
                                (height * .5) -
                                    3.0 * gap -
                                    AppBar().preferredSize.height,
                                23,
                                0),
                            child: Card(
                              elevation: 11,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(11)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(11.0),
                                      child: Text(
                                        'select note color:',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontFamily: 'varela-round.regular',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 8.0, 0, 8),
                                      child: Center(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: width * 0.13,
                                                  height: width * 0.13,
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xFFFF9100),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  1000))),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: width * 0.13,
                                                  height: width * 0.13,
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xFF16DDFF),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  1000))),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: width * 0.13,
                                                  height: width * 0.13,
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xFFD887FA),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  1000))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showData(BuildContext context) async {
    List<Map> list = await database.rawQuery('SELECT * FROM Notes');
    if (kDebugMode) {
      print(list);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home(false)),
    );
  }
}

class CustomPage extends CustomPainter {
  double gap;
  int i;

  CustomPage(this.gap, this.i);

  @override
  void paint(Canvas canvas, Size size) {
    final verticalLine = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    final horizontalLine = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.0;

    if (i == 0) {
      // canvas.drawLine(Offset(size.width * 0.1, 0),
      //     Offset(size.width * 0.1, size.height), verticalLine);
      return;
    }

    for (var x = 0.0; x <= size.height; x += gap) {
      if (x <= gap * 2) {
        continue;
      }
      canvas.drawLine(Offset(0, x), Offset(size.width, x), horizontalLine);
    }

    // canvas.drawLine(Offset(size.width * 0.1, 0),
    //     Offset(size.width * 0.1, size.height), verticalLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
