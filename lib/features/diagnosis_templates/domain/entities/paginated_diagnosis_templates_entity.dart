import 'package:equatable/equatable.dart';
import 'diagnosis_template_entity.dart';

class PaginatedDiagnosisTemplatesEntity extends Equatable {
  final List<DiagnosisTemplateEntity> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const PaginatedDiagnosisTemplatesEntity({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [items, currentPage, lastPage, total];
}
