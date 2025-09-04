import 'package:flutter/material.dart';
import 'package:nari_shakti/presentation/screens/welcome_screen.dart';
import 'package:nari_shakti/presentation/screens/login/phone_input_screen.dart';
import 'package:nari_shakti/presentation/screens/login/otp_verification_screen.dart';
import 'package:nari_shakti/presentation/screens/home/home_screen.dart';
import 'package:nari_shakti/presentation/screens/share_location/share_location_screen.dart';
import 'package:nari_shakti/presentation/screens/sos/sos_screen.dart';
import 'package:nari_shakti/presentation/screens/fake_call/fake_call_screen.dart';
import 'package:nari_shakti/presentation/screens/profile/profile_screen.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String phoneInput = '/phone-input';
  static const String otpVerification = '/otp-verification';
  static const String home = '/home';
  static const String shareLocation = '/share-location';
  static const String sos = '/sos';
  static const String fakeCall = '/fake-call';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case phoneInput:
        return MaterialPageRoute(builder: (_) => const PhoneInputScreen());
      case otpVerification:
        final args = settings.arguments as String?; // Phone number
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phoneNumber: args ?? ''),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case shareLocation:
        return MaterialPageRoute(builder: (_) => const ShareLocationScreen());
      case sos:
        return MaterialPageRoute(builder: (_) => const SOSScreen());
      case fakeCall:
        return MaterialPageRoute(builder: (_) => const FakeCallScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
