import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tolet/auth/forgot_pasword.dart';
import 'package:tolet/auth/signup_screen.dart';
import 'package:tolet/screens/owner/home_screen.dart';
import 'package:tolet/screens/owner/ownerdashboard.dart';
import 'package:tolet/screens/tenant/home_tenant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tolet/screens/tenant/tenantdashboard.dart';
import 'package:tolet/widgets/constcolor.dart';
import 'package:tolet/widgets/customized_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        String uid = userCredential.user!.uid;

        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          String userType = userData['userType'];

          // Save userType and login state to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userType', userType);

          if (userType == 'Tenant') {
            Get.to(() => tenantDashboard(), transition: Transition.fade);
          } else if (userType == 'Landlord') {
            Get.to(() => ownerDashboard(), transition: Transition.fade);
          } else {
            Fluttertoast.showToast(
                msg: 'Unknown user role', backgroundColor: Colors.red);
          }
        } else {
          Fluttertoast.showToast(
              msg: 'User data not found in Firestore',
              backgroundColor: Colors.red);
        }
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
      } finally {
        setState(() {
          isLoading = false;
        });
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.06,
              ),
              Center(
                child: Image.asset(
                  'assets/images/tolet.png',
                  width: screenWidth * 0.4, // Responsive image width
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign in',
                      style: TextStyle(
                          color: Color(constcolor.App_blue_color),
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.07),
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
                    ),
                    Text(
                      'YOUR EMAIL',
                      style: TextStyle(
                        color: Color(0xffc3c3c3),
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
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
                      height: screenHeight * 0.03,
                    ),
                    Text(
                      'PASSWORD',
                      style: TextStyle(
                        color: Color(0xffc3c3c3),
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
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
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Get.to(() => ForgotPasswordView(),
                            transition: Transition.fadeIn);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(constcolor.App_blue_color),
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Center(
                child: isLoading
                    ? LoadingAnimationWidget.inkDrop(
                        color: Colors.black, size: 50)
                    : InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        child: CustomizedButton(
                          title: 'Login',
                          colorButton: Color(constcolor.App_blue_color),
                          height: screenHeight * 0.07,
                          widht: screenWidth * 0.7,
                          colorText: Colors.white,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
              ),
              SizedBox(
                height: screenHeight * 0.15,
              ),
              Center(
                child: Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    Get.to(() => SignupScreen(), transition: Transition.fade);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => SignupScreen()));
                  },
                  child: CustomizedButton(
                    title: 'Create an Account',
                    colorButton: Color(constcolor.App_blue_color),
                    height: screenHeight * 0.07,
                    widht: screenWidth * 0.7,
                    colorText: Colors.white,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
