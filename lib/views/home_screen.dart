import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:weather_app/utils/location_class.dart';
import '../controllers/weather_controller.dart';
import '../services/internet_service.dart';
import '../utils/common_method/convert_temp.dart';
import '../utils/common_widgets/weather_card.dart';

class HomeWeatherScreen extends StatefulWidget {
  @override
  State<HomeWeatherScreen> createState() => _HomeWeatherScreenState();
}

class _HomeWeatherScreenState extends State<HomeWeatherScreen> {
  final WeatherController _controller = Get.put(WeatherController());
  final TextEditingController _searchController = TextEditingController();
  var connectivityResult;
  @override
  void initState() {
    _controller.fetchWeatherByCoords();
    getValue();
    super.initState();
  }

  getValue() async {
    connectivityResult = await hasInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final weather = _controller.weather.value;
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.lightBlueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          hintText: "Search city",
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (value) {
                          _searchController.clear();
                          _controller.fetchWeatherByCity(value);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Location",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _controller.location.value,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                _controller.fetchWeatherByCoords();
                              },
                              child: Icon(Icons.location_on,
                                  color: Colors.white, size: 32)),
                        ],
                      ),
                      SizedBox(height: 20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${weather.temp}°",
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Feels Like ${weather.feelsLike}°",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                              Text(
                                "Humidity: ${weather.humidity}%",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 40),

                      // Weather Details
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WeatherDetail(
                                  icon: Icons.thermostat_outlined,
                                  label: "Min Temp",
                                  value: "${weather.minTemp}°",
                                ),
                                WeatherDetail(
                                  icon: Icons.thermostat,
                                  label: "Max Temp",
                                  value: "${weather.maxTemp}°",
                                ),
                                WeatherDetail(
                                  icon: Icons.cloud_outlined,
                                  label: "Clouds",
                                  value: "${weather.cloudPct}%",
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WeatherDetail(
                                  icon: Icons.air,
                                  label: "Wind Speed",
                                  value: "${weather.windSpeed} m/s",
                                ),
                                WeatherDetail(
                                  icon: Icons.navigation_outlined,
                                  label: "Wind Dir",
                                  value: "${weather.windDegrees}°",
                                ),
                                WeatherDetail(
                                  icon: Icons.water_drop_outlined,
                                  label: "Humidity",
                                  value: "${weather.humidity}%",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Celsius', style: TextStyle(fontSize: 16)),
                          Switch(
                            value: _controller.isCelsius.value,
                            onChanged: (value) async {
                              _controller.isCelsius.value = value;
                            },
                          ),
                          Text('Fahrenheit', style: TextStyle(fontSize: 16)),
                        ],
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Temperature: ${convertTemperature(weather.temp.toDouble(), _controller.isCelsius.value)}° ${_controller.isCelsius.value ? 'C' : 'F'}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),
                      if (connectivityResult)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                'Make sure your internet is connected!',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}





