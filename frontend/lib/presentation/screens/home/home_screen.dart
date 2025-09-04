import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import '../../../config/mapbox_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/location_helper.dart';
import '../../state/location_provider.dart';
import '../../state/sos_provider.dart';
import 'widgets/footer_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map View
          Consumer<LocationProvider>(
            builder: (context, location, child) {
              return GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(28.6139, 77.2090), // Default to New Delhi
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (controller) {
                  // Initialize map
                },
              );
            },
          ),
          
          // Current Location Button
          Positioned(
            right: 16,
            bottom: 100, // Above the bottom navigation
            child: FloatingActionButton(
              heroTag: 'getCurrentLocation',
              onPressed: () {
                context.read<LocationProvider>().getCurrentLocation();
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FooterNav(currentIndex: 0),
    );
  }
}
