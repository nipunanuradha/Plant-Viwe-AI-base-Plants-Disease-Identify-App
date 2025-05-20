# Plant View AI: Plant & Disease Identifier

Plant View AI is a cross-platform Flutter application designed to help users identify plants and diagnose plant diseases using AI, manage plant care with reminders, explore plant information, check weather conditions, and learn with quizzes. The app leverages machine learning, computer vision, and cloud technologies to provide a comprehensive plant care assistant for gardeners, students, and plant enthusiasts.

---

## 🌱 Project Overview

**Plant View AI** enables users to:
- Instantly identify plant species and detect diseases from images using AI/ML.
- Explore detailed plant care guides for vegetables, fruits, and flowers.
- Set personalized reminders for watering, fertilizing, and other plant care tasks.
- Check live weather and compass data for optimal plant care decisions.
- Test and expand plant knowledge with interactive quizzes.
- Manage user accounts securely with Firebase authentication.

---

## 🚀 Features

- **AI Plant & Disease Identification**: Upload or capture plant images to identify species and diagnose diseases using a backend ML model.
- **Plant Encyclopedia**: Browse categorized plant info (vegetables, fruits, flowers) with care tips, environmental needs, and images.
- **Disease Prediction by Conditions**: Predict plant diseases by entering environmental parameters (temperature, humidity, pH, etc.).
- **Reminders & Notifications**: Schedule and manage reminders for plant care tasks with local notifications.
- **Weather & Compass**: Get real-time weather data and compass heading for your location to optimize plant care.
- **Light Condition Detector**: Use the camera to analyze ambient light and determine suitability for plant growth.
- **Interactive Quizzes**: Learn and test your plant knowledge with fun, educational quizzes.
- **User Authentication**: Register and log in securely with Firebase Auth; user data stored in Firestore.
- **Modern UI/UX**: Clean, responsive, and animated interface with Material Design.

---

## 🛠️ Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Firebase Project](https://firebase.google.com/)
- Python backend for AI/ML model (Flask or FastAPI, not included in this repo)

### Installation
1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd my_app
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure Firebase:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective folders.
   - Update `firebase_options.dart` as needed.
4. **Run the app:**
   ```bash
   flutter run
   ```
5. **(Optional) Start the AI/ML backend:**
   - Ensure your Python server for plant/disease prediction is running and accessible at the configured endpoint (default: `http://10.0.2.2:5000/`).

---

## 📦 Dependencies

- Flutter SDK ^3.5.3
- firebase_core, firebase_auth, cloud_firestore
- http, image_picker, permission_handler
- flutter_local_notifications, shared_preferences
- flutter_animate, animated_text_kit
- camera, sensors_plus, location, flutter_compass
- cupertino_icons, fluttertoast, timezone, flutter_datetime_picker_plus

See `pubspec.yaml` for the full list and versions.

---

## 📁 Folder Structure

```
my_app/
├── lib/
│   ├── main.dart                # App entry point
│   ├── navigation.dart          # Main navigation (bottom nav)
│   ├── PlantClassifierApp.dart  # AI plant/disease classifier
│   ├── DeleteDiseaseRecordPage.dart # Disease prediction by conditions
│   ├── PlantCategoryPage.dart   # Plant encyclopedia (categories)
│   ├── PlantDetailPage.dart     # Plant detail info
│   ├── RemindersPage.dart       # Plant care reminders
│   ├── WeatherCheckPage.dart    # Weather and compass
│   ├── CameraLightDetectorPage.dart # Light condition detector
│   ├── quiz_page.dart           # Plant knowledge quiz
│   ├── LoginPage.dart, register.dart # Auth screens
│   ├── settings_page.dart       # User settings & options
│   ├── screen.dart              # Splash screen
│   └── ...
├── assets/images/               # Plant and UI images
├── pubspec.yaml                 # Dependencies & assets
└── ...
```

---

## 🤖 AI/ML Backend
- The app expects a Python-based backend (Flask/FastAPI) for image-based plant and disease prediction.
- Endpoints:
  - `/predict` for plant classification
  - `/disease_api/predict` for disease prediction by conditions
- Ensure the backend is running and accessible from your device/emulator.

---

## 🔒 Authentication & Data
- Uses Firebase Authentication for user login/registration.
- User data and reminders are stored in Firestore and local storage.

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Please open an issue or submit a pull request.

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## 📬 Contact

For questions, feedback, or support, contact:
- Anuradha Nipun Athukorala (Project Owner)
- Email: nipunanuradha33@gmail.com
- [LinkedIn](http://www.linkedin.com/in/anuradha-athukorala)

---

_Developed with Flutter, Firebase, and AI/ML for a greener tomorrow!_
