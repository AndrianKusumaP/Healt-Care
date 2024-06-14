import 'package:Health_Care/screens/homepage.dart';
import 'package:Health_Care/screens/maps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Health_Care/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Welcome(),
    )
   );
}
