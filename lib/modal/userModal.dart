import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  String? displayName;
  String? username;
  String? email;
  String? photoURL;
  String? uid;
  String? deviceToken;
  Timestamp? date;
  // List requested;

  UserModal(
      {required this.displayName,
      required this.username,
      required this.email,
      required this.photoURL,
      required this.uid,
      required this.deviceToken,
      required this.date});

  factory UserModal.fromMap(Map<String, dynamic> currentUser) {
    return UserModal(
      displayName: currentUser['displayName'],
      username: currentUser['username'],
      email: currentUser['email'],
      photoURL: currentUser['photoURL'],
      uid: currentUser['uid'],
      deviceToken: currentUser['deviceToken'],
      date: currentUser['date'],
    );
  }
}
