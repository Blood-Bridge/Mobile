import 'dart:async';

import 'package:blood_bridge/core/services/secure_storage_service.dart';
import 'package:blood_bridge/core/services/hive_helper.dart';
import 'package:blood_bridge/features/auth/presentation/views/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;

/// Production-grade Dio helper with robust token management.
class DioHelper {
  DioHelper._();

  static Dio? _dio;
  static Dio? _refreshDio;
  static Future<String?>? _refreshFuture;
  static bool _isLoggingOut = false;

  static const String _defaultPrefer = 'return=representation';
  static const String _refreshPath = 'Auth/refresh-token';

  static Dio get dio {
    if (_dio == null) {
      throw StateError(
        'DioHelper is not initialized. Call DioHelper.init() first.',
      );
    }
    return _dio!;
  }

  static void init() {
    if (_dio != null) return;

    print("DIO INIT");

    final baseUrl = dotenv.env['DATA_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception("Missing DATA_URL in .env file");
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {'Prefer': _defaultPrefer},
      ),
    );

    _dio!.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );

    _dio!.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    // Isolated Dio for refresh (no interceptors)
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }

  static Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageService.getToken();
    final expiration = await SecureStorageService.getExpiration();

    if (token != null && token.isNotEmpty) {
      final isNearExpiry =
          expiration != null &&
          expiration.difference(DateTime.now()).inSeconds <= 60;

      if (isNearExpiry) {
        final newToken = await _refreshToken();
        if (newToken != null) {
          options.headers['Authorization'] = 'Bearer $newToken';
        } else {
          // Refresh failed → cancel request to avoid immediate 401
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Token refresh failed',
              type: DioExceptionType.cancel,
            ),
          );
        }
      } else {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  static Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    if (err.response?.statusCode == 401) {
      if (_isRefreshRequest(options) || options.extra['isRetry'] == true) {
        await _handleLogout();
        return handler.next(err);
      }

      final newToken = await _refreshToken();

      if (newToken != null) {
        options.headers['Authorization'] = 'Bearer $newToken';
        options.extra['isRetry'] = true;

        try {
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (_) {
          await _handleLogout();
        }
      } else {
        await _handleLogout();
      }
    }

    return handler.next(err);
  }

  static bool _isRefreshRequest(RequestOptions options) {
    return options.path.contains(_refreshPath) ||
        options.extra['isRefresh'] == true;
  }

  static Future<String?> _refreshToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    final completer = Completer<String?>();
    _refreshFuture = completer.future;

    try {
      final result = await _performRefresh();
      completer.complete(result);
      return result;
    } catch (e) {
      completer.complete(null);
      return null;
    } finally {
      _refreshFuture = null;
    }
  }

  static Future<String?> _performRefresh() async {
    final refreshToken = await SecureStorageService.getRefreshToken();
    final currentToken = await SecureStorageService.getToken();

    if (refreshToken == null || currentToken == null) return null;

    try {
      final response = await _refreshDio!.post(
        _refreshPath,
        data: {"token": currentToken, "refreshToken": refreshToken},
        options: Options(extra: {'isRefresh': true}),
      );

      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) return null;

      final newToken = data['token'] as String?;
      final newRefresh = data['refreshToken'] as String?;
      final userId = data['userId'];
      final expStr = data['expiration'] as String?;

      if (newToken == null ||
          newRefresh == null ||
          userId == null ||
          expStr == null) {
        return null;
      }

      await SecureStorageService.saveAuthData(
        token: newToken,
        refreshToken: newRefresh,
        userId: userId,
        expiration: DateTime.parse(expStr),
      );

      return newToken;
    } catch (e, s) {
      print('❌ Token refresh failed: $e\n$s');
      return null;
    }
  }

  static Future<void> _handleLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await SecureStorageService.clear();
      await HiveHelper.clearUserData();
      if (Get.isDialogOpen ?? false) Get.back();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _isLoggingOut = false;
    }
  }

  // ==================== Public API ====================

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => dio.get(path, queryParameters: queryParameters, options: options);

  static Future<Response> postData({
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    String? prefer,
    Options? options,
  }) {
    final opt = options ?? Options();
    opt.headers ??= {};
    if (prefer != null) {
      opt.headers!['Prefer'] = prefer;
    }
    return dio.post(
      path,
      queryParameters: queryParameters,
      data: body,
      options: opt,
    );
  }

  static Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Options? options,
  }) => dio.delete(
    path,
    queryParameters: queryParameters,
    data: body,
    options: options,
  );

  static Future<Response> patchData({
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Options? options,
  }) => dio.patch(
    path,
    queryParameters: queryParameters,
    data: body,
    options: options,
  );

  static Future<Response> putData({
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Options? options,
  }) => dio.put(
    path,
    queryParameters: queryParameters,
    data: body,
    options: options,
  );
}
