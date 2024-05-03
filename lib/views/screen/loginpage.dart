import 'package:chatterz/views/screen/registerpage.dart';
import 'package:chatterz/views/screen/setup_profile.dart';
import 'package:chatterz/views/utility/appcolors.dart';
import 'package:chatterz/views/utility/appicon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../utility/services/fb_authservices.dart';
import '../utility/services/fb_storeservices.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isInside = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  AppIcon.icon,
                  color: AppColors.primaryColor,
                  height: size.height * 0.15,
                ),
              ),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome back! Glad',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: '\nto see you, Again!',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 21,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
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
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                              color: Colors.grey, style: BorderStyle.solid),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }

                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }

                        if (!value.contains(RegExp(r'[A-Z]'))) {
                          return 'Password must contain at least one uppercase letter';
                        }

                        if (!value.contains(RegExp(r'[a-z]'))) {
                          return 'Password must contain at least one lowercase letter';
                        }

                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'Password must contain at least one digit';
                        }

                        return null;
                      },
                      obscureText: isPasswordVisible,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      onFieldSubmitted: (value) {},
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          fontSize: 18),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: isPasswordVisible
                              ? const Icon(
                                  CupertinoIcons.eye,
                                )
                              : const Icon(
                                  CupertinoIcons.eye_slash,
                                ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        hintText: 'Enter Your Password',
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Forgot Password?',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    await FBAuthServices.fbAuthServices
                        .signInWithEmailAndPassword(
                            emailController.text, passwordController.text);
                    await FbStoreServices.fbStStoreServices.updatediveceToken();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SetupProfile()));
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: size.width,
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                  child: const Text('Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      )),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('OR',
                        style: GoogleFonts.openSans(
                            fontSize: 22, fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Listener(
                onPointerUp: (_) => {
                  setState(() {
                    isInside = false;
                  })
                },
                onPointerMove: (_) {
                  setState(() {
                    isInside = true;
                  });
                },
                child: GestureDetector(
                  onTap: () async {
                    await FBAuthServices.fbAuthServices.signInWithGoogle();
                    if (FBAuthServices.fbAuthServices.auth.currentUser !=
                        null) {
                      Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: HomePage(),
                          ));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          isInside ? Color(0xE7EBEBF1) : Colors.grey.shade300,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
                          height: 40,
                        ),
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        Text(
                          'Sign In with Google',
                          style: GoogleFonts.poppins(
                            color: isInside ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don\'t have an account?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: '  Sign Up',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RagisterPage(),
                                ));
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
