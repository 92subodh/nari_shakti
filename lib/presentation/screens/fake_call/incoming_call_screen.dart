import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/fake_call_service.dart';

class IncomingCallScreen extends StatelessWidget {
  final String callerName;
  final VoidCallback onCallEnd;

  const IncomingCallScreen({
    super.key,
    required this.callerName,
    required this.onCallEnd,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Caller Info
              Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    callerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Incoming call...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              // Call Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CallButton(
                      icon: Icons.call_end,
                      color: Colors.red,
                      onPressed: () async {
                        await FakeCallService().endCall();
                        onCallEnd();
                      },
                    ),
                    _CallButton(
                      icon: Icons.call,
                      color: Colors.green,
                      onPressed: () {
                        // Start fake conversation
                        // TODO: Implement call accepted logic
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OngoingCallScreen(
                              callerName: callerName,
                              onCallEnd: onCallEnd,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class OngoingCallScreen extends StatefulWidget {
  final String callerName;
  final VoidCallback onCallEnd;

  const OngoingCallScreen({
    super.key,
    required this.callerName,
    required this.onCallEnd,
  });

  @override
  State<OngoingCallScreen> createState() => _OngoingCallScreenState();
}

class _OngoingCallScreenState extends State<OngoingCallScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  String _duration = '00:00';

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _updateDuration();
  }

  void _updateDuration() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          final minutes = _stopwatch.elapsed.inMinutes;
          final seconds = _stopwatch.elapsed.inSeconds % 60;
          _duration = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        });
        _updateDuration();
      }
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.callerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _duration,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.all(40),
              child: _CallButton(
                icon: Icons.call_end,
                color: Colors.red,
                onPressed: () async {
                  await FakeCallService().endCall();
                  widget.onCallEnd();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _CallButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Icon(
        icon,
        size: 36,
        color: Colors.white,
      ),
    );
  }
}
