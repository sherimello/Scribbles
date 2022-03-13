import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path/path.dart';
import 'package:scribbles/widgets/note_preview_card.dart';
import 'package:scribbles/widgets/test.dart';
import 'package:sqflite/sqflite.dart';

import '../popup_card/custom_rect_tween.dart';
import '../popup_card/hero_dialog_route.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var t1 =
          'jhasjkhdiuiashiudyhiausdoijasiojdojoasjioljdoiaiojsiodjoiasjiodjioajoidajsoijdojasiodjojaosjdojoias',
      t2 = "hello",
      date = '19-3-93';
  late Database database;
  late List<Map> list;
  List notes = [];

// Get a location using getDatabasesPath
  late String path;
  int size = 0;

  Future<void> initiateDB() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, 'demo.db');
    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title VARCHAR, note VARCHAR)');
    });
  }

  showData() async {
    list = (await database.rawQuery('SELECT * FROM Notes'));

    setState(() {
      print(list.length);
      size = list.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiateDB().whenComplete(() => showData());
  }

  @override
  Widget build(BuildContext context) {
    // initState();
    void _showToast(BuildContext context) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Added to favorite'),
          action: SnackBarAction(
              label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.black,
        title: const Padding(
          padding: EdgeInsets.all(0.0),
          child: Text(
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
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: SafeArea(
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
                          id: index.toString(),
                          title: list[index]["title"].toString(),
                          note: list[index]["note"].toString()),
                  // PreviewCard(
                  //   id: list.asMap()["id"].toString(), title: list.asMap()["title"].toString(), note: list.asMap()["note"].toString()
                  // ),
                  staggeredTileBuilder: (int index) =>
                      const StaggeredTile.fit(1),
                  // StaggeredTile.coimport 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';unt(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
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
                            builder: (context) => const Center(
                              child: Test(
                                  Icons.post_add,
                                  Icons.camera_alt_outlined,
                                  Icons.place_outlined,
                                  Icons.menu),
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
                ))
          ]),
        ),
      ),
    );
  }
}
