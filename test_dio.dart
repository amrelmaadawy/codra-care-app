import 'dart:convert';
import 'package:dio/dio.dart';

String? _utf8Decoder(
  List<int> responseBytes,
  RequestOptions options,
  ResponseBody responseBody,
) {
  return utf8.decode(responseBytes, allowMalformed: false);
}

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api/mobile',
      responseDecoder: _utf8Decoder,
      headers: {
        'Authorization': 'Bearer 15|KU27oxrlMzezL0p4WoR9VLFGyYn57kdQpNpDkEsJ1009b973',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Tenant-Code': 'CLN_DEMO01',
      },
    ),
  );

  try {
    final response = await dio.get('/doctor/prescriptions?page=1');
    print('With _utf8Decoder: Success! Data type: ${response.data.runtimeType}');
  } catch (e, stack) {
    print('With _utf8Decoder Error: $e');
  }
}
