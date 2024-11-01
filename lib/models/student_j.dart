class StudentJ {
  final int classNum;
  final int classValue;
  final String name;
  final String id;

  StudentJ({required this.classValue, required this.classNum, required this.name, required this.id});

  @override
  String toString() {
    return 'Student(name: $name, class: $classValue, class_num: $classNum, id: $id)';
  }
}
