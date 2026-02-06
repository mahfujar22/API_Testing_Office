import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:template_flutter/features/auth/data/rx_post_login/api.dart';
import 'package:template_flutter/networks/rx_base.dart';
import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/error_message_handler.dart'; 
import '../../../../helpers/post_login.dart';
import '../../../../networks/dio/dio.dart';
import '../model/login_response.dart';

final class LoginRx extends RxResponseInt<LoginResponse> {
  final api = LoginApi.instance;

  LoginRx({required super.empty, required super.dataFetcher});

  ValueStream<LoginResponse> get getFileData => dataFetcher.stream;

  Future<bool> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final data = await api.login(
        email: email,
        password: password,
        role: role,
      );

      

      // backend status true না হলে এখানেই error throw হবে (LoginApi থেকে)
      final success = await handleSuccessWithReturn(data);
      
      return success;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  Future<bool> handleSuccessWithReturn(LoginResponse data) async {
    // backend status false হলে এখানে আসা উচিত না — তবুও safety check
    if (!data.status) {
      ErrorMessageHandler.showErrorToast(data.message ?? "Login failed (invalid response)");
      return false;
    }

    try {
      final accessToken = data.data.token;
      final userId = data.data.user.id;

      DioSingleton.instance.update(accessToken);

      await appData.write(kKeyIsLoggedIn, true);
      await appData.write(kKeyIsExploring, false);
      await appData.write(kKeyUserID, userId);
      await appData.write(kKeyAccessToken, accessToken);

      dataFetcher.sink.add(data);

      performPostLoginActions();
      

      return true;
    } catch (e) {
      ErrorMessageHandler.showErrorToast("Failed to save login data: $e");
      return false;
    }
  }

  @override
  bool handleErrorWithReturn(dynamic error) {
    String errorMessage = "Something went wrong";

    if (error is Exception) {
      errorMessage = error.toString().replaceFirst('Exception: ', '').trim();
    } else if (error is String) {
      errorMessage = error;
    }
    if (error is DioException && error.response?.data is Map) {
      final responseData = error.response!.data as Map;
      final serverMessage = responseData['message'] as String?;
      if (serverMessage != null && serverMessage.isNotEmpty) {
        errorMessage = serverMessage;
      }
    }

    ErrorMessageHandler.showErrorToast(errorMessage);
    return false;
  }
}