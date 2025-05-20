import 'package:flutter/material.dart';
import 'PlantDetailPage.dart';

class PlantCategoryPage extends StatefulWidget {
  const PlantCategoryPage({super.key});

  @override
  State<PlantCategoryPage> createState() => _PlantCategoryPageState();
}

class _PlantCategoryPageState extends State<PlantCategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> vegetables = [
    {
      "name": "Carrot",
      "description": "Rich in Vitamin A.",
      "temperature": "16-21°C",
      "humidity": "High",
      "water": "Moderate",
      "sunlight": "Full Sun",
      "image": "assets/images/carrot.jpg"
    },
    {
      "name": "Tomato",
      "description": "Rich in lycopene and powerful antioxidant.",
      "temperature": "20-27°C",
      "humidity": "Moderate",
      "water": "Frequent",
      "sunlight": "Full Sun",
      "image": "assets/images/tomato.jpg"
    },
    {
      "name": "Pumpkin",
      "description": " Large gourd rich in fiber and beta-carotene.",
      "temperature": "21-30°C",
      "humidity": "Moderate",
      "water": "Frequent",
      "sunlight": "Full Sun",
      "image": "assets/images/Pumpkin.jpg"
    },
    {
      "name": "Cabbage",
      "description": "Leafy vegetable rich in Vitamin K and C.",
      "temperature": "10-24°C",
      "humidity": "Moderate",
      "water": "Regular",
      "sunlight": "Full Sun",
      "image": "assets/images/Cabbage.jpg"
    },
    {
      "name": "Beetroot",
      "description": "Iron-rich root packed with antioxidants.",
      "temperature": "15-25°C",
      "humidity": "Moderate",
      "water": "Moderate",
      "sunlight": "Full Sun",
      "image": "assets/images/beetroot.jpg"
    },
    {
      "name": "Cucumbers",
      "description": "Water-rich fruit often used as a vegetable.",
      "temperature": "18-30°C",
      "humidity": "High",
      "water": "Frequent",
      "sunlight": "Full Sun",
      "image": "assets/images/Cucumbers.jpg"
    },
    // (Add more plants here as needed...)
  ];

  final List<Map<String, String>> fruits = [
    {
      "name": "Apple",
      "description": "Crisp fruit high in fiber and vitamin C.",
      "temperature": "7-24°C",
      "humidity": "Moderate",
      "water": "Regular",
      "sunlight": "Full Sun",
      "image": "assets/images/apple.jpg"
    },
    {
      "name": "Banana",
      "description": "Tropical fruit rich in potassium.",
      "temperature": "26-30°C",
      "humidity": "High",
      "water": "Frequent",
      "sunlight": "Full Sun",
      "image": "assets/images/banana.png"
    },
    {
      "name": "Cherry",
      "description": "Sweet or tart fruit high in antioxidants.",
      "temperature": "16-27°C",
      "humidity": "Moderate",
      "water": "Moderate",
      "sunlight": "Full Sun",
      "image": "assets/images/Cherry.jpg"
    },
    {
      "name": "Papaya",
      "description": "Tropical fruit rich in vitamin C and enzymes.",
      "temperature": "22-33°C",
      "humidity": "High",
      "water": "Regular",
      "sunlight": "Full Sun",
      "image": "assets/images/Papaya.jpg"
    },
    {
      "name": "Strawberry",
      "description": "Vitamin C -rich red berry.",
      "temperature": "15-25°C",
      "humidity": "Moderate",
      "water": "Regular",
      "sunlight": "Full Sun",
      "image": "assets/images/Strawberry.jpg"
    },
    {
      "name": "Grapes",
      "description": "Fruit used for wine and fresh consumption.",
      "temperature": "15-30°C",
      "humidity": "Moderate",
      "water": "Regular",
      "sunlight": "Full Sun",
      "image": "assets/images/grapes.jpg"
    },
    // (Add more fruits here as needed...)
  ];
  final List<Map<String, String>> flowers = [
    {
      "name": "Rose",
      "description": "Symbolic and fragrant flower.",
      "temperature": "15-28°C",
      "humidity": "Moderate",
      "water": "Regular",
      "sunlight": "Full Sun",
      "image": "assets/images/rose.jpg"
    },
    {
      "name": "SunFlower",
      "description": "Tall, sun-tracking yellow flower.",
      "temperature": "18-30°C",
      "humidity": "Moderate",
      "water": "Regular",
      "sunlight": "Full Sun",
      "image": "assets/images/sunflower.jpg"
    },
    {
      "name": "Hydrangea",
      "description": "Color-changing shrub with clustered blooms.",
      "temperature": "13-24°C",
      "humidity": "High",
      "water": "Regular",
      "sunlight": "Partial-Sun ",
      "image": "assets/images/Hydrangea.jpg"
    },
    {
      "name": "Lavender",
      "description": "Aromatic herb used in perfumes and oils.",
      "temperature": "15-30°C",
      "humidity": "Moderate",
      "water": "Low",
      "sunlight": "Full Sun",
      "image": "assets/images/lavender.jpg"
    },
    {
      "name": "Daisy",
      "description": "Symbol of purity and innocence.",
      "temperature": "15-25°C",
      "humidity": "Moderate",
      "water": "Moderate",
      "sunlight": "Full Sun",
      "image": "assets/images/daisy.jpg"
    },
    {
      "name": "Orchid",
      "description": "Elegant indoor flower with intricate blooms.",
      "temperature": "18-30°C",
      "humidity": "High",
      "water": "Frequent",
      "sunlight": "Full Sun",
      "image": "assets/images/orchid.jpg"
    },
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildPlantCard(Map<String, String> plant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlantDetailPage(
                plant: plant, commonImage: plant["image"] ?? ""),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.green.shade50,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: plant['name']!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    plant["image"] ?? "",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                plant['name']!,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 6),
              Text(
                plant['description']!,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoIcon(Icons.thermostat, plant['temperature']!),
                  _infoIcon(Icons.water_drop, plant['humidity']!),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoIcon(Icons.opacity, plant['water']!),
                  _infoIcon(Icons.wb_sunny_outlined, plant['sunlight']!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Plant Categories',
            style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.eco_outlined), text: "Vegetables"),
            Tab(icon: Icon(Icons.local_florist_outlined), text: "Fruits"),
            Tab(icon: Icon(Icons.filter_vintage_outlined), text: "Flowers"),
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vegetables.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return _buildPlantCard(vegetables[index]);
            },
          ),
          GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: fruits.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return _buildPlantCard(fruits[index]);
            },
          ),
          GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: flowers.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return _buildPlantCard(flowers[index]);
            },
          ),
        ],
      ),
    );
  }
}
