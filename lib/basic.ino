#include "secrets.h"
#include <WiFi.h>
#include <Firebase.h>
#include <TinyGPS++.h>
#include <HardwareSerial.h>

Firebase fb(REFERENCE_URL);
TinyGPSPlus gps;
HardwareSerial gpsSerial(1);  // Use UART1 (RX: 16, TX: 17)

void setup() {
  Serial.begin(115200);
  gpsSerial.begin(9600, SERIAL_8N1, 16, 17);  // GPS RX=16, TX=17

  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi");

  Serial.println("Firebase Initialized");
}

void loop() {
  while (gpsSerial.available() > 0) {
    gps.encode(gpsSerial.read());

    if (gps.location.isUpdated()) {
      String latStr = String(gps.location.lat(), 6);  // 6 decimal places
      String lngStr = String(gps.location.lng(), 6);  // 6 decimal places

      Serial.print("Latitude: ");
      Serial.print(latStr);
      Serial.print(", Longitude: ");
      Serial.println(lngStr);

      // Store in Firebase as STRING to preserve full precision
      fb.setString("GPS/Latitude", latStr);
      fb.setString("GPS/Longitude", lngStr);
      fb.setString("GPS/Status", "Updated");

      Serial.println("GPS data sent to Firebase!");
      delay(2000);  // Send data every 2 seconds
    }
  }
}

