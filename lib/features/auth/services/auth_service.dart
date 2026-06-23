  import 'package:dio/dio.dart';

  import '../../../core/constants/api_constants.dart';

  class AuthService {
    final Dio _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    Future<String> login({
      required String email,
      required String password,
    }) async {
      final response = await _dio.post(
        '/users/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return response.data['token'];
    }
  }