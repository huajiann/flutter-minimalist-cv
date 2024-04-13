import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:see_vee/model/cv_model.dart';

class HomeViewModel extends ChangeNotifier {
  CvModel? model;

  Future<void> loadData() async {
    final response = await rootBundle.loadString('/data.json');
    if (jsonDecode(response) is Map<String, dynamic>) {
      model = CvModel.fromJson(jsonDecode(response));
    }
    notifyListeners();
  }
}
