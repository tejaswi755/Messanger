import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? imageFile;
  TextEditingController fullname = TextEditingController();

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
      CroppedFile? cropfile =
          await ImageCropper().cropImage(sourcePath: file!.path);

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
            const TextField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
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
                  onPressed: () {},
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
