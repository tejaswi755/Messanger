import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/model/chatroom.dart';
import 'package:messanger/model/usermodel.dart';

class Chatscreen extends StatefulWidget {
  final UserModel usermodel;
  final User firebaseuser;
  final ChatRoomModel chatroom;
  final UserModel targetuser;

  const Chatscreen(
      {super.key,
      required this.usermodel,
      required this.firebaseuser,
      required this.chatroom,
      required this.targetuser});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("dlkfhuiwe"),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Container(
                color: Colors.grey[400],
                height: 65,
                child: Row(
                  children: const [
                    Flexible(
                        child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    )),
                    IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
