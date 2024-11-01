import 'package:elevate_reg_app_2/screens/login_screen.dart';
import 'package:elevate_reg_app_2/screens/pick_school_screen.dart';
import 'package:elevate_reg_app_2/widgets/loading_spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  Future<bool> _checkForTokenAndUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkForTokenAndUserData(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const LoadingSpinnerFullScreen()
            : snapshot.data == true
                ? const PickSchoolScreen()
                : const LoginScreen();
      },
    );
  }
}
