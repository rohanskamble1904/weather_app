import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// to get the real time location
class LocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location
    return await Geolocator.getCurrentPosition();
  }

 static Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      print('Location permission granted');
      getCurrentLocation();
    } else if (status.isDenied) {
      print('Location permission denied');

    } else if (status.isPermanentlyDenied) {
      print('Location permission permanently denied');
      await openAppSettings();
    }
  }
}