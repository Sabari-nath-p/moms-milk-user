import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/SearchDonarModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class SearchDonarController extends GetxController {
  TextEditingController zipSearchText = TextEditingController(
    text: user.zipcode,
  );
  TextEditingController donarSearchText = TextEditingController();

  bool isLoading = false;
  bool isSearching = false;

  String sortBy = 'distance';
  final List<String> sortOptions = [
    'distance',
    'rating',
    'recent',
    'availability',
  ];

  String bloodGroupFilter = '';
  bool medicalRecordsRequired = false;
  bool onlyAvailableDonors = true;

  List<SearchDonarModel> allDonors = [];
  List<SearchDonarModel> filteredDonors = [];
  List<String> activeFilters = [];

  int currentPage = 1;
  int limit = 10;
  bool hasMoreData = true;
  bool isLoadingMore = false;

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void onInit() {
    super.onInit();
    loadDonors();
  }

  @override
  void onClose() {
    zipSearchText.dispose();
    donarSearchText.dispose();
    super.onClose();
  }

  void searchDonors() {
    loadDonors();
  }

  void loadDonors({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMoreData || isLoadingMore) return;
      isLoadingMore = true;
      currentPage++;
    } else {
      isLoading = true;
      currentPage = 1;
      hasMoreData = true;
      allDonors.clear();
    }

    update();

    try {
      Map<String, String> queryParams = {
        'page': currentPage.toString(),
        'limit': limit.toString(),
      };

      if (bloodGroupFilter.isNotEmpty)
        queryParams['bloodGroup'] = bloodGroupFilter;
      if (medicalRecordsRequired)
        queryParams['ableToShareMedicalRecord'] = 'true';
      if (onlyAvailableDonors) queryParams['isAvailable'] = 'true';
      if (zipSearchText.text.isNotEmpty)
        queryParams['zipcode'] = zipSearchText.text;
      if (donarSearchText.text.isNotEmpty)
        queryParams['donorName'] = donarSearchText.text;

      String endpoint = "/requests/search/donors";
      if (queryParams.isNotEmpty) {
        String queryString = queryParams.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
            )
            .join('&');
        endpoint = "$endpoint?$queryString";
      }

      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        onSuccess: (data) {
          List<dynamic> donorsData = data.data['data'] ?? [];
          Map<String, dynamic>? paginationData = data.data['pagination'];

          List<SearchDonarModel> newDonors = donorsData
              .map((item) => SearchDonarModel.fromJson(item))
              .toList();

          if (loadMore) {
            allDonors.addAll(newDonors);
          } else {
            allDonors = newDonors;
          }

          if (paginationData != null) {
            hasMoreData = paginationData['hasNextPage'] ?? false;
            currentPage = paginationData['currentPage'] ?? currentPage;
          } else {
            hasMoreData = newDonors.length >= limit;
          }

          filteredDonors = List.from(allDonors);
        },
        onError: (error) {
          Fluttertoast.showToast(msg: 'Failed to load donors: $error');
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to load donors: $e');
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  void applyFilters() {
    updateActiveFilters();
    loadDonors();
  }

  void updateBloodGroupFilter(String bloodGroup) {
    bloodGroupFilter = bloodGroup;
    applyFilters();
  }

  void updateMedicalRecordsFilter(bool required) {
    medicalRecordsRequired = required;
    applyFilters();
  }

  void updateAvailabilityFilter(bool onlyAvailable) {
    onlyAvailableDonors = onlyAvailable;
    applyFilters();
  }

  void clearAllFilters() {
    bloodGroupFilter = '';
    medicalRecordsRequired = false;
    onlyAvailableDonors = true;
    zipSearchText.clear();
    donarSearchText.clear();
    updateActiveFilters();
    loadDonors();
  }

  void updateActiveFilters() {
    activeFilters.clear();

    if (bloodGroupFilter.isNotEmpty) {
      activeFilters.add('Blood: $bloodGroupFilter');
    }

    if (medicalRecordsRequired) {
      activeFilters.add('Medical Records');
    }

    // FIX: chip shows when available filter IS ON (not when off)
    // Previously was `if (!onlyAvailableDonors)` which showed chip for wrong state
    if (onlyAvailableDonors) {
      activeFilters.add('Available Donors');
    }

    if (zipSearchText.text.isNotEmpty) {
      activeFilters.add('Zip: ${zipSearchText.text}');
    }

    if (donarSearchText.text.isNotEmpty) {
      activeFilters.add('Name: ${donarSearchText.text}');
    }
  }

  void removeFilter(String filter) {
    if (filter.startsWith('Blood:')) {
      bloodGroupFilter = '';
    } else if (filter == 'Medical Records') {
      medicalRecordsRequired = false;
    } else if (filter == 'Available Donors') {
      // tapping X on this chip → show ALL donors, not just available
      onlyAvailableDonors = false;
    } else if (filter.startsWith('Zip:')) {
      zipSearchText.clear();
    } else if (filter.startsWith('Name:')) {
      donarSearchText.clear();
    }

    applyFilters();
  }

  Color getAvailabilityColor(bool isAvailable) {
    return isAvailable ? Colors.green : Colors.orange;
  }

  String getDonorDistance(Map<String, dynamic> donor) {
    double distance = donor['distance']?.toDouble() ?? 0.0;
    return '${distance.toStringAsFixed(1)}km';
  }

  String getDonorRating(Map<String, dynamic> donor) {
    double rating = donor['rating']?.toDouble() ?? 0.0;
    return '${rating.toStringAsFixed(1)}★';
  }

  String getAvailabilityText(bool isAvailable) {
    return isAvailable ? 'Available'.tr : 'Unavailable'.tr;
  }

  void viewDonorProfile(Map<String, dynamic> donor) {
    print('Navigate to donor profile: ${donor['name']}');
  }

  void contactDonor(Map<String, dynamic> donor) {
    print('Contact donor: ${donor['name']}');
  }

  void refreshDonors() {
    loadDonors();
  }

  void loadMoreDonors() {
    loadDonors(loadMore: true);
  }

  void sendRequestToDonor({
    required int donorId,
    required String description,
    required int quantity,
    required String urgency,
    DateTime? neededBy,
  }) async {
    try {
      Map<String, dynamic> requestBody = {
        'donorId': donorId,
        'title': 'Milk Request'.tr,
        'description': description,
        'quantity': quantity,
        'urgency': urgency,
      };

      if (neededBy != null) {
        requestBody['neededBy'] = neededBy.toIso8601String();
      }

      await ApiService.request(
        endpoint: '/requests/send-to-donor',
        method: Api.POST,
        body: requestBody,
        onSuccess: (data) {
          Fluttertoast.showToast(msg: 'Request sent successfully!'.tr);
        },
        onError: (error) {
          Fluttertoast.showToast(msg: 'Failed to send request: $error');
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to send request: $e');
    }
  }
}
