import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class AppProvider with ChangeNotifier {
  List<PlatformFile> _chosenFiles = [];
  bool _isLoading = false;
  bool _userAborted = false;

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

  Future<void> pickFilesWithDragNDrop(List<File> files) async {
    _isLoading = true;
    notifyListeners();
    _chosenFiles.addAll(files
        .map(
          (file) => PlatformFile(
            path: file.path,
            name: basename(file.path),
            size: file.lengthSync(),
          ),
        )
        .toList());
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
