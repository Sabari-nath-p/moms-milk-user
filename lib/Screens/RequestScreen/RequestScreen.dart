import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/RequestModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/HomeScreen/Controller/HomeController.dart';
import 'package:mommilk_user/Screens/RequestScreen/Controller/RequestController.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen>
    with TickerProviderStateMixin {
  late Requestcontroller controller;
  late Homecontroller homecontroller;
  late TabController tabController;
  late ScrollController incomingScrollController;
  late ScrollController historyScrollController;
  late ScrollController myRequestsScrollController;

  // Menu segments for CupertinoSegmentedControl
  //

  @override
  void initState() {
    super.initState();
    controller = Get.put(Requestcontroller());
    homecontroller = Get.find();
    tabController = TabController(length: 2, vsync: this);

    // Initialize scroll controllers
    incomingScrollController = ScrollController();
    historyScrollController = ScrollController();
    myRequestsScrollController = ScrollController();

    // Add scroll listeners for pagination
    incomingScrollController.addListener(_onIncomingScroll);
    historyScrollController.addListener(_onHistoryScroll);
    myRequestsScrollController.addListener(_onMyRequestsScroll);
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
    tabController.dispose();
    incomingScrollController.dispose();
    historyScrollController.dispose();
    myRequestsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Moms Connect"),
        actions: [
          // Debug buttons for testing user types
          // PopupMenuButton<String>(
          //   icon: Icon(Icons.person),
          //   onSelected: (String userType) {
          //     controller.setUserType(userType);
          //   },
          //   itemBuilder:
          //       (BuildContext context) => <PopupMenuEntry<String>>[
          //         PopupMenuItem<String>(
          //           value: 'DONOR',
          //           child: Text('Set as Donor'),
          //         ),
          //         PopupMenuItem<String>(
          //           value: 'BUYER',
          //           child: Text('Set as Buyer'),
          //         ),
          //       ],
          // ),
          IconButton(
            onPressed: () => controller.refreshData(),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: GetBuilder<Requestcontroller>(
        builder: (controller) {
          // Show loading screen while user data is being fetched
          if (controller.isLoadingUserData || !controller.isUserDataLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading user data...'),
                ],
              ),
            );
          }

          // Update menus based on user type
          Map<int, Widget> dynamicMenus =
              user.userType == 'DONOR'
                  ? {
                    0: SizedBox(
                      width: 120,
                      height: 46,
                      child: Center(child: Text("Incoming")),
                    ),
                    1: SizedBox(
                      width: 120,
                      height: 46,
                      child: Center(child: Text("History")),
                    ),
                    2: SizedBox(
                      width: 120,
                      height: 46,
                      child: Center(child: Text("My Requests")),
                    ),
                  }
                  : {
                    0: SizedBox(
                      width: 120,
                      height: 46,
                      child: Center(child: Text("My Requests")),
                    ),
                  };

          return Column(
            children: [
              SizedBox(height: 10),
              if (user.userType == "DONOR")
                CupertinoSlidingSegmentedControl(
                  children: dynamicMenus,
                  groupValue: controller.selectedValue,
                  onValueChanged: (value) {
                    controller.selectedValue = value ?? 0;
                    controller.update();
                  },
                ),
              SizedBox(height: 16),
              Expanded(child: _buildSelectedContent(controller)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectedContent(Requestcontroller controller) {
    if (user.userType == 'DONOR') {
      switch (controller.selectedValue) {
        case 0:
          return _buildIncomingRequests(controller);
        case 1:
          return _buildHistoryRequests(controller);
        case 2:
          return _buildMyRequests(controller);
        default:
          return _buildIncomingRequests(controller);
      }
    } else {
      return _buildMyRequests(controller);
    }
  }

  Widget _buildIncomingRequests(Requestcontroller controller) {
    if (controller.isLoadingIncoming) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.incomingRequests.isEmpty) {
      return _buildEmptyState(
        context,
        'No Incoming Requests',
        'You don\'t have any pending milk requests at the moment.',
        Icons.inbox,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchIncomingRequests(),
      child: ListView.builder(
        controller: incomingScrollController,
        padding: EdgeInsets.all(16),
        itemCount:
            controller.incomingRequests.length +
            (controller.hasMoreIncoming ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.incomingRequests.length) {
            return controller.isLoadingMoreIncoming
                ? Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
                : SizedBox.shrink();
          }

          final request = controller.incomingRequests[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _buildIncomingRequestCard(context, request, controller),
          );
        },
      ),
    );
  }

  Widget _buildHistoryRequests(Requestcontroller controller) {
    if (controller.isLoadingHistory) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.historyRequests.isEmpty) {
      return _buildEmptyState(
        context,
        'No History',
        'You don\'t have any request history yet.',
        Icons.history,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchHistoryRequests(),
      child: ListView.builder(
        controller: historyScrollController,
        padding: EdgeInsets.all(16),
        itemCount:
            controller.historyRequests.length +
            (controller.hasMoreHistory ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.historyRequests.length) {
            return controller.isLoadingMoreHistory
                ? Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
                : SizedBox.shrink();
          }

          final request = controller.historyRequests[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _buildHistoryRequestCard(context, request),
          );
        },
      ),
    );
  }

  Widget _buildMyRequests(Requestcontroller controller) {
    if (controller.isLoadingMyRequests) {
      return Center(child: CircularProgressIndicator());
    }

    if (controller.myRequests.isEmpty) {
      return _buildEmptyState(
        context,
        'No Requests Yet',
        'You haven\'t made any milk requests. Create your first request!',
        Icons.help_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => controller.fetchMyRequests(),
      child: ListView.builder(
        controller: myRequestsScrollController,
        padding: EdgeInsets.all(16),
        itemCount:
            controller.myRequests.length +
            (controller.hasMoreMyRequests ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.myRequests.length) {
            return controller.isLoadingMoreMyRequests
                ? Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
                : SizedBox.shrink();
          }

          final request = controller.myRequests[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _buildMyRequestCard(context, request, controller),
          );
        },
      ),
    );
  }

  // return Scaffold(
  //   body: CustomScrollView(
  //     slivers: [
  //       SliverAppBar(
  //         expandedHeight: 80,
  //         floating: false,
  //         pinned: true,
  //         leading: IconButton(
  //           onPressed: () => Navigator.pop(context),
  //           icon: const Icon(Icons.arrow_back),
  //         ),
  //         flexibleSpace: FlexibleSpaceBar(
  //           title: Text(
  //             user['userType'] == "DONAR" ? 'Milk Requests' : 'My Requests',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               color: Theme.of(context).colorScheme.onPrimary,
  //             ),
  //           ),
  //           centerTitle: true,
  //           background: Container(
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [
  //                   Theme.of(context).colorScheme.primary,
  //                   Theme.of(context).colorScheme.primary.withOpacity(0.8),
  //                 ],
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //               ),
  //             ),
  //           ),
  //         ),
  //         bottom:
  //             user['userType'] == "DONAR"
  //                 ? TabBar(
  //                   controller: tabController,
  //                   tabs: const [Tab(text: 'Incoming'), Tab(text: 'History')],
  //                   indicatorColor: Theme.of(context).colorScheme.onPrimary,
  //                   labelColor: Theme.of(context).colorScheme.onPrimary,
  //                   unselectedLabelColor: Theme.of(
  //                     context,
  //                   ).colorScheme.onPrimary.withOpacity(0.7),
  //                 )
  //                 : null,
  //       ),
  //       SliverPadding(
  //         padding: const EdgeInsets.all(16),
  //         sliver:
  //             user['userType'] == "DONAR"
  //                 ? SliverFillRemaining(
  //                   child: TabBarView(
  //                     controller: tabController,
  //                     children: [
  //                       _buildDonorIncomingRequests(context),
  //                     ],
  //                   ),
  //                 )
  //                 : SliverList(
  //                   delegate: SliverChildListDelegate([
  //                     _buildBuyerRequests(context),
  //                   ]),
  //                 ),
  //       ),
  //     ],
  //   ),
  // );
}

Widget _buildIncomingRequestCard(
  BuildContext context,
  RequestModel request,
  Requestcontroller controller,
) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title and Urgency
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.description ?? 'No description available',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getUrgencyColor(request.urgency ?? 'low'),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (request.urgency ?? 'low').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Requester and Time Info
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                request.requester?.name ?? 'Unknown',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 16),
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(request.createdAt ?? ''),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade300, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_drink,
                      size: 14,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${request.quantity ?? 0} ml',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.declineRequest(request.id ?? 0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade500,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.acceptRequest(request.id ?? 0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade500,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildHistoryRequestCard(BuildContext context, RequestModel request) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title and Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.description ?? 'No description available',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(request.status ?? 'pending'),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (request.status ?? 'pending').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Info Row
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                request.requester?.name ?? 'Unknown',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 16),
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(request.createdAt ?? ''),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getUrgencyColor(
                    request.urgency ?? 'low',
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: getUrgencyColor(request.urgency ?? 'low'),
                    width: 1,
                  ),
                ),
                child: Text(
                  (request.urgency ?? 'low').toUpperCase(),
                  style: TextStyle(
                    color: getUrgencyColor(request.urgency ?? 'low'),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Bottom Row with Quantity
          Row(
            children: [
              Icon(Icons.local_drink, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${request.quantity ?? 0} ml',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildMyRequestCard(
  BuildContext context,
  RequestModel request,
  Requestcontroller controller,
) {
  final bool canContact =
      (request.status?.toLowerCase() ?? 'pending') == 'accepted' &&
      request.donor != null;

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Title and Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.description ?? 'No description available',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(request.status ?? 'pending'),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (request.status ?? 'pending').toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Info Row
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                _formatDate(request.createdAt ?? ''),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 16),
              Icon(Icons.local_drink, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${request.quantity ?? 0} ml',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getUrgencyColor(
                    request.urgency ?? 'low',
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: getUrgencyColor(request.urgency ?? 'low'),
                    width: 1,
                  ),
                ),
                child: Text(
                  (request.urgency ?? 'low').toUpperCase(),
                  style: TextStyle(
                    color: getUrgencyColor(request.urgency ?? 'low'),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Contact Section for accepted requests
          if (canContact) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, size: 18, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Donor Available',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          request.donor?.name ?? 'Unknown Donor',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.contactUser(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

String _formatDate(String dateString) {
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
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
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
