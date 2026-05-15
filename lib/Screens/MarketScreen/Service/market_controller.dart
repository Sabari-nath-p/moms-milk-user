/// ================= MARKET CONTROLLER =================

import 'dart:developer';

import 'package:get/get.dart';
import 'package:mommilk_user/Models/MarketListingModel.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class MarketController extends GetxController {
  final ApiService _apiService = ApiService();

  /// ================= LOADING =================

  bool isLoading = false;
  bool isLoadingMore = false;

  /// ================= PAGINATION =================

  int currentPage = 1;
  int totalPages = 1;
  bool hasNextPage = false;

  /// ================= FILTERS =================

  String search = "";
  String selectedCategory = "";
  String selectedCondition = "";

  /// ================= LIST =================

  List<MarketplaceListing> listings = [];

  /// ================= FETCH =================

  Future<void> fetchMarketplaceListings({
    String searchText = "",
    String category = "",
    String condition = "",
    int page = 1,
    int limit = 20,
    bool isRefresh = false,
  }) async {
    try {
      if (page == 1) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }

      update();

      if (isRefresh) {
        listings.clear();
      }

      search = searchText;
      selectedCategory = category;
      selectedCondition = condition;

      /// ================= QUERY PARAMS =================

      final queryParams = {
        "search": searchText,
        "page": page.toString(),
        "limit": limit.toString(),
      };

      /// CATEGORY

      if (category.isNotEmpty) {
        queryParams["category"] = category;
      }

      /// CONDITION

      if (condition.isNotEmpty) {
        queryParams["condition"] = condition;
      }

      final endpoint =
          "/marketplace/listings?"
          "${Uri(queryParameters: queryParams).query}";

      log("MARKET ENDPOINT => $endpoint");

      await _apiService.get(
        endpoint: endpoint,
        requiresAuth: false,

        onSuccess: (response) {
          try {
            final jsonData = response.data;

            final List<dynamic> data =
                jsonData["data"] ?? [];

            final fetchedListings = data
                .map(
                  (e) => MarketplaceListing.fromJson(e),
                )
                .toList();

            if (page == 1) {
              listings = fetchedListings;
            } else {
              listings.addAll(fetchedListings);
            }

            final pagination =
                PaginationModel.fromJson(
                  jsonData["pagination"] ?? {},
                );

            currentPage =
                pagination.currentPage;

            totalPages =
                pagination.totalPages;

            hasNextPage =
                pagination.hasNextPage;

            log(
              "LISTINGS COUNT => ${listings.length}",
            );
          } catch (e) {
            log("PARSE ERROR => $e");
          }
        },

        onServerError: (
          status,
          message,
        ) {
          log("SERVER ERROR => $status");
          log(message);
        },

        onNetworkError: (message) {
          log("NETWORK ERROR => $message");
        },

        onError: (error) {
          log("MARKET ERROR => $error");
        },
      );
    } catch (e) {
      log("FETCH ERROR => $e");
    } finally {
      isLoading = false;
      isLoadingMore = false;

      update();
    }
  }

  /// ================= LOAD MORE =================

  Future<void> loadMore() async {
    if (hasNextPage &&
        !isLoadingMore) {
      await fetchMarketplaceListings(
        searchText: search,
        category: selectedCategory,
        condition: selectedCondition,
        page: currentPage + 1,
      );
    }
  }

  /// ================= REFRESH =================

  Future<void> refreshMarketplace() async {
    await fetchMarketplaceListings(
      searchText: search,
      category: selectedCategory,
      condition: selectedCondition,
      page: 1,
      isRefresh: true,
    );
  }
}