import 'package:wildhack/models/file.dart';

class Folder {
  int id;
  String name = '';
  List<File> fileList = [];

  Folder({
    required this.id,
    required this.name,
    required this.fileList,
  });
}
