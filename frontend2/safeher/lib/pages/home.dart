import 'package:flutter/material.dart';
import 'package:safeher/widgets/title_text.dart';
import 'package:safeher/widgets/text_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Start the animation after a brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      'images/locationsharing.png',
                      height: 300,
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Center(
                      child: TextTitle.greeting(
                        '${_getGreeting()}, Champa',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildFeatureCard(
                          icon: Icons.location_on,
                          label: 'Location\nReview',
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        _buildFeatureCard(
                          icon: Icons.share_location,
                          label: 'Share\nLocation',
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        _buildFeatureCard(
                          icon: Icons.local_police,
                          label: 'Call\nPolice',
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        _buildFeatureCard(
                          icon: Icons.location_city,
                          label: 'Nearby\nPlaces',
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        _buildFeatureCard(
                          icon: Icons.videocam,
                          label: 'Spy\nCam',
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        _buildFeatureCard(
                          icon: Icons.phone,
                          label: 'Fake\nCall',
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/wake-word'),
                          child: _buildFeatureCard(
                            icon: Icons.mic,
                            label: 'Wake Word\nProtection',
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: SizedBox(
        height: 115, // 1.5x default height
        width: 115, // 1.5x default width
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.surface, 
              width: 6,
            ), // scaled border
          ),
          child: FloatingActionButton(
            onPressed: () {
              // Add SOS functionality here
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            child: TextTitle.small(
              'SOS',
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home, 
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.tips_and_updates, 
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon, 
            size: 20, 
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 4),
          TextBody.small(
            label,
            textAlign: TextAlign.center,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
