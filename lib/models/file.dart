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
  Status status;
  bool isAnimal;
  AnimalType animalType = AnimalType.other;

  File({
    required this.path,
    required this.name,
    required this.sizeInBytes,
    this.isAnimal = false,
    this.status = Status.waiting,
  });
}
