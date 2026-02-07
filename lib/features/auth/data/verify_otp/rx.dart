import 'package:rxdart/rxdart.dart';
import 'package:template_flutter/features/auth/data/verify_otp/api.dart';
import 'package:template_flutter/networks/rx_base.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/error_message_Handler.dart';
import '../../../../helpers/post_login.dart';
import '../../../../networks/dio/dio.dart';

final class VerifyOtpRx extends RxResponseInt<Map> {
  VerifyOtpRx({required super.empty, required super.dataFetcher});
  ValueStream get getFileData => dataFetcher.stream;
  final api = VerifyOtpApi.instance;

  Future<bool> verifyOtp({required String email, required String otp}) async {
    try {
      final data = await api.verifyOtp(email: email, otp: otp);
      await handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    String? accesstoken = data['token'];
    int id = data['data']['id'];
    DioSingleton.instance.update(accesstoken!);
    await appData.write(kKeyIsLoggedIn, true);
    await appData.write(kKeyIsExploring, false);
    await appData.write(kKeyUserID, id);
    await appData.write(kKeyAccessToken, accesstoken);

    dataFetcher.sink.add(data);
    performPostLoginActions();

    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error); // Just one call!
    return false;
  }
}
