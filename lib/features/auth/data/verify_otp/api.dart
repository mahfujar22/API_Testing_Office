
import 'package:template_flutter/networks/dio/dio.dart';
import 'package:template_flutter/networks/endpoints.dart';

import '../../../../networks/exception_handler/data_source.dart';

final class VerifyOtpApi {
  static final VerifyOtpApi _singleton = VerifyOtpApi. _internal();
  VerifyOtpApi. _internal();
  static VerifyOtpApi get instance => _singleton;

  Future<Map> verifyOtp({
    required String email,
    required String otp,
  }) async {
    Map data = {
      "email": email,
      "otp": otp,
    };
    print('Sending data to API: $data');
    final response = await postHttp(Endpoints.verifyOtp(), data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data as Map;
    } else {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}