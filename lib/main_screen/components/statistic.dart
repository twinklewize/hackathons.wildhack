import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wildhack/constants/colors.dart';
import 'package:wildhack/wigets/long_empty_button.dart';
import 'package:wildhack/wigets/long_filled_button.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Title(text: 'Статистика'),
          const StatisticsCardWithDiagram(
            mainText: 'Всего фото \nобработано',
            amount: 100,
            total: 560,
            color: AppColors.blue,
          ),
          const StatisticsCardWithDiagram(
            mainText: 'Фотографий \nживотных',
            amount: 30,
            total: 43,
            color: AppColors.lightOrange,
          ),
          const StatisticsCard(
            mainText: 'Видео \nзагружено',
            total: 43,
          ),
          const Status(color: AppColors.blue, text: 'Данные обрабатываются'),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 100),
            child: LongFilledButton(
              buttonColor: AppColors.blue,
              onPressed: () {},
              textValue: 'Продолжить',
              textColor: AppColors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 100),
            child: LongEmptyButton(
              color: AppColors.blue,
              onPressed: () {},
              textValue: 'Продолжить',
            ),
          ),
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
  final String mainText;
  final int amount;
  final int total;
  final Color color;

  // ignore: use_key_in_widget_constructors
  const StatisticsCardWithDiagram({
    required this.mainText,
    required this.amount,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double _value = (amount / total) * 100;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        height: 128,
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
            SizedBox(
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
            Row(
              children: [
                Text(
                  '$amount',
                  style: const TextStyle(
                    color: AppColors.lightGray,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '/$total',
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        height: 128,
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
