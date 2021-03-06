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
import 'package:messanger/controller/uihelp.dart';
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
    UiHelper.showloadingDialog(context, "Loading");
    try {
      XFile? pickedfile = await ImagePicker().pickImage(source: source);
      cropimage(pickedfile);
    } catch (e) {
      //print(e.toString());
      Navigator.pop(context);
      UiHelper.showAlertDialog(context, "Error!", e.toString());
    }
  }

  void cropimage(XFile? file) async {
    try {
      CroppedFile? cropfile = await ImageCropper().cropImage(
        sourcePath: file!.path,
        compressQuality: 3,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (cropfile != null) {
        setState(() {
          imageFile = File(cropfile.path);

          // print(imageFile);
        });
        Navigator.pop(context);
      }
    } catch (e) {
      UiHelper.showAlertDialog(context, "Error!te", e.toString());
    }
  }

  void check() {
    String fullname = fullnamecontroller.text.trim();
    if (fullname == "" || imageFile == null) {
      UiHelper.showAlertDialog(
          context, "Incomplete", "Please fill all the details");
    } else {
      setdata();
    }
  }

  void setdata() async {
    UiHelper.showloadingDialog(context, "Uploading Image");
    try {
      UploadTask uploadtask = FirebaseStorage.instance
          .ref("profilePictures")
          .child(widget.usermodel.uid!.toString())
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadtask;

      String imageurl = await snapshot.ref.getDownloadURL();

      String fullname = fullnamecontroller.text.trim();
      widget.usermodel.fullname = fullname;
      widget.usermodel.profilepic = imageurl;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.usermodel.uid)
          .set(widget.usermodel.toMap())
          .then((value) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen(
            usermodel: widget.usermodel,
            firebaseuser: widget.firebaseuser,
          );
        }));
      });
    } catch (ex) {
      Navigator.pop(context);
      UiHelper.showAlertDialog(context, "Error!", ex.toString());
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
        child: ListView(
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
              width: 10,
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
