import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:jiann_cv/model/cv_model.dart';

class PdfGenerator {
  const PdfGenerator();

  static pw.Font? _regularFont;
  static pw.Font? _boldFont;
  static Uint8List? _profileImageBytes;

  Future<void> _loadAssetsIfNeeded() async {
    if (_regularFont != null && _boldFont != null && _profileImageBytes != null) return;

    final regularData = await rootBundle.load('assets/fonts/JetBrainsMono-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/JetBrainsMono-Bold.ttf');
    final imgData = await rootBundle.load('assets/images/IMG_1191_1.jpg');

    _regularFont = pw.Font.ttf(regularData);
    _boldFont = pw.Font.ttf(boldData);
    _profileImageBytes = imgData.buffer.asUint8List();
  }

  Future<Uint8List> generateCvPdf(CvModel model) async {
    await _loadAssetsIfNeeded();

    final doc = pw.Document();
    final name = model.name ?? '';
    final quote = model.quote;
    final location = model.location ?? '';
    final about = model.aboutMe ?? '';
    final profileImage = _profileImageBytes != null ? pw.MemoryImage(_profileImageBytes!) : null;

    final headerStyle = pw.TextStyle(font: _boldFont, fontSize: 20);
    final regularStyle = pw.TextStyle(font: _regularFont, fontSize: 10.5);
    final sectionTitleStyle = pw.TextStyle(font: _boldFont, fontSize: 14);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(name, style: headerStyle),
                      pw.SizedBox(height: 6),
                      if (quote != null) pw.Text(quote, style: regularStyle),
                      pw.SizedBox(height: 8),
                      if (location.isNotEmpty) pw.Text(location, style: regularStyle),
                      pw.SizedBox(height: 8),
                      if (model.contact != null && model.contact!.isNotEmpty)
                        pw.Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: model.contact!
                              .map((c) => pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: pw.BoxDecoration(
                                      borderRadius: pw.BorderRadius.circular(4),
                                      border: pw.Border.all(width: .5),
                                    ),
                                    child: pw.Text(
                                      '${c.name ?? ''}${c.url != null && c.url!.isNotEmpty ? ': ${c.url}' : ''}',
                                      style: regularStyle,
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                ),
                if (profileImage != null)
                  pw.Container(
                    margin: const pw.EdgeInsets.only(left: 12),
                    width: 110,
                    height: 110,
                    decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(10)),
                    child: pw.Image(profileImage, fit: pw.BoxFit.cover),
                  ),
              ],
            ),
          ),
          pw.SizedBox(height: 8),
          // About
          if (about.isNotEmpty)
            pw.Container(padding: const pw.EdgeInsets.only(bottom: 8), child: pw.Text(about, style: regularStyle)),

          // Work
          if (model.work != null && model.work!.isNotEmpty)
            pw.Column(children: [
              pw.SizedBox(height: 6),
              pw.Text('Work Experience', style: sectionTitleStyle),
              pw.SizedBox(height: 6),
              ...model.work!.map((w) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(children: [
                        pw.Expanded(
                            child: pw.Text(w.company ?? '', style: pw.TextStyle(font: _boldFont, fontSize: 12))),
                        pw.Text('${w.startDate ?? ''}${w.endDate != null ? ' - ${w.endDate}' : ''}',
                            style: regularStyle),
                      ]),
                      if (w.position != null) pw.Text(w.position!, style: regularStyle),
                      if (w.description != null) pw.Text(w.description!, style: regularStyle),
                      if (w.badges != null && w.badges!.isNotEmpty)
                        pw.Wrap(
                          spacing: 6,
                          children: w.badges!
                              .map((b) => pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: pw.BoxDecoration(
                                        borderRadius: pw.BorderRadius.circular(4), color: PdfColors.grey300),
                                    child: pw.Text(b, style: pw.TextStyle(font: _regularFont, fontSize: 9)),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                );
              }).toList()
            ]),

          // Education
          if (model.education != null && model.education!.isNotEmpty)
            pw.Column(children: [
              pw.SizedBox(height: 6),
              pw.Text('Education', style: sectionTitleStyle),
              pw.SizedBox(height: 6),
              ...model.education!.map((e) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Row(children: [
                      pw.Expanded(child: pw.Text(e.school ?? '', style: pw.TextStyle(font: _boldFont, fontSize: 12))),
                      pw.Text('${e.start ?? ''}${e.end != null ? ' - ${e.end}' : ''}', style: regularStyle),
                    ]),
                    if (e.degree != null) pw.Text(e.degree!, style: regularStyle),
                    if (e.description != null) pw.Text(e.description!, style: regularStyle),
                  ]),
                );
              }).toList()
            ]),

          // Projects
          if (model.projects != null && model.projects!.isNotEmpty)
            pw.Column(children: [
              pw.SizedBox(height: 6),
              pw.Text('Projects', style: sectionTitleStyle),
              pw.SizedBox(height: 6),
              ...model.projects!.map((p) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6),
                  child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                    pw.Text(p.title ?? '', style: pw.TextStyle(font: _boldFont, fontSize: 12)),
                    if (p.description != null) pw.Text(p.description!, style: regularStyle),
                    if (p.badges != null && p.badges!.isNotEmpty)
                      pw.Wrap(
                        spacing: 6,
                        children: p.badges!
                            .map((b) => pw.Container(
                                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  decoration: pw.BoxDecoration(
                                      borderRadius: pw.BorderRadius.circular(4), color: PdfColors.grey200),
                                  child: pw.Text(b, style: pw.TextStyle(font: _regularFont, fontSize: 9)),
                                ))
                            .toList(),
                      ),
                  ]),
                );
              }).toList()
            ]),

          // Skills
          if (model.skills != null && model.skills!.isNotEmpty)
            pw.Column(children: [
              pw.SizedBox(height: 6),
              pw.Text('Skills', style: sectionTitleStyle),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 6,
                runSpacing: 6,
                children: model.skills!
                    .map((s) => pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration:
                            pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(4), color: PdfColors.grey200),
                        child: pw.Text(s, style: regularStyle)))
                    .toList(),
              ),
            ]),
        ],
      ),
    );

    return doc.save();
  }
}
