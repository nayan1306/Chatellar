import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_stack/api/apis.dart';
import 'package:chat_stack/helper/dialogues.dart';
import 'package:chat_stack/screens/auth/Login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // For hinding keyboard on tapping anywhere in screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: const Color.fromARGB(255, 12, 90, 126),
          // actions: [
          //   // Search user button
          //   IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          //   //more features button
          //   IconButton(
          //       onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
          // ],
        ),

        // Logout button
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton.extended(
                onPressed: () async {
                  Dialogues.showProgressbar(context);
                  await FirebaseAuth.instance.signOut().then((value) async {
                    await GoogleSignIn().signOut().then((value) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()));
                    });
                  });
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color.fromARGB(255, 254, 87, 87))),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),

                  // User profile picture
                  Stack(
                    children: [
                      _image != null
                          ?
                          // Image from local storage
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .02),
                              child: Image.file(File(_image!),
                                  width: mq.height * .18,
                                  height: mq.height * .18,
                                  fit: BoxFit.cover),
                            )
                          :
                          // Image from server
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .02),
                              child: CachedNetworkImage(
                                width: mq.height * .18,
                                height: mq.height * .18,
                                fit: BoxFit.fill,
                                imageUrl: widget.user.image,
                                // placeholder: (context, url) =>
                                //     const CircleAvatar(child: Icon(CupertinoIcons.person)),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                        child: Icon(CupertinoIcons.person)),
                              ),
                            ),

                      // edit button on top of profile picture
                      Positioned(
                        bottom: -10,
                        right: 20,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          color: const Color.fromARGB(181, 43, 43, 43),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: mq.height * .02,
                  ),

                  // User email
                  Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.blueGrey.shade700),
                  ),

                  SizedBox(
                    height: mq.height * .02,
                  ),

                  // User name
                  TextFormField(
                    onSaved: (newValue) => APIs.me.name = newValue ?? " ",
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "Required field",
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_2_outlined,
                        color: Colors.teal.shade300,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg: Elon Musk',
                      label: const Text("Name"),
                    ),
                  ),

                  SizedBox(
                    height: mq.height * .02,
                  ),

                  // About
                  TextFormField(
                    onSaved: (newValue) => APIs.me.about = newValue ?? " ",
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : "Required field",
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.article,
                        color: Colors.teal.shade300,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'eg: I am feeling Great',
                      label: const Text("About"),
                    ),
                  ),

                  SizedBox(
                    height: mq.height * .02,
                  ),
                  // Update button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(
                          side: BorderSide(
                        color: Color.fromRGBO(206, 210, 210, 1),
                        width: 3,
                      )),
                      minimumSize: Size(mq.width * .4, mq.height * .06),
                      backgroundColor: const Color.fromARGB(225, 64, 203, 117),
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        log("Inside validator");
                        APIs.updateUserInfo().then((value) {
                          Dialogues.showSnackbar(
                              context, "Profile updated successfully.");
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text("UPDATE", style: TextStyle(fontSize: 16)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Bottom sheet for pickinig profile picture
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromARGB(255, 149, 146, 146), width: 5),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        // barrierColor: const Color.fromARGB(255, 255, 0, 0),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .1),
            children: [
              const Text(
                'Profile photo',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 84, 102, 116),
                    fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 18, 162, 178),
                          fixedSize: Size(mq.width * .150, mq.height * .09),
                          shape: const CircleBorder()),
                      onPressed: () async {
                        // Capture a photo
                        final ImagePicker picker0 = ImagePicker();
                        final XFile? photo = await picker0.pickImage(
                            source: ImageSource.camera, imageQuality: 100);
                        if (photo != null) {
                          // For hiding bottom sheet
                          _image = photo.path;
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 25,
                      )),
                  // To pick image from gallery
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 19, 132, 163),
                          fixedSize: Size(mq.width * .150, mq.height * .09),
                          shape: const CircleBorder()),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 100);

                        if (image != null) {
                          log(' import Image path : ${image.path} -- Image mime type: ${image.mimeType}');
                          // For hiding bottom sheet
                          _image = image.path;
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(
                        Icons.photo,
                        size: 25,
                      )),
                ],
              )
            ],
          );
        });
  }
}
