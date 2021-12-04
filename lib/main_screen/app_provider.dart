import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wildhack/models/folder.dart';

class AppProvider with ChangeNotifier {
  List<Folder> _folders = [];
  List<PlatformFile> _chosenFiles = [];
  bool _isLoading = false;
  bool _userAborted = false;

  List<Folder> get folders {
    return [..._folders];
  }

  List<PlatformFile> get chosenFiles {
    return [..._chosenFiles];
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get userAborted {
    return _userAborted;
  }

  Future<void> pickFiles() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (chosenFiles.isNotEmpty) {
        _chosenFiles.addAll(
          (await FilePicker.platform.pickFiles(
                type: FileType.any,
                allowMultiple: true,
                onFileLoading: (FilePickerStatus status) => print(status),
              ))
                  ?.files ??
              [],
        );
      } else {
        _chosenFiles = (await FilePicker.platform.pickFiles(
              type: FileType.any,
              allowMultiple: true,
              onFileLoading: (FilePickerStatus status) => print(status),
            ))
                ?.files ??
            [];
      }
    } on PlatformException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    _isLoading = false;
    _userAborted = _chosenFiles.isEmpty;
    notifyListeners();
  }

  Future<void> clearCachedFiles() async {
    _isLoading = true;
    notifyListeners();
    try {
      _chosenFiles.clear();
    } on PlatformException catch (e) {
      print("PlatformException " + e.toString());
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }
}
