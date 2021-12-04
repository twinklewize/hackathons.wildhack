// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/main_screen/app_provider.dart';

class ChooseFilesPage extends StatelessWidget {
  ChooseFilesPage({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

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

  Widget actionButton(Function function, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              await function();
            },
            child: Text(text),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6 - 40,
          height: MediaQuery.of(context).size.height - 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // "Загруженные файлы" и заголовки таблицы
                  appProvider.chosenFiles.isNotEmpty
                      ?
                      //  'Загруженные файлы'
                      const Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            'Загруженные файлы',
                            style: TextStyle(
                              color: AppColors.darkGray,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : const SizedBox(),

                  // Список загруженных файлов
                  Builder(
                    builder: (BuildContext context) => appProvider.isLoading
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: CircularProgressIndicator(),
                          )
                        : appProvider.userAborted
                            ? const Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'User has aborted the dialog',
                                ),
                              )

                            // отображаем таблицу загруженных файлов
                            : appProvider.chosenFiles.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    child: Scrollbar(
                                      isAlwaysShown: true,
                                      controller: scrollController,
                                      child: ListView(
                                        controller: scrollController,
                                        children: [
                                          Table(
                                            columnWidths: const <int,
                                                TableColumnWidth>{
                                              0: FlexColumnWidth(),
                                              1: FlexColumnWidth(),
                                              2: FlexColumnWidth(),
                                            },
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            children: <TableRow>[
                                              // заголовки
                                              TableRow(
                                                decoration:
                                                    const BoxDecoration(),
                                                children: <Widget>[
                                                  tableCell('     Имя файла'),
                                                  tableCell(
                                                      '     Этап обработки'),
                                                  tableCell(
                                                      '     Размер файла в байтах'),
                                                ],
                                              ),

                                              //данные
                                              for (var path
                                                  in appProvider.chosenFiles)
                                                TableRow(
                                                  children: <Widget>[
                                                    tableCell(
                                                        "     " + path.name),
                                                    tableCell('     state'),
                                                    tableCell("     " +
                                                        path.size
                                                            .toStringAsFixed(
                                                                2) +
                                                        " bytes"),
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

                  // Кнопка загрузки файлов
                  appProvider.chosenFiles.isEmpty
                      ? actionButton(
                          Provider.of<AppProvider>(context, listen: false)
                              .pickFiles,
                          'Pick files',
                        )
                      : Row(
                          children: [
                            actionButton(
                              Provider.of<AppProvider>(context, listen: false)
                                  .pickFiles,
                              'Pick files',
                            ),
                            const SizedBox(width: 10),
                            actionButton(
                              Provider.of<AppProvider>(context, listen: false)
                                  .clearCachedFiles,
                              'Clear',
                            )
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
