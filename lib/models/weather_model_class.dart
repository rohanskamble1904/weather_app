class WeatherModel {
  var cloudPct;
  var temp;
  var feelsLike;
  var humidity;
  var minTemp;
  var maxTemp;
  var windSpeed;
  var windDegrees;
  var sunrise;
  var sunset;

  WeatherModel(
      {this.cloudPct,
        this.temp,
        this.feelsLike,
        this.humidity,
        this.minTemp,
        this.maxTemp,
        this.windSpeed,
        this.windDegrees,
        this.sunrise,
        this.sunset});

  WeatherModel.fromJson(Map<String, dynamic> json) {
    cloudPct = json['cloud_pct'];
    temp = json['temp'];
    feelsLike = json['feels_like'];
    humidity = json['humidity'];
    minTemp = json['min_temp'];
    maxTemp = json['max_temp'];
    windSpeed = json['wind_speed'];
    windDegrees = json['wind_degrees'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cloud_pct'] = this.cloudPct;
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['humidity'] = this.humidity;
    data['min_temp'] = this.minTemp;
    data['max_temp'] = this.maxTemp;
    data['wind_speed'] = this.windSpeed;
    data['wind_degrees'] = this.windDegrees;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    return data;
  }
  Map<String, dynamic> toMap() {
    return {
      'cloud_pct': cloudPct?.toDouble(),
      'temp': temp?.toDouble(),
      'feels_like': feelsLike?.toDouble(),
      'humidity': humidity?.toDouble(),
      'min_temp': minTemp?.toDouble(),
      'max_temp': maxTemp?.toDouble(),
      'wind_speed': windSpeed.toDouble(),
      'wind_degrees': windDegrees?.toDouble(),
      'sunrise': sunrise?.toDouble(),
      'sunset': sunset?.toDouble(),
    };
  }
}
