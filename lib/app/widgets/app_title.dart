import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
    required this.title,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 20,
  });

  final String title;
  final FontWeight fontWeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: true,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}
