import 'package:flutter/material.dart';
import 'dart:math' show Point;
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../../config/mapbox_config.dart';
import '../../../core/utils/location_helper.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  MapboxMapController? mapController;
  LatLng? selectedLocation;
  bool isLoading = false;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() => isLoading = true);
    try {
      final location = await LocationHelper.getCurrentLocation();
      if (location != null && mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLng(location),
        );
        setState(() => selectedLocation = location);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _onStyleLoadedCallback() async {
    if (mapController == null) return;
    
    await mapController!.addSymbol(
      SymbolOptions(
        geometry: selectedLocation ?? 
          LatLng(MapboxConfig.defaultLatitude, MapboxConfig.defaultLongitude),
        iconImage: "marker-15",
        iconSize: 2.0,
      ),
    );
  }

  void _onMapClick(Point<double> point, LatLng coordinates) async {
    if (mapController == null) return;

    // Clear previous markers
    await mapController!.clearSymbols();

    // Add new marker
    await mapController!.addSymbol(
      SymbolOptions(
        geometry: coordinates,
        iconImage: "marker-15",
        iconSize: 2.0,
      ),
    );

    setState(() => selectedLocation = coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          if (selectedLocation != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context, selectedLocation);
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          MapboxMap(
            accessToken: MapboxConfig.accessToken,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                MapboxConfig.defaultLatitude,
                MapboxConfig.defaultLongitude,
              ),
              zoom: MapboxConfig.defaultZoom,
            ),
            onMapCreated: _onMapCreated,
            onStyleLoadedCallback: _onStyleLoadedCallback,
            onMapClick: _onMapClick,
            compassEnabled: true,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.Tracking,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: _initializeLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
