import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/model/usermodel.dart';

class HomeScreen extends StatefulWidget {
  
  final UserModel usermodel;
 final User? firebaseuser;

  const HomeScreen({super.key, required this.usermodel, required this.firebaseuser});
  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
