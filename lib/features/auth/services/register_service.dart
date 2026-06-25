import 'package:dio/dio.dart';

class RegisterService {
  final Dio _dio = Dio();

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    await _dio.post(
      "http://10.0.2.2:8081/users/register",
      data: {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      },
    );
  }
}