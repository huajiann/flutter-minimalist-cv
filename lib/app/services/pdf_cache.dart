import 'dart:typed_data';

import 'package:jiann_cv/model/cv_model.dart';
import 'package:jiann_cv/app/services/pdf_generator.dart';

class PdfCache {
  PdfCache._privateConstructor();
  static final PdfCache instance = PdfCache._privateConstructor();

  final Map<String, Uint8List> _cache = {};
  final PdfGenerator _generator = const PdfGenerator();

  String _keyForModel(CvModel model) {
    // Use name + updated time if available; fallback to name only.
    return model.name ?? 'cv_default';
  }

  Future<void> ensureCached(CvModel model) async {
    final key = _keyForModel(model);
    if (_cache.containsKey(key)) return;
    final bytes = await _generator.generateCvPdf(model);
    _cache[key] = bytes;
  }

  Future<Uint8List?> getPdfForModel(CvModel model) async {
    final key = _keyForModel(model);
    if (_cache.containsKey(key)) return _cache[key];
    await ensureCached(model);
    return _cache[key];
  }

  void clearCache() => _cache.clear();
}
