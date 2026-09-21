import '../../../../core/network/api_client.dart';
import '../../domain/entities/visit_image_entity.dart';

class VisitImageModel extends VisitImageEntity {
  const VisitImageModel({
    required super.id,
    required super.url,
    required super.fullUrl,
    super.type,
    super.description,
    super.name,
    super.size,
  });

  factory VisitImageModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['type'] ?? 'other';
    final typeStr = rawType is Map ? rawType['value'] : rawType.toString();

    final url = json['url'] as String? ?? '';
    final rawFullUrl = json['full_url'] as String? ?? url;
    final resolvedFullUrl = _resolveFullUrl(rawFullUrl);

    int? parsedSize;
    if (json['size'] != null) {
      parsedSize = int.tryParse(json['size'].toString());
    }

    return VisitImageModel(
      id: json['id'] as int,
      url: url,
      fullUrl: resolvedFullUrl,
      type: typeStr,
      description: json['description'] as String?,
      name: json['name'] as String?,
      size: parsedSize,
    );
  }

  static String _resolveFullUrl(String input) {
    if (input.isEmpty) return '';

    try {
      final baseUrl = ApiClient.instance.dio.options.baseUrl;
      final baseUri = Uri.parse(baseUrl);
      final hostPart = baseUri.hasPort
          ? '${baseUri.scheme}://${baseUri.host}:${baseUri.port}'
          : '${baseUri.scheme}://${baseUri.host}';

      if (input.startsWith('https://') && !input.contains('/storage/')) {
        return input;
      }

      String path = input;
      if (path.contains('/storage/')) {
        path = path.substring(path.indexOf('/storage/') + 9);
      } else if (path.startsWith('storage/')) {
        path = path.substring(8);
      } else if (path.startsWith('/')) {
        path = path.substring(1);
      }

      return '$hostPart/storage/$path';
    } catch (_) {
      return input;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'full_url': fullUrl,
      'type': type,
      'description': description,
      'name': name,
      'size': size,
    };
  }
}
