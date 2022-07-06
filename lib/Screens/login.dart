import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger/Screens/home.dart';
import 'package:messanger/Screens/register.dart';
import 'package:messanger/model/usermodel.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  void check() {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    if (email == "" || password == "") {
      print("All fields are not filled");
    } else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? usercredential;
    String? uid;
    try {
      usercredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }

    if (usercredential != null) {
      uid = usercredential.user!.uid;
      DocumentSnapshot userdata =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      UserModel usermodel =
           UserModel.fromMap(userdata.data() as Map<String, dynamic>);
     // print(usermodel.email);
       Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeScreen(firebaseuser: usercredential!.user!,usermodel: usermodel,);
                    }));
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
              controller: emailcontroller,keyboardType: TextInputType.emailAddress,
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
             // keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Password',
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 50,
              width: 160,
              child: MaterialButton(
                  onPressed: () {
                    check();
                   
                  },
                  color: Colors.blue,
                  child: const Text(
                    " Login ",
                    style: TextStyle(fontSize: 25),
                  )),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account ?"),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterPage();
                    }));
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
