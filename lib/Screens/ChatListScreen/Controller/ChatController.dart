import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/ChatListScreen/ChatScreen.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Models/ChatModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Models/SessionModel.dart';
import 'package:mommilk_user/Screens/ChatScreen/ChatScreen.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Chatcontroller extends GetxController {
  late Socket socket;

  int unReadMessage = 0;

  int currentUser = 0;
  String currentUserName = "";
  int sessionID = 0;
  bool isDonar = false;

  ScrollController scrollController = ScrollController();

  TextEditingController messageText = TextEditingController();
  List<ChatMessage> messageList = [];
  List<ChatSession> chatSessionList = [];

  // If you have AuthController with user model, you can access it like this:
  // final authController = Get.find<AuthController>();
  // UserModel get user => authController.user;

  Future<void> startWebsocketConnection() async {
    String authToken = await ApiService.getAuthToken() ?? "";

    log('Initializing chat socket connection...', name: 'ChatController');

    socket = io(
      "wss://api.momsmilk.app/chat",
      OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': authToken})
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      log('✅ Connected to chat socket', name: 'ChatController');
    });

    socket.onDisconnect((reason) {
      log('❌ Disconnected from chat socket: $reason', name: 'ChatController');
    });

    socket.onError((data) {
      log('⚠️ Socket error: $data', name: 'ChatController');
    });

    // Your messages read
    socket.on('messagesRead', (data) {
      final map = Map<String, dynamic>.from(data);
      final ids = List<int>.from(map['messageIds']);
      final readBy = map['readBy'];

      log(
        '📩 messagesRead event. Messages read by $readBy: $ids',
        name: 'ChatController',
      );

      for (var id in ids) {
        updateReadStatus(id);
      }
    });

    // Your messages delivered
    socket.on('messagesDelivered', (data) {
      final map = Map<String, dynamic>.from(data);
      final ids = List<int>.from(map['messageIds']);

      log(
        '📦 messagesDelivered event. Messages delivered: $ids',
        name: 'ChatController',
      );

      // Optional: update delivery status for messages here
    });

    socket.on('newMessage', (data) {
      log('📨 newMessage event received: $data', name: 'ChatController');

      final message = ChatMessage.fromJson(Map<String, dynamic>.from(data));

      // Show in current chat if session matches
      print(sessionID);
      print(message.sessionId);
      if (message.sessionId == sessionID) {
        messageList.add(message);

        // Auto-mark as read if message is from the other user

        if (message.senderId != user.id) {
          log(
            'Marking new message ${message.id} as read',
            name: 'ChatController',
          );

          socket.emit('markAsRead', {
            'messageIds': [message.id],
          });
          scrollController.jumpTo(0);
        }
        update();
      }

      // Auto-mark as delivered for all new messages
      log('Marking message ${message.id} as delivered', name: 'ChatController');
      socket.emit('markAsDelivered', {
        'messageIds': [message.id],
      });

      // Update / insert session in session list
      if (data["session"] != null) {
        final session = ChatSession.fromJson(
          Map<String, dynamic>.from(data["session"]),
        );
        updateSessionLastMessages(session);
      }
    });
  }

  /// Recalculate total unread count from all sessions
  void updateUnreadMessage() {
    unReadMessage = 0;
    for (var session in chatSessionList) {
      unReadMessage += session.unreadCount; // Correct: no ++ here
    }
    log('🔢 Total unread messages: $unReadMessage', name: 'ChatController');
    update();
  }

  /// Public helper if you want to trigger unread calculation
  void countUnreadMessage() {
    log('Recounting unread messages...', name: 'ChatController');
    updateUnreadMessage();
  }

  /// Move or insert session to top and then update unread counts
  void updateSessionLastMessages(ChatSession session) {
    log(
      '🔄 Updating session list for sessionId=${session.id}',
      name: 'ChatController',
    );

    final index = chatSessionList.indexWhere((s) => s.id == session.id);

    if (index != -1) {
      chatSessionList.removeAt(index);
    }

    chatSessionList.insert(0, session);

    updateUnreadMessage();
  }

  /// Mark all messages in current session as read
  void markAllAsRead() {
    log(
      'Marking all messages as read for sessionID=$sessionID',
      name: 'ChatController',
    );

    final List<int> messageIds = [];

    for (var msg in messageList) {
      if (!msg.isRead && msg.senderId != user.id) {
        msg.isRead = true;
        messageIds.add(msg.id);
      }
    }

    // Reset unread count for this session
    final sessionIndex = chatSessionList.indexWhere((s) => s.id == sessionID);
    if (sessionIndex != -1) {
      chatSessionList[sessionIndex].unreadCount = 0;
    }

    updateUnreadMessage();

    if (messageIds.isNotEmpty) {
      log(
        'Sending markAsRead for messages: $messageIds',
        name: 'ChatController',
      );
      socket.emit('markAsRead', {'messageIds': messageIds});
    } else {
      update();
    }
  }

  /// Update read status of a single message (from socket event)
  void updateReadStatus(int id) {
    log('Updating read status for messageId=$id', name: 'ChatController');

    // Update in current message list
    for (var msg in messageList) {
      if (msg.id == id) {
        msg.isRead = true;
        break;
      }
    }

    // Update in sessions + adjust unread count
    for (var session in chatSessionList) {
      if (session.lastMessage?.id == id) {
        session.lastMessage!.isRead = true;

        if (session.unreadCount > 0) {
          session.unreadCount -= 1;
        }
        break;
      }
    }

    updateUnreadMessage();
  }

  /// Send a message to currently opened user
  void sentMessage(String message) {
    log(
      'Sending message to user=$currentUser, content="$message"',
      name: 'ChatController',
    );

    socket.emit('sendMessage', {
      'recipientId': currentUser,
      'content': message,
    });

    // Let the server emit `newMessage` back, so we don't duplicate locally
  }

  void OpenChatUser({
    required int userID,
    int session = 0,
    required bool isDonar,
    required userName,
  }) {
    currentUser = userID;
    currentUserName = userName;
    this.isDonar = isDonar;
    log(
      'Opening chat. userID=$userID, session=$session, isDonar=$isDonar',
      name: 'ChatController',
    );

    Get.to(ChatScreen(), transition: Transition.rightToLeft);

    if (session != 0) {
      // If a specific session is passed, use that
      sessionID = session;
      loadUserFullMessage(sID: sessionID);
    } else {
      // Otherwise fetch/create a session for this user
      loadSessionData(userID);
    }
  }

  /// Load full message history for a session
  void loadUserFullMessage({required int sID}) {
    log('Loading full messages for sessionID=$sID', name: 'ChatController');

    ApiService.request(
      endpoint: "/chat/sessions/$sID/messages",
      method: Api.GET,
      onSuccess: (dataResponse) {
        log(
          'loadUserFullMessage success: ${dataResponse.data}',
          name: 'ChatController',
        );

        messageList.clear();
        sessionID = sID;

        for (var data in dataResponse.data["messages"]) {
          messageList.add(ChatMessage.fromJson(data));
        }

        update();
        markAllAsRead();

        scrollController.jumpTo(0);
      },
      onError: (error) {
        log('❌ loadUserFullMessage error: $error', name: 'ChatController');
      },
    );
  }

  /// Load all chat sessions for this user
  void loadAllSessions() {
    log('Loading all chat sessions...', name: 'ChatController');

    ApiService.request(
      endpoint: "/chat/sessions?page=1&limit=100",
      method: Api.GET,
      onSuccess: (dataResponse) {
        log(
          'loadAllSessions success: ${dataResponse.data}',
          name: 'ChatController',
        );

        chatSessionList.clear();

        for (var data in dataResponse.data["sessions"]) {
          chatSessionList.add(ChatSession.fromJson(data));
        }

        updateUnreadMessage();
      },
      onError: (error) {
        log('❌ loadAllSessions error: $error', name: 'ChatController');
      },
    );
  }

  /// Fetch or create session for a specific user and then load messages
  void loadSessionData(int userID) {
    log(
      'Loading / creating session for userID=$userID',
      name: 'ChatController',
    );

    ApiService.request(
      endpoint: "/chat/session/$userID",
      method: Api.GET,
      onSuccess: (dataResponse) {
        log(
          'loadSessionData success: ${dataResponse.data}',
          name: 'ChatController',
        );

        final int sID = dataResponse.data["id"];
        loadUserFullMessage(sID: sID);
      },
      onError: (error) {
        log('❌ loadSessionData error: $error', name: 'ChatController');
      },
    );
  }

  @override
  void onInit() {
    super.onInit();

    log('Chatcontroller onInit', name: 'ChatController');

    startWebsocketConnection();
    loadAllSessions();
  }

  @override
  void onClose() {
    log('Chatcontroller onClose - cleaning up', name: 'ChatController');

    try {
      socket.disconnect();
      socket.close();
    } catch (e) {
      log('Error while closing socket: $e', name: 'ChatController');
    }

    messageText.dispose();
    super.onClose();
  }
}
