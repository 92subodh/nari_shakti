import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FakeCallService {
  static final FakeCallService _instance = FakeCallService._internal();
  factory FakeCallService() => _instance;
  FakeCallService._internal();

  final _audioPlayer = AudioPlayer();
  Timer? _vibrationTimer;
  Timer? _callTimer;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isCallActive = false;

  bool get isCallActive => _isCallActive;

  Future<void> initialize() async {
    // Initialize notifications
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _notifications.initialize(initializationSettings);

    // Load ringtone
    await _audioPlayer.setAsset('assets/audio/ringtone.mp3');
    await _audioPlayer.setLoopMode(LoopMode.one);
  }

  Future<void> startFakeCall({
    required String callerName,
    required int delaySeconds,
    required VoidCallback onCallStart,
  }) async {
    if (_isCallActive) return;

    // Wait for the specified delay
    await Future.delayed(Duration(seconds: delaySeconds));

    _isCallActive = true;

    // Show notification
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'fake_call_channel',
      'Fake Calls',
      channelDescription: 'Channel for fake incoming calls',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      enableVibration: false,
      playSound: false,
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await _notifications.show(
      0,
      'Incoming Call',
      callerName,
      platformChannelSpecifics,
    );

    // Start vibration pattern
    _startVibration();

    // Start ringtone
    await _audioPlayer.play();

    // Trigger the UI callback
    onCallStart();

    // Auto-end call after 30 seconds if not answered
    _callTimer = Timer(const Duration(seconds: 30), () {
      endCall();
    });
  }

  void _startVibration() {
    _vibrationTimer?.cancel();
    _vibrationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 1000, 500, 1000]); // Incoming call pattern
      }
    });
  }

  Future<void> endCall() async {
    if (!_isCallActive) return;

    _isCallActive = false;
    _vibrationTimer?.cancel();
    _callTimer?.cancel();
    await _audioPlayer.stop();
    await _notifications.cancel(0);
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.cancel();
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    _vibrationTimer?.cancel();
    _callTimer?.cancel();
    if (_isCallActive) {
      Vibration.cancel();
    }
  }
}
