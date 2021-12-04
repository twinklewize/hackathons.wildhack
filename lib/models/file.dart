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
  late ContentType contentType;
  late PlatformFile path;
  late DateTime date;
  late Status status = Status.waiting;
  late bool isAnimal = false;
  late AnimalType animalType = AnimalType.other;
}
