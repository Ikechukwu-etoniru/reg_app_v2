class Subject {
  final String name;
  final String id;
  final String shortName;
  final String? imageAsset;
  Subject({
    required this.id,
    required this.name,
    required this.shortName,
    this.imageAsset,
  });
}

class SubjectModel {
  final String name;
  final String id;
  SubjectModel({
    required this.id,
    required this.name,
  });
}

class SubjectClass {
  int classNum;
  int classId;
  String subject;
  final String name;

  SubjectClass({
    required this.classNum,
    required this.classId,
    required this.subject,
    required this.name,
  });

   // Convert SubjectClass instance to a map
  Map<String, dynamic> toMap() {
    return {
      'class_num': classNum,
      'class': classId,
      'subject': subject,
    };
  }
}
