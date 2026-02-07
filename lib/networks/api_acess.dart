
import 'package:rxdart/rxdart.dart';
import 'package:template_flutter/features/auth/data/rx_forgot_pass/rx.dart';
import 'package:template_flutter/features/auth/data/verify_otp/rx.dart';


import '../features/auth/data/model/login_response.dart';
import '../features/auth/data/rx_post_login/rx.dart';
import '../features/auth/data/rx_post_signup/rx.dart';

SingUpRx signupRx = SingUpRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

LoginRx loginRx = LoginRx(
  empty: LoginResponse(
    status: false,
    message: '',
    data: Data(
      token: '',
      user: User(
        id: 0,
        profileImage: '',
        name: '',
        email: '',
        phone: '',
        dob: null,
        nationalInsuranceNumber: null,
        nationality: null,
        flarHouseNo: null,
        street: null,
        city: null,
        postCode: null,
      ),
    ),
  ),
  dataFetcher: BehaviorSubject<LoginResponse>(),
);


ForgotPassRx forgotPassRx = ForgotPassRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

VerifyOtpRx verifyRedeemRx = VerifyOtpRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);