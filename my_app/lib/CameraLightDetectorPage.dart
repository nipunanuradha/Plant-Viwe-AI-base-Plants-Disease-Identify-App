import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraLightDetectorPage extends StatefulWidget {
  const CameraLightDetectorPage({super.key});

  @override
  State<CameraLightDetectorPage> createState() =>
      _CameraLightDetectorPageState();
}

class _CameraLightDetectorPageState extends State<CameraLightDetectorPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  String _plantCondition = "Loading...";
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.low,
        enableAudio: false,
      );
      await _controller!.initialize();
      setState(() {});
      _startAnalyzingLight();
    }
  }

  void _startAnalyzingLight() {
    _controller?.startImageStream((CameraImage image) {
      if (_isProcessing) return;
      _isProcessing = true;

      double avgBrightness = _calculateAverageBrightness(image);
      _updatePlantCondition(avgBrightness);

      Future.delayed(const Duration(seconds: 1), () {
        _isProcessing = false;
      });
    });
  }

  double _calculateAverageBrightness(CameraImage image) {
    int total = 0;
    int count = 0;

    // Analyze Y (luminance) plane
    final bytes = image.planes[0].bytes;
    for (int i = 0; i < bytes.length; i += 100) {
      total += bytes[i];
      count++;
    }
    return total / count;
  }

  void _updatePlantCondition(double brightness) {
    setState(() {
      if (brightness < 50) {
        _plantCondition = "Too dark for plants 🌑";
      } else if (brightness >= 50 && brightness < 180) {
        _plantCondition = "Good light for plants 🌱☀️";
      } else {
        _plantCondition = "Too bright! ☀️🔥";
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("Camera Light Detector"),
        backgroundColor: Colors.green.shade700,
      ),
      body: _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: CameraPreview(_controller!),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Current Light Condition for Plants:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _plantCondition,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
