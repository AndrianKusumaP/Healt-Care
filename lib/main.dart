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
    GetMaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Welcome(),
    )
   );
}
