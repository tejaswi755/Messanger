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
                child: Container(
                    child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("chatrooms")
                                        .doc(widget.chatroom.chatroomid)
                                        .collection("messages")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.active) {
                                        if (snapshot.hasData) {
                                          QuerySnapshot datasnapshot =
                                              snapshot.data as QuerySnapshot;

                                          return ListView.builder(
                                            itemCount: datasnapshot.docs.length,
                                            itemBuilder: (context, index) {
                                              MessageModel currentmessage =
                                                  MessageModel.fromMap(datasnapshot.docs[index]
                                                      .data() as Map<String, dynamic>);
                                             
                                              return Text(currentmessage.text.toString());
                                            },
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(child: const Text("check your internet connection"));
                                        } else {
                                          return Center(child: const Text("Say hii to your new Friend"));
                                        }
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    },
                                  ),
                    ),
              ),
              Container(
                color: Colors.grey[400],
                height: 65,
                child: Row(
                  children: [
                    Flexible(
                        child: TextField(
                      maxLines: null,
                      controller: messagecontroller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
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
        ),);
  }
}
