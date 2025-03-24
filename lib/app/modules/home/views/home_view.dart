import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/gps_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live GPS Location'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.sendLocation();
        },
        child: Icon(Icons.location_history_outlined),
      ),
      body: Obx(() {
        GpsLocation currentLocation = controller.gpsLocation.value;
        // Move the camera to the updated GPS location if the map is ready

        return FlutterMap(
          mapController: controller.mapController,
          options: MapOptions(
            initialCenter:
                LatLng(currentLocation.latitude, currentLocation.longitude),
            initialZoom: 14.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                      currentLocation.latitude, currentLocation.longitude),
                  child: Icon(Icons.location_on),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
