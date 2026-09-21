import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/prescription_entity.dart';
import 'prescription_pdf_colors.dart';

abstract final class PrescriptionPdfElements {
  static pw.Widget buildHeader(String? doctorName, PrescriptionEntity rx) {
    final dateStr = rx.createdAt != null
        ? DateFormat('yyyy/MM/dd - hh:mm a').format(rx.createdAt!)
        : DateFormat('yyyy/MM/dd').format(DateTime.now());

    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PrescriptionPdfColors.emerald, width: 2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'CodraCare Medical ERP',
                style: const pw.TextStyle(
                  fontSize: 14,
                  color: PrescriptionPdfColors.emerald,
                ),
              ),
              pw.Text(
                'مركز كودرا كير الطبي',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PrescriptionPdfColors.textMuted,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                doctorName != null && doctorName.isNotEmpty
                    ? 'د. $doctorName'
                    : 'عيادة كودرا كير',
                style: const pw.TextStyle(
                  fontSize: 14,
                  color: PrescriptionPdfColors.textDark,
                ),
              ),
              pw.Text(
                'الروشتة: #${rx.prescriptionNumber}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PrescriptionPdfColors.textMuted,
                ),
              ),
              pw.Text(
                'التاريخ: $dateStr',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PrescriptionPdfColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget buildPatientCard(PrescriptionEntity rx) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: pw.BoxDecoration(
        color: PrescriptionPdfColors.bgLight,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: PrescriptionPdfColors.border),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'المريض: ${rx.patient.fullName}',
                style: const pw.TextStyle(fontSize: 11),
              ),
              if (rx.patient.phone != null && rx.patient.phone!.isNotEmpty)
                pw.Text(
                  'الهاتف: ${rx.patient.phone}',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PrescriptionPdfColors.textMuted,
                  ),
                ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'كود المريض: ${rx.patient.patientCode}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              if (rx.visitNumber != null)
                pw.Text(
                  'رقم الزيارة: ${rx.visitNumber}',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PrescriptionPdfColors.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget buildFooter(String? doctorName) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'مع أطيب التمنيات بالشفاء العاجل',
              style: const pw.TextStyle(
                fontSize: 8.5,
                color: PrescriptionPdfColors.emerald,
              ),
            ),
            pw.Text(
              'CodraCare Medical ERP - النظام الطبي الموحد',
              style: const pw.TextStyle(
                fontSize: 7.5,
                color: PrescriptionPdfColors.textMuted,
              ),
            ),
          ],
        ),
        pw.Column(
          children: [
            pw.Text(
              'توقيع الطبيب',
              style: const pw.TextStyle(
                fontSize: 9,
                color: PrescriptionPdfColors.textMuted,
              ),
            ),
            pw.SizedBox(height: 24),
            pw.Container(
              width: 100,
              height: 1,
              color: PrescriptionPdfColors.border,
            ),
          ],
        ),
      ],
    );
  }
}
