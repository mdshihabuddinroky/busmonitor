import 'dart:async';
import 'dart:developer';

import 'package:busmonitor/app/models/gps_model.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  final Location _location = Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;
  StreamSubscription<LocationData>?
      _locationSubscription; // To track the stream subscription

  void stopLocationService() {}
  Future<void> initialize() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await _location.getLocation();
  }

  Future<GpsLocation?> getLocation() async {
    if (_locationData == null) {
      await initialize();
    } else {
      _locationData = await _location.getLocation();
    }

    if (_locationData != null) {
      return GpsLocation(
        latitude: _locationData!.latitude!,
        longitude: _locationData!.longitude!,
        status: "Active",
      );
    }
    return null;
  }

  Stream<GpsLocation> getLocationStream() {
    return _location.onLocationChanged.map((locationData) {
      return GpsLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        status: "Active",
      );
    });
  }

  Future<void> enableBackgroundMode() async {
    await _location.enableBackgroundMode(enable: true);
  }

  @override
  void dispose() {
    // Cancel the location stream subscription
    _locationSubscription?.cancel();
    _locationSubscription = null;

    // Optionally, disable background mode if it was enabled
    _location.enableBackgroundMode(enable: false);

    // Additional cleanup if required
    log("LocationController disposed and resources released.");
  }
}
