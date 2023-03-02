import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sesa/core/interceptors/service_interceptor.dart';
import 'package:sesa/core/models/app_config.dart';

class HttpService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;

  late String _base_url;

  HttpService() {
    AppConfig _config = getIt.get<AppConfig>();
    _base_url = _config.BASE_API_URL;
  }

  Future<Response> post(String _path, {body}) async {
    String _url = '$_base_url$_path';
    return await dio.post(
      _url,
      data: json.encode(body),
      /* options: Options(
        sendTimeout: 300 * 1000, // 300 seconds,
        receiveTimeout: 300 * 1000, // 300 seconds,
      ), */
    );
  }

  Future<Response> postLogin(String _path, {body}) async {
    String _url = '$_base_url$_path';
    dio.interceptors.addAll([
      ServiceInterceptor(),
      //LogInterceptor(),
    ]);
    return await dio.post(
      _url,
      data: json.encode(body),
      options: Options(
        sendTimeout: 300 * 1000, // 300 seconds,
        receiveTimeout: 300 * 1000, // 300 seconds,
      ),
    );
  }

  Future<Response> postImage(String _path, {body}) async {
    String _url = '$_base_url$_path';
    dio.interceptors.addAll([
      ServiceInterceptor(),
      //LogInterceptor(),
    ]);
    return await dio.post(
      _url,
      data: body,
      options: Options(
        sendTimeout: 300 * 1000, // 300 seconds,
        receiveTimeout: 300 * 1000, // 300 seconds,
      ),
    );
  }

  Future<Response> putRequest(String _path, {body}) async {
    String _url = '$_base_url$_path';
    dio.interceptors.addAll([
      ServiceInterceptor(),
      //LogInterceptor(),
    ]);
    return await dio.put(
      _url,
      data: json.encode(body),
      options: Options(
        sendTimeout: 300 * 1000, // 300 seconds,
        receiveTimeout: 300 * 1000, // 300 seconds,
      ),
    );
  }

  Future<Response> postTest(String _path, {body}) async {
    String _url = 'localhost:2000';
    dio.interceptors.addAll([
      //TesttInterceptor(),
      //ServiceInterceptor(),
      //LogInterceptor(),
    ]);
    return await dio.post(
      _url,
      data: json.encode(body),
      options: Options(
        sendTimeout: 300 * 1000, // 300 seconds,
        receiveTimeout: 300 * 1000, // 300 seconds,
      ),
      /* options: Options(
        headers: {
          'lang': Platform.localeName.split('_')[0],
          "Content-Type": "application/json"
        },
      ), */
    );
  }

  Future<Response> getRequest(String _path) async {
    String _url = '$_base_url$_path';
    dio.interceptors.addAll([
      ServiceInterceptor(),
      //LogInterceptor(),
    ]);
    return await dio.get(
      _url,
      options: Options(
        sendTimeout: 300 * 1000, // 300 seconds,
        receiveTimeout: 300 * 1000, // 300 seconds,
      ),
    );
  }

  Future<Response> get(String _path) async {
    String _url = '$_base_url$_path';
    dio.interceptors.addAll([
      //ServiceInterceptor(),
      //LogInterceptor(),
    ]);
    return await dio.get(
      _url,
      options: Options(
        sendTimeout: 300 * 1000, // 300 seconds,
        receiveTimeout: 300 * 1000, // 300 seconds,
      ),
    );
  }

  Future<Response> deleteRequest(String _path) async {
    String _url = '$_base_url$_path';
    dio.interceptors.addAll([
      ServiceInterceptor(),
      //LogInterceptor(),
    ]);
    return await dio.delete(
      _url,
      options: Options(
        sendTimeout: 300 * 1000, // 300 seconds,
        receiveTimeout: 300 * 1000, // 300 seconds,
      ),
    );
  }
}
