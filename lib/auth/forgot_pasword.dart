import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    // Basic email validation logic
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebf7fd),
      appBar: AppBar(
        backgroundColor: Color(0xff1a2847),
        elevation: 1,
        toolbarHeight: 80,
        title: const Text(
          "Forgot Password",
          style: TextStyle(letterSpacing: -1),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 200),
                  const Text(
                    "Enter an Email to reset Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate() &&
                          _isEmailValid(_emailController.text.trim())) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _emailController.text.trim());
                          Fluttertoast.showToast(
                            msg: "Reset link sent to email!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green.withOpacity(0.7),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            Fluttertoast.showToast(
                              msg: "No user found for that email.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red.withOpacity(0.7),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "An error occurred. Please try again.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red.withOpacity(0.7),
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Please enter a valid email",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red.withOpacity(0.7),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
