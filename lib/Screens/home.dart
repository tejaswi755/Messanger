import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/Screens/login.dart';
import 'package:messanger/Screens/searchscreen.dart';
import 'package:messanger/model/usermodel.dart';

class HomeScreen extends StatefulWidget {
  final UserModel usermodel;
  final User firebaseuser;

  const HomeScreen(
      {super.key, required this.usermodel, required this.firebaseuser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  FloatingActionButton(
          onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchScreen(usermodel: widget.usermodel, user: widget.firebaseuser);
            }));
          },
          child: Icon(Icons.search)),
      appBar: AppBar(
        title: const Text("Messanger"),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            child: const Icon(
              Icons.logout,
            ),
            onTap: () {
              
              FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LoginPage();
              }));
            },
          )
        ],
      ),body: Container(child: 
      Text("Welcome")),
    );
  }
}
