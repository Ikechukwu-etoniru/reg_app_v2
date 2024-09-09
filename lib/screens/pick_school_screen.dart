import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevate_reg_app_2/models/school.dart';
import 'package:elevate_reg_app_2/screens/select_type_screen.dart';
import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:elevate_reg_app_2/utils/my_padding.dart';
import 'package:elevate_reg_app_2/widgets/is_error_screen.dart';
import 'package:elevate_reg_app_2/widgets/loading_spinner.dart';
import 'package:elevate_reg_app_2/widgets/my_dropdown.dart';
import 'package:elevate_reg_app_2/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class PickSchoolScreen extends StatefulWidget {
  static const routeName = '/pick_school_screen.dart';
  const PickSchoolScreen({super.key});

  @override
  State<PickSchoolScreen> createState() => _PickSchoolScreenState();
}

class _PickSchoolScreenState extends State<PickSchoolScreen> {
  List<School> _listOfSchools = [];
  School? _selectedSchool;
  var _isScreenLoading = false;
  var _isLoading = false;
  var _isError = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getSchoolList();
  }

  // Get all schools in the database
  Future getSchoolList() async {
    try {
      setState(() {
        _isScreenLoading = true;
      });
      final userProfile =
          await FirebaseFirestore.instance.collection('schools').get();
      final userData = await convertQuerySnapshotToList(userProfile);
      for (var element in userData) {
        final newSchool = School(
          id: element['id'],
          name: element['school_name'],
          imageUrl: element['image_url'],
          currentTerm: element['current_term'],
          isAvailable: element['is_available'],
        );
        if (newSchool.isAvailable) {
          _listOfSchools.add(newSchool);
        }
      }
    } catch (error) {
      _isError = true;
    } finally {
      setState(() {
        _isScreenLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isScreenLoading
        ? const LoadingSpinnerFullScreen()
        : _isError
            ? IsErrorScreen(onPressed: getSchoolList)
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Pick School'),
                ),
                body: Padding(
                  padding: MyPadding.screenPadding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyDropDown(
                          items: _listOfSchools
                              .map(
                                (e) => DropdownMenuItem<School>(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundImage: NetworkImage(
                                            e.imageUrl,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            e.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.primayGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            _selectedSchool = val as School;
                          },
                          hint: const Text(
                            'Pick School',
                            style: TextStyle(
                              color: Colors.black26,
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.toString().isEmpty) {
                              return 'Select a school';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SubmitButton(
                          text: 'Continue',
                          onPressed: () {
                            final isValid = _formKey.currentState!.validate();
                            if (!isValid) {
                              return;
                            }
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return SelectTypeScreen(
                                school: _selectedSchool!,
                              );
                            }));
                          },
                          isLoading: false,
                        )
                      ],
                    ),
                  ),
                ),
              );
  }
}

Future<List<Map<String, dynamic>>> convertQuerySnapshotToList(
    QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
  List<Map<String, dynamic>> dataList = [];

  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
      in querySnapshot.docs) {
    final data = documentSnapshot.data();
    dataList.add(data);
  }

  return dataList;
}
