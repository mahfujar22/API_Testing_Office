import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:template_flutter/networks/endpoints.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class SingUpApi {
  static final SingUpApi _singleton = SingUpApi._internal();
  SingUpApi._internal();
  static SingUpApi get instance => _singleton;

  Future<Map> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String confirmPassword,
    required String role,
  }) async {
    try {
      Map data = {
        "email": email,
        "password": password,
        "name": name,
        "password_confirmation": confirmPassword,
        "phone": phone,
        "role": role,
      };
      Response response = await postHttp(Endpoints.signUp(), data);
      if (response.statusCode == 200) {
        final data = json.decode(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
