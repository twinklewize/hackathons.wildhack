import 'package:flutter/material.dart';

import '../constants/colors.dart';

class LongFilledButton extends StatelessWidget {
  final String textValue;
  final Function onPressed;
  final Color textColor;
  final Color buttonColor;

  // ignore: use_key_in_widget_constructors
  const LongFilledButton({
    required this.buttonColor,
    required this.textColor,
    required this.textValue,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await onPressed();
            },
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Text(
                textValue,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
