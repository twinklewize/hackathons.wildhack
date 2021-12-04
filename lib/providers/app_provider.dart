import 'package:flutter/material.dart';
import 'package:wildhack/models/file.dart';
import 'package:wildhack/models/folder.dart';

class AppProvider with ChangeNotifier {
  List<Folder> _folders = [
    Folder(
      id: 0,
      name: '0',
      fileList: <File>[],
    ),
    Folder(
      id: 0,
      name: '0',
      fileList: <File>[],
    ),
    Folder(
      id: 0,
      name: '0',
      fileList: <File>[],
    ),
  ];
  Folder? _currentOpenedFolder;

  List<Folder> get folders {
    return [..._folders];
  }

  Folder? get currentFolder {
    Folder? t = _currentOpenedFolder;
    return t;
  }

  // // удаление файла из прошлой папки и добавление файла в целевую папку
  // void dragFileToAnotherFolder({
  //   required File draggedfile,
  //   required int fromFolderId,
  //   required int toFolderId,
  // }) {
  //   // удаление файла из прошлой папки
  //   folders
  //       .firstWhere((folder) => folder.id == fromFolderId)
  //       .fileList
  //       .removeWhere((file) => file.path == draggedfile.path);

  //   // добавление файла в целевую папку
  //   folders
  //       .firstWhere((folder) => folder.id == toFolderId)
  //       .fileList
  //       .add(draggedfile);

  //   notifyListeners();
  // }

  // Future<void> uploadFilesFromPCFileSystem() async {
  //   // временные файлы
  //   String? _directoryPath;
  //   List<PlatformFile>? _paths;
  //   String? _extension;
  //   String? _fileName;
  //   bool _userAborted = false;
  //   try {
  //     _directoryPath = null;
  //     _paths = (await FilePicker.platform.pickFiles(
  //       type: FileType.any,
  //       allowMultiple: true,
  //       onFileLoading: (FilePickerStatus status) => print(status),
  //       allowedExtensions: (_extension?.isNotEmpty ?? false)
  //           ? _extension?.replaceAll(' ', '').split(',')
  //           : null,
  //     ))
  //         ?.files;
  //   } on PlatformException catch (e) {
  //     Fluttertoast.showToast(
  //       msg: 'Unsupported operation' + e.toString(),
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  //   } catch (e) {
  //      Fluttertoast.showToast(
  //       msg: e.toString(),
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  //   }
  //   _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
  //   _userAborted = _paths == null;

  // }
}
