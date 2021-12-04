import 'package:flutter/material.dart';

class LongEmptyButton extends StatelessWidget {
  final String textValue;
  final Function() onPressed;
  final Color color;

  // ignore: use_key_in_widget_constructors
  const LongEmptyButton({
    required this.color,
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
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onPressed(),
            borderRadius: BorderRadius.circular(8),
            child: Center(
              child: Text(
                textValue,
                style: TextStyle(
                  color: color,
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
