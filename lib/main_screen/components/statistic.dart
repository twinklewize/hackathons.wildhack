import 'dart:io' as io;
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/main_screen/app_provider.dart';
import 'package:wildhack/wigets/long_empty_button.dart';
import 'package:wildhack/wigets/long_filled_button.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: true);
    return Container(
      color: AppColors.white,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Title(text: 'Статистика'),
          appProvider.appState == AppState.waiting
              ? StatisticsCard(
                  mainText: 'Файлов \nзагружено',
                  total: Provider.of<AppProvider>(context, listen: true)
                      .filesWithoutAnimal
                      .length,
                )
              : const SizedBox(),
          appProvider.appState == AppState.loading ||
                  appProvider.appState == AppState.loaded
              ?
              // 1st statistic card
              Column(
                  children: [
                    StatisticsCardWithDiagram(
                      amount: appProvider.allLoadedFiles.length,
                      total: appProvider.filesWithAnimal.length +
                          appProvider.filesWithoutAnimal.length,
                      color: AppColors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'Всего фото \nобработано',
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${appProvider.allLoadedFiles.length}',
                                style: const TextStyle(
                                  color: AppColors.lightGray,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '/${appProvider.filesWithAnimal.length + appProvider.filesWithoutAnimal.length}',
                                style: const TextStyle(
                                  color: AppColors.lightGray,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          appProvider.appState == AppState.loading ||
                  appProvider.appState == AppState.loaded
              // 2nd statistic card
              ? Column(
                  children: [
                    StatisticsCardWithDiagram(
                      amount: appProvider.filesWithAnimal.length,
                      total: appProvider.filesWithAnimal.length +
                          appProvider.filesWithoutAnimal.length,
                      color: AppColors.lightOrange,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'Фотографий \nживотных',
                              style: TextStyle(
                                color: AppColors.darkGray,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${appProvider.filesWithAnimal.length}',
                                style: const TextStyle(
                                  color: AppColors.lightGray,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '/${appProvider.filesWithAnimal.length + appProvider.filesWithoutAnimal.length}',
                                style: const TextStyle(
                                  color: AppColors.lightGray,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          appProvider.appState == AppState.loading
              ? const Center(
                  child: Status(
                      color: AppColors.blue, text: 'Данные обрабатываются'),
                )
              : const SizedBox(),
          appProvider.appState == AppState.loaded
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Status(
                        color: Colors.green, text: 'Данные успешно обработаны'),
                  ),
                )
              : const SizedBox(),
          const Spacer(),
          appProvider.appState == AppState.waiting ||
                  appProvider.appState == AppState.loading ||
                  appProvider.appState == AppState.loaded
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: LongEmptyButton(
                    color: AppColors.darkGray,
                    onPressed: () async {
                      await Provider.of<AppProvider>(context, listen: false)
                          .clearCachedFiles();
                    },
                    textValue: 'Очистить',
                  ),
                )
              : const SizedBox(),
          appProvider.appState == AppState.waiting
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: LongFilledButton(
                    buttonColor: AppColors.blue,
                    onPressed: () {
                      appProvider.sendFilePathsToBackend();
                    },
                    textValue: 'Начать обработку',
                    textColor: AppColors.white,
                  ),
                )
              : const SizedBox(),
          appProvider.appState == AppState.loading
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: LongFilledButton(
                    buttonColor: AppColors.lightBlue,
                    onPressed: () {
                      appProvider.sendFilePathsToBackend();
                    },
                    textValue: 'Продолжить',
                    textColor: AppColors.darkGray,
                  ),
                )
              : const SizedBox(),
          // TO DO LOADED
          appProvider.appState == AppState.loaded
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
                  child: LongFilledButton(
                    buttonColor: AppColors.blue,
                    onPressed: () {
                      var encoder = ZipFileEncoder();
                      encoder.zipDirectory(io.Directory('animals'),
                          filename: 'animals.zip');

                      // Manually create a zip of a directory and individual files.
                      // encoder.addDirectory(io.Directory('animals'));
                      encoder.addFile(
                          io.File(appProvider.filesWithoutAnimal[0].path));
                      encoder.close();
                    },
                    textValue: 'Экспорт',
                    textColor: AppColors.white,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class Status extends StatelessWidget {
  final Color color;
  final String text;
  const Status({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: color,
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  final String text;
  const Title({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.darkGray,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class StatisticsCardWithDiagram extends StatelessWidget {
  final int amount;
  final int total;
  final Color color;

  // ignore: use_key_in_widget_constructors
  const StatisticsCardWithDiagram({
    required this.amount,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double _value = (amount / total) * 100;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: 128,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Positioned(
                right: 60,
                left: 60,
                top: 10,
                bottom: 10,
                child: SizedBox(
                  height: 88,
                  width: 88,
                  child: SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        showLabels: false,
                        showTicks: false,
                        startAngle: 180,
                        endAngle: 180,
                        radiusFactor: 1,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.12,
                          color: AppColors.white,
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: _value,
                            width: 0.12,
                            sizeUnit: GaugeSizeUnit.factor,
                            enableAnimation: true,
                            animationDuration: 20,
                            animationType: AnimationType.linear,
                            color: color,
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            positionFactor: 0.02,
                            widget: Text(
                              _value.toStringAsFixed(0),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w400,
                                fontSize: 32,
                              ),
                            ),
                          )
                        ])
                  ]),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class StatisticsCard extends StatelessWidget {
  final String mainText;
  final int total;

  // ignore: use_key_in_widget_constructors
  const StatisticsCard({
    required this.mainText,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 104,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                mainText,
                style: const TextStyle(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              '$total',
              style: const TextStyle(
                color: AppColors.lightGray,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
