import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:elevate_reg_app_2/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';

import '../utils/alert.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  const SubmitButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    this.color,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 0,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: MyColors.primayGreen,
                  width: 1,
                )),
            alignment: Alignment.center,
            child: const LoadingSpinner(),
          )
        : GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: color ?? MyColors.primayGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 13,
                ),
              ),
            ),
          );
  }
}

class SubmitButtonBlank extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;
  const SubmitButtonBlank({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MyColors.primayGreen)),
        alignment: Alignment.center,
        child: isLoading
            ? const CircularProgressIndicator(
                color: MyColors.primayGreen,
              )
            : Text(
                text,
                style: const TextStyle(
                  color: MyColors.primayGreen,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }
}

class SubmitNotReadyButton extends StatelessWidget {
  final String buttonText;
  final String dialogText;
  final BuildContext ctx;
  const SubmitNotReadyButton({
    required this.buttonText,
    required this.dialogText,
    required this.ctx,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(Alert.snackBar(message: dialogText, context: ctx));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 13,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: MyColors.primayGreen,
              width: 1,
            )),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: const TextStyle(
            color: MyColors.primayGreen,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
