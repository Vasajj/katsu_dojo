import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'enter_page.dart';
import 'youtube/video_screen.dart';
import 'package:firebase_core/firebase_core.dart';






Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(MyApp());
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '1',
      routes: {
        '1': (context) => EnterPage(),

        '8': (context) => VideoScreen(),
      },
    );
  }
}
