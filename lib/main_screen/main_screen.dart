import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/main_screen/app_provider.dart';
import 'package:wildhack/main_screen/components/choose_files_page.dart';
import 'package:wildhack/main_screen/components/files_uploading.dart';
import 'package:wildhack/main_screen/components/grid_view_page.dart';
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
              // child: ChooseFilesPage(),
              child: appProvider.filesWithoutAnimal.isEmpty
                  ? const FilesUploading()
                  : ChooseFilesPage(),
              //child: GridViewPage(),
            ),
            appProvider.filesWithoutAnimal.isEmpty
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
