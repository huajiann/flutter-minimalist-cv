import 'package:flutter/material.dart';
import 'package:jiann_cv/app/services/print_service.dart';
import 'package:jiann_cv/model/cv_model.dart';

class PrintButton extends StatefulWidget {
  const PrintButton({super.key, this.model});
  final CvModel? model;

  @override
  State<PrintButton> createState() => _PrintButtonState();
}

class _PrintButtonState extends State<PrintButton> {
  bool _loading = false;

  Future<void> _onPressed() async {
    setState(() => _loading = true);
    try {
      await printService.requestPrint(widget.model);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Print',
      icon: _loading
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.print),
      onPressed: _loading ? null : _onPressed,
    );
  }
}
