import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class WeatherCheckPage extends StatefulWidget {
  const WeatherCheckPage({super.key});

  @override
  State<WeatherCheckPage> createState() => _WeatherCheckPageState();
}

class _WeatherCheckPageState extends State<WeatherCheckPage> {
  double? temperature;
  int? humidity;
  double? windSpeed;
  double? pressure;
  int? precipitationProbability;
  int? weatherCode;
  String? time;
  String locationText = "Detecting location...";
  bool isLoading = true;
  double? heading;

  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();
    _initCompass();
    _fetchLocationAndWeather();
  }

  Future<void> _initCompass() async {
    final hasPermission = await _locationService.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      await _locationService.requestPermission();
    }

    FlutterCompass.events?.listen((event) {
      if (!mounted) return;
      setState(() => heading = event.heading);
    });
  }

  Future<void> _fetchLocationAndWeather() async {
    try {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          setState(() {
            locationText = "Location service disabled.";
            isLoading = false;
          });
          return;
        }
      }

      PermissionStatus permissionGranted =
          await _locationService.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            locationText = "Location permission denied.";
            isLoading = false;
          });
          return;
        }
      }

      final locationData = await _locationService.getLocation();

      double lat = locationData.latitude ?? 6.9271;
      double lon = locationData.longitude ?? 79.8612;

      setState(() {
        locationText = "";
      });

      final uri = Uri.parse(
        'https://api.tomorrow.io/v4/weather/forecast?location=$lat,$lon&apikey=tQlOSTbITf9P0ZkkmiRBjg9AZmwwLTZb',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latest = data["timelines"]["minutely"][0]["values"];

        setState(() {
          temperature = latest["temperature"];
          humidity = latest["humidity"];
          windSpeed = latest["windSpeed"];
          pressure = latest["pressureSeaLevel"];
          precipitationProbability = latest["precipitationProbability"];
          weatherCode = latest["weatherCode"];
          time = data["timelines"]["minutely"][0]["time"];
          isLoading = false;
        });
      } else {
        setState(() {
          locationText = "Weather fetch failed.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        locationText = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Weather + Compass"),
        backgroundColor: Colors.green.shade800,
        automaticallyImplyLeading: false, // 🔒 Hides the back button
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Text(locationText,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500)),
                  if (time != null)
                    Text("Updated: $time",
                        style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  if (heading != null)
                    Center(
                      child: Column(
                        children: [
                          const Text("Heading",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Transform.rotate(
                            angle: -((heading ?? 0) * (math.pi / 180)),
                            child: Icon(Icons.navigation,
                                size: 100, color: Colors.orange),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  _weatherCard("🌡️ Temperature",
                      "${temperature?.toStringAsFixed(1)} °C"),
                  _weatherCard("💧 Humidity", "$humidity%"),
                  _weatherCard("🌬️ Wind Speed", "$windSpeed km/h"),
                  _weatherCard("🌡️ Pressure", "$pressure hPa"),
                  _weatherCard(
                      "🌧️ Precipitation", "$precipitationProbability%"),
                  _weatherCard("🔢 Weather Code", "$weatherCode"),
                ],
              ),
            ),
    );
  }

  Widget _weatherCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.wb_cloudy),
        title: Text(label),
        trailing: Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
