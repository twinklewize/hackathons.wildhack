import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/main_screen/app_provider.dart';
import 'package:wildhack/main_screen/components/files_uploading.dart';
import 'package:wildhack/main_screen/components/files_view_widget.dart';
import 'package:wildhack/main_screen/components/statistic.dart';

import 'components/side_menu.dart';

// ignore: use_key_in_widget_constructors
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 2,
              child: SideMenu(),
            ),
            const Expanded(
              flex: 8,
              child: MiddlePart(),
            ),
            appProvider.appState == AppState.empty
                ? Container()
                : const Expanded(
                    flex: 3,
                    child: Statistics(),
                  ),
          ],
        ),
      ),
    );
  }
}

class MiddlePart extends StatelessWidget {
  const MiddlePart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    switch (appProvider.appState) {
      case AppState.empty:
        return const FilesUploading();
      case AppState.waiting:
        return Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: FilesViewWidget(
                title: 'Загруженные файлы',
                files: appProvider.filesWithoutAnimal,
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
      case AppState.loading:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: FilesViewWidget(
                title: 'Загруженные файлы',
                files: appProvider.filesWithAnimal +
                    appProvider.filesWithoutAnimal,
                dragNDropOn: false,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: FilesViewWidget(
                title: 'Обработанные файлы',
                files: appProvider.allLoadedFiles,
                withFolders: true,
                dragNDropOn: false,
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
      case AppState.loaded:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: FilesViewWidget(
                title: 'Животные',
                files: appProvider.filesWithAnimal,
                dragNDropOn: false,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: FilesViewWidget(
                title: 'Пустые фотографии',
                files: appProvider.filesWithoutAnimal,
                dragNDropOn: false,
              ),
            ),
            const SizedBox(height: 30),
          ],
        );
      default:
        return Container();
    }
  }
}
