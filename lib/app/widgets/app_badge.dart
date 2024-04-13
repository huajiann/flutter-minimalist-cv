import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.title,
    this.backgroundColor = const Color.fromRGBO(240, 240, 240, 1),
  });

  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(title),
        ),
      ),
    );
  }
}
