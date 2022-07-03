import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messanger/Screens/chatscreen.dart';
import 'package:messanger/Screens/home.dart';
import 'package:messanger/Screens/login.dart';
import 'package:messanger/controller/getmodelcontroller.dart';
import 'package:messanger/firebase_options.dart';
import 'package:messanger/model/usermodel.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  User? user = FirebaseAuth.instance.currentUser;
  
  if (user == null) {
    runApp(const MyApp());
  } else {
    UserModel usermodel = await GetUserModel.getusermodelById(user.uid);
    runApp( MyApp2(firebaseuser: user,usermodel: usermodel,));
   

  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.]
  // String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class MyApp2 extends StatelessWidget {
  final UserModel usermodel;
  final User firebaseuser;

  const MyApp2(
      {super.key, required this.usermodel, required this.firebaseuser});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(usermodel: usermodel, firebaseuser: firebaseuser),
    );
  }
}
