import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:rxdart/rxdart.dart';
import 'package:template_flutter/features/auth/data/verify_otp/rx.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../helpers/ui_helpers.dart';

class VerifyForgotOtpScreen extends StatefulWidget {
  final String email;
  const VerifyForgotOtpScreen({super.key, required this.email});

  @override
  State<VerifyForgotOtpScreen> createState() => _VerifyForgotOtpScreenState();
}

class _VerifyForgotOtpScreenState extends State<VerifyForgotOtpScreen> {
  int _secondsRemaining = 300;
  bool _showResend = false;
  Timer? _timer;

  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final verifyOtpRx = VerifyOtpRx(empty: {}, dataFetcher: BehaviorSubject());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel(); // cancel old timer if any
    _secondsRemaining = 300;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _showResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void resendCode() {
    setState(() {
      _showResend = false;
      _secondsRemaining = 300;
    });
    startTimer();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE2B0A7), Color(0xFFF6F4EC)],

            // colors: [Color(0xFFE2B0A7), Color(0xFFF1D5B8)],
          ),
        ),
        child: GestureDetector(
          // focusColor: Colors.transparent,
          // hoverColor: Colors.transparent,
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelper.verticalSpace(52.h),

                    _otpFieldWidget(),
                    UIHelper.verticalSpace(34.h),

                    Center(
                      child: _showResend
                          ? GestureDetector(
                              onTap: resendCode,
                              child: Text("RESEND CODE",
                                  style: TextFontStyle
                                      .textStyle16c606060DMSans400),
                            )
                          : Text(
                              "RESEND CODE IN ${_formatTime(_secondsRemaining)}",
                              style: TextFontStyle.textStyle16c606060DMSans400,
                            ),
                    ),

                    UIHelper.verticalSpace(24.h),
                    customButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          log('Email: ${widget.email}');
                          log('OTP: ${_otpController.text.trim()}');
                          final success = await verifyOtpRx.verifyOtp(
                            email: widget.email,
                            otp: _otpController.text.trim(),
                          );
                          if (success) {
                            NavigationService.navigateToWithArgs(
                              Routes.loginScreen,
                              {'email': widget.email},
                            );
                          }
                        }
                      },
                      title: "Verify",
                    ),

                    // CustomButton(
                    //   onTap: () {
                    //     verifyForgetPassRx
                    //         .verifyForgetPass(
                    //           email: widget.email,
                    //           otp: _otpController.text.trim(),
                    //         )
                    //         .waitingForSucess()
                    //         .then((success) {
                    //           if (success) {
                    //             NavigationService.navigateToWithArgs(
                    //               Routes.resetPasswordRoute,
                    //               {'email': widget.email},
                    //             );
                    //           }
                    //         });
                    //   },
                    //   btnName: "NEXT",
                    //   borderRadius: 100.r,
                    //   textStyle: TextFontStyle.headline14C6E0B08GlacialBold
                    //       .copyWith(color: Color(0xFFF6F4EC)),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpFieldWidget() {
    return Center(
      child: Pinput(
        controller: _otpController,
        length: 6,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter your 6 digit otp code";
          }
          if (value.length != 6) {
            return "OTP must be 6 digits";
          }
          return null;
        },
        defaultPinTheme: PinTheme(
          width: 44.w,
          height: 44.w,
          margin: EdgeInsets.all(8.sp),
          textStyle: TextFontStyle.textStyle12c606060DMSans400,
          decoration: BoxDecoration(
            color: Color(0xFFF6F4EC),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(width: 1.w, color: Colors.black38),
            boxShadow: [
              BoxShadow(
                color: AppColors.allPrimaryColor.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 12),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: AppColors.allPrimaryColor.withValues(alpha: .22),
                blurRadius: 2,
                offset: const Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
        ),
        submittedPinTheme: PinTheme(
          width: 44.w,
          height: 44.w,
          margin: EdgeInsets.all(8.sp),
          textStyle: TextFontStyle.textStyle12c606060DMSans400.copyWith(
            color: Color(0xFFF6F4EC),
          ),
          decoration: BoxDecoration(
            color: AppColors.allPrimaryColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.allPrimaryColor, width: 2.w),
            boxShadow: [
              BoxShadow(
                color: AppColors.allPrimaryColor.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        focusedPinTheme: PinTheme(
          width: 44.w,
          height: 44.w,
          margin: EdgeInsets.all(8.sp),
          // textStyle: TextFontStyle.headline16w500C242424Inter,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.allPrimaryColor, width: 1.8.w),
          ),
        ),
        onCompleted: (pin) => log('Completed: $pin'),
        onChanged: (value) => log('Changed: $value'),
      ),
    );
  }
}
