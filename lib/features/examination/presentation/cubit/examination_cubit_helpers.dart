import '../../../../core/error/failures.dart';
import '../../domain/entities/examination_entity.dart';

String mapFailure(Failure failure) {
  if (failure is ValidationFailure || failure is ServerFailure) return failure.message;
  if (failure is NetworkFailure) return 'errors.no_internet';
  if (failure is UnauthorizedFailure) return 'errors.unauthorized';
  if (failure is NotFoundFailure) return 'errors.not_found';
  return 'errors.unexpected';
}

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
