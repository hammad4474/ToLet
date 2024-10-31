import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tolet/auth/signup_infoFill.dart';
import 'package:tolet/widgets/constcolor.dart';
import 'package:tolet/widgets/customized_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  String? email;
  String? verificationId;
  EmailOTP emailOTP = EmailOTP();
  bool _isVerified = false;
  bool _isOtpObscured = true; // For toggling OTP visibility

  void initState() {
    super.initState();
    _emailController.clear();

    // Add a listener to the OTP controller to update the button's state
    _otpController.addListener(() {
      setState(() {}); // This will refresh the widget when OTP text changes
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isVerified = true;
      });
      EmailOTP.config(
        appName: 'Tolet',
        otpType: OTPType.numeric,
        expiry: 30000,
        emailTheme: EmailTheme.v6,
        appEmail: 'Tolet@company',
        otpLength: 6,
      );

      EmailOTP.sendOTP(email: _emailController.text);

      setState(() {
        _isVerified = false;
      });

      Fluttertoast.showToast(
          msg: 'OTP sent successfully to ${_emailController.text}');
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isVerified = true;
    });
    if (EmailOTP.verifyOTP(otp: _otpController.text)) {
      Fluttertoast.showToast(msg: 'OTP verified successfully');
      setState(() {
        _isVerified = false;
      });

      Get.to(() => SignupInfofill(), transition: Transition.fadeIn);
    } else {
      Fluttertoast.showToast(msg: 'Wrong OTP. Please try again.');
      setState(() {
        _isVerified = false;
      });
    }
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^\+\d{1,3}\d{4,14}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
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
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Center(
                child: Image.asset(
                  'assets/images/tolet.png',
                  width: screenWidth * 0.5,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color(constcolor.App_blue_color),
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.08,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),

                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Your Email',
                        filled: true,
                        fillColor: Color(0xfff2f3f3),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                            horizontal: screenWidth * 0.03),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: _emailValidator,
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    // IntlPhoneField(
                    //   controller: _phoneController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Your Phone Number',
                    //     filled: true,
                    //     fillColor: Color(0xfff2f3f3),
                    //     contentPadding: EdgeInsets.symmetric(
                    //         vertical: screenHeight * 0.02,
                    //         horizontal: screenWidth * 0.03),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    //   initialCountryCode: 'PK',
                    //   onChanged: (phone) {
                    //     fullPhoneNumber = phone.completeNumber;
                    //   },
                    // ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.4,
                          child: TextFormField(
                            obscureText: _isOtpObscured,
                            controller: _otpController,
                            decoration: InputDecoration(
                              hintText: 'OTP',
                              filled: true,
                              fillColor: Color(0xfff2f3f3),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                  horizontal: screenWidth * 0.03),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isOtpObscured
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isOtpObscured = !_isOtpObscured;
                                    });
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        InkWell(
                          onTap: _sendOtp,
                          //   if (_formKey.currentState!.validate()) {
                          //     try {
                          //       await FirebaseAuth.instance.verifyPhoneNumber(
                          //         phoneNumber: fullPhoneNumber!,
                          //         timeout: Duration(seconds: 60),
                          //         verificationCompleted:
                          //             (PhoneAuthCredential credential) async {
                          //           await FirebaseAuth.instance
                          //               .signInWithCredential(credential);
                          //           Fluttertoast.showToast(
                          //               msg:
                          //                   'Phone number verified automatically.');
                          //           setState(() {
                          //             _isOtpVerified = true;
                          //           });
                          //         },
                          //         verificationFailed:
                          //             (FirebaseAuthException e) {
                          //           Fluttertoast.showToast(
                          //               msg:
                          //                   'Verification failed: ${e.message}');
                          //           setState(() {
                          //             _isOtpVerified = false;
                          //           });
                          //         },
                          //         codeSent: (String verificationId,
                          //             int? resendToken) {
                          //           Fluttertoast.showToast(
                          //               msg: 'OTP sent successfully');
                          //           setState(() {
                          //             this.verificationId = verificationId;
                          //           });
                          //         },
                          //         codeAutoRetrievalTimeout:
                          //             (String verificationId) {
                          //           Fluttertoast.showToast(
                          //               msg: 'OTP auto-retrieval timed out');
                          //           setState(() {
                          //             this.verificationId = verificationId;
                          //           });
                          //         },
                          //       );
                          //     } catch (e) {
                          //       Fluttertoast.showToast(msg: 'Error: $e');
                          //     }
                          //   }
                          // },
                          child: _isVerified
                              ? LoadingAnimationWidget.inkDrop(
                                  color: Colors.black, size: 50)
                              : CustomizedButton(
                                  title: 'Get Code',
                                  colorButton: Color(constcolor.App_blue_color),
                                  height: screenHeight * 0.06,
                                  widht: screenWidth * 0.4,
                                  colorText: Colors.white,
                                  fontSize: screenWidth * 0.04,
                                ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.08,
                    ),
                    Center(
                      child: _isVerified
                          ? LoadingAnimationWidget.inkDrop(
                              color: Colors.black, size: 50)
                          : InkWell(
                              onTap: _otpController.text.isNotEmpty
                                  ? _verifyOtp
                                  : null,
                              child: CustomizedButton(
                                title: 'Verify',
                                colorButton: Color(constcolor.App_blue_color),
                                height: screenHeight * 0.06,
                                widht: screenWidth * 0.85,
                                colorText: Colors.white,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              // InkWell(
              //   onTap: _isVerified
              //       ? () {
              //           Get.to(() => SignupInfofill(),
              //               transition: Transition.fade);
              //         }
              //       : null,
              //   child: CustomizedButton(
              //     title: 'Next',
              //     colorButton: Color(constcolor.App_blue_color),
              //     height: screenHeight * 0.06,
              //     widht: screenWidth * 0.85,
              //     colorText: Colors.white,
              //     fontSize: screenWidth * 0.045,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
