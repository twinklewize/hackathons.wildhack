import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wildhack/constants/colors.dart';

class FilesUploading extends StatefulWidget {
  const FilesUploading({Key? key}) : super(key: key);

  @override
  State<FilesUploading> createState() => _FilesUploadingState();
}

class _FilesUploadingState extends State<FilesUploading> {
  final Set<Uri> files = {};
  bool isDragging = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: DropTarget(
        onDragEntered: (details) {
          setState(() {
            isDragging = true;
          });
        },
        onDragExited: (details) {
          setState(() {
            isDragging = false;
          });
        },
        onDragDone: (details) => {
          files.addAll(details.urls),
          files.map(buildFile).toList(),
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color:
                isDragging ? AppColors.blue.withOpacity(0.5) : AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Container(
              width: 420,
              height: 420,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightBlue,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 114),
                  SvgPicture.asset('assets/icons/folder_icon.svg'),
                  const SizedBox(height: 30),
                  const Text(
                    'Перетащите файлы сюда',
                    style: TextStyle(
                      color: AppColors.lightGray,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Или нажмите кнопку "Загрузить"',
                    style: TextStyle(
                      color: AppColors.lightGray,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  File buildFile(Uri file) {
    return File(file.toFilePath());
  }
}
