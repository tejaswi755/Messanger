import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/Screens/login.dart';
import 'package:messanger/model/usermodel.dart';

class HomeScreen extends StatefulWidget {
  final UserModel usermodel;
  final User? firebaseuser;

  const HomeScreen(
      {super.key, required this.usermodel, required this.firebaseuser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),automaticallyImplyLeading: false,
        
        actions: [
          GestureDetector(
            child: Icon(Icons.logout_rounded),
            onTap: () {
              print("logout");
              FirebaseAuth.instance.signOut();
              Navigator.push(context,
                 MaterialPageRoute(builder: (context){
                  return LoginPage();
                }));
            },
          )
        ],
      ),
    );
  }
}
