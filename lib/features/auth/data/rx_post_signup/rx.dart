
import 'package:rxdart/rxdart.dart';
import 'package:template_flutter/features/auth/data/rx_post_signup/api.dart';
import 'package:template_flutter/networks/rx_base.dart';
import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/error_message_Handler.dart';
import '../../../../helpers/post_login.dart';
import '../../../../networks/dio/dio.dart';

final class SingUpRx extends RxResponseInt<Map>{
  String? errorMessage;
  final api = SingUpApi.instance;

  SingUpRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
    required String confirmP,
  }) async {
    try {
      final response = await api.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
        confirmPassword: confirmP,
      );
      handleSuccessWithReturn(response);
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

  





 