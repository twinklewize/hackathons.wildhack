import 'package:flutter/widgets.dart';
import 'package:wildhack/constants/colors.dart';

class AppShadows {
  static final boxShadow = BoxShadow(
    color: AppColors.black.withOpacity(0.15),
    blurRadius: 15,
    offset: const Offset(-2, 4),
  );
  AppShadows._();
}
