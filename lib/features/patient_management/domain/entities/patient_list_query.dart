import 'package:equatable/equatable.dart';

class PatientListQuery extends Equatable {
  final String? search;
  final int page;

  const PatientListQuery({this.search, this.page = 1});

  PatientListQuery copyWith({
    String? search,
    int? page,
    bool clearSearch = false,
  }) {
    return PatientListQuery(
      search: clearSearch ? null : (search ?? this.search),
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [search, page];
}
