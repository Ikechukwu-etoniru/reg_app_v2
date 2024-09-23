class Student {
  final String id;
  final String schoolId;
  final String name;
  final int classId;
  final String imageUrl;
  final List<String> subjectIds;

  Student({
    required this.id,
    required this.schoolId,
    required this.name,
    required this.imageUrl,
    required this.classId,
    required this.subjectIds,
  });
}
