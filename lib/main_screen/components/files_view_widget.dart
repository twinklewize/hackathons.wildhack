import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildhack/main_screen/app_provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'dart:io' as io;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/models/file.dart';

enum View {
  grid,
  list,
  folders,
}

// ignore: must_be_immutable
class FilesViewWidget extends StatefulWidget {
  List<File> files;
  String title;
  final bool dragNDropOn;
  final bool withFolders;
  FilesViewWidget({
    Key? key,
    required this.title,
    required this.files,
    this.dragNDropOn = true,
    this.withFolders = false,
  }) : super(key: key);

  @override
  _FilesViewWidgetState createState() => _FilesViewWidgetState();
}

class _FilesViewWidgetState extends State<FilesViewWidget> {
  bool _isInit = true;
  late View view;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      widget.withFolders ? view = View.folders : view = View.list;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
                      (view != View.folders && widget.withFolders == true)
                          ? Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      view = View.folders;
                                    });
                                  },
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: SvgPicture.asset(
                                      'assets/icons/back_arrow_icon.svg',
                                      color: AppColors.darkGray,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            )
                          : Container(),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
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
                            : (view == View.list
                                ? SvgPicture.asset('assets/icons/grid_icon.svg')
                                : Container()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                view == View.list
                    ? CustomListView(files: widget.files)
                    : (view == View.grid
                        ? CustomGridView(files: widget.files)
                        : Row(
                            children: [
                              FolderWidget(
                                color: AppColors.lightOrange,
                                amount: Provider.of<AppProvider>(context,
                                        listen: true)
                                    .filesWithAnimal
                                    .length,
                                text: 'Животные',
                                onPressed: () {
                                  setState(() {
                                    widget.title = 'Животные';
                                    view = View.grid;
                                    widget.files = Provider.of<AppProvider>(
                                            context,
                                            listen: false)
                                        .filesWithAnimal;
                                  });
                                },
                              ),
                              const SizedBox(width: 50),
                              FolderWidget(
                                color: AppColors.darkGray,
                                amount: Provider.of<AppProvider>(context,
                                        listen: true)
                                    .allLoadedButEmpty
                                    .length,
                                text: 'Пустые фотографии',
                                onPressed: () {
                                  setState(() {
                                    widget.title = 'Пустые фотографии';
                                    view = View.grid;
                                    widget.files = Provider.of<AppProvider>(
                                            context,
                                            listen: false)
                                        .allLoadedButEmpty;
                                  });
                                },
                              ),
                            ],
                          )),
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
                    height: MediaQuery.of(context).size.height * 0.23,
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
                                file.status == Status.waiting
                                    ? TableRow(
                                        children: <Widget>[
                                          tableCell("     " + file.name,
                                              color: AppColors.darkGray),
                                          tableCell('     ' + 'Ожидание',
                                              color: AppColors.darkGray),
                                          tableCell(
                                              "     " +
                                                  ((file.sizeInBytes / 1024) /
                                                          1024)
                                                      .toStringAsFixed(1) +
                                                  " МБ",
                                              color: AppColors.darkGray),
                                        ],
                                      )
                                    : (file.status == Status.loading
                                        ? TableRow(
                                            children: <Widget>[
                                              tableCell("     " + file.name,
                                                  color: AppColors.blue),
                                              tableCell('     ' + 'Обработка',
                                                  color: AppColors.blue),
                                              tableCell(
                                                  "     " +
                                                      ((file.sizeInBytes /
                                                                  1024) /
                                                              1024)
                                                          .toStringAsFixed(1) +
                                                      " МБ",
                                                  color: AppColors.blue),
                                            ],
                                          )
                                        : TableRow(
                                            children: <Widget>[
                                              tableCell("     " + file.name,
                                                  color: AppColors.orange),
                                              tableCell('     ' + 'Обработано',
                                                  color: AppColors.orange),
                                              tableCell(
                                                  "     " +
                                                      ((file.sizeInBytes /
                                                                  1024) /
                                                              1024)
                                                          .toStringAsFixed(1) +
                                                      " МБ",
                                                  color: AppColors.orange),
                                            ],
                                          )),
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

  Widget tableCell(String text, {Color color = AppColors.lightGray}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
        const Divider(),
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
              onTap: () {
                onPressed();
              },
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
