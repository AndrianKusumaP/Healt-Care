import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uts/screens/medicine.dart';
import 'package:uts/screens/welcome.dart';
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
