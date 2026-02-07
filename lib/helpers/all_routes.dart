// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:template_flutter/features/auth/presentation/verify_otp_forgot/veryfy_otp_forgot_screen.dart';



// import '../features/auth/presentation/login.dart';
// import '../features/auth/presentation/signup.dart';
import '../features/auth/presentation/forgot_password/forgot_password_screen.dart';
import '../features/auth/presentation/sign_up/register_screen.dart';
import '../features/auth/presentation/signin/signin_screen.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  // Auth Routes
  static const String loginScreen = '/logIn';
  static const String signUpScreen = '/signUp';
  static const String forgotPWScreen = '/ForgotPWScreen';
  static const String otpScreen = '/OtpScreen';
  static const String setPassword = '/SetPassword';
  //products_with_pagination
  static const String productsWithPagination = '/ProductsWithPagination';
  //ProductsScreen
  static const String productsScreen = '/ProductsScreen';
  //ProductDetailsScreen
  static const String productDetailsScreen = '/ProductDetailsScreen';

  // Main App Routes
  static const String homeScreen = '/home_screen';
  static const String navigationScreen = '/NavigationScreen';
  static const String profile = '/Profile';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String verifyForgotOtpScreen = '/verifyForgotOtpScreen';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth Routes - Commented out temporarily
      case Routes.loginScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const LoginScreen())
            : _FadedTransitionRoute(
                widget: const LoginScreen(), settings: settings);

      case Routes.signUpScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const SignUpScreen())
            : _FadedTransitionRoute(
                widget: const SignUpScreen(), settings: settings);
      case Routes.forgotPasswordScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const ForgotPasswordScreen())
            : _FadedTransitionRoute(
                widget: const ForgotPasswordScreen(), settings: settings);
      case Routes.verifyForgotOtpScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String? ?? '';
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => VerifyForgotOtpScreen(email: email))
            : _FadedTransitionRoute(
                widget: VerifyForgotOtpScreen(email: email), settings: settings);

     

      default:
        return null;
    }
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
      : super(
          settings: settings,
          reverseTransitionDuration: const Duration(milliseconds: 1),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionDuration: const Duration(milliseconds: 1),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.ease,
              ),
              child: child,
            );
          },
        );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: widget,
    );
  }
}
