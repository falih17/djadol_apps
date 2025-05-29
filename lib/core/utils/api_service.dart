import '../widgets/zui.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'store.dart';

class ApiService {
  static ApiService? _instance;

  ApiService._();

  factory ApiService() => _instance ??= ApiService._();

  late Dio _dio;
  // Configuration function
  void configureDio({
    // String baseUrl,
    Map<String, dynamic>? defaultHeaders,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    void Function(RequestOptions options, RequestInterceptorHandler handler)?
        onRequest,
    void Function(Response response, ResponseInterceptorHandler handler)?
        onResponse,
    void Function(DioException e, ErrorInterceptorHandler handler)? onError,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: Constants.url,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      headers: defaultHeaders ??
          {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
    ));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: onRequest ??
            (options, handler) {
              debugPrint('Request: ${options.method} ${options.path}');
              debugPrint('Headers: ${options.headers}');
              debugPrint('Query Params: ${options.queryParameters}');
              handler.next(options);
            },
        onResponse: onResponse ??
            (response, handler) {
              // debugPrint('Response: ${response.statusCode} ${response.data}');
              handler.next(response);
            },
        onError: onError ??
            (DioException e, handler) async {
              if (e.response?.statusCode == 401) {
                // If a 401 response is received, refresh the access token
                await refreshToken();
                return handler.resolve(await _dio.fetch(e.requestOptions));
              }
              debugPrint('Error: ${e.message}');
              debugPrint('Response: ${e.response}');
              handler.next(e);
            },
      ),
    );
    if (!kReleaseMode) {
      // _dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }
  }

  void setToken(String token) {
    _dio.options.headers['token'] = token;
    Store().setToken(token);
  }

  Future<void> refreshToken() async {
    // final data = await get(ApiUrl.authRefresh);
    // setToken(data['token']);
  }

  Future<dynamic> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List> getList(
    String url,
    int page,
    int size, {
    Map<String, dynamic>? data,
  }) async {
    try {
      String formId = url.split('/').last;
      final dataParam = {
        'page': page,
        'length': size,
        'order[0][column]': 0,
        'order[0][dir]': 'desc',
        'form_id': formId,
        ...?data,
      };
      Response response = await _dio.post(
        url,
        data: FormData.fromMap(dataParam),
      );
      return response.data['data'] as List;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String url, Map<String, dynamic> data,
      {Map<String, dynamic>? queryParameters, BuildContext? context}) async {
    try {
      if (context != null) LoadingScreen.instance.show(context);
      Response response = await _dio.post(
        url,
        data: FormData.fromMap(data),
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      debugPrint('Error fetching list: $data');
      rethrow;
    } finally {
      if (context != null) LoadingScreen.instance.hide(context);
    }
  }

  Future<Response> patch(String url, String id, Map<String, dynamic> data,
      {Map<String, dynamic>? queryParameters,
      List<Map> files = const [],
      BuildContext? context}) async {
    try {
      if (context != null) LoadingScreen.instance.show(context);
      FormData formData = FormData.fromMap(data);
      Response response = await _dio.patch(
        url,
        data: formData,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    } finally {
      if (context != null) LoadingScreen.instance.hide(context);
    }
  }

  Future<Response> delete(String collection, String id,
      {Map<String, dynamic>? queryParameters, BuildContext? context}) async {
    try {
      if (context != null) LoadingScreen.instance.show(context);
      Response response = await _dio.delete(
        '/api/collections/$collection/records/$id',
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    } finally {
      if (context != null) LoadingScreen.instance.hide(context);
    }
  }
}

MultipartFile multiPartFile(String path) {
  return MultipartFile.fromFileSync(path);
}
