import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scribbles/classes/my_sharedpreferences.dart';
import 'package:scribbles/pages/new_note_page_design.dart';
import 'package:scribbles/pages/sync_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../popup_card/custom_rect_tween.dart';
import '../popup_card/hero_dialog_route.dart';

class Test extends StatefulWidget {
  final List<Map<dynamic, dynamic>> list;

  const Test(this.list, {Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isSwitched = false;
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
      _googleSignIn.disconnect();
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("error signing in : $e"),
        ));
      }
    }

    uploadDataToFirebase() {
      Firebase.initializeApp();

      for (int i = 0; i < widget.list.length; i++) {
        ref.child(userNode).push().set({
          'title': widget.list[i]['title'].toString(),
          'note': widget.list[i]['note'].toString(),
          'theme': widget.list[i]['theme'].toString(),
          'time': widget.list[i]['time'].toString(),
        }).asStream().listen((event) { }, onDone: (){

        });
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Hero(
            tag: '000',
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: Material(
              color:Colors.transparent,
              child: Container(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * .5,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35))),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child:
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Switch(
                                        value: isSwitched,
                                        activeTrackColor: Colors.lightGreenAccent,
                                        activeColor: Colors.green,
                                        onChanged: (value) {
                                          setState(() {
                                            isSwitched = value;
                                          });
                                          value?
                                          MySharedPreferences().setStringValue("isCloudBackupOn", "1") : MySharedPreferences().setStringValue("isCloudBackupOn", "0");
                                          save(value);
                                          if (value) {
                                            signIn().whenComplete(
                                                    () => uploadDataToFirebase());
                                          }
                                        }),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text("Cloud Backup",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'varela-round.regular',
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold)),

                                          Flexible(
                                            child: Text(
                                                "(automatically backs up notes everytime you open the app)",
                                                overflow: TextOverflow.visible,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'varela-round.regular',
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold)),
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
    );
  }
  void save(bool value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("isNight", value);
  }

  Future<void> checkIfSwitchIsOn() async {
    await MySharedPreferences().getStringValue("isCloudBackupOn") == "0" ? setState((){
      isSwitched = false;
    }) : setState((){
      isSwitched = true;
    });
  }
}
