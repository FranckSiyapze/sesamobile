import 'package:dio/dio.dart';
import 'package:sesa/ui/utils/storage.dart';

class ServiceInterceptor extends Interceptor {
  //final GetIt getIt = GetIt.instance;
  late String _deviceData, deviceData;
  @override
  Future<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    //MobileInfos _config = getIt.get<MobileInfos>();
    String token = await readStorage(value: "bearer");
    //print(_deviceData);
    options.headers.addAll(
      <String, dynamic>{
        "Authorization": "Bearer " + token,
        "Accept": "application/json",
      },
    );
    //print("_config.uuid : " + _config.uuid);
    //final heads =
    //options.headers;
    //print(options.headers);
    print(options.data);
    return super.onRequest(options, handler);
  }

  @override
  Future<dynamic> onResponse(
      Response options, ResponseInterceptorHandler handler) async {
    //print(options.data);
    return super.onResponse(options, handler);
  }
}
