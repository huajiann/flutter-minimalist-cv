import 'package:jiann_cv/model/cv_model.dart';
import 'print_service_stub.dart' if (dart.library.html) 'print_service_web.dart' as impl;

abstract class PrintService {
  Future<void> initialize([CvModel? model]);
  Future<void> requestPrint([CvModel? model]);
  Future<void> dispose();
}

PrintService get printService => impl.printService;
