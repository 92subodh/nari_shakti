
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safeher/utils/logging_utils.dart';
import 'package:safeher/utils/request_utils.dart';
class UserSession {
  final String token;
  final String? refreshToken;
  final String userId;
  final String? name;
  final String phone;

  UserSession({
    required this.token,
    this.refreshToken,
    required this.userId,
    this.name,
    required this.phone,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      token: json['token'],
      refreshToken: json['refreshToken'],
      userId: json['user']['id'],
      name:json['user']['name'],
      phone: json['user']['phone'],
    );
  }
}



class AuthUtils {
  AuthUtils._internal();
  static final AuthUtils _singleton = AuthUtils._internal();
  factory AuthUtils() {
    return _singleton;
  }

  static const String baseUrl = "https://nari-shakti.onrender.com"; // your backend

  String? _jwt;
  // ignore: unused_field
  String? _refreshToken;

  String? get jwt => _jwt;

  Future<void> sendOtp(String phoneNumber) async {
    logging.i("sending otp to $phoneNumber");
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/send-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneNumber}),
      );

      if (response.statusCode == 200) {
        logging.i("OTP sent successfully to $phoneNumber");
      } else {
        logging.e("Failed to send OTP: ${response.body}");
      }
    } catch (e) {
      logging.e("Exception sending OTP: $e");
    }
  }

  Future<UserSession?> verifyOtp(String phoneNumber, String otp) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phoneNumber, "otp": otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final session = UserSession.fromJson(data);

      // persist token if you want auto-login later
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("authToken", session.token);
        await prefs.setString("userId", session.userId!);
        // await prefs.setString("name", session.name!);
      if (session.refreshToken != null) {
        await prefs.setString("refreshToken", session.refreshToken!);
      }

      return session;
    } else {
      logging.e("verifyOtp failed: ${response.body}");
      return null;
    }
  } catch (e) {
    logging.e("exception verifying otp: $e");
    return null;
  }
}

  Future<void> logout() async {
    _jwt = null;
    _refreshToken = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt");
    await prefs.remove("refreshToken");
    logging.i("Logged out successfully");
  }

  /// Example: call your backend to check if user is onboarded
  Future<ServerResponse> checkUserSignedUp() async {
    logging.i("Checking if user is onboarded");
    var response = await fetch(
      route: "/user/with-phone",
      params: {"number": "83265892365892"},
    );
    return response;
  }
}
