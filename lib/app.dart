import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:see_vee/app/assets/theme.dart';
import 'package:see_vee/app/view/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      theme: AppTheme.defaultTheme,
      home: const HomePage(),
    );
  }
}
