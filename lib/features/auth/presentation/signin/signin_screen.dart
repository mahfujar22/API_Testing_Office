
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/custom_button.dart';
import '../../../../common_widgets/custom_rich_text_button.dart';
import '../../../../common_widgets/custom_textform_field.dart';
import '../../../../common_widgets/custom_toast.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../constants/validator.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/loading_helper.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../networks/api_acess.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  
  get naviagationService => null;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

Future<void> _login() async {
  if (!_formkey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    final success = await loginRx.login(
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
      role: _roleController.text.trim(),
    );

    if (success && mounted) {
      customToastMessage("Success", "Login successful");
      NavigationService.navigateTo(Routes.homeScreen);
    } else if (mounted) {
      customToastMessage("Failed", "Invalid credentials or role");
    }
  } catch (e) {
    if (mounted) {
      customToastMessage("Error", "Something went wrong: $e");
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}




  @override
  Widget build(BuildContext context) {
    _emailController.text ;
    _passController.text ;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            UIHelper.kDefaulutPadding(),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UIHelper.verticalSpace(40.h),

                // Logo
                // Assets.images.logo.image(
                //   height: 80.h,
                //   width: 80.w,
                //   fit: BoxFit.contain,
                // ),

                UIHelper.verticalSpace(40.h),

                // Title
                Text(
                  "Mahfujar",
                  style: TextFontStyle.textStyle26c202020DMSans600,
                ),

                UIHelper.verticalSpace(8.h),

                Text(
                  "Please sign in to your account",
                  style: TextFontStyle.textStyle14c606060DMSans400,
                  textAlign: TextAlign.center,
                ),

                UIHelper.verticalSpace(40.h),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      // Email Field
                      CustomTextFormField(
                        validator: emailValidator,
                        controller: _emailController,
                        hintText: "Enter email or phone number",
                        labelText: "Email or Phone Number",
                        prefixIcon: Icons.email_outlined,
                        textInputAction: TextInputAction.next,
                      ),

                      UIHelper.verticalSpace(16.h),

                      // Password Field
                      CustomTextFormField(
                        validator: passwordValidator,
                        isPassword: true,
                        controller: _passController,
                        hintText: "Enter password",
                        labelText: "Password",
                        prefixIcon: Icons.lock_outline,
                        textInputAction: TextInputAction.done,
                      ),

                      UIHelper.verticalSpace(16.h),

                      CustomTextFormField(
                        // validator: emailValidator,
                        controller: _roleController,
                        hintText: "Role",
                        labelText: "Role",
                        prefixIcon: Icons.email_outlined,
                        textInputAction: TextInputAction.next,
                      ),
                      UIHelper.verticalSpace(16.h),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: (){
                            NavigationService.navigateTo(Routes.forgotPasswordScreen);
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextFontStyle.textStyle14cFF3A1222DMSans600,
                          ),
                          ),
                      ),

                      UIHelper.verticalSpace(40.h),

                      // Login Button
                      customButton(
                        onPressed: _isLoading ? null : _login,
                        title: _isLoading ? "Signing In..." : "Sign In",
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),

                UIHelper.verticalSpace(40.h),

                // Sign Up Redirect
                CustomRichTextButton(
                  onPressed: () {
                   NavigationService.navigateTo(Routes.signUpScreen);
                  },
                  additionalText: "Don't have an Account? ",
                  buttonText: "Sign Up",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _horizontalLine() {
  //   return Container(
  //     height: 1.h,
  //     color: AppColors.cE8E8E8,
  //   );
  // }
}
