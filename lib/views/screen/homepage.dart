import 'package:chatterz/views/utility/services/fb_authservices.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.bottomRight,
            height: size.height * 0.1,
            width: size.width * 0.28,
            decoration: BoxDecoration(
              color: Colors.cyan,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: FBAuthServices
                            .fbAuthServices.auth.currentUser?.photoURL !=
                        null
                    ? NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/chatterz-4ed37.appspot.com/o/${Uri.encodeComponent(FBAuthServices.fbAuthServices.auth.currentUser!.photoURL ?? "")}?alt=media')
                    : const NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/chatterz-4ed37.appspot.com/o/default%20image%2Fuser_image.png?alt=media&token=a090e2bb-5681-40dd-9a73-284d95809347'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            FBAuthServices.fbAuthServices.auth.currentUser?.displayName ?? "",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
