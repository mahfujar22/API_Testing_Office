
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template_flutter/helpers/loading_helper.dart';
import 'package:template_flutter/networks/api_acess.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_textform_field.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../constants/validator.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../helpers/ui_helpers.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _typeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE2B0A7), Color(0xFFF6F4EC)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    UIHelper.verticalSpace(40.h),
                      Text(
                  "Forgot password",
                  style: TextFontStyle.textStyle26c202020DMSans600,
                ),

                UIHelper.verticalSpace(8.h),

                Text(
                  "Enter your Email to Sent your OTP",
                  style: TextFontStyle.textStyle14c606060DMSans400,
                  textAlign: TextAlign.center,
                ),

                UIHelper.verticalSpace(40.h),
                      CustomTextFormField(
                        validator: emailValidator,
                        controller: _emailController,
                        hintText: "Enter email or phone number",
                        labelText: "Email or Phone Number",
                        prefixIcon: Icons.email_outlined,
                        textInputAction: TextInputAction.next,
                      ),
                  
                   
                 UIHelper.verticalSpace(24.h),
                    customButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final success = await forgotPassRx
                                  .forgotPassword(
                                    email: _emailController.text.trim(),
                                    type: "email",
                                  )
                                  .waitingForFutureWithoutBg();
                              if (success) {
                                NavigationService.navigateToWithArgs(
                                  Routes.verifyForgotOtpScreen,
                                  {'email': _emailController.text},
                                );
                              }
                            } catch (e) {
                              // Error already handled in rx
                            }
                          }
                        },
                        title: "Submit",
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
