import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/utils/location_class.dart';
import 'package:weather_app/views/home_screen.dart';

import 'controllers/internet_controller.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  Get.put(InternetController(), permanent: true);
  LocationService.requestLocationPermission();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => HomeWeatherScreen()),
    ],
  ));
}
