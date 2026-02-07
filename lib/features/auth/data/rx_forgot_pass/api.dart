import 'dart:convert';
import 'package:template_flutter/networks/dio/dio.dart';
import 'package:template_flutter/networks/endpoints.dart';

import '../../../../networks/exception_handler/data_source.dart';

final class ForgotPassApi {
  static final ForgotPassApi _singleton = ForgotPassApi._internal();
  ForgotPassApi._internal();

  static ForgotPassApi get instance => _singleton;

  Future<Map> forgotPassword(
      {required String email, required String type}) async {
    Map data = {
      "email": email,
      "type": type,
    };
    final response = await postHttp(Endpoints.forgotPass(), data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data as Map;
    } else {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}
