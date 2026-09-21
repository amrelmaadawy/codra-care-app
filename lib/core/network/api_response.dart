import 'package:equatable/equatable.dart';

class ApiResponse<T> extends Equatable {
  final bool success;
  final T? data;
  final String message;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.success,
    this.data,
    required this.message,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic rawData) fromData,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true,
      data: json['data'] != null ? fromData(json['data']) : null,
      message: (json['message'] as String?) ?? '',
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  @override
  List<Object?> get props => [success, data, message, errors];
}
