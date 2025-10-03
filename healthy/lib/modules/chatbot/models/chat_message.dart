class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String? senderName;
  final String? senderAvatar;
  final Map<String, dynamic>? metadata;
  final String? messageType; // 'text', 'image', 'file', 'quick_reply'
  final List<Map<String, dynamic>>? quickReplies;
  final bool isTyping;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.senderName,
    this.senderAvatar,
    this.metadata,
    this.messageType = 'text',
    this.quickReplies,
    this.isTyping = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      isUser: json['is_user'] == true || json['isUser'] == true,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'].toString())
          : DateTime.now(),
      senderName:
          json['sender_name']?.toString() ?? json['senderName']?.toString(),
      senderAvatar:
          json['sender_avatar']?.toString() ?? json['senderAvatar']?.toString(),
      metadata: json['metadata'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      messageType: json['message_type']?.toString() ??
          json['messageType']?.toString() ??
          'text',
      quickReplies: json['quick_replies'] is List
          ? (json['quick_replies'] as List)
              .map((reply) => Map<String, dynamic>.from(reply))
              .toList()
          : json['quickReplies'] is List
              ? (json['quickReplies'] as List)
                  .map((reply) => Map<String, dynamic>.from(reply))
                  .toList()
              : null,
      isTyping: json['is_typing'] == true || json['isTyping'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'metadata': metadata,
      'message_type': messageType,
      'quick_replies': quickReplies,
      'is_typing': isTyping,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? timestamp,
    String? senderName,
    String? senderAvatar,
    Map<String, dynamic>? metadata,
    String? messageType,
    List<Map<String, dynamic>>? quickReplies,
    bool? isTyping,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      metadata: metadata ?? this.metadata,
      messageType: messageType ?? this.messageType,
      quickReplies: quickReplies ?? this.quickReplies,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, message: $message, isUser: $isUser, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        other.id == id &&
        other.message == message &&
        other.isUser == isUser &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        isUser.hashCode ^
        timestamp.hashCode;
  }

  /// Create a typing indicator message
  factory ChatMessage.typing({
    String? senderName,
    String? senderAvatar,
  }) {
    return ChatMessage(
      id: 'typing_${DateTime.now().millisecondsSinceEpoch}',
      message: '',
      isUser: false,
      timestamp: DateTime.now(),
      senderName: senderName ?? 'Assistant',
      senderAvatar: senderAvatar,
      isTyping: true,
    );
  }

  /// Create a user message
  factory ChatMessage.user({
    required String message,
    String? senderName,
    String? senderAvatar,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
      senderName: senderName ?? 'You',
      senderAvatar: senderAvatar,
      metadata: metadata,
    );
  }

  /// Create a bot message
  factory ChatMessage.bot({
    required String message,
    String? senderName,
    String? senderAvatar,
    Map<String, dynamic>? metadata,
    List<Map<String, dynamic>>? quickReplies,
  }) {
    return ChatMessage(
      id: 'bot_${DateTime.now().millisecondsSinceEpoch}',
      message: message,
      isUser: false,
      timestamp: DateTime.now(),
      senderName: senderName ?? 'Assistant',
      senderAvatar: senderAvatar,
      metadata: metadata,
      quickReplies: quickReplies,
    );
  }
}
