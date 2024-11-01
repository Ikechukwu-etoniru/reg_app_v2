// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_reg_app_2/models/school.dart';
import 'package:elevate_reg_app_2/models/student.dart';
import 'package:elevate_reg_app_2/utils/alert.dart';
import 'package:elevate_reg_app_2/utils/my_padding.dart';
import 'package:elevate_reg_app_2/widgets/add_student_widgets.dart';
import 'package:elevate_reg_app_2/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class AddParentsSubscriptionScreen extends StatefulWidget {
  final School school;
  const AddParentsSubscriptionScreen({required this.school, super.key});

  @override
  State<AddParentsSubscriptionScreen> createState() =>
      _AddParentsSubscriptionScreenState();
}

class _AddParentsSubscriptionScreenState
    extends State<AddParentsSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _lastNameController = TextEditingController();

  Future _identifyParentsChild() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      // Reference to your Firestore collection
      CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance
              .collection('schools')
              .doc(widget.school.id)
              .collection('student');

      // Query for documents where the 'name' field matches the specified value
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference
              .where('name',
                  isGreaterThanOrEqualTo:
                      _lastNameController.text.trim().toLowerCase())
              .where('name',
                  isLessThanOrEqualTo:
                      '${_lastNameController.text.trim().toLowerCase()}\uf8ff')
              .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Convert data to a student class and add to list to send to next screen
        List<Student> nameMatchedStudentList = [];
        for (var element in querySnapshot.docs) {
          var studentData = element.data();
          List<String> stringList = studentData['subjects'].cast<String>();
          nameMatchedStudentList.add(
            Student(
              id: studentData['id'],
              name: studentData['name'],
              imageUrl: studentData['image_url'],
              classId: studentData['class'],
              subjectIds: stringList,
              schoolId: widget.school.id,
            ),
          );
        }
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return SelectChildScreen(
        //     studentWithMatchingName: nameMatchedStudentList,
        //     lastName: _lastNameController.text.trim(),
        //     isFirstChild: true,
        //     school: _listOfSchools.firstWhere(
        //       (element) => element.id == _selectedSchoolId,
        //     ),
        //   );
        // }));
      } else if (querySnapshot.docs.isEmpty) {
        // What to do when the list is empty
        Alert.errorDialog(
            context: context,
            description:
                'No child in the selected school database matched the last name "${_lastNameController.text}" in the class . Crosscheck inputed details and try again',
            title: 'No Match');
      }
    } catch (e) {
      Alert.errorDialog(
        context: context,
        description:
            'An error occured while trying to fetch youe child information. Try again',
      );
      return [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future uploadPaymentDetail() async {
  // try {
  //   final subscriptionDetail = {
  //     'amount': subDetails.amount.toString(),
  //     'class': subDetails.childClass,
  //     'date': subDetails.date,
  //     'term': subDetails.term,
  //     'reference': subDetails.reference,
  //     'child_id': subDetails.childId,
  //     'plan': subDetails.paymentPlan
  //   };
  //   await fireStore
  //       .collection('parents')
  //       .doc(auth.currentUser!.uid)
  //       .collection('subscription_history')
  //       .doc(subDetails.id)
  //       .set(subscriptionDetail);
  // } catch (error) {
  //   throw AppException('An error occured while uploading payment details');
  // }
  // }

  // Future updateStudentStatusAsPaid(SubscribtionHistory subDetails) async {
  //   try {
  //     final subscriptionDetail = {
  //       'amount': subDetails.amount.toString(),
  //       'class': widget.childClass,
  //       'date': subDetails.date,
  //       'term': widget.schoolTerm,
  //       'term_number': subDetails.paymentPlan == 1 ? 1 : 3
  //     };
  //     await fireStore.collection('parents').doc(auth.currentUser!.uid).set({
  //       widget.childId: subscriptionDetail,
  //     }, SetOptions(merge: true));
  //   } catch (error) {
  //     throw AppException(
  //         'An error occured while updating student status as paid');
  //   }
  // }

  // From here, i send the payment detail to the paid parents folder for the school to see

  // Future updateSchoolThatParentsHasPaid(SubscribtionHistory subDetails) async {
  //   try {
  //     final currentChildSchool =
  //         Provider.of<UserProvider>(context, listen: false).currentSchool;
  //     final paidParentsPath = fireStore
  //         .collection('schools')
  //         .doc(currentChildSchool.id)
  //         .collection('paid_parents')
  //         .doc('${currentChildSchool.currentTerm}-${DateTime.now().year}');
  //     final paidParentsVal = await paidParentsPath.get();
  //     final paidParentsData = paidParentsVal.data();
  //     final newParentsNumber = (paidParentsData!['parentNumber'] as int) + 1;

  //     final newTotalBalance = (paidParentsData['totalAmount'] as int) +
  //         int.parse(subDetails.amount);
  //     await paidParentsPath.set({
  //       'parentNumber': newParentsNumber,
  //       'totalAmount': newTotalBalance,
  //     });
  //   } catch (error) {
  //     throw AppException('An error occured while notifying school of payment');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Parents Subscription'),
      ),
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const TextFieldTitle(title: 'Enter Child Last Name'),
              TextFormField(
                controller: _lastNameController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 13,
                ),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Student Last Name';
                  } 
                  return null;
                },
              ),
              const Spacer(),
              SubmitButton(text: 'Find Student', onPressed: () {
          
              }, isLoading: _isLoading,
              )
              // MyDropDown(
              //   items: [
              //     '2000',
              //     '6000',
              //   ]
              //       .map(
              //         (e) => DropdownMenuItem<String>(
              //           value: e,
              //           child: Text(
              //             e,
              //             style: const TextStyle(
              //                 fontSize: 13,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black),
              //           ),
              //         ),
              //       )
              //       .toList(),
              //   onChanged: (val) {
              //     // selectedClass = val as String;
              //   },
              //   hint: const Text(
              //     'Pick Amount',
              //     style: TextStyle(
              //       fontSize: 13,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.grey,
              //     ),
              //   ),
              //   validator: (value) {
              //     if (value == null) {
              //       return 'Add Amount';
              //     }
              //     return null;
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
