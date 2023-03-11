import 'package:chat_stack/api/apis.dart';
import 'package:chat_stack/models/chat_user.dart';
import 'package:chat_stack/screens/profile_screen.dart';
import 'package:chat_stack/screens/sentiment_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // declare confettiController;
  late ConfettiController _centerController;
  // For storing all users
  List<ChatUser> _list = [];
  // for storing searched items
  final List<ChatUser> _SearchList = [];
  // For storing search satatus
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    // initialize confettiController
    _centerController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    // dispose the controller
    _centerController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   APIs.getSelfInfo();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        // If search is on and back button is pressed close search
        // else simiple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            // leading: ElevatedButton.icon(
            //   icon: const Icon(CupertinoIcons.square_stack),
            //   onPressed: () {
            //     return HiddenDrawer();
            //   },
            //   label: const Text(''),
            // ),

            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search: Name, Email...',
                        hintStyle: TextStyle(color: Colors.white)),
                    autofocus: true,
                    style: const TextStyle(
                        fontSize: 17, letterSpacing: 0.5, color: Colors.white),
                    //when search text changes then updated search list
                    onChanged: (val) {
                      // search logic
                      _SearchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _SearchList.add(i);
                        }
                      }
                      setState(() {
                        // update UI with new _SearchList
                        _SearchList;
                      });
                    },

                    // onChanged: (val) {
                    //   // search logic
                    //   _SearchList.clear();
                    //   for (var i in _list) {
                    //     if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                    //         i.email.toLowerCase().contains(val.toLowerCase())) {
                    //       _SearchList.add(i);
                    //     }
                    //   }
                    //   setState(() {
                    //     // update UI with new _SearchList
                    //     _SearchList;
                    //   });
                    // },
                  )
                : const Text("Chatellar"),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(
                      _isSearching ? CupertinoIcons.clear_fill : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me)));
                  },
                  icon: const Icon(Icons.more_vert_outlined)),
            ],
          ),

          // Background color
          backgroundColor: Colors.transparent,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 150, bottom: 20),
            child: FloatingActionButton(
              onPressed: () {
                _centerController.play();
              },
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              backgroundColor: const Color.fromARGB(255, 161, 0, 62),
              child: const Icon(Icons.celebration_outlined),
            ),
          ),
          body: SafeArea(
              child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: StreamBuilder<QuerySnapshot>(
                  stream: APIs.getAllUsers(),
                  builder: (context, snapshot) {
                    // log('Info: ${snapshot.connectionState}');
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
                        // log('Data:$data');
                        _list = data
                                ?.map((e) => ChatUser.fromJson(
                                    e.data() as Map<String, dynamic>))
                                .toList() ??
                            [];
                        // log('Data:$_list');
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
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _isSearching
                                  ? _SearchList.length
                                  : _list.length,
                              padding: EdgeInsets.only(top: mq.height * 0.035),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatUserCard(
                                    user: _isSearching
                                        ? _SearchList[index]
                                        : _list[index]);
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
              ),
              // align the confetti on the screen
              Align(
                alignment: const Alignment(0, 0.8),
                child: ConfettiWidget(
                  confettiController: _centerController,
                  // blastDirection: pi / 2,
                  blastDirectionality: BlastDirectionality.explosive,
                  // maxBlastForce: 5,
                  // minBlastForce: 1,
                  // emissionFrequency: 0.03,

                  emissionFrequency: 0.01,
                  numberOfParticles: 20,
                  maxBlastForce: 30,
                  minBlastForce: 15,
                  gravity: 0.3,

                  // 10 paticles will pop-up at a time
                  // numberOfParticles: 10,

                  // particles will pop-up
                  // gravity: 0,
                ),
              )
            ],
          )),
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 11, 39, 58),
                    ),
                    child: Center(
                      child: Text(
                        'F E A T U R E S',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: const Icon(Icons.rocket_launch_outlined),
                      tileColor: const Color.fromARGB(255, 162, 237, 247),
                      title: const Text('Sentiment Analyzer'),
                      horizontalTitleGap: 2,
                      onTap: () {
                        // Update the state of the app
                        // ...
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SentimentScreen()));
                        // Then close the drawer
                        //
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: const Color.fromARGB(255, 162, 247, 239),
                      title: const Text('Coming soon...'),
                      horizontalTitleGap: 2,
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        // Navigator.pop(context);
                      },
                    ),
                  ),
                ]),
          ),
          endDrawer: const Drawer(),
        ),
      ),
    );
  }
}
