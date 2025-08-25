import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/main.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class DioClient {
  final Dio dio;

  DioClient(): dio = Dio(
    BaseOptions(
      baseUrl: 'https://apickp.azurewebsites.net/storeops/api',
      headers: {
        'Content-Type': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SharedPreferencesService.getSharedPreference(SharedPreferencesService.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 401) {
            final context = navKey.currentState?.overlay?.context;

            if (context != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return AlertDialog(
                    title: const Text("Session Expired"),
                    content: const Text(
                      "Your session has expired. Please log in again",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.of(ctx).pop();
                          await SharedPreferencesService.clearAllSharedPreference();
                          appRouter.go('/login');
                        },
                        child: const Text("Accept"),
                      ),
                    ],
                  );
                },
              );
            }
          }
          return handler.next(response);
        },
      )
    );
  }
}