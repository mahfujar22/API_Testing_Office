import 'package:dio/dio.dart';
import 'package:template_flutter/features/auth/data/model/login_response.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class LoginApi {
  static final LoginApi _singleton = LoginApi._internal();
  LoginApi._internal();
  static LoginApi get instance => _singleton;

  Future<LoginResponse> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      Map data = {"email": email, "password": password, "role": role};
      Response response = await postHttp(Endpoints.login(), data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginRes = LoginResponse.fromJson(response.data);
        if (loginRes.status == true) {
          return loginRes;
        } else {
          throw Exception(loginRes.message);
        }
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}