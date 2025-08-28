import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/RequestModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class Requestcontroller extends GetxController {
  int selectedValue = 0;

  // Loading states
  bool isLoadingIncoming = false;
  bool isLoadingHistory = false;
  bool isLoadingMyRequests = false;
  bool isLoadingMoreIncoming = false;
  bool isLoadingMoreHistory = false;
  bool isLoadingMoreMyRequests = false;
  bool isLoadingUserData = false;

  // Data lists
  List<RequestModel> incomingRequests = [];
  List<RequestModel> historyRequests = [];
  List<RequestModel> myRequests = [];

  // Pagination
  int incomingPage = 1;
  int historyPage = 1;
  int myRequestsPage = 1;
  final int limit = 10;
  bool hasMoreIncoming = true;
  bool hasMoreHistory = true;
  bool hasMoreMyRequests = true;

  // Current user type and data
  // String userType = 'DONAR'; // Default, will be updated from actual user data
  //Map<String, dynamic>? currentUser;
  bool isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
    isLoadingUserData = false;
    update();
  }

  void loadInitialData() {
    if (user.userType == 'DONOR') {
      fetchIncomingRequests();
      fetchHistoryRequests();
      fetchMyRequests(); // Donors can also have their own requests
    } else {
      fetchMyRequests();
    }
    isUserDataLoaded = true;
    update();
  }

  // Fetch incoming requests for donors
  Future<void> fetchIncomingRequests({bool loadMore = false}) async {
    if (user.userType != 'DONOR') {
      print('User is not a donor, skipping incoming requests fetch');
      return;
    }

    if (loadMore) {
      if (!hasMoreIncoming || isLoadingMoreIncoming) return;
      isLoadingMoreIncoming = true;
      incomingPage++;
    } else {
      isLoadingIncoming = true;
      incomingPage = 1;
      hasMoreIncoming = true;
      incomingRequests.clear();
    }

    update();

    try {
      Map<String, String> queryParams = {
        'status': 'PENDING',
        'page': incomingPage.toString(),
        'limit': limit.toString(),
      };

      String endpoint = "/requests/incoming";
      String queryString = queryParams.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
          )
          .join('&');
      endpoint = "$endpoint?$queryString";

      print('Fetching incoming requests: $endpoint');

      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        onSuccess: (data) {
          print('Incoming requests API success: ${data.data}');
          List<dynamic> requestsData = data.data['data'] ?? [];
          Map<String, dynamic>? paginationData = data.data['pagination'];

          List<RequestModel> newRequests =
              requestsData.map((item) => RequestModel.fromJson(item)).toList();

          if (loadMore) {
            incomingRequests.addAll(newRequests);
          } else {
            incomingRequests = newRequests;
          }

          print('Loaded ${newRequests.length} incoming requests');

          // Update pagination
          if (paginationData != null) {
            hasMoreIncoming = paginationData['hasNextPage'] ?? false;
          } else {
            hasMoreIncoming = newRequests.length >= limit;
          }
        },
        onError: (error) {
          print('Incoming requests API error: $error');
          Get.snackbar('Error', 'Failed to load incoming requests: $error');
        },
      );
    } catch (e) {
      print('Exception in fetchIncomingRequests: $e');
      Get.snackbar('Error', 'Failed to load incoming requests: $e');
    } finally {
      isLoadingIncoming = false;
      isLoadingMoreIncoming = false;
      update();
    }
  }

  // Fetch history requests for donors
  Future<void> fetchHistoryRequests({bool loadMore = false}) async {
    if (user.userType != 'DONOR') {
      print('User is not a donor, skipping history requests fetch');
      return;
    }

    if (loadMore) {
      if (!hasMoreHistory || isLoadingMoreHistory) return;
      isLoadingMoreHistory = true;
      historyPage++;
    } else {
      isLoadingHistory = true;
      historyPage = 1;
      hasMoreHistory = true;
      historyRequests.clear();
    }

    update();

    try {
      Map<String, String> queryParams = {
        // 'status': 'ACCEPTED,DECLINED,COMPLETED,CANCELLED',
        'page': historyPage.toString(),
        'limit': limit.toString(),
      };

      String endpoint = "/requests/incoming";
      String queryString = queryParams.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
          )
          .join('&');
      endpoint = "$endpoint?$queryString";

      print('Fetching history requests: $endpoint');

      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        onSuccess: (data) {
          print('History requests API success: ${data.data}');
          List<dynamic> requestsData = data.data['data'] ?? [];
          Map<String, dynamic>? paginationData = data.data['pagination'];

          List<RequestModel> newRequests =
              requestsData.map((item) => RequestModel.fromJson(item)).toList();

          if (loadMore) {
            historyRequests.addAll(newRequests);
          } else {
            historyRequests = newRequests;
          }

          print('Loaded ${newRequests.length} history requests');

          // Update pagination
          if (paginationData != null) {
            hasMoreHistory = paginationData['hasNextPage'] ?? false;
          } else {
            hasMoreHistory = newRequests.length >= limit;
          }
        },
        onError: (error) {
          print('History requests API error: $error');
          Get.snackbar('Error', 'Failed to load history requests: $error');
        },
      );
    } catch (e) {
      print('Exception in fetchHistoryRequests: $e');
      Get.snackbar('Error', 'Failed to load history requests: $e');
    } finally {
      isLoadingHistory = false;
      isLoadingMoreHistory = false;
      update();
    }
  }

  // Fetch my requests for buyers and donors
  Future<void> fetchMyRequests({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMoreMyRequests || isLoadingMoreMyRequests) return;
      isLoadingMoreMyRequests = true;
      myRequestsPage++;
    } else {
      isLoadingMyRequests = true;
      myRequestsPage = 1;
      hasMoreMyRequests = true;
      myRequests.clear();
    }

    update();

    try {
      Map<String, String> queryParams = {
        'page': myRequestsPage.toString(),
        'limit': limit.toString(),
      };

      String endpoint = "/requests/my-requests";
      String queryString = queryParams.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
          )
          .join('&');
      endpoint = "$endpoint?$queryString";

      print('Fetching my requests: $endpoint');

      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        onSuccess: (data) {
          print('My requests API success: ${data.data}');
          List<dynamic> requestsData = data.data['data'] ?? [];
          Map<String, dynamic>? paginationData = data.data['pagination'];

          List<RequestModel> newRequests =
              requestsData.map((item) => RequestModel.fromJson(item)).toList();

          if (loadMore) {
            myRequests.addAll(newRequests);
          } else {
            myRequests = newRequests;
          }

          print('Loaded ${newRequests.length} my requests');

          // Update pagination
          if (paginationData != null) {
            hasMoreMyRequests = paginationData['hasNextPage'] ?? false;
          } else {
            hasMoreMyRequests = newRequests.length >= limit;
          }
        },
        onError: (error) {
          print('My requests API error: $error');
          Get.snackbar('Error', 'Failed to load my requests: $error');
        },
      );
    } catch (e) {
      print('Exception in fetchMyRequests: $e');
      Get.snackbar('Error', 'Failed to load my requests: $e');
    } finally {
      isLoadingMyRequests = false;
      isLoadingMoreMyRequests = false;
      update();
    }
  }

  // Accept a request (for donors)
  Future<void> acceptRequest(int requestId) async {
    try {
      await ApiService.request(
        endpoint: '/requests/$requestId/accept',
        method: Api.POST,
        onSuccess: (data) {
          Get.snackbar(
            'Success',
            'Request accepted successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Refresh incoming requests
          fetchIncomingRequests();
          fetchHistoryRequests();
        },
        onError: (error) {
          Get.snackbar('Error', 'Failed to accept request: $error');
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept request: $e');
    }
  }

  // Decline a request (for donors)
  Future<void> declineRequest(int requestId) async {
    try {
      await ApiService.request(
        endpoint: '/requests/$requestId/decline',
        method: Api.POST,
        onSuccess: (data) {
          Get.snackbar(
            'Success',
            'Request declined successfully!',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          // Refresh incoming requests
          fetchIncomingRequests();
          fetchHistoryRequests();
        },
        onError: (error) {
          Get.snackbar('Error', 'Failed to decline request: $error');
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to decline request: $e');
    }
  }

  // Utility methods
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
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'declined':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown date';

    try {
      DateTime date = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      Duration difference = now.difference(date);

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

  // Contact donor/requester (for accepted requests)
  void contactUser(RequestModel request) {
    // Implementation for contact functionality
    // You can navigate to chat screen or show contact details
    String contactName =
        user.userType == 'DONOR'
            ? request.requester?.name ?? 'Unknown'
            : request.donor?.name ?? 'Unknown';
    String contactEmail =
        user.userType == 'DONOR'
            ? request.requester?.email ?? 'No email'
            : request.donor?.email ?? 'No email';

    Get.snackbar(
      'Contact Info',
      'Name: $contactName\nEmail: $contactEmail',
      duration: const Duration(seconds: 5),
    );
  }

  // Refresh all data
  Future<void> refreshData() async {
    // First refresh user data to ensure we have the latest user type
    // await _fetchUserProfile();

    // Then refresh appropriate data based on user type
    if (user.userType == 'DONOR') {
      await Future.wait([
        fetchIncomingRequests(),
        fetchHistoryRequests(),
        fetchMyRequests(),
      ]);
    } else {
      await fetchMyRequests();
    }
  }

  // Load more data for pagination
  void loadMoreIncoming() => fetchIncomingRequests(loadMore: true);
  void loadMoreHistory() => fetchHistoryRequests(loadMore: true);
  void loadMoreMyRequests() => fetchMyRequests(loadMore: true);

  // Method to manually set user type (for testing or when API is not available)
  void setUserType(String type) {
    user.userType = type.toUpperCase();
    selectedValue = 0; // Reset to first tab
    print('User type manually set to: ${user.userType}');

    // Clear existing data
    incomingRequests.clear();
    historyRequests.clear();
    myRequests.clear();

    // Reset pagination
    incomingPage = 1;
    historyPage = 1;
    myRequestsPage = 1;
    hasMoreIncoming = true;
    hasMoreHistory = true;
    hasMoreMyRequests = true;

    update();
    loadInitialData();
  }

  // Get current user info
  //String getCurrentUserType() => user.userType!;
  // Map<String, dynamic>? getCurrentUser() => currentUser;
  bool isUserDataLoaded = false;
}
