import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/RequestModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/RequestScreen/Controller/RequestController.dart';
import 'package:mommilk_user/Screens/RequestScreen/Views/HistoryRequestCard.dart';
import 'package:mommilk_user/Screens/RequestScreen/Views/IncommingRequestCard.dart';
import 'package:mommilk_user/Screens/RequestScreen/Views/MyRequestCard.dart';
import 'package:mommilk_user/theme/app_theme.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with TickerProviderStateMixin {
  late Requestcontroller controller;
  late Homecontroller homecontroller;

  late ScrollController incomingScrollController;
  late ScrollController historyScrollController;
  late ScrollController myRequestsScrollController;

  @override
  void initState() {
    super.initState();

    controller = Get.put(Requestcontroller());
    homecontroller = Get.find();

    incomingScrollController = ScrollController()..addListener(_onIncomingScroll);
    historyScrollController = ScrollController()..addListener(_onHistoryScroll);
    myRequestsScrollController = ScrollController()..addListener(_onMyRequestsScroll);
  }

  void _onIncomingScroll() {
    if (incomingScrollController.position.pixels ==
        incomingScrollController.position.maxScrollExtent) {
      controller.loadMoreIncoming();
    }
  }

  void _onHistoryScroll() {
    if (historyScrollController.position.pixels ==
        historyScrollController.position.maxScrollExtent) {
      controller.loadMoreHistory();
    }
  }

  void _onMyRequestsScroll() {
    if (myRequestsScrollController.position.pixels ==
        myRequestsScrollController.position.maxScrollExtent) {
      controller.loadMoreMyRequests();
    }
  }

  @override
  void dispose() {
    incomingScrollController.dispose();
    historyScrollController.dispose();
    myRequestsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    

    return Scaffold(
      backgroundColor:  Colors.white,
      body: GetBuilder<Requestcontroller>(
        builder: (controller) {
          if (controller.isLoadingUserData || !controller.isUserDataLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading user data...")
                ],
              ),
            );
          }

          /// -----------------------------
          /// BUILD THE SEGMENTED MENU
          /// -----------------------------
          Map<int, Widget> buildMenus(int selectedIndex) {
            return {
              for (int key in (user.userType == "DONOR" ? [0, 1] : [0]))
                key: Container(
                  width: 160,
                  height: 46,
                  decoration: BoxDecoration(
                    color: selectedIndex == key ? Color(0xffFB7185): Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                   
                  ),
                  child: Center(
                    child: Text(
                      user.userType == "DONOR"
                          ? (key == 0
                              ? "Pending (${controller.incomingRequests.length})"
                              : "Connections")
                          : "My Requests",
                      style: TextStyle(
                        color: selectedIndex == key ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            };
          }

          return Column(
            children: [
              const SizedBox(height: 12),

              // DONOR → Sliding tabs
              if (user.userType == "DONOR")
                CupertinoSlidingSegmentedControl<int>(
                  children: buildMenus(controller.selectedValue),
                  groupValue: controller.selectedValue,
                  onValueChanged: (value) {
                    controller.selectedValue = value ?? 0;
                    controller.update();
                  },
                  thumbColor:  Color(0xffFB7185)
                ),

              const SizedBox(height: 16),

              Expanded(
                child: _buildSelectedContent(controller),
              ),
            ],
          );
        },
      ),
    );
  }

  /// -----------------------------
  /// SELECTED CONTENT BASED ON TAB
  /// -----------------------------
  Widget _buildSelectedContent(Requestcontroller controller) {
    if (user.userType == 'DONOR') {
      if (controller.selectedValue == 0) {
        return _buildIncomingRequests(controller);
      } else {
        return _buildHistoryRequests(controller);
      }
    } else {
      return _buildMyRequests(controller);
    }
  }

  /// -----------------------------
  /// INCOMING REQUESTS (DONOR)
  /// -----------------------------
  Widget _buildIncomingRequests(Requestcontroller controller) {
    if (controller.isLoadingIncoming) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.incomingRequests.isEmpty) {
      return _buildEmptyState(
        context,
        "No Incoming Requests",
        "You don’t have any pending milk requests.",
        Icons.inbox,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchIncomingRequests(),
      child: ListView.builder(
        controller: incomingScrollController,
        padding: EdgeInsets.all(16),
        itemCount: controller.incomingRequests.length +
            (controller.hasMoreIncoming ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.incomingRequests.length) {
            return controller.isLoadingMoreIncoming
                ? Center(child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator()))
                : SizedBox.shrink();
          }

          final request = controller.incomingRequests[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: IncommingRequestCard(
              controller: controller,
              request: request,
            ),
          );
        },
      ),
    );
  }

  /// -----------------------------
  /// HISTORY (DONOR)
  /// -----------------------------
  Widget _buildHistoryRequests(Requestcontroller controller) {
    if (controller.isLoadingHistory) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.historyRequests.isEmpty) {
      return _buildEmptyState(
        context,
        "No History",
        "No previous request activity available.",
        Icons.history,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchHistoryRequests(),
      child: ListView.builder(
        controller: historyScrollController,
        padding: EdgeInsets.all(16),
        itemCount:
            controller.historyRequests.length + (controller.hasMoreHistory ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.historyRequests.length) {
            return controller.isLoadingMoreHistory
                ? Center(child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator()))
                : SizedBox.shrink();
          }

          final request = controller.historyRequests[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: HistoryRequestCard(request: request),
          );
        },
      ),
    );
  }

  /// -----------------------------
  /// MY REQUESTS (BUYER)
  /// -----------------------------
  Widget _buildMyRequests(Requestcontroller controller) {
    if (controller.isLoadingMyRequests) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.myRequests.isEmpty) {
      return _buildEmptyState(
        context,
        "No Requests Yet",
        "You have not placed any requests yet.",
        Icons.list_alt,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchMyRequests(),
      child: ListView.builder(
        controller: myRequestsScrollController,
        padding: EdgeInsets.all(16),
        itemCount:
            controller.myRequests.length + (controller.hasMoreMyRequests ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.myRequests.length) {
            return controller.isLoadingMoreMyRequests
                ? Center(child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator()))
                : SizedBox.shrink();
          }

          final request = controller.myRequests[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: MyRequestCard(
              request: request,
              controller: controller,
            ),
          );
        },
      ),
    );
  }

  /// -----------------------------
  /// EMPTY STATE UI
  /// -----------------------------
  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppTheme.CardGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 45, color: Color(0xFFF43F5E)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

Color getUrgencyColor(String urgency) {
  switch (urgency.toLowerCase()) {
    case 'high':
      return Colors.red;
    case 'medium':
      return Colors.orange;
    case 'low':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'active':
    case 'pending':
      return Colors.orange;
    case 'completed':
    case 'accepted':
      return Colors.green;
    case 'declined':
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  } catch (e) {
    return dateString;
  }
}
