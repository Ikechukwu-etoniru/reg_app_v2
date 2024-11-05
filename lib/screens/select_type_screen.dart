import 'package:elevate_reg_app_2/models/school.dart';
import 'package:elevate_reg_app_2/screens/add_parents_subscription_screen.dart';
import 'package:elevate_reg_app_2/screens/add_student_screen.dart';
import 'package:elevate_reg_app_2/screens/add_teacher_screen.dart';
import 'package:elevate_reg_app_2/utils/colors.dart';
import 'package:elevate_reg_app_2/utils/my_padding.dart';
import 'package:flutter/material.dart';

class SelectTypeScreen extends StatefulWidget {
  final School school;
  const SelectTypeScreen({required this.school, super.key});

  @override
  State<SelectTypeScreen> createState() => _SelectTypeScreenState();
}

class _SelectTypeScreenState extends State<SelectTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: MyPadding.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                foregroundImage: NetworkImage(widget.school.imageUrl),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.school.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SelectTypeContainer(
              type: 'Add Student',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddStudentScreen(school: widget.school);
                }));
              },
            ),
            SelectTypeContainer(
              type: 'Add teacher',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddTeacherScreen(school: widget.school);
                }));
              },
            ),
            SelectTypeContainer(
              type: 'Add Parents Subscription',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddParentsSubscriptionScreen(school: widget.school);
                }));
              },
            ),
            // SelectTypeContainer(
            //   type: 'Update Jss1c students',
            //   onPressed: () {
            //     Navigator.of(context)
            //         .push(MaterialPageRoute(builder: (context) {
            //       return UpdateSomeStudentsScreen(school: widget.school);
            //     }));
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class SelectTypeContainer extends StatelessWidget {
  final String type;
  final void Function()? onPressed;
  const SelectTypeContainer(
      {required this.type, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: MyColors.primayGreen,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              type,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}

int getClassId(String className) {
  if (className == 'JSS1') {
    return 1;
  } else if (className == 'JSS2') {
    return 2;
  } else if (className == 'JSS3') {
    return 3;
  } else if (className == 'SSS1') {
    return 4;
  } else if (className == 'SSS2') {
    return 5;
  } else {
    return 6;
  }
}

int getClassIdId(String classId) {
  if (classId == 'A') {
    return 1;
  } else if (classId == 'B') {
    return 2;
  } else if (classId == 'C') {
    return 3;
  } else if (classId == 'D') {
    return 4;
  } else if (classId == 'E') {
    return 5;
  } else if (classId == 'F') {
    return 6;
  } else if (classId == 'G') {
    return 7;
  } else if (classId == 'H') {
    return 8;
  } else if (classId == 'I') {
    return 9;
  } else {
    return 10;
  }
}
