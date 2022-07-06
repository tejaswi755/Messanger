

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/main.dart';
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
          messageid: uuid.v1(),
          createdon: DateTime.now(),
          seen: false,
          sender: widget.usermodel.uid,
          text: message);
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(messagemodel.messageid)
          .set(messagemodel.tomap());
      widget.chatroom.lastmessage = message;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());
    }
  }

  TextEditingController messagecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          CircleAvatar(
              backgroundImage: NetworkImage(widget.targetuser.profilepic!)),
          const SizedBox(
            width: 50,
          ),
          const Text("Tejaswi")
        ]),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatroom.chatroomid)
                      .collection("messages")
                      .orderBy('createdon', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      
                      if (snapshot.hasData) {
                        QuerySnapshot datasnapshot =
                            snapshot.data as QuerySnapshot;
                        if (datasnapshot.docs.length > 0) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: datasnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentmessage =
                                  MessageModel.fromMap(datasnapshot.docs[index]
                                      .data() as Map<String, dynamic>);

                              return Row(
                                mainAxisAlignment: currentmessage.sender ==
                                        widget.usermodel.uid
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 10),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: currentmessage.sender ==
                                                widget.usermodel.uid
                                            ? Colors.teal
                                            : Colors.grey),
                                    child: Text(currentmessage.text.toString(),
                                        style: const TextStyle(fontSize: 22)),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text("Say Hiii to Your new Friend",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w300)),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text("check your internet connection"));
                      } else {
                        return const Center(
                          child: Text("Say Hiii to Your new Friend"),
                        );
                      }
                    } else {
                      return const SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator.adaptive(
                            value: 40,
                          ));
                    }
                  },
                ),
              ),
            ),
            Container(
              color: Colors.grey[400],
              height: 80,
              child: Row(
                children: [
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      maxLines: null,
                      controller: messagecontroller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  )),
                  IconButton(
                      onPressed: () {
                        sendmessage();
                        messagecontroller.clear();
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
      ),
    );
  }
}
