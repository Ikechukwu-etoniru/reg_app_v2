// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_reg_app_2/models/school.dart';
import 'package:elevate_reg_app_2/models/subjects.dart';
import 'package:elevate_reg_app_2/screens/select_type_screen.dart';
import 'package:elevate_reg_app_2/utils/alert.dart';
import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:elevate_reg_app_2/utils/my_padding.dart';
import 'package:elevate_reg_app_2/widgets/add_student_widgets.dart';
import 'package:elevate_reg_app_2/widgets/submit_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddSubjectScreen extends StatefulWidget {
  final File picFile;
  final String name;
  final String parentsNumber1;
  final String? parentsNumber2;
  final String classId;
  final String classIdentifier;
  final int selectedClass;
  final School school;
  const AddSubjectScreen(
      {required this.picFile,
      required this.name,
      required this.parentsNumber1,
      required this.parentsNumber2,
      required this.classId,
      required this.classIdentifier,
      required this.selectedClass,
      required this.school,
      super.key});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  Future addStudent() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Reference ref = _storage
          .ref()
          .child('students_images')
          .child('${DateTime.now().toString()}.jpg');
      UploadTask uploadTask = ref.putFile(widget.picFile);
      String imageUrl = await (await uploadTask).ref.getDownloadURL();
      final schoolStudentCollection = FirebaseFirestore.instance
          .collection('schools')
          .doc(widget.school.id)
          .collection('student');

      List<String> allSelectivesSs1 = [
        ss1Selective1,
        ss1Selective2,
        ss1Selective3,
        ss1Selective4,
        ss1Selective5
      ];

      List<String> allSelectivesSs2 = [
        ss2Selective1,
        ss2Selective2,
        ss2Selective3,
        ss2Selective4,
        ss2Selective5,
        ss2Selective6,
      ];

      List<String> allSelectivesSs3 = [
        ss3Selective1,
        ss3Selective2,
        ss3Selective3,
        ss3Selective4,
        ss3Selective5,
        ss3Selective6,
      ];

      // Filter the list to remove any empty strings
      List<String> filteredSubjects1 =
          allSelectivesSs1.where((subject) => subject.isNotEmpty).toList();
      List<String> filteredSubjects2 =
          allSelectivesSs2.where((subject) => subject.isNotEmpty).toList();
      List<String> filteredSubjects3 =
          allSelectivesSs3.where((subject) => subject.isNotEmpty).toList();

      DocumentReference docRef =
          widget.parentsNumber2 == null || widget.parentsNumber2!.isEmpty
              ? await schoolStudentCollection.add({
                  'class': getClassId(widget.classId),
                  'class_num': getClassIdId(widget.classIdentifier),
                  'image_url': imageUrl,
                  'name': widget.name,
                  'school_id': widget.school.id,
                  // Remember Reg App hardcoded to secondary school 2
                  'school_type': 2,
                  'parent_number_1': widget.parentsNumber1,
                  'subjects': widget.selectedClass == 4
                      ? filteredSubjects1
                      : widget.selectedClass == 5
                          ? filteredSubjects2
                          : filteredSubjects3
                })
              : await schoolStudentCollection.add({
                  'class': getClassId(widget.classId),
                  'class_num': getClassIdId(widget.classIdentifier),
                  'image_url': imageUrl,
                  'name': widget.name,
                  'school_id': widget.school.id,
                  // Remember Reg App hardcoded to secondary school 2
                  'school_type': 2,
                  'parent_number_1': widget.parentsNumber1,
                  'parent_number_2': widget.parentsNumber2,
                  'subjects': widget.selectedClass == 4
                      ? filteredSubjects1
                      : widget.selectedClass == 5
                          ? filteredSubjects2
                          : filteredSubjects3
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
        _isLoading = false;
      });
    }
  }

  // SS1 Variables
  String ss1Selective1 = '';
  String ss1Selective2 = '';
  String ss1Selective3 = '';
  String ss1Selective4 = '';
  String ss1Selective5 = '';

  // SS2 Variables
  String ss2Selective1 = '';
  String ss2Selective2 = '';
  String ss2Selective3 = '';
  String ss2Selective4 = '';
  String ss2Selective5 = '';
  String ss2Selective6 = '';

  // SS3 Variables
  String ss3Selective1 = '';
  String ss3Selective2 = '';
  String ss3Selective3 = '';
  String ss3Selective4 = '';
  String ss3Selective5 = '';
  String ss3Selective6 = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subjects'),
      ),
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const TextFieldTitle(title: 'Add Subjects'),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.selectedClass == 4 || widget.selectedClass == 5)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 1',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'Q3gEtV4GN4FTrgST72E8',
                                  groupValue: widget.selectedClass == 4
                                      ? ss1Selective1
                                      : ss2Selective1,
                                  onChanged: (val) async {
                                    setState(() {
                                      if (widget.selectedClass == 4) {
                                        ss1Selective1 = val!;
                                      } else {
                                        ss2Selective1 = val!;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Data Processing',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'fg7ogwovmrPS89HcUZuU',
                                  groupValue: widget.selectedClass == 4
                                      ? ss1Selective1
                                      : ss2Selective1,
                                  onChanged: (val) async {
                                    setState(() {
                                      if (widget.selectedClass == 4) {
                                        ss1Selective1 = val!;
                                      } else {
                                        ss2Selective1 = val!;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Catering Craft Practice (CCP)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                  // //////////////////////////////////////////line 1
                  if (widget.selectedClass == 4 || widget.selectedClass == 5)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 2',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'oJwvWPoLeL68HfvpD5sW',
                                  groupValue: widget.selectedClass == 4
                                      ? ss1Selective2
                                      : ss2Selective2,
                                  onChanged: (val) async {
                                    setState(() {
                                      if (widget.selectedClass == 4) {
                                        ss1Selective2 = val!;
                                      } else {
                                        ss2Selective2 = val!;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Physics',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'U2eXDE0EUDt2BNYPNBG0',
                                  groupValue: widget.selectedClass == 4
                                      ? ss1Selective2
                                      : ss2Selective2,
                                  onChanged: (val) async {
                                    setState(() {
                                      if (widget.selectedClass == 4) {
                                        ss1Selective2 = val!;
                                      } else {
                                        ss2Selective2 = val!;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Government',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  // //////////////////////////////////////////line 2
                  if (widget.selectedClass == 4 || widget.selectedClass == 5)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 3',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'edcFN7VutiT2lTRpNHb9',
                                  groupValue: widget.selectedClass == 4
                                      ? ss1Selective3
                                      : ss2Selective3,
                                  onChanged: (val) async {
                                    setState(() {
                                      if (widget.selectedClass == 4) {
                                        ss1Selective3 = val!;
                                      } else {
                                        ss2Selective3 = val!;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Chemistry',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: '55Guz8BtNlf9KlTifBpG',
                                  groupValue: widget.selectedClass == 4
                                      ? ss1Selective3
                                      : ss2Selective3,
                                  onChanged: (val) async {
                                    setState(() {
                                      if (widget.selectedClass == 4) {
                                        ss1Selective3 = val!;
                                      } else {
                                        ss2Selective3 = val!;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'CRS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'EeIW8uViyo7WgRVgBKfW',
                                  groupValue: widget.selectedClass == 4
                                      ? ss1Selective3
                                      : ss2Selective3,
                                  onChanged: (val) async {
                                    setState(() {
                                      if (widget.selectedClass == 4) {
                                        ss1Selective3 = val!;
                                      } else {
                                        ss2Selective3 = val!;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Financial Accounting',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  // //////////////////////////////////////////line 3
                  if (widget.selectedClass == 4)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 4',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: '2FBHZ33VrR1B2f9MV1O7',
                                  groupValue: ss1Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss1Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'History',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'HfxrvnIf55D6rSy8c9E8',
                                  groupValue: ss1Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss1Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Computer Science',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'yfexqkiOjWbe0jKeOBjV',
                                  groupValue: ss1Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss1Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Technical Drawing',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'UpEq6l95YlfLABLhf91E',
                                  groupValue: ss1Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss1Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Agricultural Science',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  // //////////////////////////////////////////line 4
                  if (widget.selectedClass == 4)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 5',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'YldABhSvh6pue50HEmvW',
                                  groupValue: ss1Selective5,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss1Selective5 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Literature',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'qZT58Enre6kFlyfziBE7',
                                  groupValue: ss1Selective5,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss1Selective5 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Geography',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'P9yGujnIqabWGNHTyLRI',
                                  groupValue: ss1Selective5,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss1Selective5 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'French',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  // ///////////////////////////////////////// ss2 s4
                  if (widget.selectedClass == 5)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 4',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'rY0kZXtcMj905DllrT6G',
                                  groupValue: ss2Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss2Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Economics',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'HfxrvnIf55D6rSy8c9E8',
                                  groupValue: ss2Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss2Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Computer Science',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'P9yGujnIqabWGNHTyLRI',
                                  groupValue: ss2Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss2Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'French',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  // ///////////////////////////////////////// ss2 s5
                  if (widget.selectedClass == 5)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 5',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'W84Kkxym8nrGJFI73W25',
                                  groupValue: ss2Selective5,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss2Selective5 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Further Maths',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: '2FBHZ33VrR1B2f9MV1O7',
                                  groupValue: ss2Selective5,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss2Selective5 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'History',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                  // ///////////////////////////////////////// ss2 s6
                  if (widget.selectedClass == 5)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 6',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'yfexqkiOjWbe0jKeOBjV',
                                  groupValue: ss2Selective6,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss2Selective6 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Technical Drawing',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'UpEq6l95YlfLABLhf91E',
                                  groupValue: ss2Selective6,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss2Selective6 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Agricultural Science',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'YldABhSvh6pue50HEmvW',
                                  groupValue: ss2Selective6,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss2Selective6 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Literature',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'qZT58Enre6kFlyfziBE7',
                                  groupValue: ss2Selective6,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss2Selective6 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Geography',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  // ///////////////////////////////ss3 s1

                  if (widget.selectedClass == 6)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 1',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'Q3gEtV4GN4FTrgST72E8',
                                  groupValue: ss3Selective1,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective1 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Data Processing',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'fg7ogwovmrPS89HcUZuU',
                                  groupValue: ss3Selective1,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective1 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Catering Craft Practice (CCP)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'g7vs6V6kxQo389xHmae5',
                                  groupValue: ss3Selective1,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective1 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'BK',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                  // //////////////////////////////////////////ss3 s2
                  if (widget.selectedClass == 6)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 2',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'oJwvWPoLeL68HfvpD5sW',
                                  groupValue: ss3Selective2,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective2 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Physics',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'U2eXDE0EUDt2BNYPNBG0',
                                  groupValue: ss3Selective2,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective2 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Government',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                  // ///////////////////////////////////////ss3 s3
                  if (widget.selectedClass == 6)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 3',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'edcFN7VutiT2lTRpNHb9',
                                  groupValue: ss3Selective3,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective3 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Chemistry',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: '55Guz8BtNlf9KlTifBpG',
                                  groupValue: ss3Selective3,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective3 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'CRS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'EeIW8uViyo7WgRVgBKfW',
                                  groupValue: ss3Selective3,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective3 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Financial Accounting',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                  // ///////////////////////////////////////// ss3 s4
                  if (widget.selectedClass == 6)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 4',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'rY0kZXtcMj905DllrT6G',
                                  groupValue: ss3Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Economics',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'W84Kkxym8nrGJFI73W25',
                                  groupValue: ss3Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Further Maths',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'P9yGujnIqabWGNHTyLRI',
                                  groupValue: ss3Selective4,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective4 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'French',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                  // ///////////////////////////////////////// ss3 s5
                  if (widget.selectedClass == 6)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 5',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: '2FBHZ33VrR1B2f9MV1O7',
                                  groupValue: ss3Selective5,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective5 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'History',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'HfxrvnIf55D6rSy8c9E8',
                                  groupValue: ss3Selective5,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective5 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Computer Science',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'qZT58Enre6kFlyfziBE7',
                                  groupValue: ss3Selective5,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective5 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Geography',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  // ///////////////////////////////////////// ss3 s6
                  if (widget.selectedClass == 6)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: MyColors.secGreen1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selective 6',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'yfexqkiOjWbe0jKeOBjV',
                                  groupValue: ss3Selective6,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective6 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Technical Drawing',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'UpEq6l95YlfLABLhf91E',
                                  groupValue: ss3Selective6,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective6 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Agricultural Science',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: 1.3,
                                child: Radio<String?>(
                                  activeColor: MyColors.primayGreen,
                                  value: 'YldABhSvh6pue50HEmvW',
                                  groupValue: ss3Selective6,
                                  onChanged: (val) async {
                                    setState(() {
                                      ss3Selective6 = val!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                'Literature',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            SubmitButton(
              text: 'Add Child',
              onPressed: addStudent,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

List<SubjectModel> subjectssssss = [
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
