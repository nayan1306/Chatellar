import 'dart:developer';

import 'package:chat_stack/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text("Chat Stack"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 150, bottom: 20),
        child: FloatingActionButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          },
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 161, 0, 62),
          child: const Icon(Icons.message_outlined),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          log('Info: ${snapshot.connectionState}');
          switch (snapshot.connectionState) {
            // if data is loadinig
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            // If some or all data is loaded show it
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs.reversed;
              log('Data:$data');
              list = data
                      ?.map((e) =>
                          ChatUser.fromJson(e.data() as Map<String, dynamic>))
                      .toList() ??
                  [];
              log('Data:$list');
              /* ---------------Test 4---------------- */
              // APIs.firestore.collection("users").get().then(
              //   (querySnapshot) {
              //     print("Successfully completed");

              //     for (var docSnapshot in querySnapshot.docs) {
              //       log('${docSnapshot.id} => ${docSnapshot.data()}');
              //       log('Output 2: ${querySnapshot.docs}');
              //     }
              //     log('List:$list');
              //   },
              //   onError: (e) => print("Error completing: $e"),
              // );

              /* ---------------Test 3---------------- */
              // if (snapshot.hasData) {
              //   APIs.firestore.collection("users").get().then((event) {
              //     for (var doc in event.docs) {
              //       // log("${doc.id} => ${jsonEncode(doc.data())}");
              //       final data = doc.data();
              //       log('Some content: $data');
              //       // list =
              //       //     data.map((e) => ChatUser.fromJson(e.data())).toList() ??
              //       //         [];
              //     }
              //   });
              //   //final data = snapshot.docs.data();

              //   log('This works fine........');
              // }

              //***************Test 2************************************ */
              // log('Info: ${snapshot.connectionState}');

              // final docRef = APIs.firestore.collection("users").doc();
              // docRef.get().then(
              //   (DocumentSnapshot doc) {
              //     final data = doc.data() as List;
              //     list =
              //         data.map((e) => ChatUser.fromJson(e.data())).toList() ??
              //             [];

              //     log('Some content: $data');
              //     // ...
              //   },
              //   onError: (e) => print("Error getting document: $e"),
              // );

              // log('Info: ${snapshot.connectionState}');
              /***************Test 1********************************* */
              // if (snapshot.hasData) {
              //   FirebaseFirestore.instance
              //       .collection("users")
              //       .get()
              //       .then((event) {
              //     for (var doc in event.docs) {
              //       log("${doc.id} => ${jsonEncode(doc.data())}");
              //     }
              //   });
              //   log('This works fine........');
              // }

              // Logic to handel if no connections are present
              if (list.isNotEmpty) {
                return ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.only(top: mq.height * 0.035),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUserCard(user: list[index]);
                      //return Text('Name: ${list[index]}');
                    });
              } else {
                return const Center(
                    child: Text(
                  "No Connections found.",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ));
              }
          }
        },
      ),
    );
  }
}
