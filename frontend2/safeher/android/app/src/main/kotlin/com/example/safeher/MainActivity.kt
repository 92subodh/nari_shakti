package com.example.safeher

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val WAKE_WORD_CHANNEL = "safeher_wakeword_service"
    private val SMS_CHANNEL = "safeher_sms_service"
    private val LOCATION_CHANNEL = "safeher_location_service"
    private val RECORDING_CHANNEL = "safeher_recording_service"
    private val NOTIFICATION_CHANNEL = "safeher_notification_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Wake Word Service Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WAKE_WORD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val intent = Intent(this, WakeWordForegroundService::class.java)
                    intent.action = "START_SERVICE"
                    startForegroundService(intent)
                    result.success(true)
                }
                "stopService" -> {
                    val intent = Intent(this, WakeWordForegroundService::class.java)
                    intent.action = "STOP_SERVICE"
                    stopService(intent)
                    result.success(true)
                }
                "isServiceRunning" -> {
                    val isRunning = WakeWordForegroundService.isServiceRunning()
                    result.success(isRunning)
                }
                "setAccessKey" -> {
                    val accessKey = call.argument<String>("accessKey")
                    if (accessKey != null) {
                        WakeWordForegroundService.setAccessKey(accessKey)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Access key is required", null)
                    }
                }
                "setBuiltInWakeWords" -> {
                    val keywords = call.argument<List<String>>("keywords")
                    if (keywords != null) {
                        WakeWordForegroundService.setBuiltInKeywords(keywords)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Keywords are required", null)
                    }
                }
                "setCustomWakeWords" -> {
                    val wakeWordPaths = call.argument<List<String>>("wakeWordPaths")
                    if (wakeWordPaths != null) {
                        WakeWordForegroundService.setCustomKeywordPaths(wakeWordPaths)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Wake word paths are required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // SMS Service Channel (placeholder)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendEmergencySMS" -> {
                    // TODO: Implement SMS sending
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        // Location Service Channel (placeholder)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LOCATION_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getCurrentLocation" -> {
                    // TODO: Implement location getting
                    result.success(mapOf(
                        "latitude" to 0.0,
                        "longitude" to 0.0,
                        "accuracy" to 10.0
                    ))
                }
                "shareLocationWithContacts" -> {
                    // TODO: Implement location sharing
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        // Recording Service Channel (placeholder)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RECORDING_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startEmergencyRecording" -> {
                    // TODO: Implement emergency recording
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        // Notification Service Channel (placeholder)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "notifyEmergencyContacts" -> {
                    // TODO: Implement emergency contact notification
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
