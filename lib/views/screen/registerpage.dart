import 'package:chatterz/views/utility/appcolors.dart';
import 'package:chatterz/views/utility/appicon.dart';
import 'package:chatterz/views/utility/services/fb_authservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'loginpage.dart';

class RagisterPage extends StatefulWidget {
  const RagisterPage({super.key});

  @override
  State<RagisterPage> createState() => _RagisterPageState();
}

class _RagisterPageState extends State<RagisterPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

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
                  AppIcon.signupicon,
                  height: size.height * 0.20,
                ),
              ),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'New to Chatterz?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: '\nCreate an account',
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
                      height: size.height * 0.01,
                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your confirm password';
                        }

                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                      obscureText: isConfirmPasswordVisible,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (value) {},
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          fontSize: 18),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: isConfirmPasswordVisible
                              ? const Icon(
                                  CupertinoIcons.eye,
                                )
                              : const Icon(
                                  CupertinoIcons.eye_slash,
                                ),
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                            });
                          },
                        ),
                        hintText: 'Enter Your Confirm Password',
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
                      height: size.height * 0.02,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              GestureDetector(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    await FBAuthServices.fbAuthServices
                        .registerWithEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                    )
                        .then((value) {
                      if (value != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      } else {
                        print('Something went wrong');
                      }
                    });
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
                  child: const Text('Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      )),
                ),
              ),
              SizedBox(
                height: size.height * 0.14,
              ),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: '  Login',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
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
