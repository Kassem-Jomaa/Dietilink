import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple test to verify chatbot connection
void main() async {
  print('🔍 Testing chatbot connection...');

  // Test 1: Health check
  print('\n1. Testing health endpoint...');
  try {
    final healthResponse = await http.get(
      Uri.parse('http://10.0.2.2:8000/health'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 5));

    if (healthResponse.statusCode == 200) {
      final data = json.decode(healthResponse.body);
      print('✅ Health check passed: ${data['status']}');
    } else {
      print('❌ Health check failed: ${healthResponse.statusCode}');
    }
  } catch (e) {
    print('❌ Health check error: $e');
  }

  // Test 2: Chat endpoint
  print('\n2. Testing chat endpoint...');
  try {
    final chatResponse = await http
        .post(
          Uri.parse('http://10.0.2.2:8000/chat'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'message': 'Hello, test message',
            'timestamp': DateTime.now().toIso8601String(),
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (chatResponse.statusCode == 200) {
      final data = json.decode(chatResponse.body);
      print('✅ Chat test passed: ${data['response']?.substring(0, 50)}...');
    } else {
      print('❌ Chat test failed: ${chatResponse.statusCode}');
      print('Response: ${chatResponse.body}');
    }
  } catch (e) {
    print('❌ Chat test error: $e');
  }

  print('\n🎯 Connection test completed!');
}
