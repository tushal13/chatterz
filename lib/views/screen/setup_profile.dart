import 'package:chatterz/modal/userModal.dart';
import 'package:chatterz/views/screen/loginpage.dart';
import 'package:chatterz/views/utility/appcolors.dart';
import 'package:chatterz/views/utility/apptextstayl.dart';
import 'package:chatterz/views/utility/services/fb_authservices.dart';
import 'package:chatterz/views/utility/services/fb_storeservices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'homepage.dart';

class SetupProfile extends StatelessWidget {
  SetupProfile({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    User? user = FBAuthServices.fbAuthServices.auth.currentUser;
    return Scaffold(
        appBar: AppBar(
          title: user?.displayName == null && user?.photoURL == null
              ? const Text('Setup Profile')
              : const Text(
                  'Update Profile',
                ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: size.height * 0.67,
                  child: Column(
                    children: [
                      user?.displayName == null || user?.photoURL == null
                          ? Center(
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    height: size.height * 0.1,
                                    width: size.width * 0.28,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: user?.photoURL != null
                                            ? NetworkImage(
                                                'https://firebasestorage.googleapis.com/v0/b/chatterz-4ed37.appspot.com/o/${Uri.encodeComponent(user?.photoURL ?? '')}?alt=media')
                                            : const NetworkImage(
                                                'https://firebasestorage.googleapis.com/v0/b/chatterz-4ed37.appspot.com/o/default%20image%2Fuser_image.png?alt=media&token=a090e2bb-5681-40dd-9a73-284d95809347'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: size.height * 0.06,
                                    left: size.width * 0.16,
                                    bottom: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        imagepickerbottomsheet(context);
                                      },
                                      icon: Icon(
                                        Icons.add_circle_sharp,
                                        size: 25,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      user?.displayName == null || user?.photoURL == null
                          ? Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Visibility(
                                    visible: user?.displayName == null,
                                    child: TextFormField(
                                      controller: nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }

                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      onFieldSubmitted: (value) async {
                                        await FbStoreServices.fbStStoreServices
                                            .updateDisplayName(
                                                nameController.text);
                                        // Handle the next focus or action here
                                      },
                                      style: AppTextStyle.textfieldinput,
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(CupertinoIcons.person),
                                        hintText: 'Enter Your name',
                                        hintStyle: AppTextStyle.textfieldhint,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: user?.displayName != null,
                                    child: TextFormField(
                                      enabled: false,
                                      initialValue: user?.displayName ?? '',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }

                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                      onFieldSubmitted: (value) async {
                                        await FbStoreServices.fbStStoreServices
                                            .updateDisplayName(value);
                                      },
                                      style: AppTextStyle.textfieldinput,
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(CupertinoIcons.person),
                                        hintText: 'Enter Your name',
                                        hintStyle: AppTextStyle.textfieldhint,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  TextFormField(
                                    initialValue: user?.email ?? '',
                                    enabled: user?.displayName == null,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!value.contains('@') ||
                                          !value.contains('.')) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    onFieldSubmitted: (value) {},
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.5,
                                        fontSize: 18),
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(CupertinoIcons.mail),
                                      hintText: 'Enter You Email',
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FBAuthServices.fbAuthServices
                                          .fetchUser(),
                                      builder: (context, snap) {
                                        if (snap.hasData) {
                                          QuerySnapshot<Map<String, dynamic>>?
                                              data = snap.data;
                                          List<
                                                  QueryDocumentSnapshot<
                                                      Map<String, dynamic>>>
                                              myData = data?.docs ?? [];
                                          List<UserModal> users = myData
                                              .map((e) =>
                                                  UserModal.fromMap(e.data()))
                                              .toList();
                                          List<UserModal> currentUser = myData
                                              .map((e) =>
                                                  UserModal.fromMap(e.data()))
                                              .where((use) =>
                                                  use.email == user?.email)
                                              .toList();

                                          UserModal currentuser =
                                              currentUser.first;

                                          Logger().i(user);

                                          return Column(
                                            children: [
                                              Visibility(
                                                visible: currentuser.username ==
                                                    null,
                                                child: TextFormField(
                                                  initialValue:
                                                      currentuser.username ??
                                                          '',
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your username';
                                                    }
                                                    if (value.length < 4) {
                                                      return 'Username must be at least 4 characters long';
                                                    }
                                                    if (users.any((user) =>
                                                        user.username ==
                                                        value)) {
                                                      return 'Username already exists';
                                                    }
                                                    return null;
                                                  },
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  onFieldSubmitted: (value) {},
                                                  style: AppTextStyle
                                                      .textfieldinput,
                                                  decoration: InputDecoration(
                                                    suffixIcon: Icon(
                                                        CupertinoIcons
                                                            .app_badge),
                                                    hintText:
                                                        'Enter Your Username',
                                                    hintStyle: AppTextStyle
                                                        .textfieldhint,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: currentuser.username !=
                                                    null,
                                                child: TextFormField(
                                                  controller:
                                                      usernameController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter your username';
                                                    }
                                                    if (value.length < 4) {
                                                      return 'Username must be at least 4 characters long';
                                                    }
                                                    if (users.any((user) =>
                                                        user.username ==
                                                        value)) {
                                                      return 'Username already exists';
                                                    }
                                                    return null;
                                                  },
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  onFieldSubmitted: (value) {},
                                                  style: AppTextStyle
                                                      .textfieldinput,
                                                  decoration: InputDecoration(
                                                    suffixIcon: Icon(
                                                        CupertinoIcons
                                                            .app_badge),
                                                    hintText:
                                                        'Enter Your Username',
                                                    hintStyle: AppTextStyle
                                                        .textfieldhint,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Colors.grey,
                                                        style:
                                                            BorderStyle.solid,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/chatterz-4ed37.appspot.com/o/${Uri.encodeComponent(user?.photoURL ?? '')}?alt=media'),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Hello,',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${user?.displayName ?? 'User'}!',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Is this you?',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 30),
                                SizedBox(height: 10),
                                TextButton(
                                  onPressed: () {
                                    // Cancel or Edit logic here
                                  },
                                  child: Text(
                                    'Not You? Edit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                user?.displayName == null || user?.photoURL == null
                    ? GestureDetector(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            await FbStoreServices.fbStStoreServices
                                .updateProfile(
                              usernameController.text,
                            );
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage()));
                          }
                          // Logger().i("Profile image uploaded. Url: ${user}");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width,
                          height: size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primaryColor,
                          ),
                          child: Text('Next', style: AppTextStyle.btntextstyq),
                        ),
                      )
                    : Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                await FbStoreServices.fbStStoreServices
                                    .updateProfile(
                                  usernameController.text,
                                );
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => HomePage()));
                              }
                              // Logger().i("Profile image uploaded. Url: ${user}");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width,
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryColor,
                              ),
                              child: Text('Confirm',
                                  style: AppTextStyle.btntextstyq),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginPage()));

                              // Logger().i("Profile image uploaded. Url: ${user}");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width,
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  )),
                              child: Text('Not You ? ',
                                  style: AppTextStyle.btntextstyq
                                      .copyWith(color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ));
  }
}

imagepickerbottomsheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(18),
        height: 170,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile photo",
                  style: AppTextStyle.mbtitle,
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 65,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.secondaryColor,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 35,
                          ),
                          // title: Text('Camera'),
                          onPressed: () async {
                            await FbStoreServices.fbStStoreServices
                                .pickCameraProfileImage();
                          }),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Text(
                      "Camera",
                      style: AppTextStyle.mbbtntitle,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 65,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.secondaryColor,
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            size: 35,
                          ),
                          // title: Text('Gallery'),
                          onPressed: () async {
                            await FbStoreServices.fbStStoreServices
                                .pickGalleryProfileImage();
                          }),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Text("Gallery", style: AppTextStyle.mbbtntitle),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

//
