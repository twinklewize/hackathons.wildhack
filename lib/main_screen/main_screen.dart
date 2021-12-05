import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/main_screen/app_provider.dart';
import 'package:wildhack/main_screen/components/choose_files_page.dart';
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
      // drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 2,
              child: SideMenu(),
            ),
            Expanded(
              flex: 8,
              child: appProvider.chosenFiles.isEmpty
                  ? const FilesUploading()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 30),
                        Expanded(
                          child: FilesViewWidget(
                            title: 'Загруженные файлы',
                            files:
                                Provider.of<AppProvider>(context).chosenFiles,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          child: FilesViewWidget(
                            title: 'Загруженные файлы',
                            files:
                                Provider.of<AppProvider>(context).chosenFiles,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
            ),
            appProvider.chosenFiles.isEmpty
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
