import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:messanger/Screens/profile.dart';
//import 'package:messanger/controller/registercontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messanger/controller/uihelp.dart';
import 'package:messanger/model/usermodel.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  TextEditingController cpasswordcontroller = TextEditingController();

  void checkvalue() {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String cpassword = cpasswordcontroller.text.trim();

    if (email == "" || password == "" || cpassword == "") {
      
      UiHelper.showAlertDialog(
          context, "Data Incomplete", "All fields are not Completed");
    } else if (password != cpassword) {
      
      UiHelper.showAlertDialog(context, "Password Miss-Match",
          "Password in the fields do not Match");
    } else {
      register(email, password);
    }
  }

  void register(String email, String password) async {
    UserCredential? credential;
    String? uid;
    UiHelper.showloadingDialog(context, "Registering ");
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      UiHelper.showAlertDialog(context, "Error!", ex.code.toString());
    }

    if (credential != null) {
      uid = credential.user!.uid;
      UserModel newuser =
          UserModel(uid: uid, email: email, fullname: "", profilepic: " ");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newuser.toMap())
          .then((value) {
       Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ProfilePage(
            firebaseuser: credential!.user!,
            usermodel: newuser,
          );
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailcontroller,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter Email',
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: passwordcontroller,
              obscureText: true,
              decoration: const InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Password',
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: cpasswordcontroller,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: ' Conform Password',
                hintText: 'Conform Password',
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              width: 160,
              child: MaterialButton(
                  onPressed: () {
                    checkvalue();
                  },
                  color: Colors.blue,
                  child: const Text(
                    " Register ",
                    style: TextStyle(fontSize: 25),
                  )),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account ?"),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Click here",
                      style: TextStyle(color: Colors.blue)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
