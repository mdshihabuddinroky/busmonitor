import 'dart:developer';

import 'package:busmonitor/app/modules/home/controllers/location_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:location/location.dart';
import '../../../models/gps_model.dart';
import '../../../services/firebase_service.dart';

class HomeController extends GetxController {
  LocationController locationController = Get.put(LocationController());
  var gpsLocation =
      GpsLocation(latitude: 0.0, longitude: 0.0, status: 'No data').obs;
  Location location = Location();

  final MapController mapController = MapController();

  @override
  void onInit() {
    super.onInit();

    // Listen to Firebase stream
    FirebaseService().gpsStream.listen((newLocation) {
      gpsLocation.value = newLocation;
      log("New location: ${newLocation.latitude}, ${newLocation.longitude}");
      mapController.move(
        LatLng(newLocation.latitude, newLocation.longitude),
        14,
      );
    });
  }

  void sendLocation() async {
    await locationController.initialize();
    locationController.getLocationStream().listen((location) async {
      FirebaseService().sendGpsLocation(location);
    });
  }
}
