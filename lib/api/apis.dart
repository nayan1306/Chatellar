import 'package:chat_stack/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  // For authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  //For accesing cloud firestone database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // For storing self information
  static late ChatUser me;

  // to return current user
  static get user => auth.currentUser!;

  // for checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // for creating a new user
  static Future<void> getSelfInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        createUser().then((value) => getSelfInfo());
      }
    });
  }

  // For creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    // DateTime now = DateTime.now();
    // String time = DateFormat('hh:mm a').format(now);

    final chatuser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hey, I am using Chatellar",
        createdAt: time,
        lastActive: time,
        id: auth.currentUser!.uid,
        isOnline: false,
        pushToken: '',
        email: user.email);
    return (await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set(chatuser.toJson()));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // For updating user information
  // for checking if user exists or not
  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }
}
