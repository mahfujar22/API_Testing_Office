import 'package:rxdart/rxdart.dart';
import 'package:template_flutter/features/auth/data/rx_forgot_pass/api.dart';
import 'package:template_flutter/networks/rx_base.dart';
import '../../../../helpers/error_message_Handler.dart';

final class ForgotPassRx extends RxResponseInt<Map> {
  String? errorMesage;
  final api = ForgotPassApi.instance;
  ForgotPassRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> forgotPassword({
    required String email,
    required String type,
  }) async {
    try {
      final data = await api.forgotPassword(
        email: email,
        type: type,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}
