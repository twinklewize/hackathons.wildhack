import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wildhack/constants/colors.dart';

class FilesUploading extends StatelessWidget {
  const FilesUploading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
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
    );
  }
}
