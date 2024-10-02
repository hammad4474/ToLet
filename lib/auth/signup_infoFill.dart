// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tolet/widgets/customized_button.dart';

class SignupInfofill extends StatefulWidget {
  const SignupInfofill({super.key});

  @override
  State<SignupInfofill> createState() => _SignupInfofillState();
}

class _SignupInfofillState extends State<SignupInfofill> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cPasswordController = TextEditingController();

  String? selectedUserType;

  bool _isobsecureText = true;
  bool _isobsecureText1 = true;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _emailController.clear();
    _passwordController.clear();
    _cPasswordController.clear();
    _fnameController.clear();
    _lnameController.clear();
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    _cPasswordController.clear();
    _fnameController.clear();
    _lnameController.clear();
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
      return 'Please enter a password';
    }
    if (_passwordController.text != _cPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _typeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please choose your user type';
    }
    return null;
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        User? user = userCredential.user;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'firstname': _fnameController.text,
            'lastname': _lnameController.text,
            'email': user.email,
            'userType': selectedUserType,
          });

          Fluttertoast.showToast(
              msg: 'User Signed Up successfully',
              backgroundColor: Colors.green);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed', backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 120,
              ),
              Center(
                child: Text(
                  'Congratulations',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Center(
                child: Text(
                  'on verifying the email belongs to you',
                  style: TextStyle(color: Colors.black),
                ),
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
                      'Sign up',
                      style: TextStyle(
                          color: Color(0xff2660ac),
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 170,
                          child: TextFormField(
                            controller: _fnameController,
                            validator: _nameValidator,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Firstname',
                              filled: true,
                              fillColor: Color(0xfff2f3f3),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
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
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 170,
                          child: TextFormField(
                            controller: _lnameController,
                            validator: _nameValidator,
                            //obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Lastname',
                              filled: true,
                              fillColor: Color(0xfff2f3f3),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
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
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: _emailValidator,
                      controller: _emailController,
                      //obscureText: true,
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
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isobsecureText,
                      decoration: InputDecoration(
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
                        hintText: 'Passcode',
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
                      height: 10,
                    ),
                    TextFormField(
                      controller: _cPasswordController,
                      validator: _passwordValidator,
                      obscureText: _isobsecureText1,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isobsecureText1 = !_isobsecureText1;
                              });
                            },
                            icon: Icon(_isobsecureText1
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        hintText: 'Confirm passcode',
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
                      'TYPE OF USER',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xffcbcbcb)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedUserType,
                      items: ['Tenant', 'Landlord'].map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedUserType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please choose your user type';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Choose your user type',
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
                      height: 30,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            print('Form is valid');
                            _signUp();
                          }
                        },
                        child: CustomizedButton(
                            title: 'Submit',
                            colorButton: Color(0xff2a82c8),
                            height: 44,
                            widht: 400,
                            colorText: Colors.white,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Back to login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
