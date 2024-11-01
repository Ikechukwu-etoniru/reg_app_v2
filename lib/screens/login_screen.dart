// ignore_for_file: use_build_context_synchronously

import 'package:elevate_reg_app_2/screens/pick_school_screen.dart';
import 'package:elevate_reg_app_2/utils/alert.dart';
import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:elevate_reg_app_2/widgets/submit_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen.dart';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;

  var _obscurePassword = true;

  Future loginUser() async {
    FocusScope.of(context).unfocus();
    var isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
          PickSchoolScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled') {
        Alert.errorDialog(
          context: context,
          description: e.message ?? 'Your account has been disabled',
        );

        setState(() {
          _isLoading = false;
        });
      } else if (e.code == 'invalid-email') {
        Alert.errorDialog(
          context: context,
          description: e.message ?? 'You entered an invalid email address',
        );
        setState(() {
          _isLoading = false;
        });
      } else if (e.code == 'user-not-found') {
        Alert.errorDialog(
          context: context,
          description: e.message ?? 'A user with your credential doesn\' exist',
        );
        setState(() {
          _isLoading = false;
        });
      } else if (e.code == 'wrong-password') {
        Alert.errorDialog(
          context: context,
          description: e.message ?? 'You entered a wrong password',
        );
        setState(() {
          _isLoading = false;
        });
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        Alert.errorDialog(
          context: context,
          description:
              'You entered a wrong login credential. Confirm your email and password',
        );
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        Alert.errorDialog(context: context, description: e.code);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Alert.errorDialog(
          context: context,
          description: 'An error occured, Login unsuccessful');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            height: deviceHeight * 0.3,
            width: double.infinity,
            color: MyColors.secGreen1,
            child: Center(
              child: Image.asset(
                'images/elevate_icon.png',
                fit: BoxFit.fill,
                height: 110,
                width: 110,
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                        prefixIcon: Image.asset('images/email.png'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter you email address';
                        } else if (!value.contains('@') ||
                            !value.contains('.')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                        prefixIcon: Image.asset('images/password.png'),
                        suffixIcon: IconButton(
                            onPressed: !_obscurePassword
                                ? null
                                : () async {
                                    setState(() {
                                      _obscurePassword = false;
                                    });
                                    await Future.delayed(
                                      const Duration(seconds: 5),
                                    );
                                    setState(() {
                                      _obscurePassword = true;
                                    });
                                  },
                            icon: _obscurePassword
                                ? Image.asset('images/eye.png')
                                : Image.asset(
                                    'images/eye-slash.png',
                                  )),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Type a password';
                        } 
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    SubmitButton(
                      text: 'Sign in ',
                      onPressed: loginUser,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
