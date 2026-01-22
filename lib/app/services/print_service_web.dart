import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:jiann_cv/app/services/pdf_cache.dart';
import 'package:jiann_cv/model/cv_model.dart';
import 'print_service.dart';

class PrintServiceWeb implements PrintService {
  PrintServiceWeb();

  String? _objectUrl;
  html.IFrameElement? _iframe;

  late StreamSubscription<html.Event> _beforePrintSub;
  late StreamSubscription<html.Event> _afterPrintSub;
  late html.EventListener _keyDownListener;

  bool _initialized = false;

  @override
  Future<void> initialize([CvModel? model]) async {
    if (_initialized) return;
    _initialized = true;

    // Pre-cache if model provided
    if (model != null) await PdfCache.instance.ensureCached(model);

    // beforeprint / afterprint
    _beforePrintSub = html.window.on['beforeprint'].listen((e) {
      // no-op here; requestPrint will ensure iframe if needed
    });
    _afterPrintSub = html.window.on['afterprint'].listen((e) {
      _cleanup();
    });

    // keydown handler for Ctrl/Cmd+P
    _keyDownListener = (html.Event event) {
      final ke = event as html.KeyboardEvent;
      final key = (ke.key ?? '').toLowerCase();
      if ((ke.ctrlKey || ke.metaKey) && key == 'p') {
        ke.preventDefault();
        requestPrint();
      }
    };
    html.document.addEventListener('keydown', _keyDownListener);
  }

  @override
  Future<void> dispose() async {
    try {
      _beforePrintSub.cancel();
    } catch (_) {}
    try {
      _afterPrintSub.cancel();
    } catch (_) {}
    try {
      html.document.removeEventListener('keydown', _keyDownListener);
    } catch (_) {}
    _cleanup();
  }

  void _cleanup() {
    try {
      _iframe?.remove();
    } catch (_) {}
    if (_objectUrl != null) {
      try {
        html.Url.revokeObjectUrl(_objectUrl!);
      } catch (_) {}
      _objectUrl = null;
    }
    _iframe = null;
  }

  @override
  Future<void> requestPrint([CvModel? model]) async {
    try {
      Uint8List? bytes;
      if (model != null) {
        bytes = await PdfCache.instance.getPdfForModel(model);
      } else {
        // try to take any cached pdf
        // (select first entry)
      }

      if (bytes == null) {
        // No PDF available; fall back to window.print()
        html.window.print();
        return;
      }

      final blob = html.Blob([bytes], 'application/pdf');
      _objectUrl = html.Url.createObjectUrlFromBlob(blob);

      _iframe = html.IFrameElement()
        ..style.position = 'fixed'
        ..style.top = '0'
        ..style.left = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        ..style.zIndex = '999999'
        ..src = _objectUrl!;

      _iframe!
        ..onLoad.listen((event) {
          try {
            // try printing the iframe content; use dynamic to call print on Window
            (_iframe!.contentWindow as dynamic)?.print();
          } catch (_) {
            // fallback: open in new tab
            html.window.open(_objectUrl!, '_blank');
          }
        });

      html.document.body?.append(_iframe!);

      // If browser fires afterprint, cleanup will run; otherwise schedule a safety cleanup
      Future.delayed(const Duration(seconds: 10), () {
        _cleanup();
      });
    } catch (e) {
      // On error, fallback to printing page
      try {
        html.window.print();
      } catch (_) {}
    }
  }
}

final PrintService printService = PrintServiceWeb();
