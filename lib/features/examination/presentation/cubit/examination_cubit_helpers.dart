import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/examination_entity.dart';

String mapFailure(Failure failure) => FailureMapper.mapFailureToMessage(failure);

ExaminationEntity applySectionData(
  ExaminationEntity v,
  String sec,
  Map<String, dynamic> d,
) {
  if (sec == 'followup') {
    final raw = d['followup_days'];
    final days = raw != null ? int.tryParse(raw.toString()) : null;
    return v.copyWith(
      followupDays: days,
      followupNotes: d['followup_notes'] as String?,
    );
  }
  if (sec == 'examination_notes' || sec == 'examination') {
    return v.copyWith(
      chiefComplaint: d['chief_complaint'] as String?,
      diagnosis: d['diagnosis'] as String?,
      notes: d['notes'] as String?,
    );
  }
  return v;
}
