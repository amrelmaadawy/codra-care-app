import 'package:uuid/uuid.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints/reception_endpoints.dart';
import '../models/financial_snapshot_model.dart';
import '../models/payment_action_result_model.dart';
import '../models/service_option_model.dart';

abstract class ReceptionPaymentsRemoteDataSource {
  Future<FinancialSnapshotModel> getFinancialSnapshot(int appointmentId);

  Future<PaymentActionResultModel> addPayments({
    required int appointmentId,
    required int expectedFinancialVersion,
    required List<Map<String, dynamic>> payments,
    String? clientRequestId,
  });

  Future<PaymentActionResultModel> addRefund({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    String? reason,
    int? specificPaymentTransactionId,
    String? clientRequestId,
  });

  Future<PaymentActionResultModel> addDiscount({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    required String reason,
    String? clientRequestId,
  });

  Future<PaymentActionResultModel> addService({
    required int appointmentId,
    required int expectedFinancialVersion,
    required int serviceId,
    int? quantity,
    String? clientRequestId,
  });

  Future<List<ServiceOptionModel>> getServiceOptions(
    int appointmentId, {
    String? search,
    int? page,
  });

  Future<Map<String, dynamic>> getVoucherPreview(
    int appointmentId,
    int voucherId,
  );
}

class ReceptionPaymentsRemoteDataSourceImpl
    implements ReceptionPaymentsRemoteDataSource {
  final ApiClient _apiClient;
  static const _uuid = Uuid();

  const ReceptionPaymentsRemoteDataSourceImpl(this._apiClient);

  String _resolveRequestId(String? clientRequestId) =>
      clientRequestId ?? _uuid.v4();

  @override
  Future<FinancialSnapshotModel> getFinancialSnapshot(int appointmentId) async {
    final response = await _apiClient.dio.get(
      ReceptionEndpoints.appointmentTransactions(appointmentId),
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return FinancialSnapshotModel.fromJson(data);
  }

  @override
  Future<PaymentActionResultModel> addPayments({
    required int appointmentId,
    required int expectedFinancialVersion,
    required List<Map<String, dynamic>> payments,
    String? clientRequestId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.appointmentPayments(appointmentId),
      data: {
        'client_request_id': _resolveRequestId(clientRequestId),
        'expected_financial_version': expectedFinancialVersion,
        'payments': payments,
      },
    );
    return PaymentActionResultModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<PaymentActionResultModel> addRefund({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    String? reason,
    int? specificPaymentTransactionId,
    String? clientRequestId,
  }) async {
    final payload = <String, dynamic>{
      'client_request_id': _resolveRequestId(clientRequestId),
      'expected_financial_version': expectedFinancialVersion,
      'amount': amount,
      if (reason != null && reason.isNotEmpty) 'reason': reason,
      'payment_transaction_id': ?specificPaymentTransactionId,
    };
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.appointmentRefunds(appointmentId),
      data: payload,
    );
    return PaymentActionResultModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<PaymentActionResultModel> addDiscount({
    required int appointmentId,
    required int expectedFinancialVersion,
    required String amount,
    required String reason,
    String? clientRequestId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.appointmentDiscounts(appointmentId),
      data: {
        'client_request_id': _resolveRequestId(clientRequestId),
        'expected_financial_version': expectedFinancialVersion,
        'amount': amount,
        'reason': reason,
      },
    );
    return PaymentActionResultModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<PaymentActionResultModel> addService({
    required int appointmentId,
    required int expectedFinancialVersion,
    required int serviceId,
    int? quantity,
    String? clientRequestId,
  }) async {
    final response = await _apiClient.dio.post(
      ReceptionEndpoints.appointmentServices(appointmentId),
      data: {
        'client_request_id': _resolveRequestId(clientRequestId),
        'expected_financial_version': expectedFinancialVersion,
        'service_id': serviceId,
        'quantity': quantity ?? 1,
      },
    );
    return PaymentActionResultModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<ServiceOptionModel>> getServiceOptions(
    int appointmentId, {
    String? search,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{
      if (search != null && search.isNotEmpty) 'search': search,
      'page': ?page,
    };
    final response = await _apiClient.dio.get(
      ReceptionEndpoints.appointmentServiceOptions(appointmentId),
      queryParameters: queryParams,
    );
    final list = (response.data['data'] as List<dynamic>?) ?? [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(ServiceOptionModel.fromJson)
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getVoucherPreview(
    int appointmentId,
    int voucherId,
  ) async {
    final response = await _apiClient.dio.get(
      ReceptionEndpoints.appointmentVoucherPreview(appointmentId, voucherId),
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
