import 'package:elevate_reg_app_2/models/school.dart';
import 'package:elevate_reg_app_2/screens/add_student_screen.dart';
import 'package:elevate_reg_app_2/utils/my_padding.dart';
import 'package:flutter/material.dart';

class AddTeacherScreen extends StatefulWidget {
  final School school;
  const AddTeacherScreen({required this.school, super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Teacher'),
      ),
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Column(
          children: [
            const TextFieldTitle(title: 'Enter Teachers Name'),
            TextFormField(
              controller: nameController,
              style: const TextStyle(
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                hintText: 'Teacher\'s Name',
                hintStyle: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.person,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter last name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const TextFieldTitle(title: 'Add Subjects'),
          ],
        ),
      ),
    );
  }
}
