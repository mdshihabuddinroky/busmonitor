class GpsLocation {
  double latitude;
  double longitude;
  String status;

  GpsLocation({
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  factory GpsLocation.fromMap(Map<String, dynamic> map) {
    return GpsLocation(
      latitude: double.tryParse(map['Latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(map['Longitude'].toString()) ?? 0.0,
      status: map['Status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Latitude': latitude.toString(),
      'Longitude': longitude.toString(),
      'Status': status,
    };
  }
}
