import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_streamo_github/auth/presentation/otp_screen.dart';
import 'package:i_streamo_github/auth/presentation/phone_login.dart';
import 'package:i_streamo_github/auth/presentation/phone_login_screen.dart';
import 'package:i_streamo_github/core/presentation/splash_page.dart';
import 'package:i_streamo_github/repos/presentation/home_screen.dart';

class CustomRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case '/authentication':
        return MaterialPageRoute(builder: (_) => const PhoneLogin());

      case '/otp':
        final _phone = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => OtpScreen(_phone));
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const PhoneLogin());
    }
  }
}
