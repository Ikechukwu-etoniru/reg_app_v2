// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_reg_app_2/models/school.dart';
import 'package:elevate_reg_app_2/models/subjects.dart';
import 'package:elevate_reg_app_2/screens/add_student_screen.dart';
import 'package:elevate_reg_app_2/utils/alert.dart';
import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:elevate_reg_app_2/utils/my_padding.dart';
import 'package:elevate_reg_app_2/widgets/add_student_widgets.dart';
import 'package:elevate_reg_app_2/widgets/my_dropdown.dart';
import 'package:elevate_reg_app_2/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class AddTeacherScreen extends StatefulWidget {
  final School school;
  const AddTeacherScreen({required this.school, super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  bool _isButtonLoading = false;
  final nameController = TextEditingController();

  List<SubjectClass> teacherSubjects = [];

  List<Map<String, dynamic>> convertToMapList(
      List<SubjectClass> subjectClasses) {
    return subjectClasses.map((subjectClass) => subjectClass.toMap()).toList();
  }

  Future addSubjectDialog() async {
    SubjectModel? subject;
    int? classId;
    int? classNum;
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        final subjectNameList = subjects.map((e) => e.name).toList();
        subjectNameList.sort();
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 30,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Select Subject',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Select Subject",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: MyColors.primayGreen,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyDropDown(
                    items: subjectNameList
                        .map(
                          (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )),
                        )
                        .toList(),
                    onChanged: (value) {
                      subject = subjects.firstWhere(
                          (element) => element.name == value.toString());
                    },
                    hint: const Text('Select subject'),
                    validator: (val) {
                      if (val == null || val.toString().isEmpty) {
                        return 'This field is mandatory';
                      }
                      // else if (teacherSubjects.contains(subject!)) {
                      //   return 'This subject has already been added';
                      // }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Select Classes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: MyColors.primayGreen,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            classId = (index + 1);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            // height: 40,
                            width: 55,
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.primayGreen),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Select Classes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: MyColors.primayGreen,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            classNum = (index + 1);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            width: 55,
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.primayGreen),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SubmitButton(
                    isLoading: false,
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    color: Colors.red,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SubmitButton(
                    isLoading: false,
                    text: 'Add',
                    onPressed: () {
                      final isValid = formKey.currentState!.validate();
                      if (isValid) {
                        setState(() {
                          teacherSubjects.add(SubjectClass(
                            subject: subject!.id,
                            name: subject!.name,
                            classId: classId!,
                            classNum: classNum!,
                          ));
                        });
                        Navigator.of(ctx).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void onDelete(String id, int classId, int classNum) {
    setState(() {
      teacherSubjects.removeWhere((val) {
        return val.subject == id &&
            val.classId == classId &&
            val.classNum == classNum;
      });
    });
  }

  Future addTeacherToDatabase() async {
    setState(() {
      _isButtonLoading = true;
    });
    final schoolTeacherCollection = FirebaseFirestore.instance
        .collection('schools')
        .doc(widget.school.id)
        .collection('teachers');
    List<Map<String, dynamic>> subjectClassList =
        convertToMapList(teacherSubjects);
    try {
      final addedTeacher = await schoolTeacherCollection.add({
        'isAdmin': false,
        'name': nameController.text,
        'points': 0,
        'schoolId': widget.school.id,
        'teacher_code': generateSixDigitNumber(),
        'subject_class_classnum': subjectClassList,
      });
      // Get the generated document ID
      String docId = addedTeacher.id;

      // Update the document to include the ID as a field
      await addedTeacher.update({
        'id': docId,
      });
      nameController.clear();
      teacherSubjects.clear();
    } catch (error) {
      Alert.errorDialog(
          context: context,
          description: 'An error occured while adding this teacher');
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Teacher'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: MyColors.primayGreen,
                      ),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.spaceEvenly,
                      children: teacherSubjects
                          .map((e) => OnlySubjectContainer(
                                subject: e,
                                onDelete: onDelete,
                              ))
                          .toList(),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(seconds: 1));
                      await addSubjectDialog();
                    },
                    child: const Text('Add Subject & Class'),
                  ),
                ],
              ),
            ),
            SubmitButton(
              text: 'Add Teacher',
              onPressed: addTeacherToDatabase,
              isLoading: _isButtonLoading,
            )
          ],
        ),
      ),
    );
  }
}

class ClassBox extends StatelessWidget {
  final int id;
  final void Function()? onPressed;

  const ClassBox({required this.id, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40,
        width: 45,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyColors.primayGreen),
        ),
        child: Center(
          child: Text(
            id.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

String generateSixDigitNumber() {
  final random = Random();
  int number = 100000 +
      random.nextInt(900000); // Generates a number between 100000 and 999999
  return number.toString();
}
