import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IsErrorScreen extends StatelessWidget {
  final void Function()? onPressed;
  const IsErrorScreen({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Oops!!!',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          SvgPicture.asset(
            'images/error.svg',
            height: 200,
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Something went wrong, kindly check your internet connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: TextButton(
              onPressed: onPressed,
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: MyColors.primayGreen,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 2,
                  color: Colors.transparent,
                  shadows: [
                    Shadow(
                      offset: Offset(0, -5),
                      color: MyColors.primayGreen,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
