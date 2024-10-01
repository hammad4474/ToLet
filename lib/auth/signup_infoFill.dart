// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tolet/widgets/customized_button.dart';

class SignupInfofill extends StatefulWidget {
  const SignupInfofill({super.key});

  @override
  State<SignupInfofill> createState() => _SignupInfofillState();
}

class _SignupInfofillState extends State<SignupInfofill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                        obscureText: true,
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
                        obscureText: true,
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
                  obscureText: true,
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
                  obscureText: true,
                  decoration: InputDecoration(
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
                  obscureText: true,
                  decoration: InputDecoration(
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
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Choose your user-type',
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
                  child: CustomizedButton(
                      title: 'Submit',
                      colorButton: Color(0xff2a82c8),
                      height: 44,
                      widht: 400,
                      colorText: Colors.white,
                      fontSize: 18),
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
    );
  }
}
