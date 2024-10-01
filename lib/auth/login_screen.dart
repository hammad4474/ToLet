// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tolet/auth/signup_screen.dart';
import 'package:tolet/widgets/customized_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isobsecureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        Fluttertoast.showToast(msg: 'Logged in', backgroundColor: Colors.green);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: 'No user found for that email.',
              backgroundColor: Colors.red);
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
              msg: 'Wrong password provided.', backgroundColor: Colors.red);
        } else {
          Fluttertoast.showToast(
              msg: 'An error occurred. Please try again.',
              backgroundColor: Colors.red);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Something went wrong. Please try again.',
            backgroundColor: Colors.red);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
              ),
              Center(
                child: Image.asset('assets/images/Logo 1.png'),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign in',
                      style: TextStyle(
                          color: Color(0xff2660ac),
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'YOUR EMAIL',
                      style: TextStyle(
                        color: Color(0xffc3c3c3),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: _emailValidator,
                      decoration: InputDecoration(
                        hintText: 'yourmail@gmail.com',
                        filled: true,
                        fillColor: Color(0xfff2f3f3),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'PASSWORD',
                      style: TextStyle(
                        color: Color(0xffc3c3c3),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: _passwordValidator,
                      obscureText: _isobsecureText,
                      decoration: InputDecoration(
                        hintText: '******',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isobsecureText = !_isobsecureText;
                            });
                          },
                          icon: Icon(
                            _isobsecureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        filled: true,
                        fillColor: Color(0xfff2f3f3),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      print('Form is valid');
                      _login();
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => ));
                    }
                  },
                  child: CustomizedButton(
                      title: 'Login',
                      colorButton: Color(0xff2a82c8),
                      height: 50,
                      widht: 300,
                      colorText: Colors.white,
                      fontSize: 18),
                ),
              ),
              SizedBox(
                height: 140,
              ),
              Center(
                child: Text(
                  'Dont have an account?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                  child: CustomizedButton(
                      title: 'Create an Account',
                      colorButton: Color(0xff6bc2f3),
                      height: 50,
                      widht: 300,
                      colorText: Colors.white,
                      fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
