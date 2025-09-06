import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SOSService {
  static final Logger _logger = Logger();

  /// Trigger SOS emergency actions
  static Future<void> triggerSOS({
    required String triggerKeyword,
    bool sendSMS = true,
    bool shareLocation = true,
    bool startRecording = true,
    bool notifyContacts = true,
  }) async {
    _logger.w("🚨 SOS TRIGGERED by keyword: $triggerKeyword");
    
    // Show immediate feedback to user
    await Fluttertoast.showToast(
      msg: "🚨 Emergency Alert Activated!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 18.0,
    );

    try {
      // Execute emergency actions in parallel for speed
      await Future.wait([
        if (sendSMS) _sendEmergencySMS(),
        if (shareLocation) _shareCurrentLocation(),
        if (startRecording) _startEmergencyRecording(),
        if (notifyContacts) _notifyEmergencyContacts(),
      ]);
      
      _logger.i("All SOS actions completed successfully");
    } catch (e) {
      _logger.e("Error during SOS execution: $e");
    }
  }

  /// Send emergency SMS to predefined contacts
  static Future<void> _sendEmergencySMS() async {
    try {
      _logger.i("📱 Sending emergency SMS...");
      
      // Get emergency contacts from shared preferences
      final emergencyContacts = await _getEmergencyContacts();
      
      if (emergencyContacts.isEmpty) {
        _logger.w("No emergency contacts configured");
        return;
      }

      final message = "🚨 EMERGENCY ALERT: I need help! This is an automated message from SafeHer app. Please check on me immediately.";
      
      // Platform-specific SMS sending
      const platform = MethodChannel("safeher_sms_service");
      await platform.invokeMethod("sendEmergencySMS", {
        "contacts": emergencyContacts,
        "message": message,
      });
      
      _logger.i("✅ Emergency SMS sent successfully");
    } catch (e) {
      _logger.e("❌ Failed to send emergency SMS: $e");
    }
  }

  /// Share current location with emergency contacts
  static Future<void> _shareCurrentLocation() async {
    try {
      _logger.i("📍 Sharing current location...");
      
      const platform = MethodChannel("safeher_location_service");
      final location = await platform.invokeMethod("getCurrentLocation");
      
      if (location != null) {
        final latitude = location["latitude"];
        final longitude = location["longitude"];
        final accuracy = location["accuracy"];
        
        _logger.i("📍 Location obtained: $latitude, $longitude (±${accuracy}m)");
        
        // Send location to emergency contacts
        await platform.invokeMethod("shareLocationWithContacts", {
          "latitude": latitude,
          "longitude": longitude,
          "accuracy": accuracy,
        });
        
        _logger.i("✅ Location shared successfully");
      }
    } catch (e) {
      _logger.e("❌ Failed to share location: $e");
    }
  }

  /// Start emergency audio/video recording
  static Future<void> _startEmergencyRecording() async {
    try {
      _logger.i("🎥 Starting emergency recording...");
      
      const platform = MethodChannel("safeher_recording_service");
      await platform.invokeMethod("startEmergencyRecording", {
        "recordAudio": true,
        "recordVideo": true,
        "duration": 300, // 5 minutes
      });
      
      _logger.i("✅ Emergency recording started");
    } catch (e) {
      _logger.e("❌ Failed to start emergency recording: $e");
    }
  }

  /// Notify emergency contacts through various channels
  static Future<void> _notifyEmergencyContacts() async {
    try {
      _logger.i("📞 Notifying emergency contacts...");
      
      const platform = MethodChannel("safeher_notification_service");
      await platform.invokeMethod("notifyEmergencyContacts", {
        "message": "🚨 Emergency situation detected for SafeHer user. Please check immediately!",
        "includeLocation": true,
        "includeLiveTracking": true,
      });
      
      _logger.i("✅ Emergency contacts notified");
    } catch (e) {
      _logger.e("❌ Failed to notify emergency contacts: $e");
    }
  }

  /// Get emergency contacts from storage
  static Future<List<String>> _getEmergencyContacts() async {
    try {
      // This would typically read from SharedPreferences or secure storage
      // For now, returning mock data - you can integrate with your existing user data
      return [
        "+1234567890", // Emergency contact 1
        "+0987654321", // Emergency contact 2
      ];
    } catch (e) {
      _logger.e("Failed to get emergency contacts: $e");
      return [];
    }
  }
}
