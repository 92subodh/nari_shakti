import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class WakeWordDebugService {
  static const MethodChannel _platform = MethodChannel("safeher_wakeword_service");
  static final Logger _logger = Logger();

  /// Test if the native implementation is available
  static Future<bool> testNativeImplementation() async {
    try {
      _logger.i("Testing native implementation...");
      
      // Try a simple method call
      final result = await _platform.invokeMethod("isServiceRunning");
      _logger.i("Native implementation test successful: $result");
      return true;
    } on MissingPluginException catch (e) {
      _logger.e("Native implementation missing: $e");
      return false;
    } catch (e) {
      _logger.e("Native implementation test failed: $e");
      return false;
    }
  }

  /// Get debug information about the platform
  static Future<Map<String, dynamic>> getDebugInfo() async {
    final debugInfo = <String, dynamic>{};
    
    try {
      // Test basic platform information
      debugInfo['platform'] = 'Available';
      debugInfo['channel'] = 'safeher_wakeword_service';
      
      // Test method availability
      final testMethods = [
        'isServiceRunning',
        'startService', 
        'stopService',
        'setAccessKey',
        'setBuiltInWakeWords',
      ];
      
      for (final method in testMethods) {
        try {
          await _platform.invokeMethod(method);
          debugInfo['method_$method'] = 'Available';
        } on MissingPluginException {
          debugInfo['method_$method'] = 'Missing';
        } catch (e) {
          debugInfo['method_$method'] = 'Error: ${e.runtimeType}';
        }
      }
      
    } catch (e) {
      debugInfo['error'] = e.toString();
    }
    
    return debugInfo;
  }
}
