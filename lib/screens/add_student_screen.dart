// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_reg_app_2/models/school.dart';
import 'package:elevate_reg_app_2/models/subjects.dart';
import 'package:elevate_reg_app_2/screens/add_subject_screen.dart';
import 'package:elevate_reg_app_2/screens/select_type_screen.dart';
import 'package:elevate_reg_app_2/utils/alert.dart';
import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:elevate_reg_app_2/utils/my_padding.dart';
import 'package:elevate_reg_app_2/widgets/add_student_widgets.dart';
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
  final auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  List<SubjectModel> studentSubjects = [];

  final lastNameController = TextEditingController();
  final otherNamesController = TextEditingController();
  final parentsNumberController = TextEditingController();
  final parentsNumber2Controller = TextEditingController();
  String? selectedClass;
  String? selectedClassIdentifier;
  final _formKey = GlobalKey<FormState>();
  int _selectedClassToDetermineSubject = 0;

  void getPath(String path) {
    imagePath = path;
  }

  void getFile(File selectedImage) {
    setState(() {
      pickedImage = selectedImage;
    });
  }

  void onDeleteClass(String id) {
    final subjectMap =
        studentSubjects.firstWhere((element) => element.id == id);

    setState(() {
      studentSubjects.remove(subjectMap);
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
      if (_selectedClassToDetermineSubject == 4 ||
          _selectedClassToDetermineSubject == 5 ||
          _selectedClassToDetermineSubject == 6) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AddSubjectScreen(
            picFile: pickedImage!,
            name:
                '${lastNameController.text.toLowerCase().trim()} ${otherNamesController.text.toLowerCase().trim()}',
            parentsNumber1: parentsNumberController.text.trim(),
            parentsNumber2: parentsNumber2Controller.text.trim(),
            classId: selectedClass!,
            classIdentifier: selectedClassIdentifier!,
            selectedClass: _selectedClassToDetermineSubject,
            school: widget.school,
          );
        }));
        return;
      }

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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => SelectTypeScreen(
                  school: widget.school,
                )),
        (Route<dynamic> route) =>
            route.isFirst, // Keep only the first route (FirstScreen)
      );
    } catch (error) {
      Alert.errorDialog(context: context, description: 'An error occured');
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  // Future addSubjectDialog() async {
  //   SubjectModel? subject;
  //   final formKey = GlobalKey<FormState>();
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext ctx) {
  //       final subjectNameList = subjects.map((e) => e.name).toList();
  //       subjectNameList.sort();
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         elevation: 30,
  //         child: Form(
  //           key: formKey,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(
  //               vertical: 40,
  //               horizontal: 15,
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Center(
  //                   child: Text(
  //                     'Select Subject',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 17,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 const Text(
  //                   "Select Subject",
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 13,
  //                     color: MyColors.primayGreen,
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 MyDropDown(
  //                   items: subjectNameList
  //                       .map(
  //                         (e) => DropdownMenuItem<String>(
  //                             value: e,
  //                             child: Text(
  //                               e,
  //                               style: const TextStyle(
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 16,
  //                               ),
  //                             )),
  //                       )
  //                       .toList(),
  //                   onChanged: (value) {
  //                     subject = subjects.firstWhere(
  //                         (element) => element.name == value.toString());
  //                   },
  //                   hint: const Text('Select subject'),
  //                   validator: (val) {
  //                     if (val == null || val.toString().isEmpty) {
  //                       return 'This field is mandatory';
  //                     } else if (studentSubjects.contains(subject!)) {
  //                       return 'This subject has already been added';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 SubmitButton(
  //                   isLoading: false,
  //                   text: 'Cancel',
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   color: Colors.red,
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 SubmitButton(
  //                   isLoading: false,
  //                   text: 'Add',
  //                   onPressed: () {
  //                     final isValid = formKey.currentState!.validate();
  //                     if (isValid) {
  //                       setState(() {
  //                         studentSubjects.add(subject!);
  //                       });
  //                       Navigator.of(ctx).pop();
  //                     }
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
                        if (val == 'JSS1') {
                          setState(() {
                            _selectedClassToDetermineSubject = 1;
                          });
                        } else if (val == 'JSS2') {
                          setState(() {
                            _selectedClassToDetermineSubject = 2;
                          });
                        } else if (val == 'JSS3') {
                          setState(() {
                            _selectedClassToDetermineSubject = 3;
                          });
                        } else if (val == 'SSS1') {
                          setState(() {
                            _selectedClassToDetermineSubject = 4;
                          });
                        } else if (val == 'SSS2') {
                          setState(() {
                            _selectedClassToDetermineSubject = 5;
                          });
                        } else if (val == 'SSS3') {
                          setState(() {
                            _selectedClassToDetermineSubject = 6;
                          });
                        }
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
                    const SizedBox(
                      height: 20,
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

// SubjectModel(id: '', name: ''),
List<SubjectModel> subjects = [
  SubjectModel(id: '0GysCkcOWkZihrZwArTR', name: 'Reading'),
  SubjectModel(id: '1EYUCQ5fUxmePArfU6n2', name: 'Efik'),
  SubjectModel(id: '2FBHZ33VrR1B2f9MV1O7', name: 'History'),
  SubjectModel(id: '3jMRkuXbI7jCOolCs5XY', name: 'English Language'),
  SubjectModel(id: '4AuA2igObQPxQZByZIfT', name: 'Tourism'),
  SubjectModel(id: '55Guz8BtNlf9KlTifBpG', name: 'CRS'),
  SubjectModel(id: '60oznoYCV1mlKYDh0MYV', name: 'Igbo'),
  SubjectModel(id: '848ClkhrevINYat6sNZ3', name: 'Visual Art'),
  SubjectModel(id: '8EhqiYFlnoJDhdt3U6Sr', name: 'Woodwork'),
  SubjectModel(id: 'CqyBRQOSjgsibBaRK8Vy', name: 'Social Studies'),
  SubjectModel(id: 'EeIW8uViyo7WgRVgBKfW', name: 'Financial Accounting'),
  SubjectModel(id: 'GlmpfCSWRgQBTns9jQ0P', name: 'Hausa'),
  SubjectModel(id: 'GsGC9junUl3vCG5wmdEp', name: 'Yoruba'),
  SubjectModel(id: 'HfxrvnIf55D6rSy8c9E8', name: 'Computer Science'),
  SubjectModel(id: 'Hv5vqYpMHDQowXKQF79m', name: 'Commerce'),
  SubjectModel(id: 'P9yGujnIqabWGNHTyLRI', name: 'French'),
  SubjectModel(id: 'PRsTgCiX3XjkS9pvcCJa', name: 'Music'),
  SubjectModel(id: 'PwKDgbyM6d9Fz7iU4sTW', name: 'Basic Science'),
  SubjectModel(id: 'Q3gEtV4GN4FTrgST72E8', name: 'Data Processing'),
  SubjectModel(id: 'QzAUkpJVJOif1cBM5aWs', name: 'Creative & Cultural Arts'),
  SubjectModel(id: 'S8g0EVILN7FNXo82wGJ5', name: 'Basic Tech/ Intotech'),
  SubjectModel(id: 'U2eXDE0EUDt2BNYPNBG0', name: 'Government'),
  SubjectModel(id: 'UpEq6l95YlfLABLhf91E', name: 'Agricultural Science'),
  SubjectModel(id: 'UwXVaVfDczCHk15Jh588', name: 'B.C.E'),
  SubjectModel(id: 'W84Kkxym8nrGJFI73W25', name: 'Further Mathematics'),
  SubjectModel(id: 'XI5BU91w5Xdiu73UB1Dm', name: 'National Values'),
  SubjectModel(id: 'YldABhSvh6pue50HEmvW', name: 'Literature In English'),
  SubjectModel(id: 'ZXPuQK1d136CMV7Ke1R2', name: 'Mathematics'),
  SubjectModel(id: 'edcFN7VutiT2lTRpNHb9', name: 'Chemistry'),
  SubjectModel(
      id: 'fg7ogwovmrPS89HcUZuU', name: 'Catering Craft Practice (CCP)'),
  SubjectModel(id: 'g7vs6V6kxQo389xHmae5', name: 'BK'),
  SubjectModel(id: 'ghzPwbeFpHpUZolToTrs', name: 'Marketing'),
  SubjectModel(id: 'h6PcTwSyhXrgGJYnWM64', name: 'Typewriting'),
  SubjectModel(id: 'ipvmNBMc4EPeR6Qx8FmN', name: 'Animal Husbandry'),
  SubjectModel(id: 'lQOy2mq48LoaLGTxge5t', name: 'Physical Education'),
  SubjectModel(id: 'm8arUeRB9P0GF0GvMehO', name: 'Home Management'),
  SubjectModel(id: 'n0KUhRQwxNzwoBsx8di2', name: 'Physical & Health Education'),
  SubjectModel(id: 'oJwvWPoLeL68HfvpD5sW', name: 'Physics'),
  SubjectModel(id: 'oVHQknkZpbpKL6jTdm2M', name: 'Home Economics'),
  SubjectModel(id: 'ogxpD9x45sBUgmc49XJM', name: 'Civic Education'),
  SubjectModel(id: 'pg3BrkoQBhOnYEheoIhS', name: 'Foods & Nutrition'),
  SubjectModel(id: 'qZT58Enre6kFlyfziBE7', name: 'Geography'),
  SubjectModel(id: 'rY0kZXtcMj905DllrT6G', name: 'Economics'),
  SubjectModel(id: 'wKlJaT1sZk4vspU2s6nU', name: 'Business Studies'),
  SubjectModel(id: 'x3WxJ9eLOeYRo9LDxLgX', name: 'Biology'),
  SubjectModel(id: 'yfexqkiOjWbe0jKeOBjV', name: 'Technical Drawing'),
];

// Container(
//   padding: const EdgeInsets.symmetric(
//       vertical: 10, horizontal: 10),
//   margin: const EdgeInsets.only(bottom: 15),
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(10),
//     border: Border.all(
//       color: MyColors.primayGreen,
//     ),
//   ),
//   child: Wrap(
//     alignment: WrapAlignment.start,
//     runAlignment: WrapAlignment.spaceEvenly,
//     children: studentSubjects
//         .map((e) => OnlySubjectContainer(
//               subject: e,
//               onDelete: onDeleteClass,
//             ))
//         .toList(),
//   ),
// ),
// TextButton(
//   onPressed: () async {
//     FocusScope.of(context).unfocus();
//     await addSubjectDialog();
//   },
//   child: const Text('Add Subject & Class'),
// ),
