import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  void _fetchWeatherData() {
    setState(() {
      weatherData = _getWeatherData();
    });
  }

  Future<Map<String, dynamic>> _getWeatherData() async {
    final weather = await _getCurrentWeather();
    final forecast = await _getForecast();
    return {
      'weather': weather,
      'forecast': forecast,
    };
  }

  Future<Weather> _getCurrentWeather() async {
    const String cityName = 'Tataouine';
    final key = dotenv.env['OpenWeatherMap_API_key'];
    if (key == null) throw Exception('API key is missing');
    WeatherFactory wf = WeatherFactory(key);
    return await wf.currentWeatherByCityName(cityName);
  }

  Future<List<Weather>> _getForecast() async {
    const String cityName = 'Tataouine';
    final key = dotenv.env['OpenWeatherMap_API_key'];
    if (key == null) throw Exception('API key is missing');
    WeatherFactory wf = WeatherFactory(key);
    return await wf.fiveDayForecastByCityName(cityName);
  }

  Widget _buildWeatherCard(Weather weather) {
    final currentTemperature = weather.temperature?.celsius;
    final currentSky = weather.weatherMain ?? '';
    final weatherIcon = (currentSky == 'Clouds' || currentSky == 'Rain') ? Icons.cloud : Icons.sunny;

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "${currentTemperature?.toStringAsFixed(1)}°C",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Icon(weatherIcon, size: 64),
                const SizedBox(height: 16),
                Text(currentSky, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForecastList(List<Weather> forecast) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: 8,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final hourlyForecast = forecast[index];
          final hourlyTime = DateTime.parse(hourlyForecast.date.toString());
          final hourlyTemperature = hourlyForecast.temperature?.celsius?.toStringAsFixed(1);
          final hourlySky = hourlyForecast.weatherMain;
          final weatherIcon = (hourlySky == 'Clouds' || hourlySky == 'Rain') ? Icons.cloud : Icons.sunny;

          return HourlyForecastItem(
            time: DateFormat.j().format(hourlyTime),
            icon: weatherIcon,
            temperature: "$hourlyTemperature°C",
          );
        },
      ),
    );
  }

  Widget _buildAdditionalInfo(Weather weather) {
    final currentHumidity = weather.humidity?.toStringAsFixed(0);
    final currentWindSpeed = weather.windSpeed?.toString();
    final currentPressure = weather.pressure?.toStringAsFixed(0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AdditionalInfoItem(
          icon: Icons.water_drop,
          label: 'Humidity',
          value: currentHumidity!,
        ),
        AdditionalInfoItem(
          icon: Icons.air,
          label: 'Wind Speed',
          value: currentWindSpeed!,
        ),
        AdditionalInfoItem(
          icon: Icons.beach_access,
          label: 'Pressure',
          value: currentPressure!,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                size: 34,
              ),
              tooltip: 'Refresh',
              onPressed: _fetchWeatherData,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: weatherData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            final data = snapshot.data!;
            final currentWeatherData = data['weather'] as Weather;
            final forecastData = data['forecast'] as List<Weather>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: _buildWeatherCard(currentWeatherData),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildForecastList(forecastData),
                const SizedBox(height: 50),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildAdditionalInfo(currentWeatherData),
              ],
            );
          },
        ),
      ),
    );
  }
}
