// import 'dart:io' as io;

// import 'package:desktop_drop/desktop_drop.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:provider/provider.dart';
// import 'package:wildhack/constants/colors.dart';
// import 'package:wildhack/main_screen/app_provider.dart';
// import 'package:wildhack/models/file.dart';

// class ChooseFilesPage extends StatelessWidget {
//   ChooseFilesPage({Key? key}) : super(key: key);

//   final ScrollController scrollController = ScrollController();

//   Widget tableCell(String text) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           text,
//           maxLines: 1,
//           overflow: TextOverflow.clip,
//         ),
//         const Divider(),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Set<Uri> files = {};
//     var appProvider = Provider.of<AppProvider>(context);
//     return Scaffold(
//       body: Center(
//         child: DropTarget(
//           onDragDone: (details) async {
//             files.addAll(details.urls);
//             await Provider.of<AppProvider>(context, listen: false)
//                 .pickFilesWithDragNDrop(
//               files
//                   .map(
//                     (uri) => File(
//                       path: uri.path,
//                       name: basename(uri.toFilePath()),
//                       sizeInBytes:
//                           io.File(uri.toFilePath()).statSync().size.toDouble(),
//                     ),
//                   )
//                   .toList(),
//             );
//           },
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.6 - 40,
//             height: MediaQuery.of(context).size.height - 60,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     // "Загруженные файлы" и заголовки таблицы
//                     appProvider.chosenFiles.isNotEmpty
//                         ?
//                         //  'Загруженные файлы'
//                         const Padding(
//                             padding: EdgeInsets.all(40),
//                             child: Text(
//                               'Загруженные файлы',
//                               style: TextStyle(
//                                 color: AppColors.darkGray,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           )
//                         : const SizedBox(),

//                     // Список загруженных файлов
//                     Builder(
//                       builder: (BuildContext context) => appProvider.isLoading
//                           ? const Padding(
//                               padding: EdgeInsets.only(bottom: 10.0),
//                               child: CircularProgressIndicator(),
//                             )
//                           : appProvider.userAborted
//                               ? const Padding(
//                                   padding: EdgeInsets.only(bottom: 10.0),
//                                   child: Text(
//                                     'User has aborted the dialog',
//                                   ),
//                                 )

//                               // отображаем таблицу загруженных файлов
//                               : appProvider.chosenFiles.isNotEmpty
//                                   ? Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 30),
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.50,
//                                       child: Scrollbar(
//                                         isAlwaysShown: true,
//                                         controller: scrollController,
//                                         child: ListView(
//                                           controller: scrollController,
//                                           children: [
//                                             Table(
//                                               columnWidths: const <int,
//                                                   TableColumnWidth>{
//                                                 0: FlexColumnWidth(),
//                                                 1: FlexColumnWidth(),
//                                                 2: FlexColumnWidth(),
//                                               },
//                                               defaultVerticalAlignment:
//                                                   TableCellVerticalAlignment
//                                                       .middle,
//                                               children: <TableRow>[
//                                                 // заголовки
//                                                 TableRow(
//                                                   decoration:
//                                                       const BoxDecoration(),
//                                                   children: <Widget>[
//                                                     tableCell('     Имя файла'),
//                                                     tableCell(
//                                                         '     Этап обработки'),
//                                                     tableCell(
//                                                         '     Размер файла в МБ'),
//                                                   ],
//                                                 ),

//                                                 //данные
//                                                 for (var file
//                                                     in appProvider.chosenFiles)
//                                                   TableRow(
//                                                     children: <Widget>[
//                                                       tableCell(
//                                                           "     " + file.name),
//                                                       tableCell('     ' +
//                                                           file.status
//                                                               .toString()),
//                                                       tableCell("     " +
//                                                           ((file.sizeInBytes /
//                                                                       1024) /
//                                                                   1024)
//                                                               .toStringAsFixed(
//                                                                   1) +
//                                                           " МБ"),
//                                                     ],
//                                                   ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                   : const SizedBox(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
