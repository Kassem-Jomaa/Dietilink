class ChatResponse {
  final String message;
  final String? messageId;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final List<Map<String, dynamic>>? quickReplies;
  final String? intent;
  final double? confidence;
  final Map<String, dynamic>? entities;
  final bool isTyping;
  final String? sessionId;

  ChatResponse({
    required this.message,
    this.messageId,
    required this.timestamp,
    this.metadata,
    this.quickReplies,
    this.intent,
    this.confidence,
    this.entities,
    this.isTyping = false,
    this.sessionId,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message']?.toString() ?? '',
      messageId:
          json['message_id']?.toString() ?? json['messageId']?.toString(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      metadata: json['metadata'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      quickReplies: json['quick_replies'] is List
          ? (json['quick_replies'] as List)
              .map((reply) => Map<String, dynamic>.from(reply))
              .toList()
          : json['quickReplies'] is List
              ? (json['quickReplies'] as List)
                  .map((reply) => Map<String, dynamic>.from(reply))
                  .toList()
              : null,
      intent: json['intent']?.toString(),
      confidence: json['confidence'] is num
          ? (json['confidence'] as num).toDouble()
          : null,
      entities: json['entities'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['entities'])
          : null,
      isTyping: json['is_typing'] == true || json['isTyping'] == true,
      sessionId:
          json['session_id']?.toString() ?? json['sessionId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'message_id': messageId,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'quick_replies': quickReplies,
      'intent': intent,
      'confidence': confidence,
      'entities': entities,
      'is_typing': isTyping,
      'session_id': sessionId,
    };
  }

  ChatResponse copyWith({
    String? message,
    String? messageId,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    List<Map<String, dynamic>>? quickReplies,
    String? intent,
    double? confidence,
    Map<String, dynamic>? entities,
    bool? isTyping,
    String? sessionId,
  }) {
    return ChatResponse(
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      quickReplies: quickReplies ?? this.quickReplies,
      intent: intent ?? this.intent,
      confidence: confidence ?? this.confidence,
      entities: entities ?? this.entities,
      isTyping: isTyping ?? this.isTyping,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  String toString() {
    return 'ChatResponse(message: $message, messageId: $messageId, timestamp: $timestamp, intent: $intent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatResponse &&
        other.message == message &&
        other.messageId == messageId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return message.hashCode ^ messageId.hashCode ^ timestamp.hashCode;
  }

  /// Create a typing response
  factory ChatResponse.typing({
    String? sessionId,
  }) {
    return ChatResponse(
      message: '',
      timestamp: DateTime.now(),
      isTyping: true,
      sessionId: sessionId,
    );
  }

  /// Create a simple text response
  factory ChatResponse.text({
    required String message,
    String? messageId,
    String? sessionId,
    Map<String, dynamic>? metadata,
  }) {
    return ChatResponse(
      message: message,
      messageId: messageId,
      timestamp: DateTime.now(),
      sessionId: sessionId,
      metadata: metadata,
    );
  }

  /// Create a response with quick replies
  factory ChatResponse.withQuickReplies({
    required String message,
    required List<Map<String, dynamic>> quickReplies,
    String? messageId,
    String? sessionId,
    Map<String, dynamic>? metadata,
  }) {
    return ChatResponse(
      message: message,
      messageId: messageId,
      timestamp: DateTime.now(),
      quickReplies: quickReplies,
      sessionId: sessionId,
      metadata: metadata,
    );
  }

  /// Create a response with intent and confidence
  factory ChatResponse.withIntent({
    required String message,
    required String intent,
    required double confidence,
    Map<String, dynamic>? entities,
    String? messageId,
    String? sessionId,
    Map<String, dynamic>? metadata,
  }) {
    return ChatResponse(
      message: message,
      messageId: messageId,
      timestamp: DateTime.now(),
      intent: intent,
      confidence: confidence,
      entities: entities,
      sessionId: sessionId,
      metadata: metadata,
    );
  }
}
