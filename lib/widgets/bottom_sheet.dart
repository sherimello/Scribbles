import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scribbles/classes/my_sharedpreferences.dart';
import 'package:scribbles/pages/new_note_page_design.dart';
import 'package:scribbles/pages/sync_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/profile.dart';
import '../popup_card/custom_rect_tween.dart';
import '../popup_card/hero_dialog_route.dart';

class Test extends StatefulWidget {
  final List<Map<dynamic, dynamic>> list;

  const Test(this.list, {Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isSwitched = false, _isCloudSyncing = false;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void initState() {
    // TODO: implement initState
    checkIfSwitchIsOn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fb = FirebaseDatabase.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    final ref = fb.ref().child('notes');
    String userNode = "";
    GoogleSignInAccount _currentUser;

    void signOut() {
      _googleSignIn.disconnect().whenComplete(() =>
          {print("signed out"), MySharedPreferences().removeValue("userName")});
    }

    Future<void> signIn() async {
      try {
        await _googleSignIn.signIn();
        _currentUser = _googleSignIn.currentUser!;
        userNode =
            _currentUser.email.substring(0, _currentUser.email.indexOf('@'));
        print(userNode);
        _googleSignIn.onCurrentUserChanged.listen((event) {
          _currentUser = event!;
        });
        _googleSignIn.signInSilently();
      } catch (e) {
        MySharedPreferences().setStringValue("isCloudBackupOn", "0");
        setState(() {
          isSwitched = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("error signing in : $e"),
        ));
      }
    }

    uploadDataToFirebase() async {
      for (int i = 0; i < widget.list.length; i++) {
        print((widget.list[i]['time'].toString().replaceAll('\n', '')));
        // print(getNodeForCloudUploadUsingCreationDate(widget.list[i]['time']));
        ref
            .child(userNode)
            .child((widget.list[i]['time'].toString().replaceAll('\n', ' ')))
            .set({
              'title': widget.list[i]['title'].toString(),
              'note': widget.list[i]['note'].toString(),
              'theme': widget.list[i]['theme'].toString(),
              'time': widget.list[i]['time'].toString(),
            })
            .asStream()
            .listen((event) {}, onDone: () {});
      }
    }

    return AbsorbPointer(
      absorbing: _isCloudSyncing,
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Hero(
                    tag: '000',
                    createRectTween: (begin, end) {
                      return CustomRectTween(begin: begin!, end: end!);
                    },
                    child: Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(11, 11, 11, 41),
                        child: SingleChildScrollView(
                          child: ClipRRect(
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
                                          child: NewNotePage('000', '000', ""),
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
                                                    fontFamily:
                                                        'varela-round.regular',
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
                                    onTap: () {
                                      Navigator.of(context).push(HeroDialogRoute(
                                        builder: (context) => const Center(
                                          child: SyncFile('000'),
                                        ),
                                        // settings: const RouteSettings(),
                                      ));
                                    },
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
                                                    fontFamily:
                                                        'varela-round.regular',
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
                                    onTap: () {
                                      Navigator.of(context).push(HeroDialogRoute(
                                        // bgColor: const Color(0x00000000),
                                        builder: (context) => const Center(
                                          child: Profile(tag: '000'),
                                        ),
                                        // settings: const RouteSettings(),
                                      ));
                                    },
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
                                                    fontFamily:
                                                        'varela-round.regular',
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(11.0),
                                      child: Wrap(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 7.0),
                                            child: Center(
                                              child: Switch(
                                                  value: isSwitched,
                                                  activeTrackColor:
                                                      Colors.lightGreenAccent,
                                                  activeColor: Colors.green,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      isSwitched = value;
                                                    });
                                                    value
                                                        ? {
                                                            setState(() {
                                                              _isCloudSyncing =
                                                                  true;
                                                            }),
                                                            MySharedPreferences()
                                                                .setStringValue(
                                                                    "isCloudBackupOn",
                                                                    "1")
                                                          }
                                                        : {
                                                            MySharedPreferences()
                                                                .setStringValue(
                                                                    "isCloudBackupOn",
                                                                    "0"),
                                                            signOut()
                                                          };
                                                    save(value);
                                                    if (value) {
                                                      signIn().whenComplete(() => {
                                                            uploadDataToFirebase()
                                                                .whenComplete(() {
                                                              setState(() {
                                                                _isCloudSyncing =
                                                                    false;
                                                              });
                                                            }),
                                                            MySharedPreferences()
                                                                .setStringValue(
                                                                    "userName",
                                                                    userNode)
                                                          });
                                                    }
                                                  }),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Text("Cloud Backup",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'varela-round.regular',
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Flexible(
                                                    child: Text(
                                                        "(automatically backs up notes everytime you open the app)",
                                                        overflow:
                                                            TextOverflow.visible,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'varela-round.regular',
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
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
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isCloudSyncing,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  void save(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("isNight", value);
  }

  Future<void> checkIfSwitchIsOn() async {
    await MySharedPreferences().getStringValue("isCloudBackupOn") == "0"
        ? setState(() {
            isSwitched = false;
          })
        : setState(() {
            isSwitched = true;
          });
  }

  String getNodeForCloudUploadUsingCreationDate(String date) {
    String node = "";
    if (date.contains('Sunday')) {
      node += "01";
      String removable = "Sunday, ";
      date = date.substring(removable.length);
    }
    if (date.contains('Monday')) {
      node += "02";
      String removable = "Monday, ";
      date = date.substring(removable.length);
    }
    if (date.contains('Tuesday')) {
      node += "03";
      String removable = "Tuesday, ";
      date = date.substring(removable.length);
    }
    if (date.contains('Wednesday')) {
      node += "04";
      String removable = "Wednesday, ";
      date = date.substring(removable.length);
    }
    if (date.contains('Thursday')) {
      node += "05";
      String removable = "Thursday, ";
      date = date.substring(removable.length);
    }
    if (date.contains('Friday')) {
      node += "06";
      String removable = "Friday, ";
      date = date.substring(removable.length);
    }
    if (date.contains('Saturday')) {
      node += "07";
      String removable = "Saturday, ";
      date = date.substring(removable.length);
    }
    //for month...
    if (date.contains('January')) {
      node += "01";
      String removable = "January ";
      date = date.substring(removable.length);
    }
    if (date.contains('February')) {
      node += "02";
      String removable = "February ";
      date = date.substring(removable.length);
    }
    if (date.contains('March')) {
      node += "03";
      String removable = "March ";
      date = date.substring(removable.length);
    }
    if (date.contains('April')) {
      node += "04";
      String removable = "April ";
      date = date.substring(removable.length);
    }
    if (date.contains('May')) {
      node += "05";
      String removable = "May ";
      date = date.substring(removable.length);
    }
    if (date.contains('June')) {
      node += "06";
      String removable = "June ";
      date = date.substring(removable.length);
    }
    if (date.contains('July')) {
      node += "07";
      String removable = "July ";
      date = date.substring(removable.length);
    }
    if (date.contains('August')) {
      node += "08";
      String removable = "August ";
      date = date.substring(removable.length);
    }
    if (date.contains('September')) {
      node += "09";
      String removable = "September ";
      date = date.substring(removable.length);
    }
    if (date.contains('October')) {
      node += "10";
      String removable = "October ";
      date = date.substring(removable.length);
    }
    if (date.contains('November')) {
      node += "11";
      String removable = "November ";
      date = date.substring(removable.length);
    }
    if (date.contains('December')) {
      node += "12";
      String removable = "December ";
      date = date.substring(removable.length);
    }
    node += date.substring(1, 3);
    date += date.substring(4);

    node += date.substring(1, 5);
    date += date.substring(1);
    node += date.substring(1, 3);
    date += date.substring(1);
    node += date.substring(1, 3);
    date += date.substring(1);
    node += date.substring(1, 3);

    return node;
  }
}
