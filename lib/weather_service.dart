import 'package:weather/weather.dart';

class WeatherService {
  static const apiKey = '27385a66f20784f3fa4c52d21b4d62a7';
  static final weather = WeatherFactory(apiKey);

  static Future<double?> getTemp(String country) async {
    try {
      final currentWeather = await weather.currentWeatherByCityName(country);
      return currentWeather.temperature!.celsius;
    } catch (e) {
      print('Error in temp');
      return null;
    }
  }

  static Future<List<Weather>> getCast(String country) async {
    try {
      final List<Weather> fivedayForecast =
          await weather.fiveDayForecastByCityName(country);
      return fivedayForecast;
    } catch (e) {
      print('Error in temp');
      return [];
    }
  }
}
