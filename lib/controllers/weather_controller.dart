
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../db/local_database.dart';
import '../models/weather_model_class.dart';
import '../services/internet_service.dart';
import '../services/network_services.dart';
import '../utils/location_class.dart';

class WeatherController extends GetxController {
    LocationService locationService=LocationService();

    var weather = WeatherModel(
      cloudPct: 0,
      temp: 0,
      feelsLike: 0,
      humidity: 0,
      minTemp: 0,
      maxTemp: 0,
      windSpeed: 0,
      windDegrees: 0,
      sunrise: 0,
      sunset: 0,

    ).obs;
  var isLoading = false.obs;
  var location ="".obs;
  var isCelsius = true.obs;

  final WeatherService _service = WeatherService();
/// fetch the weather data using the lat long
  Future<void> fetchWeatherByCoords() async {
    try {
      isLoading(true);
      var connectivityResult = await Connectivity().checkConnectivity();
      if(connectivityResult[0] == ConnectivityResult.none) {
        var localData = await LocalDatabase.getWeatherData();
        print(localData);
        if (localData != null) {
          weather(localData);
        } else {
          Get.snackbar("Error", "No internet connection and no local data available.");
        }
      }else{
        print("else block");
        try{
          final position = await LocationService.getCurrentLocation();
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            location.value =
            '${place.subLocality},${place.locality}, ${place.country}';
          }
          final data = await _service.fetchWeatherByCoords(
              position.latitude, position.longitude);
          print(data);
          if(data != null){
            weather(WeatherModel.fromJson(data));
            print(weather);
           await LocalDatabase.saveWeatherData(weather.value);

          }else{
            Get.snackbar("Error", "Failed to fetch data from API.");

          }
        }catch(e){
          Get.snackbar("Error", "An error occurred: $e");

        }

      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  /// fetch the data using the name of location and converted into lat long
  Future<void> fetchWeatherByCity(String cityName) async {
    try {

      isLoading(true);
      var connectivityResult = await Connectivity().checkConnectivity();
      if(connectivityResult[0] == ConnectivityResult.none) {
        var localData = await LocalDatabase.getWeatherData();
        print(localData);
        if (localData != null) {
          weather(localData);
          print(weather);
        } else {
          Get.snackbar("Error", "No internet connection and no local data available.");
        }
      }else {
        List<Location> locations = await locationFromAddress(cityName);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            locations[0].latitude, locations[0].longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          location.value =
          ' ${place.subLocality},${place.locality}, ${place.country}';
        }

        final data = await _service.fetchWeatherByCoords(
            locations[0].latitude, locations[0].longitude);
        if(data !=null) {
          weather(WeatherModel.fromJson(data));
          await LocalDatabase.saveWeatherData(weather.value);
        }else{
          Get.snackbar("Error", "Failed to fetch data from API.");

        }
      }
    } catch (e) {
      final cachedWeather = await LocalDatabase.getWeatherData();
      if (cachedWeather != null) {
        weather(cachedWeather);
      }
    } finally {
      isLoading(false);
    }
  }
}
