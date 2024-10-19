import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:tolet/auth/signup_infoFill.dart';
import 'package:tolet/widgets/constcolor.dart';
import 'package:tolet/widgets/customized_button.dart';
import 'package:email_otp/email_otp.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _verifyEmailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? fullphone;
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  String? verificationId;
  bool _isOtpVerified = false;

  @override
  void initState() {
    super.initState();
    _verifyEmailController.clear();
    _phoneController.clear();
  }

  @override
  void dispose() {
    _verifyEmailController.clear();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
      return 'Please enter your phone number';
    }
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';

    if (!RegExp(r'^\+\d{1,3}\d{4,14}$').hasMatch(value)) {
      return 'Please enter a valid phone number in E.164 format';
    }

    return null;
  }

  Future<void> _verifyOtp() async {
    if (verificationId != null) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: _otpController.text,
      );

      try {
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() {
          _isOtpVerified = true;
        });
        Fluttertoast.showToast(msg: 'OTP verified successfully');
      } catch (e) {
        Fluttertoast.showToast(msg: 'Wrong OTP. Please try again.');
        setState(() {
          _isOtpVerified = false;
        });
      }
    }
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
                  'assets/images/image 3.png',
                  width: screenWidth *
                      0.5, // Adjust image size based on screen width
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
                        fontSize: screenWidth * 0.08, // Responsive font size
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Text(
                      'VERIFY THROUGH EMAIL',
                      'VERIFY THROUGH Phone No',
                      style: TextStyle(
                        color: Color(0xffc3c3c3),
                        fontSize: screenWidth * 0.045, // Responsive font size
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    TextFormField(
                      controller: _verifyEmailController,
                      validator: _emailValidator,
                    IntlPhoneField(
                      controller: _phoneController,
                      focusNode: _focusNode,
                      onChanged: (phone) {
                        setState(() {
                          fullphone = phone.completeNumber;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'yourmail@gmail.com',
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
                        labelText: 'Your Phone Number',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                    ),
                    // IntlPhoneField(
                    //   controller: _phoneController,
                    //   focusNode: _focusNode,
                    //   decoration: InputDecoration(
                    //     labelText: 'Phone Number',
                    //     filled: true,
                    //     fillColor: Color(0xfff2f3f3),
                    //     contentPadding: EdgeInsets.symmetric(
                    //       vertical: screenHeight * 0.02,
                    //       horizontal: screenWidth * 0.03,
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide.none,
                    //     ),
                    //   ),
                    //   initialCountryCode: 'PK', // Set the initial country code
                    //   onChanged: (phone) {
                    //     print(phone.completeNumber);
                    //   },
                    // ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.4, // Responsive width
                          child: TextFormField(
                            obscureText: true,
                            controller: _otpController,
                            decoration: InputDecoration(
                              hintText: "***",
                              hintText: "****",
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
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.03,
                        ),
                        InkWell(
                          onTap: () {
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              print('form is valid');
                              EmailOTP.config(
                                appName: 'ToLet',
                                otpType: OTPType.numeric,
                                expiry: 30000,
                                emailTheme: EmailTheme.v1,
                                appEmail: 'nagaanil16@gmail.com',
                                otpLength: 6,
                              );
                              EmailOTP.sendOTP(
                                  email: _verifyEmailController.text);
                              Fluttertoast.showToast(msg: 'Sending OTP...');

                              try {
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: fullphone!,
                                  timeout: Duration(seconds: 60),
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);
                                    Fluttertoast.showToast(
                                        msg:
                                            'Phone number verified automatically.');
                                    setState(() {
                                      _isOtpVerified = true;
                                    });
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Verification failed: ${e.message}');
                                    setState(() {
                                      _isOtpVerified = false;
                                    });
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    Fluttertoast.showToast(
                                        msg: 'OTP sent successfully');
                                    setState(() {
                                      this.verificationId = verificationId;
                                    });
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    Fluttertoast.showToast(
                                        msg: 'OTP auto-retrieval timed out');
                                    setState(() {
                                      this.verificationId = verificationId;
                                    });
                                  },
                                );
                              } catch (e) {
                                Fluttertoast.showToast(msg: 'Error: $e');
                              }
                            }
                          },
                          child: CustomizedButton(
                            title: 'Get Code',
                            colorButton: Color(constcolor.App_blue_color),
                            height: screenHeight * 0.06, // Responsive height
                            widht: screenWidth * 0.4, // Responsive width
                            colorText: Colors.white,
                            fontSize:
                                screenWidth * 0.04, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.08,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            print('form is valid');
                            bool isVerified =
                                EmailOTP.verifyOTP(otp: _otpController.text);
                            if (isVerified) {
                              Fluttertoast.showToast(
                                msg: 'Verified',
                                backgroundColor: Colors.green,
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              setState(() {
                                _isOtpVerified = true;
                              });
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Wrong OTP',
                                backgroundColor: Colors.red,
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              setState(() {
                                _isOtpVerified = false;
                              });
                            }
                          if (_otpController.text.isNotEmpty) {
                            _verifyOtp();
                          }
                        },
                        child: CustomizedButton(
                          title: 'Verify',
                          colorButton: Color(constcolor.App_blue_color),
                          height: screenHeight * 0.06, // Responsive height
                          widht: screenWidth * 0.85, // Responsive width
                          colorText: Colors.white,
                          fontSize: screenWidth * 0.045, // Responsive font size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              InkWell(
                onTap: //_isOtpVerified
                    // ?
                    () {
                  Get.to(() => SignupInfofill(), transition: Transition.fade);
                },
                // : null,
                onTap: _isOtpVerified
                    ? () {
                        Get.to(() => SignupInfofill(),
                            transition: Transition.fade);
                      }
                    : null,
                child: CustomizedButton(
                  title: 'Next',
                  colorButton: Color(constcolor.App_blue_color),
                  height: screenHeight * 0.06, // Responsive height
                  widht: screenWidth * 0.85, // Responsive width
                  colorText: Colors.white,
                  fontSize: screenWidth * 0.045, // Responsive font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
