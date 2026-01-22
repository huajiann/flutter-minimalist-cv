import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:jiann_cv/app/services/pdf_cache.dart';
import 'package:jiann_cv/model/cv_model.dart';
import 'print_service.dart';

class PrintServiceStub implements PrintService {
  PrintServiceStub();

  @override
  Future<void> dispose() async {}

  @override
  Future<void> initialize([CvModel? model]) async {
    if (model != null) {
      await PdfCache.instance.ensureCached(model);
    }
  }

  @override
  Future<void> requestPrint([CvModel? model]) async {
    try {
      Uint8List? bytes;
      if (model != null) {
        bytes = await PdfCache.instance.getPdfForModel(model);
      }
      if (bytes == null) {
        // If no model provided or cache miss, ask printing package to layout using its own builder.
        await Printing.layoutPdf(onLayout: (format) async => Uint8List(0));
      } else {
        await Printing.sharePdf(bytes: bytes, filename: '${model?.name ?? 'cv'}.pdf');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('PrintServiceStub.requestPrint error: $e');
    }
  }
}

final PrintService printService = PrintServiceStub();
