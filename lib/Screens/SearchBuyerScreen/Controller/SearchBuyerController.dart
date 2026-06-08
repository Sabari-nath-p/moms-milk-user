import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/SearchBuyerModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class SearchBuyerController extends GetxController {
  TextEditingController zipSearchText = TextEditingController(
    text: user.zipcode,
  );
  TextEditingController buyerSearchText = TextEditingController();

  bool isLoading = false;
  bool isSearching = false;

  List<SearchBuyerModel> allBuyers = [];
  List<SearchBuyerModel> filteredBuyers = [];
  List<String> activeFilters = [];

  int currentPage = 1;
  int limit = 10;
  bool hasMoreData = true;
  bool isLoadingMore = false;

  @override
  void onInit() {
    super.onInit();
    loadBuyers();
  }

  @override
  void onClose() {
    zipSearchText.dispose();
    buyerSearchText.dispose();
    super.onClose();
  }

  void searchBuyers() {
    loadBuyers();
  }

  void loadBuyers({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMoreData || isLoadingMore) return;
      isLoadingMore = true;
      currentPage++;
    } else {
      isLoading = true;
      currentPage = 1;
      hasMoreData = true;
      allBuyers.clear();
    }

    update();

    try {
      Map<String, String> queryParams = {
        'page': currentPage.toString(),
        'limit': limit.toString(),
      };

      if (zipSearchText.text.isNotEmpty) {
        queryParams['zipcode'] = zipSearchText.text;
      }

      if (buyerSearchText.text.isNotEmpty) {
        queryParams['buyerName'] = buyerSearchText.text;
      }

      String endpoint = "/requests/search/buyers";
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
          List<dynamic> buyersData = data.data['data'] ?? [];
          Map<String, dynamic>? paginationData = data.data['pagination'];

          List<SearchBuyerModel> newBuyers = buyersData
              .map((item) => SearchBuyerModel.fromJson(item))
              .toList();

          if (loadMore) {
            allBuyers.addAll(newBuyers);
          } else {
            allBuyers = newBuyers;
          }

          if (paginationData != null) {
            hasMoreData = paginationData['hasNextPage'] ?? false;
            currentPage = paginationData['currentPage'] ?? currentPage;
          } else {
            hasMoreData = newBuyers.length >= limit;
          }

          filteredBuyers = List.from(allBuyers);
        },
        onError: (error) {
          Fluttertoast.showToast(msg: 'Failed to load buyers: $error'.tr);
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to load buyers: $e'.tr);
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  void applyFilters() {
    updateActiveFilters();
    loadBuyers();
  }

  void clearAllFilters() {
    zipSearchText.clear();
    buyerSearchText.clear();
    updateActiveFilters();
    loadBuyers();
  }

  void updateActiveFilters() {
    activeFilters.clear();
    if (zipSearchText.text.isNotEmpty) {
      activeFilters.add('Zip: ${zipSearchText.text}'.tr);
    }
    if (buyerSearchText.text.isNotEmpty) {
      activeFilters.add('Name: ${buyerSearchText.text}'.tr);
    }
  }

  void removeFilter(String filter) {
    if (filter.startsWith('Zip:')) {
      zipSearchText.clear();
    } else if (filter.startsWith('Name:')) {
      buyerSearchText.clear();
    }
    applyFilters();
  }

  void loadMoreBuyers() {
    loadBuyers(loadMore: true);
  }

  void sendRequestToBuyer({
    required int buyerId,
    required String description,
    required int quantity,
    required String urgency,
    DateTime? neededBy,
  }) async {
    try {
      Map<String, dynamic> requestBody = {
        'buyerId': buyerId,
        'title': 'Milk Offer'.tr,
        'description': description,
        'quantity': quantity,
        'urgency': urgency,
      };

      if (neededBy != null) {
        requestBody['neededBy'] = neededBy.toIso8601String();
      }

      await ApiService.request(
        endpoint: '/requests/send-to-buyer',
        method: Api.POST,
        body: requestBody,
        onSuccess: (data) {
          Fluttertoast.showToast(msg: 'Request sent successfully!'.tr);
        },
        onError: (error) {
          Fluttertoast.showToast(msg: 'Failed to send request: $error'.tr);
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to send request: $e'.tr);
    }
  }
}
