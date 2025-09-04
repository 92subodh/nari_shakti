import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../state/location_provider.dart';
import '../home/widgets/footer_nav.dart';

class ShareLocationScreen extends StatelessWidget {
  const ShareLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.shareLocation),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<LocationProvider>(
          builder: (context, location, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Location',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          location.address ?? 'Fetching location...',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => location.getCurrentLocation(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Location'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Share Location With:'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _ShareOptionCard(
                        title: 'Emergency Contacts',
                        icon: Icons.contacts,
                        onTap: () {
                          // TODO: Implement share with emergency contacts
                        },
                      ),
                      const SizedBox(height: 12),
                      _ShareOptionCard(
                        title: 'Police',
                        icon: Icons.local_police,
                        onTap: () {
                          // TODO: Implement share with police
                        },
                      ),
                      const SizedBox(height: 12),
                      _ShareOptionCard(
                        title: 'Share via WhatsApp',
                        icon: Icons.whatsapp,
                        onTap: () {
                          // TODO: Implement WhatsApp sharing
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const FooterNav(currentIndex: 1),
    );
  }
}

class _ShareOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ShareOptionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
