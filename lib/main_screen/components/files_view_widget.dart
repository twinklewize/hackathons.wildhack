import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildhack/main_screen/app_provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'dart:io' as io;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/models/file.dart';

enum View { grid, list }

// ignore: must_be_immutable
class FilesViewWidget extends StatefulWidget {
  List<File> files;
  final String title;
  final bool dragNDropOn;
  FilesViewWidget({
    Key? key,
    required this.title,
    required this.files,
    this.dragNDropOn = true,
  }) : super(key: key);

  @override
  _FilesViewWidgetState createState() => _FilesViewWidgetState();
}

class _FilesViewWidgetState extends State<FilesViewWidget> {
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
                view == View.list
                    ? CustomListView(files: widget.files)
                    : CustomGridView(files: widget.files)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomGridView extends StatelessWidget {
  CustomGridView({
    Key? key,
    required this.files,
  }) : super(key: key);

  final List<File> files;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 20,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 20),
          itemCount: files.length,
          itemBuilder: (BuildContext ctx, index) {
            return GestureDetector(
              onTap: () {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    height: 120,
                    width: 160,
                    decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Image.file(io.File(files[index].path)),
                        Flexible(
                          child: Text(
                            files[index].name,
                            style: const TextStyle(
                              color: AppColors.darkGray,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            );
          }),
    );
  }
}

class CustomListView extends StatelessWidget {
  const CustomListView({
    Key? key,
    required this.files,
  }) : super(key: key);

  final List<File> files;

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Expanded(
        child: SingleChildScrollView(
          child: Builder(
            builder: (BuildContext context) => files.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.30,
                    child: Scrollbar(
                      isAlwaysShown: true,
                      controller: scrollController,
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FlexColumnWidth(),
                              1: FlexColumnWidth(),
                              2: FlexColumnWidth(),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              // заголовки
                              TableRow(
                                decoration: const BoxDecoration(),
                                children: <Widget>[
                                  tableCell('     Имя файла'),
                                  tableCell('     Этап обработки'),
                                  tableCell('     Размер файла'),
                                ],
                              ),

                              //данные
                              for (var file in files)
                                TableRow(
                                  children: <Widget>[
                                    tableCell("     " + file.name),
                                    tableCell('     ' + file.status.toString()),
                                    tableCell("     " +
                                        ((file.sizeInBytes / 1024) / 1024)
                                            .toStringAsFixed(1) +
                                        " МБ"),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget tableCell(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
        const Divider(),
      ],
    );
  }
}
