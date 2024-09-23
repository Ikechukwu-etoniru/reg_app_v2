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
