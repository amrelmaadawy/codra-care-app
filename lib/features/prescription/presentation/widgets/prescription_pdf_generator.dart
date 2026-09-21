import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/prescription_entity.dart';
import 'prescription_pdf_colors.dart';
import 'prescription_pdf_drug_row.dart';
import 'prescription_pdf_elements.dart';

abstract final class PrescriptionPdfGenerator {
  static Future<Uint8List> generate({
    required PrescriptionEntity prescription,
    String? doctorName,
  }) async {
    final pdf = pw.Document();

    final regularData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final ttfRegular = pw.Font.ttf(regularData);
    final ttfBold = pw.Font.ttf(boldData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        theme: pw.ThemeData.withFont(base: ttfRegular, bold: ttfBold),
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              PrescriptionPdfElements.buildHeader(doctorName, prescription),
              pw.SizedBox(height: 12),
              PrescriptionPdfElements.buildPatientCard(prescription),
              pw.SizedBox(height: 14),
              _buildRxBadge(),
              pw.SizedBox(height: 8),
              pw.Expanded(
                child: pw.ListView.separated(
                  itemCount: prescription.items.length,
                  separatorBuilder: (_, _) => pw.SizedBox(height: 6),
                  itemBuilder: (_, index) => PrescriptionPdfDrugRow.build(
                    prescription.items[index],
                    index + 1,
                  ),
                ),
              ),
              if (prescription.notes != null && prescription.notes!.trim().isNotEmpty) ...[
                pw.SizedBox(height: 8),
                _buildNotesBox(prescription.notes!),
              ],
              pw.SizedBox(height: 12),
              PrescriptionPdfElements.buildFooter(doctorName),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildRxBadge() {
    return pw.Row(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: const pw.BoxDecoration(
            color: PrescriptionPdfColors.emerald,
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Text(
            'Rx  الأدوية الموصوفة',
            style: const pw.TextStyle(
              color: PdfColors.white,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildNotesBox(String notes) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: const pw.BoxDecoration(
        color: PrescriptionPdfColors.bgLight,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Text(
        'ملاحظات إضافية: $notes',
        style: const pw.TextStyle(
          fontSize: 9,
          color: PrescriptionPdfColors.textDark,
        ),
      ),
    );
  }
}
