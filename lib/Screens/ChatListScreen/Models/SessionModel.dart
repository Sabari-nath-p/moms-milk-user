import 'package:mommilk_user/Screens/ChatListScreen/Models/ChatModel.dart';

class ChatUser {
  final int id;
  final String name;
  final String email;
  final String userType; // BUYER / DONOR / PARENT etc.

  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: json['userType'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'userType': userType,
  };
}

class ChatSession {
  final int id;
  final int parentId;
  final int donorId;
  DateTime? lastMessageAt;
  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;

  List<ChatMessage> messages;
  final ChatUser? otherUser;

  int unreadCount;
  ChatMessage? lastMessage;

  ChatSession({
    required this.id,
    required this.parentId,
    required this.donorId,
    required this.lastMessageAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    required this.otherUser,
    required this.unreadCount,
    required this.lastMessage,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic value) {
      if (value == null) return null;
      return DateTime.parse(value as String);
    }

    return ChatSession(
      id: json['id'] as int,
      parentId: json['parentId'] as int,
      donorId: json['donorId'] as int,
      lastMessageAt: _parseDate(json['lastMessageAt']),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      messages:
          (json['messages'] as List<dynamic>? ?? [])
              .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList(),
      otherUser:
          json['otherUser'] != null
              ? ChatUser.fromJson(json['otherUser'] as Map<String, dynamic>)
              : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      lastMessage:
          json['lastMessage'] != null
              ? ChatMessage.fromJson(
                json['lastMessage'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'parentId': parentId,
    'donorId': donorId,
    'lastMessageAt': lastMessageAt?.toIso8601String(),
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'messages': messages.map((e) => e.toJson()).toList(),
    'otherUser': otherUser?.toJson(),
    'unreadCount': unreadCount,
    'lastMessage': lastMessage?.toJson(),
  };
}
