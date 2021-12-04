import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wildhack/constants/colors.dart';

class GridViewPage extends StatelessWidget {
  final String title;
  const GridViewPage({
    Key? key,
    this.title = 'Животные',
  }) : super(key: key);

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
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    SvgPicture.asset('assets/icons/list_icon.svg'),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 20,
                            // childAspectRatio: 3 / 2,
                            mainAxisSpacing: 20),
                    itemCount: 100,
                    itemBuilder: (BuildContext ctx, index) {
                      return ClipRRect(
                        child: Container(
                          height: 100,
                          width: 100,
                          color: AppColors.blue,
                          child: Text('Hello'),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
