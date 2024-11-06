import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

late Size screenSize;

CameraPosition? cameraPosition;

Future<CameraPosition?> getUserLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    Position currentPosition = await Geolocator.getCurrentPosition();
    return CameraPosition(
      zoom: 14,
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
    );
  }
  return null;
}
