import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildhack/main_screen/app_provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'dart:io' as io;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/models/file.dart';

enum View { grid, list, folders }

// ignore: must_be_immutable
class FoldersWidget extends StatefulWidget {
  List<File> files;
  final String title;
  final bool dragNDropOn;
  FoldersWidget({
    Key? key,
    required this.title,
    required this.files,
    this.dragNDropOn = true,
  }) : super(key: key);

  @override
  _FoldersWidgetState createState() => _FoldersWidgetState();
}

class _FoldersWidgetState extends State<FoldersWidget> {
  View view = View.grid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: DropTarget(
        onDragDone: (details) async {
          widget.dragNDropOn
              ? await Provider.of<AppProvider>(context, listen: false)
                  .pickFilesWithDragNDrop(
                  details.urls
                      .map(
                        (e) => File(
                          path: io.File(e.toFilePath()).path,
                          name: basename(io.File(e.toFilePath()).path),
                          sizeInBytes: io.File(e.toFilePath())
                              .statSync()
                              .size
                              .toDouble(),
                        ),
                      )
                      .toList(),
                )
              : () {};
        },
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
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (view == View.grid) {
                              view = View.list;
                            } else {
                              view = View.grid;
                            }
                          });
                        },
                        child: view == View.grid
                            ? SvgPicture.asset('assets/icons/list_icon.svg')
                            : SvgPicture.asset('assets/icons/grid_icon.svg'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const FoldersView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FoldersView extends StatelessWidget {
  const FoldersView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FolderWidget(
          color: AppColors.lightOrange,
          amount: Provider.of<AppProvider>(context, listen: true)
              .filesWithAnimal
              .length,
          text: 'Животные',
          onPressed: () {},
        ),
        const SizedBox(width: 50),
        FolderWidget(
          color: AppColors.darkGray,
          amount: Provider.of<AppProvider>(context, listen: true)
              .allLoadedButEmpty
              .length,
          text: 'Пустые фотографии',
          onPressed: () {},
        ),
      ],
    );
  }
}

class FolderWidget extends StatelessWidget {
  final Color color;
  final int amount;
  final String text;
  final Function onPressed;
  const FolderWidget({
    Key? key,
    required this.color,
    required this.amount,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            InkWell(
              onDoubleTap: () => onPressed(),
              child: SvgPicture.asset(
                'assets/icons/folder_icon.svg',
                color: color,
              ),
            ),
            Positioned(
              bottom: 15,
              left: 20,
              child: Text(
                '$amount',
                style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.darkGray,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
