import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messanger/Screens/login.dart';
import 'package:messanger/Screens/profile.dart';
import 'package:messanger/Screens/register.dart';
import 'package:messanger/firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  LoginPage(),
    );
  }
}

