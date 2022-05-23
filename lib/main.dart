import 'package:flutter/material.dart';
import 'package:scribbles/pages/home.dart';

void main() {
  var kReleaseMode = true;
  runApp(const MyApp());
  //   DevicePreview(
  //   enabled: true,
  //   tools: const [
  //     ...DevicePreview.defaultTools,
  //     // const CustomPlugin(),DevicePreview(
  //     //       enabled: true,
  //     //       tools: [
  //     //         ...DevicePreview.defaultTools,
  //     //         const CustomPlugin(),
  //     //       ],
  //     //       builder: (context) => const BasicApp(),
  //     //     ),
  //   ],
  //   builder: (context) => const MyApp(),
  // ),
  // );
}

@override
void initState() {
  // TODO: implement initState
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return const NewNotePage("","");
    return Container(color: Colors.black, child: const Home(true));
    // return const Test(Icons.post_add, Icons.camera_alt_outlined,
    //     Icons.place_outlined, Icons.menu);
  }
}
