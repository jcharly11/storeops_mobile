

import 'package:dio/dio.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class DioClient {
  final Dio dio;


  DioClient(): dio = Dio(
    BaseOptions(
      baseUrl: 'https://apickp.azurewebsites.net/storeops/api',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async{
          final token= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      )
    );
  }
}