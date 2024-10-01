import 'package:flutter/material.dart';
import 'package:tolet/auth/signup_infoFill.dart';
import 'package:tolet/widgets/customized_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Center(child: Image.asset('assets/images/image 3.png')),
          SizedBox(
            height: 60,
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
                  height: 10,
                ),
                Text(
                  'VERIFY THROUGH EMAIL',
                  style: TextStyle(
                    color: Color(0xffc3c3c3),
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
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
                Row(
                  children: [
                    SizedBox(
                      width: 180,
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "***",
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
                    CustomizedButton(
                        title: 'Get Code',
                        colorButton: Color(0xff2a82c8),
                        height: 50,
                        widht: 158,
                        colorText: Colors.white,
                        fontSize: 16),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
                Center(
                  child: CustomizedButton(
                      title: 'Verify',
                      colorButton: Color(0xff2b82c8),
                      height: 40,
                      widht: 340,
                      colorText: Colors.white,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 140,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignupInfofill()));
            },
            child: CustomizedButton(
                title: 'Next',
                colorButton: Color(0xff2b82c8),
                height: 44,
                widht: 340,
                colorText: Colors.white,
                fontSize: 16),
          ),
        ],
      ),
    );
  }
}
