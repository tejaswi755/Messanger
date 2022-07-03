import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:messanger/Screens/home.dart';
import 'package:messanger/model/usermodel.dart';

class ProfilePage extends StatefulWidget {
  final UserModel usermodel;
  final User firebaseuser;

  const ProfilePage(
      {super.key, required this.usermodel, required this.firebaseuser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? imageFile;
  TextEditingController fullnamecontroller = TextEditingController();

  void selectimage(ImageSource source) async {
    try {
      XFile? pickedfile = await ImagePicker().pickImage(source: source);
      cropimage(pickedfile);
    } catch (e) {
      //print(e.toString());
    }
  }

  void cropimage(XFile? file) async {
    try {
      CroppedFile? cropfile = await ImageCropper().cropImage(
        sourcePath: file!.path,
        compressQuality: 10,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (cropfile != null) {
        setState(() {
          imageFile = File(cropfile.path);
          // print(imageFile);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void check() {
    String fullname = fullnamecontroller.text.trim();
    if (fullname == "" || imageFile == null) {
      print("Pleasse fill all the details");
    } else {
      setdata();
    }
  }

  void setdata() async {
    try {
      UploadTask uploadtask = FirebaseStorage.instance
          .ref("profilePictures")
          .child(widget.usermodel.uid!.toString())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadtask;

      String imageurl = await snapshot.ref.getDownloadURL();
      log(imageurl);
      String fullname = fullnamecontroller.text.trim();
      widget.usermodel.fullname = fullname;
      widget.usermodel.profilepic = imageurl;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.usermodel.uid)
          .set(widget.usermodel.toMap())
          .then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen(
            usermodel: widget.usermodel,
            firebaseuser: widget.firebaseuser,
          );
        }));
      });
    } catch (ex) {
      print(ex);
    }
  }

  void showPhotoOption() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload Profile Image"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectimage(ImageSource.gallery);
                },
                title: const Text("Select From Galary"),
                leading: const Icon(Icons.photo_album_outlined),
              ),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectimage(ImageSource.camera);
                  },
                  title: const Text("Select From Camera"),
                  leading: const Icon(Icons.camera_alt_outlined))
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile Page"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 150,
            ),
            CupertinoButton(
              onPressed: () {
                showPhotoOption();
              },
              child: CircleAvatar(
                backgroundImage:
                    imageFile != null ? FileImage(imageFile!) : null,
                maxRadius: 60,
                child: imageFile == null ? Icon(Icons.person, size: 60) : null,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: fullnamecontroller,
              // obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                hintText: 'Enter Full Name',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              width: 160,
              child: MaterialButton(
                  onPressed: () {
                    check();
                  },
                  color: Colors.blue,
                  child: const Text(
                    " Submit",
                    style: TextStyle(fontSize: 25),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
