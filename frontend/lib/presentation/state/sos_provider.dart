import 'package:flutter/foundation.dart';

enum SOSStatus {
  inactive,
  active,
  error
}

class SOSProvider extends ChangeNotifier {
  SOSStatus _status = SOSStatus.inactive;
  DateTime? _activatedTime;
  final List<String> _emergencyContacts = [];
  String? _error;

  SOSStatus get status => _status;
  DateTime? get activatedTime => _activatedTime;
  List<String> get emergencyContacts => _emergencyContacts;
  String? get error => _error;

  Future<void> triggerSOS() async {
    try {
      _status = SOSStatus.active;
      _activatedTime = DateTime.now();
      notifyListeners();

      // TODO: Implement actual SOS logic
      // 1. Send notifications to emergency contacts
      // 2. Make emergency calls
      // 3. Send location to emergency services
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    } catch (e) {
      _status = SOSStatus.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  void deactivateSOS() {
    _status = SOSStatus.inactive;
    _activatedTime = null;
    notifyListeners();
  }

  Future<void> addEmergencyContact(String contact) async {
    try {
      if (!_emergencyContacts.contains(contact)) {
        _emergencyContacts.add(contact);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void removeEmergencyContact(String contact) {
    _emergencyContacts.remove(contact);
    notifyListeners();
  }
}
