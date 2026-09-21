import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/prescription_item_entity.dart';
import 'prescription_pdf_colors.dart';

abstract final class PrescriptionPdfDrugRow {
  static pw.Widget build(PrescriptionItemEntity item, int number) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PrescriptionPdfColors.border),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 16,
                height: 16,
                alignment: pw.Alignment.center,
                decoration: const pw.BoxDecoration(
                  color: PrescriptionPdfColors.emeraldLight,
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Text(
                  '$number',
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PrescriptionPdfColors.emerald,
                  ),
                ),
              ),
              pw.SizedBox(width: 6),
              pw.Expanded(
                child: pw.Text(
                  item.drugName,
                  style: const pw.TextStyle(
                    fontSize: 11,
                    color: PrescriptionPdfColors.textDark,
                  ),
                ),
              ),
              if (item.dosage.isNotEmpty)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: const pw.BoxDecoration(
                    color: PrescriptionPdfColors.emeraldLight,
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(3)),
                  ),
                  child: pw.Text(
                    item.dosage,
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PrescriptionPdfColors.emerald,
                    ),
                  ),
                ),
            ],
          ),
          pw.SizedBox(height: 3),
          pw.Row(
            children: [
              if (item.frequency.isNotEmpty)
                pw.Text(
                  'التكرار: ${item.frequency}   ',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PrescriptionPdfColors.textMuted,
                  ),
                ),
              if (item.duration.isNotEmpty)
                pw.Text(
                  'المدة: ${item.duration}   ',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PrescriptionPdfColors.textMuted,
                  ),
                ),
              if (item.route.isNotEmpty)
                pw.Text(
                  'طريقة الاستخدام: ${item.route}',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PrescriptionPdfColors.textMuted,
                  ),
                ),
            ],
          ),
          if (item.notes != null && item.notes!.trim().isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              'تعليمات: ${item.notes}',
              style: const pw.TextStyle(
                fontSize: 8.5,
                color: PrescriptionPdfColors.textDark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
