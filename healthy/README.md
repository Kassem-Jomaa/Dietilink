# 🥗 DietiLink - Health & Nutrition Management App

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/GetX-8B5CF6?style=for-the-badge&logo=flutter&logoColor=white" alt="GetX">
  <img src="https://img.shields.io/badge/API-REST-FF6B6B?style=for-the-badge" alt="REST API">
</div>

<div align="center">
  <h3>🌱 Transform Your Health Journey with AI-Powered Nutrition Guidance</h3>
  <p>A comprehensive Flutter-based health and nutrition management application that combines personalized meal planning, progress tracking, appointment scheduling, and an intelligent AI chatbot for holistic wellness support.</p>
</div>

---

## ✨ Features

### 🍽️ **Meal Planning & Nutrition**
- **Personalized Meal Plans**: Customized nutrition plans based on your health goals
- **Food Database**: Comprehensive nutritional information and portion tracking
- **Meal Selection**: Interactive meal option selection with detailed nutritional breakdowns
- **Calorie Tracking**: Real-time calorie counting and nutritional analysis

### 📊 **Progress Tracking**
- **Health Metrics**: BMI, weight, and body measurements tracking
- **Visual Analytics**: Interactive charts and progress visualization using FL Chart
- **Goal Setting**: Set and track your health and fitness objectives
- **Historical Data**: View your progress over time with detailed reports

### 📅 **Appointment Management**
- **Dietitian Booking**: Schedule appointments with certified nutritionists
- **Calendar Integration**: Visual calendar with availability checking
- **Appointment History**: Track past and upcoming appointments
- **Reminder System**: Automated appointment reminders and notifications

### 🤖 **AI-Powered Chatbot**
- **Nutrition Advice**: Get instant, personalized nutrition guidance
- **Meal Plan Generation**: AI-assisted meal plan creation
- **Health Q&A**: Ask questions about nutrition, diet, and wellness
- **Smart Recommendations**: Context-aware suggestions based on your profile

### 👤 **User Profile Management**
- **Comprehensive Profiles**: Detailed health and personal information
- **Secure Authentication**: JWT-based authentication with secure storage
- **Profile Customization**: Edit and update your health preferences
- **Multi-language Support**: Available in English and Arabic

---

## 🏗️ Architecture

### **Tech Stack**
- **Frontend**: Flutter (Mobile & Web)
- **State Management**: GetX
- **API Integration**: Dio HTTP Client
- **Local Storage**: Flutter Secure Storage
- **Charts**: FL Chart
- **Internationalization**: Flutter Localizations

### **Project Structure**
```
lib/
├── core/                    # Core utilities and services
│   ├── services/           # API, Auth, Network services
│   ├── theme/              # App theming and styling
│   └── utils/              # Utility functions
├── modules/                # Feature modules
│   ├── auth/               # Authentication
│   ├── profile/            # User profile management
│   ├── meal_plan/          # Meal planning features
│   ├── progress/           # Progress tracking
│   ├── appointments/       # Appointment scheduling
│   ├── chatbot/            # AI chatbot integration
│   └── dashboard/          # Main dashboard
├── routes/                 # App routing configuration
└── translations.dart       # Internationalization
```

---

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (>=3.2.3)
- Dart SDK
- Android Studio / VS Code
- Git

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/Kassem-Jomaa/Dietilink.git
   cd Dietilink
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For mobile devices
   flutter run
   
   # For web
   flutter run -d chrome
   
   # For specific device
   flutter run -d <device-id>
   ```

### **Configuration**

1. **API Configuration**
   - Update API endpoints in `lib/config/api_config.dart`
   - Configure your backend server URLs

2. **Environment Setup**
   - Set up your backend server
   - Configure authentication tokens
   - Set up the Python chatbot server (optional)

---

## 📱 Screenshots

<div align="center">
  <img src="https://via.placeholder.com/300x600/4CAF50/white?text=Dashboard" alt="Dashboard" width="150">
  <img src="https://via.placeholder.com/300x600/2196F3/white?text=Meal+Plans" alt="Meal Plans" width="150">
  <img src="https://via.placeholder.com/300x600/FF9800/white?text=Progress" alt="Progress" width="150">
  <img src="https://via.placeholder.com/300x600/9C27B0/white?text=Chatbot" alt="Chatbot" width="150">
</div>

---

## 🔧 API Integration

### **Endpoints**
- **Authentication**: `/auth/login`, `/auth/register`
- **Profile**: `/profile`, `/profile/update`
- **Meal Plans**: `/meal-plans`, `/meal-plans/current`
- **Progress**: `/progress`, `/progress/entries`
- **Appointments**: `/appointments`, `/appointments/book`
- **Chatbot**: `http://localhost:8000/chat`

### **Authentication**
The app uses JWT-based authentication with secure token storage:
```dart
// Example API call
final response = await ApiService().get('/profile');
```

---

## 🧪 Testing

Run the test suite:
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

---

## 📚 Documentation

- [Appointments Module](Appointments_Module_Detailed_Report.md)
- [Chatbot Module](Chatbot_Module_Detailed_Report.md)
- [Meal Plan Module](Meal_Plan_Module_Detailed_Report.md)
- [Implementation Summary](Appointments_Detailed_Report.md)

---

## 🌍 Internationalization

The app supports multiple languages:
- **English** (Default)
- **Arabic** (العربية)

Language files are located in `assets/i18n/` directory.

---

## 🔒 Security Features

- **Secure Storage**: Sensitive data encrypted using Flutter Secure Storage
- **JWT Authentication**: Token-based authentication with automatic refresh
- **Input Validation**: Comprehensive input sanitization and validation
- **API Security**: Secure API communication with proper error handling

---

## 🚀 Performance Optimizations

- **Lazy Loading**: Efficient data loading with pagination
- **Caching**: Smart caching strategies for better performance
- **Memory Management**: Optimized memory usage for large datasets
- **Background Processing**: Non-blocking operations for better UX

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### **Development Guidelines**
- Follow Flutter/Dart best practices
- Use GetX patterns consistently
- Add tests for new features
- Update documentation as needed

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Kassem Jomaa**
- GitHub: [@Kassem-Jomaa](https://github.com/Kassem-Jomaa)
- Email: [Your Email]

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX for state management
- FL Chart for beautiful charts
- All contributors and testers

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>⭐ Star this repository if you found it helpful!</p>
</div>