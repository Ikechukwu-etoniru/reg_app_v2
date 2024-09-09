import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDropDown extends StatelessWidget {
  Object? value;
  List<DropdownMenuItem<Object>>? items;
  void Function(Object?)? onChanged;
  Widget? hint;
  String? Function(Object?)? validator;
  MyDropDown(
      {required this.items,
      required this.onChanged,
      required this.hint,
      required this.validator,
      this.value,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      isExpanded: true,
      value: value,
      validator: validator,
      style: const TextStyle(
        fontSize: 13,
      ),
      decoration: InputDecoration(
        filled: true,
        contentPadding: const EdgeInsets.only(
          right: 13,
          top: 13,
          bottom: 13,
        ),
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: MyColors.secGreen1,
            )),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
      ),
      items: items,
      onChanged: onChanged,
      hint: hint,
    );
  }
}
