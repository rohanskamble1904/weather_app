/// to convert the temperature
String convertTemperature(double temperature, bool isCelsius ) {
  if (isCelsius) {
    return temperature.toStringAsFixed(1);
  } else {
    double fahrenheit = (temperature * 1.8) + 32;
    return fahrenheit.toStringAsFixed(1);
  }
}