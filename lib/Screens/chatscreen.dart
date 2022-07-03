import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/model/chatroom.dart';
import 'package:messanger/model/messagemodel.dart';
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
  void sendmessage() {
    String message = messagecontroller.text;

    if (message != "") {
      MessageModel messagemodel = MessageModel(
          messageid: "dhf",
          createdon: DateTime.now(),
          seen: false,
          sender: widget.usermodel.uid,
          text: message);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc()
          .set(messagemodel.tomap());
    }
  }

  TextEditingController messagecontroller = TextEditingController();
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
                  children: [
                    Flexible(
                        child: TextField(
                      controller: messagecontroller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    )),
                    IconButton(
                        onPressed: () {
                          log("message sent");
                        },
                        icon: const Icon(
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
