import 'package:cloud_firestore/cloud_firestore.dart';

class FBSServices {
  late FirebaseFirestore firestore;

  String usercollectionName = "Users";

  FBSServices._init() {
    firestore = FirebaseFirestore.instance;
  }

  static final FBSServices fbsServices = FBSServices._init();
  addUser(
    String displayName,
    String username,
    String email,
    String photoUrl,
    String uid,
    String deviceToken,
  ) async {
    return await firestore.collection(usercollectionName).doc(uid).set({
      "displayName": displayName,
      "username": username,
      "email": email,
      "photoUrl": photoUrl,
      "uid": uid,
      "deviceToken": deviceToken,
      "date": FieldValue.serverTimestamp(),
    });
  }
}
