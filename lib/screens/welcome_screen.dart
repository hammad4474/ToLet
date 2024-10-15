// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tolet/auth/login_screen.dart';
import 'package:tolet/widgets/customized_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    //height: double.infinity,
                    child: Image.asset(
                        fit: BoxFit.cover, 'assets/images/img2.png'),
                  ),
                  Positioned(
                      child: Image.asset('assets/images/Illustration.png')),
                  Positioned(
                    top: 130,
                    left: 20,
                    child: Image.asset(
                      fit: BoxFit.cover,
                      'assets/images/img.png',
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Image.asset('assets/images/txt1.png'),
            SizedBox(
              height: 30,
            ),
            Image.asset('assets/images/Logo 1.png'),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                  style: TextStyle(
                    color: Color(0xff7b809e),
                  ),
                  textAlign: TextAlign.center,
                  'Connects property owners to tenants directly,\n enabling daily rental income and easy property\n management, while offering tenants affordable,\n verified rentals without brokers'),
            ),
            SizedBox(
              height: 80,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: CustomizedButton(
                colorButton: Color(0xff2b82c8),
                colorText: Colors.white,
                fontSize: 25,
                height: 55,
                title: 'Get started',
                widht: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
