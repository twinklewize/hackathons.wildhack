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
  ContentType contentType;
  PlatformFile path;
  Status status;
  bool isAnimal;
  AnimalType animalType;
  File({
    required this.path,
    this.contentType = ContentType.image,
    this.isAnimal = false,
    this.status = Status.waiting,
    this.animalType = AnimalType.other,
  });
}
