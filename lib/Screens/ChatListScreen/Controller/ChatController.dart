import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';

import 'package:mommilk_user/Screens/ChatListScreen/Models/ChatModel.dart';
import 'package:mommilk_user/Screens/ChatListScreen/Models/SessionModel.dart';
import 'package:mommilk_user/Screens/ChatScreen/ChatScreen.dart';

import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:socket_io_client/socket_io_client.dart';

// 1. Add WidgetsBindingObserver mixin
class Chatcontroller extends GetxController with WidgetsBindingObserver {
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

  // If you have AuthController with user model:
  // final authController = Get.find<AuthController>();
  // UserModel get user => authController.user;
  // MOCK USER FOR CONTEXT (Replace with your actual User getter)

  @override
  void onInit() {
    super.onInit();
   
    WidgetsBinding.instance.addObserver(this);

    startWebsocketConnection();
    loadAllSessions();
  }

  @override
  void onClose() {
    // 3. Remove the observer to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);

    try {
      socket.disconnect();
      socket.dispose(); // Use dispose instead of close for cleaner cleanup
    } catch (e) {
      log("Error closing socket: $e");
    }

    messageText.dispose();
    super.onClose();
  }

  // 4. Handle App Lifecycle Changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('App Lifecycle State: $state', name: 'ChatController');

