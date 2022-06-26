import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/model/usermodel.dart';

class SearchScreen extends StatefulWidget {
  final UserModel usermodel;
  final User user;

  const SearchScreen({super.key, required this.usermodel, required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController emailcontroller = TextEditingController();

  void searchuser() {
    String email = emailcontroller.text.trim();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          TextField(
            controller: emailcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              hintText: 'Enter Email',
            ),
          ),
          SizedBox(height: 50),
          Center(
            child: SizedBox(
              height: 50,
              width: 160,
              child: MaterialButton(
                  onPressed: () {},
                  child: Text("Search", style: TextStyle(fontSize: 25)),
                  color: Colors.blue),
            ),
          )
        ],
      )),
    );
  }
}
