import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jiann_cv/model/cv_model.dart';

class HomeViewModel extends ChangeNotifier {
  CvModel? model;

  Future<void> loadData() async {
    final response = await rootBundle.loadString(kDebugMode ? '/data/data.json' : '/assets/data/data.json');
    if (jsonDecode(response) is Map<String, dynamic>) {
      model = CvModel.fromJson(jsonDecode(response));
    }
    notifyListeners();
  }
}
