# Chatbot Module

A comprehensive AI-powered health assistant module for the DietiHealth app.

## 📁 Directory Structure

```
lib/modules/chatbot/
├── bindings/
│   └── chatbot_binding.dart          # Dependency injection
├── controllers/
│   └── chatbot_controller.dart       # Business logic & state management
├── models/
│   ├── chat_message.dart             # Message data model
│   └── chat_response.dart            # Response data model
├── services/
│   └── chatbot_service.dart          # API communication
├── views/
│   └── chatbot_view.dart             # Main UI screen
├── widgets/
│   ├── chat_bubble.dart              # Individual message widget
│   └── message_input.dart            # Message input widget
├── utils/                            # Utility functions (future)
├── chatbot_module.dart               # Module exports
└── README.md                         # This file
```

## 🚀 Features

### Core Functionality
- **Real-time Chat**: Interactive conversation with AI health assistant
- **Meal Plan Integration**: Access and discuss current meal plans
- **Nutrition Advice**: Get personalized dietary recommendations
- **Appointment Booking**: Schedule consultations via chat
- **Quick Replies**: Pre-defined response options for common queries

### AI Capabilities
- **Context Awareness**: Remembers conversation history and user preferences
- **Meal Plan Context**: Automatically includes current meal plan information
- **Intent Recognition**: Understands user intent and provides relevant responses
- **Multi-modal Support**: Text, quick replies, and structured data

### User Experience
- **Typing Indicators**: Visual feedback when AI is processing
- **Message History**: Persistent chat history across sessions
- **Error Handling**: Graceful error handling with retry options
- **Responsive Design**: Adapts to different screen sizes

## 🔧 Usage

### Basic Implementation

```dart
import 'package:get/get.dart';
import 'modules/chatbot/chatbot_module.dart';

// Navigate to chatbot
Get.toNamed(Routes.CHATBOT);

// Or use the view directly
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const ChatbotView()),
);
```

### Using the Controller

```dart
final controller = Get.find<ChatbotController>();

// Send a message
await controller.sendMessage("What's for breakfast today?");

// Get nutrition advice
await controller.getNutritionAdvice(
  userContext: "I'm trying to lose weight",
  preferences: {"diet": "vegetarian"}
);

// Check AI model version
await controller.checkModelVersion();
```

### Using the Service Directly

```dart
final service = Get.find<ChatbotService>();

// Send message with meal plan context
final response = await service.sendMessage("Show me my meal plan");

// Get chat history
final history = await service.getChatHistory();

// Generate meal plan
final mealPlan = await service.generateMealPlan(
  requirements: {"calories": 2000, "protein": 150},
  dietaryRestrictions: "vegetarian"
);
```

## 🍽️ Meal Plan Integration

The chatbot automatically integrates with your meal plan data:

```dart
// Ask about specific meals
"What's for breakfast?"
"Show me lunch options"
"What snacks do I have today?"

// Get meal plan overview
"What's my current meal plan?"
"Show me my meal plan"

// Get nutrition information
"How many calories in my breakfast?"
"What's the protein content of my lunch?"
```

## 🔌 API Endpoints

The chatbot service communicates with these endpoints:

- `POST /chat` - Send message
- `GET /chat/history` - Get chat history
- `DELETE /chat/history` - Clear chat history
- `POST /nutrition/advice` - Get nutrition advice
- `POST /nutrition/meal-plan` - Generate meal plan
- `POST /appointments/book` - Book appointment
- `GET /chat/model-info` - Get AI model version
- `GET /chat/model-updates` - Check for updates

## 🎨 Customization

### Styling
The chatbot uses the app's theme system. Customize colors in `AppTheme`:

```dart
// In core/theme/app_theme.dart
class AppTheme {
  static const Color primary = Color(0xFF4CAF50);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  // ... other colors
}
```

### Adding Quick Replies
```dart
final quickReplies = [
  {'text': 'Get nutrition advice', 'action': 'nutrition_advice'},
  {'text': 'Show meal plan', 'action': 'show_meal_plan'},
  {'text': 'Book appointment', 'action': 'book_appointment'},
];
```

## 🧪 Testing

Run the chatbot tests:

```bash
flutter test lib/modules/chatbot/
```

## 📱 Navigation

The chatbot can be accessed from:

1. **Dashboard**: Floating action button (chat icon)
2. **More Menu**: "AI Health Assistant" option
3. **Direct Route**: `Get.toNamed(Routes.CHATBOT)`

## 🔒 Security

- All API calls include authentication headers
- User data is encrypted in transit
- Chat history is user-specific
- No sensitive data is stored locally

## 🚀 Future Enhancements

- [ ] Voice input/output
- [ ] Image recognition for food
- [ ] Multi-language support
- [ ] Offline mode
- [ ] Chat export functionality
- [ ] Integration with health devices
- [ ] Advanced analytics and insights

## 📞 Support

For issues or questions about the chatbot module:

1. Check the logs for error messages
2. Verify API connectivity
3. Ensure proper dependency injection
4. Review the meal plan integration

## 📄 License

This module is part of the DietiHealth app and follows the same licensing terms. 