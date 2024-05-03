import 'dart:io';
import 'dart:typed_data';

import 'package:chatterz/views/utility/services/fb_authservices.dart';
import 'package:chatterz/views/utility/services/fbs_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class FbStoreServices {
  late FirebaseFirestore firestore;
  late FirebaseStorage storage;

  late FirebaseMessaging firebaseMessaging;

  FbStoreServices._init() {
    firestore = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance;
    firebaseMessaging = FirebaseMessaging.instance;
  }

  String collectionName = 'Users';
  ImagePicker imagePicker = ImagePicker();
  static FbStoreServices fbStStoreServices = FbStoreServices._init();

  pickCameraProfileImage() async {
    try {
      XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        String? imageUrl = pickedFile.path;
        Logger().i("Profile image uploaded. Url: $imageUrl");
        String? url = await uploadImage(imagePath: pickedFile.path);
        Logger().i("Profile image uploaded. Url: $url");
        updateProfileImage(url ?? '');
      }
    } catch (e) {
      print("Error picking profile image: $e");
      Logger().e("Error picking profile image: $e");
    }
  }

  pickGalleryProfileImage() async {
    try {
      XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        String? imageUrl = pickedFile.path;
        Logger().i("Profile image uploaded. Url: $imageUrl");
        String? url = await uploadImage(imagePath: pickedFile.path);
        Logger().i("Profile image uploaded. Url: $url");
        updateProfileImage(url ?? '');
      }
    } catch (e) {
      print("Error picking profile image: $e");
      Logger().e("Error picking profile image: $e");
    }
  }

  Future<String?> uploadImage({required String imagePath}) async {
    File imageFile = File(imagePath);

    if (!await imageFile.exists()) {
      print('File does not exist at path: $imagePath');
      return null;
    }

    String fileName =
        'Profile/${FBAuthServices.fbAuthServices.auth.currentUser!.email}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = storage.ref(fileName);

    Uint8List imageData = await imageFile.readAsBytes();

    try {
      await ref.putData(imageData);
      return ref.fullPath;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  updatediveceToken() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
    await FBSServices.fbsServices.firestore
        .collection(collectionName)
        .doc(
          FBAuthServices.fbAuthServices.auth.currentUser!.uid,
        )
        .update({
      "deviceToken": deviceToken,
    });
    Logger().i(
        "Profile image updated. Url: ${FBAuthServices.fbAuthServices.auth.currentUser}");
  }

  updateProfileImage(String imageUrl) async {
    await FBAuthServices.fbAuthServices.auth.currentUser!
        .updatePhotoURL(imageUrl);
    await FBSServices.fbsServices.firestore
        .collection(collectionName)
        .doc(
          FBAuthServices.fbAuthServices.auth.currentUser!.uid,
        )
        .update({
      "photoUrl": imageUrl,
    });
    Logger().i(
        "Profile image updated. Url: ${FBAuthServices.fbAuthServices.auth.currentUser}");
  }

  updateDisplayName(String displayName) async {
    await FBAuthServices.fbAuthServices.auth.currentUser
        ?.updateDisplayName(displayName);
    await FBSServices.fbsServices.firestore
        .collection(collectionName)
        .doc(
          FBAuthServices.fbAuthServices.auth.currentUser!.uid,
        )
        .update({
      "displayName": displayName,
    });
    Logger().i(
        "Profile updated. User: ${FBAuthServices.fbAuthServices.auth.currentUser}");
  }

  updateProfile(String username) async {
    await FBSServices.fbsServices.firestore
        .collection(collectionName)
        .doc(
          FBAuthServices.fbAuthServices.auth.currentUser!.uid,
        )
        .update({
      "username": username,
    });
    Logger().i(
        "Profile updated. User: ${FBAuthServices.fbAuthServices.auth.currentUser}");
  }
}