    if (state == AppLifecycleState.resumed) {
      // App is back in the foreground
      _handleAppResumed();
    }
  }

  /// Logic to run when app returns to foreground
  void _handleAppResumed() {
    // Check if socket is disconnected and reconnect
    if (socket.disconnected) {
      log(
        '🔄 App resumed: Socket disconnected, attempting reconnect...',
        name: 'ChatController',
      );
      socket.connect();
    } else {
      log(
        '✅ App resumed: Socket is already connected.',
        name: 'ChatController',
      );
    }

    // CRITICAL: Refresh data because we might have missed events while in background
    loadAllSessions();
    if (sessionID != 0) {
      loadUserFullMessage(sID: sessionID);
    }
  }

  Future<void> startWebsocketConnection() async {
    String authToken = await ApiService.getAuthToken() ?? "";

    // Added reconnection options for better stability
    socket = io(
      /// please not here change the url to staging or production accordingly
      "wss://staging.momsmilk.app/chat",

      OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': authToken})
          .enableAutoConnect()
          .setReconnectionDelay(1000) // Retry every 1 second initially
          .setReconnectionAttempts(double.infinity) // Keep retrying
          .build(),
    );

    socket.onConnect((_) {
      log('✅ Connected to chat socket', name: 'ChatController');

     
    });

    socket.onDisconnect((reason) {
      log('❌ Disconnected from chat socket: $reason', name: 'ChatController');
      // If disconnected due to network issues, the AutoConnect options handle it.
      // If disconnected due to backgrounding, didChangeAppLifecycleState handles it.
    });

    socket.onConnectError((data) {
      log('⚠️ Connect Error: $data', name: 'ChatController');
    });

    socket.onError((data) {
      log('⚠️ Socket error: $data', name: 'ChatController');
    });

    // --- Event Listeners ---
    socket.on('messagesRead', (data) {
      final map = Map<String, dynamic>.from(data);
      if (map['messageIds'] != null) {
        final ids = List<int>.from(map['messageIds']);
        for (var id in ids) {
          updateReadStatus(id);
        }
      }
    });

    socket.on('messagesDelivered', (data) {
      // Handle delivered status
    });

    socket.on('newMessageSent', (data) {
      log("new Message sent -- > {${data}}");
      final message = ChatMessage.fromJson(Map<String, dynamic>.from(data));

      if (message.sessionId == sessionID) {
        messageList.add(message);
        _scrollToBottom();
      }
      update();
      if (data["session"] != null) {
        final session = ChatSession.fromJson(
          Map<String, dynamic>.from(data["session"]),
        );
        updateSessionLastMessages(session);
      }
    });

    socket.on('newMessage', (data) {
      log("new Message get -- > {${data}}");
      final message = ChatMessage.fromJson(Map<String, dynamic>.from(data));

      if (message.sessionId == sessionID) {
        messageList.add(message);

        // Access user safely
        if (user != null && message.senderId != user.id) {
          socket.emit('markAsRead', {
            'messageIds': [message.id],
          });
          _scrollToBottom();
        }
        update();
      }

      socket.emit('markAsDelivered', {
        'messageIds': [message.id],
      });

      if (data["session"] != null) {
        final session = ChatSession.fromJson(
          Map<String, dynamic>.from(data["session"]),
        );
        updateSessionLastMessages(session);
      }
    });
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      // Small delay ensures the list has rendered the new item
      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.animateTo(
          0.0, // Assuming reverse: true in ListView, otherwise use maxScrollExtent
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void updateUnreadMessage() {
    unReadMessage = 0;
    for (var session in chatSessionList) {
      unReadMessage += session.unreadCount;
    }
    update();
  }

  void countUnreadMessage() {
    updateUnreadMessage();
  }

  void updateSessionLastMessages(ChatSession session) {
    final index = chatSessionList.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      chatSessionList.removeAt(index);
    }
    chatSessionList.insert(0, session);
    updateUnreadMessage();
  }

  void markAllAsRead() {
    final List<int> messageIds = [];
    if (user == null) return; // Guard clause

    for (var msg in messageList) {
      if (!msg.isRead && msg.senderId != user.id) {
        msg.isRead = true;
        messageIds.add(msg.id);
      }
    }

    final sessionIndex = chatSessionList.indexWhere((s) => s.id == sessionID);
    if (sessionIndex != -1) {
      chatSessionList[sessionIndex].unreadCount = 0;
    }

    updateUnreadMessage();

    if (messageIds.isNotEmpty) {
      socket.emit('markAsRead', {'messageIds': messageIds});
    } else {
      update();
    }
  }

  void updateReadStatus(int id) {
    for (var msg in messageList) {
      if (msg.id == id) {
        msg.isRead = true;
        break;
      }
    }
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

  void sentMessage(String message) {
    log("send message function ->" + currentUser.toString());
    socket.emit('sendMessage', {
      'recipientId': currentUser,
      'content': message,
    });
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

  if (session != 0) {
    sessionID = session;

    loadUserFullMessage(sID: sessionID);

    Get.to(
      () => ChatScreen(),
      transition: Transition.rightToLeft,
    );
  } else {
    ApiService.request(
      endpoint: "/chat/session/$userID",
      method: Api.GET,
      onSuccess: (dataResponse) {
        sessionID = dataResponse.data["id"];

        loadUserFullMessage(sID: sessionID);

        Get.to(
          () => ChatScreen(),
          transition: Transition.rightToLeft,
        );
      },
      onError: (error) {},
    );
  }
}

  void loadUserFullMessage({required int sID}) {
    ApiService.request(
      endpoint: "/chat/sessions/$sID/messages",
      method: Api.GET,
      onSuccess: (dataResponse) {
        messageList.clear();
        sessionID = sID;

        for (var data in dataResponse.data["messages"]) {
          messageList.add(ChatMessage.fromJson(data));
        }

        update();
        markAllAsRead();
        _scrollToBottom();
      },
      onError: (error) {},
    );
  }

  void loadAllSessions() {
    ApiService.request(
      endpoint: "/chat/sessions?page=1&limit=100",
      method: Api.GET,
      onSuccess: (dataResponse) {
        chatSessionList.clear();
        for (var data in dataResponse.data["sessions"]) {
          chatSessionList.add(ChatSession.fromJson(data));
        }
        updateUnreadMessage();
      },
      onError: (error) {},
    );
  }

  void loadSessionData(int userID) {
    ApiService.request(
      endpoint: "/chat/session/$userID",
      method: Api.GET,
      onSuccess: (dataResponse) {
        final int sID = dataResponse.data["id"];
        loadUserFullMessage(sID: sID);
      },
      onError: (error) {},
    );
  }
}
