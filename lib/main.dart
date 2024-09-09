import 'package:elevate_reg_app_2/screens/login_screen.dart';
import 'package:elevate_reg_app_2/screens/pick_school_screen.dart';
import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: MyColors.primayGreen,
            fontFamily: 'Montserrat',
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 15,
          ),
          color: Colors.transparent,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          fillColor: MyColors.tfGreen,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(
              width: 1,
              color: MyColors.secGreen1,
            ),
          ),
        ),
      ),
      title: 'Elevate Parent',
      home: const LoginScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        PickSchoolScreen.routeName: (ctx) => const PickSchoolScreen(),
      },
    );
  }
}
