import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlantClassifierPage extends StatefulWidget {
  @override
  _PlantClassifierPageState createState() => _PlantClassifierPageState();
}

class _PlantClassifierPageState extends State<PlantClassifierPage> {
  File? _image;
  String? _prediction;
  bool _loading = false;

  Future<void> _pickImage() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission denied.')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = null;
      });
    }
  }

  Future<void> _scanWithCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission denied.')),
      );
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = null;
      });
    }
  }

  Future<void> _predictPlant() async {
    if (_image == null) return;

    setState(() {
      _loading = true;
      _prediction = null;
    });

    final uri = Uri.parse("http://10.0.2.2:5000/predict");

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    try {
      final response = await request.send();
      final result = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        setState(() => _prediction =
            "${result["predicted_class"]} (Index: ${result["class_index"]})");
      } else {
        setState(() => _prediction = result["error"] ?? "Unknown error");
      }
    } catch (e) {
      setState(() => _prediction = "Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('🌿 Plant Classifier'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Plant Classifier',
              applicationVersion: '1.0.0',
              children: [
                Text("Upload a plant image to detect health status."),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "🌱 Upload a Plant Image",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ).animate().fadeIn(),
            SizedBox(height: 5),
            Text(
              "Let AI help you detect plant diseases.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.green[700]),
            ),
            SizedBox(height: 20),
            if (_image != null)
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                      image: FileImage(_image!), fit: BoxFit.cover),
                ),
              ).animate().fadeIn(duration: 600.ms),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.image, color: Colors.white),
              label: Text("Pick Image from Gallery",
                  style: TextStyle(color: Colors.white)),
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: StadiumBorder(),
              ),
            ).animate().slideX(),
            SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
              label: Text("Scan with Camera",
                  style: TextStyle(color: Colors.white)),
              onPressed: _scanWithCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: StadiumBorder(),
              ),
            ).animate().slideX(),
            SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(Icons.eco_outlined, color: Colors.white),
              label: _loading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ))
                  : Text("Classify Plant",
                      style: TextStyle(color: Colors.white)),
              onPressed: _loading ? null : _predictPlant,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[900],
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: StadiumBorder(),
              ),
            ).animate().slideX(),
            SizedBox(height: 25),
            if (_prediction != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade700),
                ),
                child: Row(
                  children: [
                    Icon(Icons.health_and_safety,
                        color: Colors.green[800], size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text("Prediction: $_prediction",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green[900])),
                    ),
                  ],
                ),
              ).animate().fadeIn().scale(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
