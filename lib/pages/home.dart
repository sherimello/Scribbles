import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:scribbles/widgets/bottom_sheet.dart';
import 'package:scribbles/widgets/note_preview_card.dart';
import 'package:sqflite/sqflite.dart';

import '../popup_card/custom_rect_tween.dart';
import '../popup_card/hero_dialog_route.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var t1 =
          'jhasjkhdiuiashiudyhiausdoijasiojdojoasjioljdoiaiojsiodjoiasjiodjioajoidajsoijdojasiodjojaosjdojoias',
      t2 = "hello",
      date = '19-3-93';
  late Database database;
  late List<Map> list;

  late GoogleSignInAccount _currentUser;

// Get a location using getDatabasesPath
  late String path;
  int size = 0;
  bool visible = true, _isLoading = true;

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
  }

  showData() async {
    list = (await database.rawQuery('SELECT * FROM Notes'));

    setState(() {
      if (list.isNotEmpty) {
        visible = false;
      }
      if (kDebugMode) {
        print(list.length);
      }
      size = list.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 3), () {
      // 5 seconds have past, you can do your work
      setState(() {
        _isLoading = false;
      });
    });
    Firebase.initializeApp();
    _googleSignIn.onCurrentUserChanged.listen((event) {
      setState(() {
        _currentUser = event!;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
    initiateDB().whenComplete(() => showData());
  }

  Widget cloudBackupLoadingCard() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget title() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'Scribbles',
          textAlign: TextAlign.center,
          style: TextStyle(
            // letterSpacing: 2,
            fontWeight: FontWeight.w900,
            fontSize: 21,
            fontFamily: 'varela-round.regular',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   title: AnimatedContainer(
      //     width: (!_isLoading) ? double.infinity : null,
      //       color: (!_isLoading) ? Colors.black: Colors.white,
      //       duration: const Duration(milliseconds: 750),
      //       child: _isLoading?cloudBackupLoadingCard():title()),
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xffF8F0E3),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(9.0, 9.0, 9.0, _isLoading ? 11.0 : 0.0),
                child: AnimatedContainer(
                    width: (!_isLoading) ? MediaQuery.of(context).size.width : 31,
                    height: (!_isLoading) ? AppBar().preferredSize.height : 31,
                    curve: Curves.easeInCirc,
                    decoration: BoxDecoration(
                      color: (!_isLoading) ? Colors.black: Colors.white,
                      borderRadius: BorderRadius.circular(_isLoading? 1000 : 19)
                    ),
                    duration: const Duration(milliseconds: 350),
                    child: Stack(
                      children: [
                        Positioned(

                          child: Visibility(
                              visible: !_isLoading,
                              child: title()),
                        ),
                        Visibility(
                            visible: _isLoading,
                            child: cloudBackupLoadingCard())
                      ],
                    ),
                    // child: _isLoading?cloudBackupLoadingCard():SingleChildScrollView(child: title())
                ),
              ),
              Expanded(
                child: Stack(children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StaggeredGridView.countBuilder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        itemCount:
                            // list.isEmpty ? 0:
                            size,
                        itemBuilder: (BuildContext context, int index) =>
                            // list.isEmpty ? Container():
                            PreviewCard(
                                time: list[index]['time'].toString(),
                                theme: list[index]["theme"].toString(),
                                noteID: list[index]["id"].toString(),
                                id: index.toString(),
                                title: list[index]["title"].toString(),
                                note: list[index]["note"].toString()),
                        // PreviewCard(
                        //   id: list.asMap()["id"].toString(), title: list.asMap()["title"].toString(), note: list.asMap()["note"].toString()
                        // ),
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                        // StaggeredTile.coimport 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';unt(2, index.isEven ? 2 : 1),
                        mainAxisSpacing: 9.0,
                        crossAxisSpacing: 9.0,
                      )),
                  Positioned(
                      bottom: 21,
                      right: 11,
                      child: Hero(
                        tag: '000',
                        createRectTween: (begin, end) {
                          return CustomRectTween(begin: begin!, end: end!);
                        },
                        child: Material(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100000),
                          ),
                          child: SizedBox(
                            width: 71,
                            height: 71,
                            child: IconButton(
                              color: Colors.black,
                              onPressed: () {
                                Navigator.of(context).push(HeroDialogRoute(
                                  builder: (context) => Center(
                                    // child: Test(
                                    //     Icons.post_add,
                                    //     Icons.camera_alt_outlined,
                                    //     Icons.place_outlined,
                                    //     Icons.menu),
                                    child: Test(list),
                                  ),
                                  // settings: const RouteSettings(),
                                ));
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )),
                  Visibility(
                    visible: visible,
                    child: Center(
                      child: Image.asset(
                        "lib/assets/images/empty2.gif",
                        fit: BoxFit.cover,
                        height: s.width * .55,
                        width: s.width * .55,
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
