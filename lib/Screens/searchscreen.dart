import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/Screens/chatscreen.dart';
import 'package:messanger/main.dart';
import 'package:messanger/model/chatroom.dart';
import 'package:messanger/model/usermodel.dart';

class SearchScreen extends StatefulWidget {
  final UserModel usermodel;
  final User user;

  const SearchScreen({super.key, required this.usermodel, required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchemailcontroller = TextEditingController();

  Future<ChatRoomModel> getChatroom(UserModel targetuser) async {
    ChatRoomModel finalchatroom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.usermodel.uid}", isEqualTo: true)
        .where("participants.${targetuser.uid}", isEqualTo: true)
        .get();
    

    if (snapshot.docs.length > 0) {
      var data = snapshot.docs[0].data();
      ChatRoomModel existingchatroom =
          ChatRoomModel.fromMap(data as Map<String, dynamic>);
      finalchatroom = existingchatroom;
      
    } else {
      ChatRoomModel newchatroommodel = ChatRoomModel(
          chatroomid: uuid.v1(),
          lastmessage: " ",
          lastaccessed: DateTime.now(),
          participants: {
            widget.usermodel.uid.toString(): true,
            targetuser.uid.toString(): true
          });
      finalchatroom = newchatroommodel;
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newchatroommodel.chatroomid)
          .set(newchatroommodel.toMap());
      
    }

    return finalchatroom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: searchemailcontroller,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter Email',
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: SizedBox(
                height: 50,
                width: 160,
                child: MaterialButton(
                    onPressed: () {
                      setState(
                        () {},
                      );
                    },
                    color: Colors.blue,
                    child:
                        const Text("Search", style: TextStyle(fontSize: 25))),
              ),
            ),
            const SizedBox(height: 50),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where(
                    "email",
                    isEqualTo: searchemailcontroller.text.trim(),
                  )
                  .where('email', isNotEqualTo: widget.usermodel.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;

                    if (datasnapshot.docs.length > 0) {
                      Map<String, dynamic> userdata =
                          datasnapshot.docs[0].data() as Map<String, dynamic>;

                      UserModel searchuser = UserModel.fromMap(userdata);

                      return ListTile(
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                          searchuser.profilepic!,
                        )),
                        title: Text(searchuser.fullname!),
                        subtitle: Text(searchuser.email!),
                        onTap: () async {
                          ChatRoomModel? chatroom =
                              await getChatroom(searchuser);

                          if (chatroom != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Chatscreen(
                                    firebaseuser: widget.user,
                                    usermodel: widget.usermodel,
                                    targetuser: searchuser,
                                    chatroom: chatroom,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        trailing: const Icon(Icons.chevron_right_outlined),
                        tileColor: Colors.grey[400],
                      );
                    }
                    return const Text(" No Data Found");
                  } else {
                    return const Text(" No Data Found");
                  }
                } else if (snapshot.hasError) {
                  return const Text(" Error has occured");
                } else {
                  return const Text(" No Data found");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
