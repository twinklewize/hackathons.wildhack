import 'package:flutter/material.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/main_screen/components/statistic.dart';

import 'components/side_menu.dart';

// ignore: use_key_in_widget_constructors
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            const Expanded(
              flex: 3,
              child: Statistics(),
            ),
          ],
        ),
      ),
    );
  }
}
