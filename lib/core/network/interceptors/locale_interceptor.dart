import 'package:dio/dio.dart';

class LocaleInterceptor extends Interceptor {
  static String currentLocale = 'ar';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept-Language'] = currentLocale;
    super.onRequest(options, handler);
  }
}
