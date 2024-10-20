import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tolet/widgets/constcolor.dart';
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
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());

        User? user = userCredential.user;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'firstname': _fnameController.text.trim,
            'lastname': _lnameController.text.trim,
            'email': user.email,
            'userType': selectedUserType,
          });

          Fluttertoast.showToast(
              msg: 'User Signed Up successfully',
              backgroundColor: Colors.green);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed', backgroundColor: Colors.red);
      } finally {
        _isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.10),
              Center(
                child: Text(
                  'Congratulations',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06),
                ),
              ),
              Center(
                child: Text(
                  'on verifying the email belongs to you',
                  style: TextStyle(
                      color: Colors.black, fontSize: screenWidth * 0.04),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Align(
                alignment: Alignment
                    .centerLeft, // Aligns the text to the start of the column
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Color(constcolor.App_blue_color),
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth *
                        0.08, // Adjusts font size based on screen width
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _fnameController,
                      validator: _nameValidator,
                      decoration: InputDecoration(
                        hintText: 'Firstname',
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
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      controller: _lnameController,
                      validator: _nameValidator,
                      decoration: InputDecoration(
                        hintText: 'Lastname',
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
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                validator: _emailValidator,
                controller: _emailController,
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
              SizedBox(height: screenHeight * 0.02),
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
                      _isobsecureText ? Icons.visibility_off : Icons.visibility,
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
              SizedBox(height: screenHeight * 0.02),
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
              SizedBox(height: screenHeight * 0.02),
              Align(
                alignment: Alignment
                    .centerLeft, // Aligns the text to the start of the row
                child: Text(
                  'TYPE OF USER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                    color: Color(0xffcbcbcb),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
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
              SizedBox(height: screenHeight * 0.04),
              Center(
                child: _isLoading
                    ? LoadingAnimationWidget.inkDrop(
                        color: Colors.black, size: 50)
                    : InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            print('Form is valid');
                            _signUp();
                          }
                        },
                        child: CustomizedButton(
                            title: 'Submit',
                            colorButton: Color(constcolor.App_blue_color),
                            height: 44,
                            widht: screenWidth * 0.8,
                            colorText: Colors.white,
                            fontSize: screenWidth * 0.05),
                      ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back to login',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
