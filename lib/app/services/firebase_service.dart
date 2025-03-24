// lib/services/firebase_service.dart

import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../models/gps_model.dart';

class FirebaseService extends GetxService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Stream to fetch the GPS data
  Stream<GpsLocation> get gpsStream {
    return _database.ref('GPS').onValue.map((event) {
      final data = event.snapshot.value;
      log(data.toString());
      return GpsLocation.fromMap((data as Map).cast<String, dynamic>());
    });
  }

// Method to send live GPS data to Firebase
  Future<void> sendGpsLocation(GpsLocation location) async {
    try {
      await _database.ref('GPS').set(location.toMap());
      log('GPS location sent: ${location.toMap()}');
    } catch (e) {
      log('Error sending GPS location: $e');
    }
  }

// Method to get the user's current location and send it to Firebase
  Future<void> updateUserLocation(GpsLocation userLocation) async {
    try {
      await sendGpsLocation(userLocation);
      log('User location updated: ${userLocation.toMap()}');
    } catch (e) {
      log('Error updating user location: $e');
    }
  }
}
