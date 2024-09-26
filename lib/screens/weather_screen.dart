import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mininal_weather__app/models/weather_model.dart';
import 'package:mininal_weather__app/services/weather_services.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // api key
  final weatherServices = WeatherServices("113c8a7667f8bfff184d8d5ea059e0b2");
  WeatherModel? _weatherModel;

  //fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await weatherServices.getCurrentCity();

    // get weather for city
    try {
      final weather = await weatherServices.getWeather(cityName);
      setState(() {
        _weatherModel = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sun.json";

    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/cloud.json";
      case "rain":
      case "drizzle":
      case "shower rain":
      case "thunderstorm":
        return "assets/rainandthunder.json";
      case "clear":
        return "assets/sun.json";
      default:
        return "assets/sun.json";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "My Location",
              style: TextStyle(fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on),
                const SizedBox(
                  width: 5,
                ),
                Text(_weatherModel?.cityName ?? "Loading City ...."),
              ],
            ),
            Lottie.asset(getWeatherAnimation(_weatherModel?.mainCondition)),
            Text(
              '${_weatherModel?.temperature.round()}°C',
              style: TextStyle(fontSize: 40),
            ),
            Text(_weatherModel?.mainCondition ?? ""),
          ],
        ),
      ),
    );
  }
}
