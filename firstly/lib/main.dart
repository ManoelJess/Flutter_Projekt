import 'package:firstly/welcome.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'dart:core';
import 'package:firebase_core/firebase_core.dart';


 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
   );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, Orientation, DeviceType) =>MaterialApp(
         home: welcomeScreen(),
      ),
    );
  }
}
