import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../state/sos_provider.dart';
import '../home/widgets/footer_nav.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.sos),
        backgroundColor: AppColors.sosRed,
        foregroundColor: Colors.white,
      ),
      body: Consumer<SOSProvider>(
        builder: (context, sos, child) {
          return Column(
            children: [
              // SOS Status Card
              Container(
                width: double.infinity,
                color: sos.status == SOSStatus.active 
                    ? AppColors.sosRed.withOpacity(0.1)
                    : null,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      sos.status == SOSStatus.active
                          ? 'SOS Active'
                          : 'SOS Ready',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: sos.status == SOSStatus.active
                            ? AppColors.sosRed
                            : Colors.green,
                      ),
                    ),
                    if (sos.status == SOSStatus.active && sos.activatedTime != null)
                      Text(
                        'Activated at ${sos.activatedTime!.hour}:${sos.activatedTime!.minute}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // SOS Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GestureDetector(
                    onLongPress: () {
                      if (sos.status != SOSStatus.active) {
                        sos.triggerSOS();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.sosActivated),
                            backgroundColor: AppColors.sosRed,
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.sosRed,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.sosRed.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.emergency,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hold to\nActivate SOS',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Emergency Contacts List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Contacts',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: sos.emergencyContacts.length,
                          itemBuilder: (context, index) {
                            final contact = sos.emergencyContacts[index];
                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(contact),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => sos.removeEmergencyContact(contact),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add emergency contact
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const FooterNav(currentIndex: 2),
    );
  }
}
