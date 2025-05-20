import 'package:flutter/material.dart';

class PlantDetailPage extends StatelessWidget {
  final Map<String, String> plant;
  final String commonImage;

  const PlantDetailPage(
      {super.key, required this.plant, required this.commonImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:
            Text(plant['name']!, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Hero(
              tag: plant['name']!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  commonImage,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              plant['description']!,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _infoRow(Icons.thermostat, "Temperature", plant['temperature']!),
            _infoRow(Icons.water_drop, "Humidity", plant['humidity']!),
            _infoRow(Icons.opacity, "Water", plant['water']!),
            _infoRow(Icons.wb_sunny_outlined, "Sunlight", plant['sunlight']!),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 12),
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
