import 'dart:developer';
import 'package:geolocator/geolocator.dart';

Future<void> requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    log("⚠️ Location permission is permanently denied.");
    return;
  }

  fetchLocation();
}

Future<void> fetchLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    log("⚠️ Location services are disabled.");
    return;
  }

  LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high, // Adjust accuracy as needed
    distanceFilter: 10, // Minimum distance (in meters) before update
  );

  Position position = await Geolocator.getCurrentPosition(
    locationSettings: locationSettings,
  );

  log("📍 User Location: ${position.latitude}, ${position.longitude}");
}
