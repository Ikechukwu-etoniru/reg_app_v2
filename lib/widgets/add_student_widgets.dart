import 'package:elevate_reg_app_2/models/subjects.dart';
import 'package:flutter/material.dart';

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

class OnlySubjectContainer extends StatelessWidget {
  final SubjectClass subject;
  final Function onDelete;
  const OnlySubjectContainer({
    required this.subject,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'class - ${subject.classId}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'class id - ${subject.classNum}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: () {
              onDelete(subject.subject, subject.classId, subject.classNum);
            },
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
