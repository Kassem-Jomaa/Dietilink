import 'package:get/get.dart';
import '../services/chatbot_service.dart';
import '../controllers/chatbot_controller.dart';

class ChatbotBinding extends Bindings {
  @override
  void dependencies() {
    // Register chatbot service
    Get.lazyPut<ChatbotService>(
      () => ChatbotService(),
      fenix: true,
    );

    // Register chatbot controller
    Get.lazyPut<ChatbotController>(
      () => ChatbotController(),
      fenix: true,
    );
  }
}
