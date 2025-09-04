import 'package:flutter/foundation.dart';

enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  unauthenticated,
  error
}

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  String? _phoneNumber;
  String? _userId;
  String? _error;

  AuthStatus get status => _status;
  String? get phoneNumber => _phoneNumber;
  String? get userId => _userId;
  String? get error => _error;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      _status = AuthStatus.authenticating;
      _phoneNumber = phoneNumber;
      notifyListeners();

      // TODO: Implement actual phone verification
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _status = AuthStatus.authenticated;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}'; // Temporary ID
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      // TODO: Implement actual OTP verification
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  void logout() {
    _status = AuthStatus.unauthenticated;
    _phoneNumber = null;
    _userId = null;
    _error = null;
    notifyListeners();
  }
}
