import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class WakeWordService {
  static const MethodChannel _platform = MethodChannel("safeher_wakeword_service");
  static final Logger _logger = Logger();

  /// Start the wake word detection foreground service
  static Future<bool> startService() async {
    try {
      final result = await _platform.invokeMethod("startService");
      _logger.i("Wake word service started successfully");
      return result == true;
    } on PlatformException catch (e) {
      _logger.e("Failed to start wake word service: ${e.message}");
      return false;
    }
  }

  /// Stop the wake word detection foreground service
  static Future<bool> stopService() async {
    try {
      final result = await _platform.invokeMethod("stopService");
      _logger.i("Wake word service stopped successfully");
      return result == true;
    } on PlatformException catch (e) {
      _logger.e("Failed to stop wake word service: ${e.message}");
      return false;
    }
  }

  /// Check if the wake word service is currently running
  static Future<bool> isServiceRunning() async {
    try {
      final result = await _platform.invokeMethod("isServiceRunning");
      return result == true;
    } on PlatformException catch (e) {
      _logger.e("Failed to check service status: ${e.message}");
      return false;
    }
  }

  /// Set the access key for Porcupine
  static Future<bool> setAccessKey(String accessKey) async {
    try {
      final result = await _platform.invokeMethod("setAccessKey", {"accessKey": accessKey});
      _logger.i("Access key set successfully");
      return result == true;
    } on PlatformException catch (e) {
      _logger.e("Failed to set access key: ${e.message}");
      return false;
    }
  }

  /// Configure custom wake words
  static Future<bool> setCustomWakeWords(List<String> wakeWordPaths) async {
    try {
      final result = await _platform.invokeMethod("setCustomWakeWords", {"wakeWordPaths": wakeWordPaths});
      _logger.i("Custom wake words set successfully");
      return result == true;
    } on PlatformException catch (e) {
      _logger.e("Failed to set custom wake words: ${e.message}");
      return false;
    }
  }

  /// Set built-in wake words
  static Future<bool> setBuiltInWakeWords(List<String> keywords) async {
    try {
      final result = await _platform.invokeMethod("setBuiltInWakeWords", {"keywords": keywords});
      _logger.i("Built-in wake words set successfully");
      return result == true;
    } on PlatformException catch (e) {
      _logger.e("Failed to set built-in wake words: ${e.message}");
      return false;
    }
  }

  /// Listen for wake word detection events
  static void setWakeWordCallback(Function(String keyword) callback) {
    _platform.setMethodCallHandler((call) async {
      if (call.method == "onWakeWordDetected") {
        final keyword = call.arguments["keyword"] as String;
        _logger.i("Wake word detected: $keyword");
        callback(keyword);
      }
    });
  }
}
