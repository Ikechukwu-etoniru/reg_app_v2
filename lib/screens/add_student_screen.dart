import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_reg_app_2/models/school.dart';
import 'package:elevate_reg_app_2/screens/select_type_screen.dart';
import 'package:elevate_reg_app_2/utils/alert.dart';
import 'package:elevate_reg_app_2/utils/my_padding.dart';
import 'package:elevate_reg_app_2/widgets/image_picker_box.dart';
import 'package:elevate_reg_app_2/widgets/my_dropdown.dart';
import 'package:elevate_reg_app_2/widgets/submit_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  final School school;
  const AddStudentScreen({required this.school, super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudentScreen> {
  String? imagePath;
  File? pickedImage;
  var _isButtonLoading = false;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  final lastNameController = TextEditingController();
  final otherNamesController = TextEditingController();
  final parentsNumberController = TextEditingController();
  final parentsNumber2Controller = TextEditingController();
  String? selectedClass;
  String? selectedClassIdentifier;
  final _formKey = GlobalKey<FormState>();

  void getPath(String path) {
    imagePath = path;
  }

  void getFile(File selectedImage) {
    setState(() {
      pickedImage = selectedImage;
    });
  }

  Future addStudent() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (pickedImage == null) {
      Alert.errorDialog(
          context: context, description: 'You have not selected an image');
      return;
    }
    try {
      setState(() {
        _isButtonLoading = true;
      });
      Reference ref = _storage
          .ref()
          .child('students_images')
          .child('${DateTime.now().toString()}.jpg');
      UploadTask uploadTask = ref.putFile(pickedImage!);
      String imageUrl = await (await uploadTask).ref.getDownloadURL();
      final schoolStudentCollection = FirebaseFirestore.instance
          .collection('schools')
          .doc(widget.school.id)
          .collection('student');

      DocumentReference docRef = parentsNumber2Controller.text.isEmpty
          ? await schoolStudentCollection.add({
              'class': getClassId(selectedClass!),
              'class_num': getClassIdId(selectedClassIdentifier!),
              'image_url': imageUrl,
              'name':
                  '${lastNameController.text.toLowerCase().trim()} ${otherNamesController.text.toLowerCase().trim()}',
              'school_id': widget.school.id,
              // Remember Reg App hardcoded to secondary school 2
              'school_type': 2,
              'parent_number_1': parentsNumberController.text.trim(),
            })
          : await schoolStudentCollection.add({
              'class': getClassId(selectedClass!),
              'class_num': getClassIdId(selectedClassIdentifier!),
              'image_url': imageUrl,
              'name':
                  '${lastNameController.text.toLowerCase().trim()} ${otherNamesController.text.toLowerCase().trim()}',
              'school_id': widget.school.id,
              // Remember Reg App hardcoded to secondary school 2
              'school_type': 2,
              'parent_number_1': parentsNumberController.text.trim(),
              'parent_number_2': parentsNumber2Controller.text.trim(),
            });
      String generatedId = docRef.id;

      await docRef.update({
        'id': generatedId,
      });
    } catch (error) {
      Alert.errorDialog(context: context, description: 'An error occured');
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Center(
                      child: ImagePickerBox(
                        getPath: getPath,
                        getFile: getFile,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TextFieldTitle(title: 'Last Name'),
                    TextFormField(
                      controller: lastNameController,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
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
                    const TextFieldTitle(title: 'Other Names'),
                    TextFormField(
                      controller: otherNamesController,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Other Name',
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
                          return 'Enter other names';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TextFieldTitle(title: 'Enter Parents Number 1'),
                    TextFormField(
                      controller: parentsNumberController,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.numbers,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter parents number';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TextFieldTitle(title: 'Enter Parents Number 2'),
                    TextFormField(
                      controller: parentsNumber2Controller,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number (Optional)',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.numbers,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TextFieldTitle(title: 'Select Class'),
                    MyDropDown(
                      items: [
                        'JSS1',
                        'JSS2',
                        'JSS3',
                        'SSS1',
                        'SSS2',
                        'SSS3',
                      ]
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        selectedClass = val as String;
                      },
                      hint: const Text(
                        'Pick Class',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Pick Class';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const TextFieldTitle(title: 'Select Class Identifier'),
                    MyDropDown(
                      items: [
                        'A',
                        'B',
                        'C',
                        'D',
                        'E',
                        'F',
                        'G',
                      ]
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        selectedClassIdentifier = val as String;
                      },
                      hint: const Text(
                        'Pick Class Identifier',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Pick Class Identifier';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SubmitButton(
                text: 'Add This Student',
                onPressed: addStudent,
                isLoading: _isButtonLoading,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldTitle extends StatelessWidget {
  final String title;
  const TextFieldTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
        ],
      ),
      const SizedBox(
        height: 5,
      )
    ]);
  }
}
