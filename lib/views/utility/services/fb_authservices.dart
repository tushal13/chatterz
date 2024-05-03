import 'package:chatterz/views/utility/services/fbs_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/web.dart';

class FBAuthServices {
  late FirebaseAuth auth;
  late FirebaseMessaging firebaseMessaging;
  FBAuthServices._init() {
    auth = FirebaseAuth.instance;
    firebaseMessaging = FirebaseMessaging.instance;
  }

  static FBAuthServices fbAuthServices = FBAuthServices._init();

  String collectionName = 'Users';

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUser() {
    return FBSServices.fbsServices.firestore
        .collection(collectionName)
        .snapshots();
  }

  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      Logger().i(
          "Registered with email and password.\nUser: ${userCredential.user}");

      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          signInWithEmailAndPassword(email, password);
          break;
        default:
          print("Unknown error.");
      }
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String deviceToken = await firebaseMessaging.getToken() ?? "";
      User user = userCredential.user!;
      await FBSServices.fbsServices.addUser(
          user.displayName ?? '',
          user.displayName ?? '',
          user.email ?? '',
          user.photoURL ?? '',
          user.uid,
          deviceToken);
      print("Signed in with email and password.\nUser: ${userCredential.user}");

      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          print(
              "The password is invalid or the user does not have a password.");
          break;
        case "user-not-found":
          print("No user found for the provided email.");
          break;
        default:
          print("Unknown error. ${e.code}");
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }
}
