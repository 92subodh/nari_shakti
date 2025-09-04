import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../home/widgets/footer_nav.dart';
import 'incoming_call_screen.dart';
import '../../../data/services/fake_call_service.dart';

class FakeCallScreen extends StatefulWidget {
  const FakeCallScreen({super.key});

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  bool _isScheduled = false;
  int _countdown = 30; // Default countdown time in seconds
  Timer? _timer;

  void _startCountdown() {
    setState(() {
      _isScheduled = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
          _triggerFakeCall();
        }
      });
    });
  }

  void _cancelCountdown() {
    _timer?.cancel();
    setState(() {
      _isScheduled = false;
      _countdown = 30;
    });
  }

  void _triggerFakeCall() {
    final fakeCallService = FakeCallService();
    fakeCallService.startFakeCall(
      callerName: 'Mom', // TODO: Make this configurable
      delaySeconds: 0,
      onCallStart: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => IncomingCallScreen(
              callerName: 'Mom',
              onCallEnd: () {
                Navigator.of(context).pop();
                _cancelCountdown();
              },
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FakeCallService().initialize();
  }

  @override
  void dispose() {
    _timer?.cancel();
    FakeCallService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.fakeCall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fake Call Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _isScheduled ? 'Fake Call Scheduled' : 'Schedule a Fake Call',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (_isScheduled) ...[
                      const SizedBox(height: 16),
                      Text(
                        '${AppStrings.fakeCallInitiated} $_countdown seconds',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Countdown Circle
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isScheduled ? AppColors.primary : Colors.grey,
                    width: 4,
                  ),
                ),
                child: Center(
                  child: _isScheduled
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _countdown.toString(),
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const Text('seconds'),
                        ],
                      )
                    : const Icon(
                        Icons.phone_callback,
                        size: 64,
                        color: Colors.grey,
                      ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            if (!_isScheduled)
              ElevatedButton.icon(
                onPressed: _startCountdown,
                icon: const Icon(Icons.alarm),
                label: const Text('Schedule Fake Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _cancelCountdown,
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel Fake Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

            const SizedBox(height: 32),

            // Call Settings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Call Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Caller Name'),
                      subtitle: const Text('Mom'),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        // TODO: Implement caller name edit
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.timer),
                      title: const Text('Ring Duration'),
                      subtitle: const Text('30 seconds'),
                      trailing: const Icon(Icons.edit),
                      onTap: () {
                        // TODO: Implement ring duration edit
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterNav(currentIndex: 3),
    );
  }
}
