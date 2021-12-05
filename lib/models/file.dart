import 'package:file_picker/file_picker.dart';

enum ContentType {
  video,
  image,
}

enum Status {
  waiting,
  loading,
  loaded,
}

enum AnimalType {
  fox,
  saiga,
  other,
}

class File {
  ContentType contentType = ContentType.image;
  String path;
  String name;
  double sizeInBytes;
  Status status = Status.waiting;
  bool isAnimal = false;
  AnimalType animalType = AnimalType.other;

  File({
    required this.path,
    required this.name,
    required this.sizeInBytes,
    required this.isAnimal,
    required this.status,
  });
}
