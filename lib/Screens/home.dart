import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/Screens/chatscreen.dart';
import 'package:messanger/Screens/login.dart';
import 'package:messanger/Screens/searchscreen.dart';
import 'package:messanger/controller/getmodelcontroller.dart';
import 'package:messanger/model/chatroom.dart';
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
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchScreen(
                    usermodel: widget.usermodel, user: widget.firebaseuser);
              }));
            },
            child: const Icon(Icons.search)),
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
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chatrooms")
              .where("participants.${widget.usermodel.uid}", isEqualTo: true)
              .orderBy("lastmessage", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                if (datasnapshot.docs.length > 0) {
                  return ListView.builder(
                    itemCount: datasnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatroomodel = ChatRoomModel.fromMap(
                          datasnapshot.docs[index].data()
                              as Map<String, dynamic>);
                      Map<String, dynamic> participantsmap =
                          chatroomodel.participants!;
                      List<String> participantKey =
                          participantsmap.keys.toList();
                      participantKey.remove(widget.usermodel.uid);
                      return FutureBuilder(
                        future:
                            GetUserModel.getusermodelById(participantKey[0]),
                        builder: (context, userdata) {
                          if (userdata.connectionState ==
                              ConnectionState.done) {
                            UserModel targetuser = userdata.data as UserModel;
                            return Container(
                              color: Colors.grey[300],
                              margin: EdgeInsets.symmetric(vertical: 1),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Chatscreen(
                                        usermodel: widget.usermodel,
                                        firebaseuser: widget.firebaseuser,
                                        chatroom: chatroomodel,
                                        targetuser: targetuser);
                                  }));
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(targetuser.profilepic!),
                                ),
                                title: Text(targetuser.fullname!),
                                subtitle: Text(chatroomodel.lastmessage!),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("Start Connecting with your Friend's",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300)),
                  );
                }
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text(snapshot.error.toString());
              } else {
                return const Text("No Chats");
              }
            } else {
              return const CircularProgressIndicator.adaptive();
            }
          },
        ));
  }
}
