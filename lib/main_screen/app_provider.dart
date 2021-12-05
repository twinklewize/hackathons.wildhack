import 'dart:convert';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:wildhack/models/file.dart';
import 'package:http/http.dart' as http;

enum AppState {
  empty, // когда файлы не загружены в систему
  waiting, // когда они загружены
  loading, // когда файлы анализируются бэком
  loaded, // файлы загружены
}

class AppProvider with ChangeNotifier {
// сначала все файлы попадают сюда
  List<File> _filesWithoutAnimal = [];

// но если животное на фото будет, то он попадет сюда
  List<File> _filesWithAnimal = [];

  bool _isWaitingFilesFromBackend = false;
  bool _userAborted = false;

  List<File> get filesWithoutAnimal {
    return [..._filesWithoutAnimal];
  }

  List<File> get filesWithAnimal {
    return [..._filesWithAnimal];
  }

  bool get isWaitingFilesFromBackend {
    return _isWaitingFilesFromBackend;
  }

  bool get userAborted {
    return _userAborted;
  }

  List<File> get allLoadedFiles {
    List<File> loaded = [];
    for (var file in filesWithAnimal) {
      if (file.status == Status.loaded) {
        loaded.add(file);
      }
    }
    for (var file in filesWithoutAnimal) {
      if (file.status == Status.loaded) {
        loaded.add(file);
      }
    }
    return loaded;
  }

  List<File> get allLoadedButEmpty {
    List<File> result = [];
    for (var file in allLoadedFiles) {
      if (file.isAnimal == false) {
        result.add(file);
      }
    }
    return result;
  }

// выбор файлов при нажатии кнопки "Загрузить"
  Future<void> pickFiles() async {
    notifyListeners();
    List<PlatformFile> _chosenPlatformFiles = [];
    try {
      if (filesWithoutAnimal.isNotEmpty) {
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
      for (var everyPlatformFile in _chosenPlatformFiles) {
        _filesWithoutAnimal.add(
          File(
            path: everyPlatformFile.path!,
            sizeInBytes: everyPlatformFile.size.toDouble(),
            name: everyPlatformFile.name,
          ),
        );
      }

// // удаление повторяющихся файлов
// _filesWithoutAnimal = filesWithoutAnimal.toSet().toList();
    } on PlatformException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
    _userAborted = filesWithoutAnimal.isEmpty;
    notifyListeners();
  }

// принятие файлов драг-н-дроп зоной
  Future<void> pickFilesWithDragNDrop(List<File> files) async {
// добавление файлов в общий список
    _filesWithoutAnimal.addAll(files);
// // удаление повторяющихся файлов
// _filesWithoutAnimal = filesWithoutAnimal.toSet().toList();
    _userAborted = filesWithoutAnimal.isEmpty;
    notifyListeners();
  }

// очистить рабочую зону
  Future<void> clearCachedFiles() async {
    notifyListeners();
    try {
      _filesWithoutAnimal.clear();
    } on PlatformException catch (e) {
      print("PlatformException " + e.toString());
    } catch (e) {
      print(e.toString());
    } finally {}
    notifyListeners();
  }

// отправить загруженные файлы на бэк
  Future<void> sendFilePathsToBackend() async {
    // // отправляем список файлов на бэк
    // final url = Uri.parse('http://localhost:2021/api/sendPaths');
    List<String> filePaths = [];
    for (var chosenFile in filesWithoutAnimal) {
      filePaths.add(chosenFile.path);
    }
    // final response = await http.post(
    //   url,
    //   headers: {io.HttpHeaders.contentTypeHeader: "application/json"},
    //   body: json.encode(
    //     {
    //       'filePaths': filePaths,
    //     },
    //   ),
    // );
    // print(response.body);

// присваиваем всем файлам режим "в обработке"
    for (var chosenFile in filesWithoutAnimal) {
      chosenFile.status = Status.loading;
    }
    _isWaitingFilesFromBackend = true;
    notifyListeners();

// смотрим, сколько файлов нам нужно получить с бэка
    int howManyFilesShouldWeRecieve = filesWithoutAnimal.length;

// получаем файлы с бэка, пока не получим все, что нужно
// отправляем запрос раз в секунду, чтобы не убить сервер
    while (filesWithAnimal.length < howManyFilesShouldWeRecieve) {
      await Future.delayed(const Duration(seconds: 1));
//await _getResultFromBackend();
      await _getResultFromFakeBackend(filePaths);
    }

// окончание процесса обработки
    _isWaitingFilesFromBackend = false;
    notifyListeners();
  }

// // получать результаты с бэка
// Future<void> _getResultFromBackend() async {
// // отправляем запрос на получение списка из нескольких проверенных файлов
// final url = Uri.parse('http://localhost:2021/api/getResults');
// final response = await http.post(
// url,
// headers: {io.HttpHeaders.contentTypeHeader: "application/json"},
// body: json.encode({}),
// );
// print(response.body);
// final decodedResponse = jsonDecode(response.body);

// // добавляем каждый пришедший файл в список с животными и удаляем из списка без животных
// for (var responseFile in decodedResponse) {
// if (responseFile['isAnimal'] == true) {
// // добавление в список с животными
// filesWithAnimal.add(
// File(
// path: responseFile['path'],
// name: basename(responseFile['path']),
// sizeInBytes:
// io.File(responseFile['path']).statSync().size.toDouble(),
// isAnimal: responseFile['isAnimal'],
// status: Status.loaded,
// ),
// );
// // удаление из списка без животных
// filesWithoutAnimal
// .removeWhere((element) => element.path == responseFile['path']);
// }
// }
// notifyListeners();
// }

// получать результаты с бэка
  Future<void> _getResultFromFakeBackend(
      List<String> sendedListOfString) async {
    List<Map<String, dynamic>> resultData = [];
    for (var item in sendedListOfString) {
      await Future.delayed(const Duration(seconds: 1));
      resultData.add({"path": item, "isAnimal": item.length.isEven});
    }

    var response = jsonEncode(resultData);

    final decodedResponse = jsonDecode(response);

    print(decodedResponse);

// добавляем каждый пришедший файл в список с животными и удаляем из списка без животных
    for (var responseFile in decodedResponse) {
      if (responseFile['isAnimal'] == true) {
// добавление в список с животными
        filesWithAnimal.add(
          File(
            path: responseFile['path'],
            name: basename(responseFile['path']),
            sizeInBytes:
                io.File(responseFile['path']).statSync().size.toDouble(),
            isAnimal: responseFile['isAnimal'],
            status: Status.loaded,
          ),
        );
        print('Новый файл');
// удаление из списка без животных
        filesWithoutAnimal
            .removeWhere((element) => element.path == responseFile['path']);
        notifyListeners();
      }
    }
  }
}
