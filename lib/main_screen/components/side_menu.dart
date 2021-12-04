import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wildhack/constants/colors.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      elevation: 0,
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 60, 0, 60),
            child: Text(
              'A.Identification',
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ),
          DrawerListTile(
            title: "Обработка данных",
            svgSrc: "assets/icons/data_icon.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Отчеты",
            svgSrc: "assets/icons/reports_icon.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Статистика",
            svgSrc: "assets/icons/statistics_icon.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 0, 20),
        child: Row(
          children: [
            SvgPicture.asset(
              svgSrc,
              color: AppColors.lightGray,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.lightGray,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
