import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:elevate_reg_app_2/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Alert {
  static SnackBar snackBar(
      {required String message, required BuildContext context}) {
    return SnackBar(
      elevation: 100,
      backgroundColor: MyColors.primayGreen,
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          }),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.only(
        left: 15,
        right: 5,
      ),
    );
  }

  static Future<bool?> sucessDialog(
      {required BuildContext context,
      required VoidCallback onPressed,
      required String description,
      required String buttonText,
      String? title,
      bool? isBarrierDismissable}) async {
    return showDialog<bool>(
      barrierDismissible: isBarrierDismissable ?? true,
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  child: SvgPicture.asset(
                    'images/success_icon.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  title ?? 'Congratulations !',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: MyColors.primayGreen,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SubmitButton(
                  isLoading: false,
                  text: buttonText,
                  onPressed: onPressed,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool?> confirmLogoutDialog(
      {required BuildContext context}) async {
    return showDialog<bool>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are you sure ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: MyColors.primayGreen,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Please confirm that you'd like to log out of your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: MyColors.darkgrey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.primayGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: MyColors.primayGreen),
                    ),
                    child: const Center(
                      child: Text(
                        'Log out',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

 
  
  static Future<bool?> errorDialog(
      {required BuildContext context,
      required String description,
      String? title,
      bool? isBarrierDismissable}) async {
    return showDialog<bool>(
      barrierDismissible: isBarrierDismissable ?? true,
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  child: SvgPicture.asset(
                    'images/error_icon.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  title ?? 'An error occured',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SubmitButton(
                  isLoading: false,
                  text: 'Close',
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  color: Colors.red[800],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
}
