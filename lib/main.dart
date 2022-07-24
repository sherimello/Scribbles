import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scribbles/pages/home.dart';
import 'package:scribbles/widgets/testwidget.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'classes/notificationservice.dart';

Future<void> main() async {
  // var kReleaseMode = true;
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      builder: (context, child) {
        // DevicePreview.appBuilder;
        //ignore system scale factor
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child ?? Container(),
        );
      },
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.black,
            ),
      ),
      home: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }
  @override
  Widget build(BuildContext context) {
    // return const NewNotePage("","");
    return Container(color: Colors.black, child: const Home(true));
    // return const Test(Icons.post_add, Icons.camera_alt_outlined,
    //     Icons.place_outlined, Icons.menu);
  }
}
