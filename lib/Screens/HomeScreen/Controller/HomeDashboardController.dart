import 'package:get/get.dart';
import 'package:mommilk_user/Models/RequestModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

/// Feeds the Buyer/Donor Home dashboard (HDashboardHome) — its summary
/// stat tiles and "Recent Requests"/"Recent Acceptances" cards.
///
///   Donor: GET /users/:id/donor-summary, GET /users/:id/donor-activity
///   Buyer: GET /users/:id/buyer-summary, GET /users/:id/buyer-activity
class HomeDashboardController extends GetxController {
  bool isSummaryLoading = false;
  bool isActivityLoading = false;

  // ── Donor summary ────────────────────────────────────────────────────────
  int activeListings = 0;
  int donorPendingRequests = 0;
  int donorAcceptedRequests = 0;
  int totalDonations = 0;

  // ── Donor activity ───────────────────────────────────────────────────────
  List<RequestModel> recentRequestsCame = [];
  List<RequestModel> recentAcceptancesDone = [];

  // ── Buyer summary ────────────────────────────────────────────────────────
  int activeRequests = 0;
  int pendingAcceptance = 0;
  int acceptedDonors = 0;
  int completedDeliveries = 0;

  // ── Buyer activity ───────────────────────────────────────────────────────
  List<RequestModel> recentRequests = [];

  Future<void> fetchDashboardData() async {
    if (user.userType == 'DONOR') {
      await Future.wait([_fetchDonorSummary(), _fetchDonorActivity()]);
    } else {
      await Future.wait([_fetchBuyerSummary(), _fetchBuyerActivity()]);
    }
  }

  Future<void> _fetchDonorSummary() async {
    isSummaryLoading = true;
    update();
    await ApiService.request(
      endpoint: '/users/${user.id}/donor-summary',
      method: Api.GET,
      onSuccess: (response) {
        final data = response.data;
        if (data is! Map) return;
        activeListings = (data['activeListings'] ?? 0) as int;
        donorPendingRequests = (data['pendingRequests'] ?? 0) as int;
        donorAcceptedRequests = (data['acceptedRequests'] ?? 0) as int;
        totalDonations = (data['totalDonations'] ?? 0) as int;
      },
    );
    isSummaryLoading = false;
    update();
  }

  Future<void> _fetchDonorActivity() async {
    isActivityLoading = true;
    update();
    await ApiService.request(
      endpoint: '/users/${user.id}/donor-activity',
      method: Api.GET,
      onSuccess: (response) {
        final data = response.data;
        if (data is! Map) return;
        recentRequestsCame = _parseRequests(data['recentRequestsCame']);
        recentAcceptancesDone = _parseRequests(data['recentAcceptancesDone']);
      },
    );
    isActivityLoading = false;
    update();
  }

  Future<void> _fetchBuyerSummary() async {
    isSummaryLoading = true;
    update();
    await ApiService.request(
      endpoint: '/users/${user.id}/buyer-summary',
      method: Api.GET,
      onSuccess: (response) {
        final data = response.data;
        if (data is! Map) return;
        activeRequests = (data['activeRequests'] ?? 0) as int;
        pendingAcceptance = (data['pendingAcceptance'] ?? 0) as int;
        acceptedDonors = (data['acceptedDonors'] ?? 0) as int;
        completedDeliveries = (data['completedDeliveries'] ?? 0) as int;
      },
    );
    isSummaryLoading = false;
    update();
  }

  Future<void> _fetchBuyerActivity() async {
    isActivityLoading = true;
    update();
    await ApiService.request(
      endpoint: '/users/${user.id}/buyer-activity',
      method: Api.GET,
      onSuccess: (response) {
        final data = response.data;
        if (data is! Map) return;
        recentRequests = _parseRequests(data['recentRequests']);
      },
    );
    isActivityLoading = false;
    update();
  }

  List<RequestModel> _parseRequests(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map((e) => RequestModel.fromJson(e))
        .toList();
  }
}
