import 'package:rxdart/rxdart.dart';
import 'package:template_flutter/features/user_report/data/rx_profile/api.dart';
import 'package:template_flutter/networks/rx_base.dart';

import '../../../../helpers/error_message_Handler.dart';


final class GetProfileRx extends RxResponseInt {
  final api = GetProfileApi.instance;

  GetProfileRx({required super.empty, required super.dataFetcher});
  
  ValueStream get fileData => dataFetcher.stream;

  Future<bool> featchProfile() async {
   try{
     Map data = await api.getProfileData();
     return await handleSuccessWithReturn(data);
   } catch (error){
    return await handleErrorWithReturn(error);
   }
  }


  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error); // Just one call!
    return false;
  }

}