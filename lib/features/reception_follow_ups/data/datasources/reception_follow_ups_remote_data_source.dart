import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints/reception_endpoints.dart';
import '../../domain/entities/get_follow_ups_params.dart';
import '../models/follow_ups_page_model.dart';

abstract class ReceptionFollowUpsRemoteDataSource {
  Future<FollowUpsPageModel> getFollowUps(GetFollowUpsParams params);
}

class ReceptionFollowUpsRemoteDataSourceImpl
    implements ReceptionFollowUpsRemoteDataSource {
  final ApiClient apiClient;

  const ReceptionFollowUpsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<FollowUpsPageModel> getFollowUps(GetFollowUpsParams params) async {
    final response = await apiClient.dio.get(
      ReceptionEndpoints.followUps,
      queryParameters: params.toQueryMap(),
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return FollowUpsPageModel.fromJson(data);
  }
}
