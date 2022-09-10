import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_database/video_Player.dart';

import 'View_Page/View_Page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // to connect project with firebase console

  runApp(MaterialApp(
    home: View_Page(),
    debugShowCheckedModeBanner: false,
  ));
}
