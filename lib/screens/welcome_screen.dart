import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tolet/auth/login_screen.dart';
import 'package:tolet/widgets/constcolor.dart';
import 'package:tolet/widgets/customized_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Top part with image and title
            Column(
              children: [
                // House image
                SizedBox(
                  height: screenHeight * 0.45,
                  width: double
                      .infinity, // House image height is around 25% of screen height
                  child: Image.asset(
                    'assets/images/ghar.png', // Replace this with the top house image path
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                // Space between image and text
                Text(
                  "Welcome to",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Responsive font size
                    fontWeight: FontWeight.normal,
                    color: Color(0xff192747),
                  ),
                ),
                // Small space after "Welcome to" text
                Image.asset(
                  'assets/images/tolet.png',
                  height: 100, // Replace this with the logo image path
                  width: 100, // Logo width
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.05, // Space after the button
            ),
            // Middle content: description text
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      screenWidth * 0.05), // Padding for description text
              child: Text(
                'Connects property owners to tenants directly,\n enabling daily rental income and easy property\n management, while offering tenants affordable,\n verified rentals without brokers',
                style: TextStyle(
                  fontSize: screenWidth * 0.03, // Responsive text size
                  color: Color(0xff7b809e),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05, // Space after the button
            ),
            // Bottom part with "Get Started" button
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => LoginScreen(), transition: Transition.fadeIn);
                  },
                  child: CustomizedButton(
                    colorButton: Color(constcolor.App_blue_color),
                    colorText: Colors.white,
                    fontSize: screenWidth * 0.05, // Responsive button text size
                    height: screenHeight * 0.07, // Responsive button height
                    title: 'Get started',
                    widht: screenWidth * 0.60, // Responsive button width
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05, // Space after the button
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
