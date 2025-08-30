import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/SearchDonarModel.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class SearchDonarController extends GetxController {
  TextEditingController zipSearchText = TextEditingController();
  TextEditingController donarSearchText = TextEditingController();

  // Loading states
  bool isLoading = false;
  bool isSearching = false;

  // Sorting
  String sortBy = 'distance';
  final List<String> sortOptions = [
    'distance',
    'rating',
    'recent',
    'availability',
  ];

  // Filters
  String bloodGroupFilter = '';
  bool medicalRecordsRequired = false;
  bool onlyAvailableDonors = true;

  // Data lists
  List<SearchDonarModel> allDonors = [];
  List<SearchDonarModel> filteredDonors = [];
  List<String> activeFilters = [];

  // Pagination
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

  // Search functionality
  void searchDonors() {
    // Reset pagination and reload with new search criteria
    loadDonors();
  }

  // Load donors from API
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
      
      // Build query parameters
      Map<String, String> queryParams = {
        'page': currentPage.toString(),
        'limit': limit.toString(),
      };

      // Add optional filters
      if (bloodGroupFilter.isNotEmpty) {
        queryParams['bloodGroup'] = bloodGroupFilter;
      }

      if (medicalRecordsRequired) {
        queryParams['ableToShareMedicalRecord'] = 'true';
      }

      if (onlyAvailableDonors) {
        queryParams['isAvailable'] = 'true';
      }

      if (zipSearchText.text.isNotEmpty) {
        queryParams['zipcode'] = zipSearchText.text;
      }

      if (donarSearchText.text.isNotEmpty) {
        queryParams['donorName'] = donarSearchText.text;
      }

      //queryParams['maxDistance'] = "10";

      // Build endpoint with query parameters
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
          // Handle new API response format with pagination
          List<dynamic> donorsData = data.data['data'] ?? [];
          Map<String, dynamic>? paginationData = data.data['pagination'];

          // Parse donor data
          List<SearchDonarModel> newDonors =
              donorsData
                  .map((item) => SearchDonarModel.fromJson(item))
                  .toList();

          if (loadMore) {
            allDonors.addAll(newDonors);
          } else {
            allDonors = newDonors;
          }

          // Use pagination data from API response
          if (paginationData != null) {
            hasMoreData = paginationData['hasNextPage'] ?? false;
            currentPage = paginationData['currentPage'] ?? currentPage;
          } else {
            // Fallback to old logic if pagination data not available
            hasMoreData = newDonors.length >= limit;
          }

          filteredDonors = List.from(allDonors);
          // sortDonors();
          //updateActiveFilters();
        },
        onError: (error) {
          Get.snackbar('Error', 'Failed to load donors: $error');
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load donors: $e');
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  // Apply filters - now triggers API call with filters
  void applyFilters() {
    // Update active filters display
    updateActiveFilters();

    // Reload data with new filters
    loadDonors();
  }

  // Sort donors
  // void sortDonors() {
  //   switch (sortBy) {
  //     case 'distance':
  //       filteredDonors.sort(
  //         (a, b) => (a['distance'] ?? 0).compareTo(b['distance'] ?? 0),
  //       );
  //       break;
  //     case 'rating':
  //       filteredDonors.sort(
  //         (a, b) => (b['rating'] ?? 0).compareTo(a['rating'] ?? 0),
  //       );
  //       break;
  //     case 'recent':
  //       filteredDonors.sort((a, b) {
  //         DateTime aDate =
  //             DateTime.tryParse(a['lastActive'] ?? '') ?? DateTime.now();
  //         DateTime bDate =
  //             DateTime.tryParse(b['lastActive'] ?? '') ?? DateTime.now();
  //         return bDate.compareTo(aDate);
  //       });
  //       break;
  //     case 'availability':
  //       filteredDonors.sort((a, b) {
  //         bool aAvailable = a['isAvailable'] ?? false;
  //         bool bAvailable = b['isAvailable'] ?? false;
  //         return bAvailable ? 1 : (aAvailable ? -1 : 0);
  //       });
  //       break;
  //   }
  //   update();
  // }

  // Update sort option
  // void updateSortBy(String newSortBy) {
  //   sortBy = newSortBy;
  //  // sortDonors();
  // }

  // Filter management
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

    if (!onlyAvailableDonors) {
      activeFilters.add('All Donors');
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
    } else if (filter == 'All Donors') {
      onlyAvailableDonors = true;
    } else if (filter.startsWith('Zip:')) {
      zipSearchText.clear();
    } else if (filter.startsWith('Name:')) {
      donarSearchText.clear();
    }

    applyFilters();
  }

  // Utility functions
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
    return isAvailable ? 'Available' : 'Busy';
  }

  // Navigation functions
  void viewDonorProfile(Map<String, dynamic> donor) {
    // TODO: Navigate to donor profile screen
    // Get.to(() => DonorProfileScreen(donor: donor));
    print('Navigate to donor profile: ${donor['name']}');
  }

  void contactDonor(Map<String, dynamic> donor) {
    // TODO: Navigate to contact/chat screen
    // Get.to(() => ChatScreen(donor: donor));
    print('Contact donor: ${donor['name']}');
  }

  // Refresh functionality
  void refreshDonors() {
    loadDonors();
  }

  // Load more donors for pagination
  void loadMoreDonors() {
    loadDonors(loadMore: true);
  }

  // Send request to donor
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
        'title': 'Milk Request',
        'description': description,
        'quantity': quantity,
        'urgency': urgency,
      };

      // Add neededBy if provided
      if (neededBy != null) {
        requestBody['neededBy'] = neededBy.toIso8601String();
      }

      await ApiService.request(
        endpoint: '/requests/send-to-donor',
        method: Api.POST,
        body: requestBody,
        onSuccess: (data) {
          Get.snackbar(
            'Success',
            'Request sent successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        onError: (error) {
          Get.snackbar('Error', 'Failed to send request: $error');
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send request: $e');
    }
  }
}
