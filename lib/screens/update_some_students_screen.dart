import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_reg_app_2/models/school.dart';
import 'package:elevate_reg_app_2/models/student_j.dart';
import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:elevate_reg_app_2/utils/my_padding.dart';
import 'package:elevate_reg_app_2/widgets/loading_spinner.dart';
import 'package:elevate_reg_app_2/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class UpdateSomeStudentsScreen extends StatefulWidget {
  final School school;
  const UpdateSomeStudentsScreen({required this.school, super.key});

  @override
  State<UpdateSomeStudentsScreen> createState() =>
      _UpdateSomeStudentsScreenState();
}

class _UpdateSomeStudentsScreenState extends State<UpdateSomeStudentsScreen> {
  var _isScreenLoading = false;
  var _isButtonLoading = false;
  List<StudentJ> studentsList = [];
  List<String> studentsInJss1AList = [];

  @override
  void initState() {
    super.initState();
    fetchStudentsWithSpecificClass();
  }

  Future fetchStudentsWithSpecificClass() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      setState(() {
        _isScreenLoading = true;
      });
      // Query documents where 'class' is 1 and 'class_num' is 3

      QuerySnapshot querySnapshot = await firestore
          .collection('schools')
          .doc(widget.school.id)
          .collection('student')
          .where('class', isEqualTo: 1)
          .where('class_num', isEqualTo: 3)
          .get();
      // Iterate through each document and add to the list of Students
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Create a Student instance and add it to the list
        StudentJ student = StudentJ(
          classValue: data['class'],
          classNum: data['class_num'],
          name: data['name'],
          id: doc.id,
        );
        studentsList.add(student);
      }
    } catch (e) {
      print("Error fetching documents: $e");
    } finally {
      setState(() {
        _isScreenLoading = false;
      });
    }
  }

  Future addStudentsToJss1A() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    setState(() {
      _isButtonLoading = true;
    });

    try {
      // Loop through each document ID in the list
      for (String docId in studentsInJss1AList) {
        // Update 'class_num' field to 1 for each document
        await firestore
            .collection('schools')
            .doc(widget.school.id)
            .collection('student')
            .doc(docId)
            .update({'class_num': 1});
      }
    } catch (e) {
      print("Error updating documents: $e");
    } finally {
      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isScreenLoading
        ? const LoadingSpinnerFullScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Update Some Students'),
            ),
            body: Padding(
              padding: MyPadding.screenPadding,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: studentsList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 70,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                              color: MyColors.primayGreen,
                              width: 1,
                            ),
                          ),
                          child: Row(children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    studentsList[index].name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (studentsInJss1AList
                                          .contains(studentsList[index].id)) {
                                        setState(() {
                                          studentsInJss1AList
                                              .remove(studentsList[index].id);
                                        });
                                      } else {
                                        setState(() {
                                          studentsInJss1AList
                                              .add(studentsList[index].id);
                                        });
                                      }
                                    },
                                    child: const Text(
                                      'Add this student',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: MyColors.secGreen1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (studentsInJss1AList
                                .contains(studentsList[index].id))
                              const Icon(
                                Icons.donut_small,
                                size: 30,
                              )
                          ]),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        studentsInJss1AList.length.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: SubmitButton(
                          text: 'Change Student class',
                          onPressed: addStudentsToJss1A,
                          isLoading: _isButtonLoading,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
