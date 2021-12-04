import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wildhack/models/file.dart';

class AppProvider with ChangeNotifier {
  List<File> _chosenFiles = [];
  bool _isLoading = false;
  bool _userAborted = false;
  List<File> get chosenFiles {
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
    List<PlatformFile> _chosenPlatformFiles = [];
    try {
      if (chosenFiles.isNotEmpty) {
        _chosenPlatformFiles.addAll(
          (await FilePicker.platform.pickFiles(
                type: FileType.any,
                allowMultiple: true,
                onFileLoading: (FilePickerStatus status) => print(status),
              ))
                  ?.files ??
              [],
        );
      } else {
        _chosenPlatformFiles = (await FilePicker.platform.pickFiles(
              type: FileType.any,
              allowMultiple: true,
              onFileLoading: (FilePickerStatus status) => print(status),
            ))
                ?.files ??
            [];
      }
      _chosenFiles.clear();
      for (var everyPlatformFile in _chosenPlatformFiles) {
        _chosenFiles.add(
          File(
            path: everyPlatformFile.path!,
            sizeInBytes: everyPlatformFile.size.toDouble(),
            name: everyPlatformFile.name,
          ),
        );
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
    _chosenFiles.addAll(files);
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

  Future<void> sendFilePathsToBackend() async {}
}
