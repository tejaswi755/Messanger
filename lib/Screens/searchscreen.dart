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
  TextEditingController searchemailcontroller = TextEditingController();

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
              controller: searchemailcontroller,
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
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text("Search", style: TextStyle(fontSize: 25)),
                    color: Colors.blue),
              ),
            ),
            SizedBox(height: 50),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("email", isEqualTo: searchemailcontroller.text.trim())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;

                    if (datasnapshot.docs.length > 0) {
                      Map<String, dynamic> userdata =
                          datasnapshot.docs[0].data() as Map<String, dynamic>;

                      UserModel searchuser = UserModel.fromMap(userdata);

                      return ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(searchuser.profilepic!)),
                        title: Text(searchuser.fullname!),
                        subtitle:Text(searchuser.email!) ,
                        trailing:Icon(Icons.chevron_right_outlined) ,
                      );
                    }
                    return Text(" No Data Found");
                  } else {
                    return Text(" No Data Found");
                  }
                } else if (snapshot.hasError) {
                  return Text(" Error has occured");
                } else {
                  return Text(" No Data found");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
