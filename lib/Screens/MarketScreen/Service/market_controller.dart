/// ================= MARKET CONTROLLER =================

import 'dart:developer';

import 'package:get/get.dart';
import 'package:mommilk_user/Models/MarketListingModel.dart';
import 'package:mommilk_user/Models/MarketPlaceDetailModel.dart';
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

MarketplaceDetailsModel?
    marketplaceDetails;

bool isDetailsLoading = false;


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
/// ================= SINGLE LISTING =================
/// ================= DETAILS =================

/// ================= FETCH DETAILS =================
Future<void> fetchMarketplaceDetails(
  int listingId,
) async {
  try {
    isDetailsLoading = true;
    update();

    final endpoint =
        "/marketplace/listings/$listingId";

    log("================================");
    log("DETAIL API CALL START");
    log("ENDPOINT => $endpoint");
    log("LISTING ID => $listingId");
    log("================================");

    await _apiService.get(
      endpoint: endpoint,
      requiresAuth: false,
      onSuccess: (response) {
  try {
    log("DETAIL RESPONSE => ${response.data}");

    final jsonData = response.data;

    /// ✅ handle both API formats safely
    final Map<String, dynamic>? data =
        (jsonData is Map<String, dynamic> &&
                jsonData.containsKey("data"))
            ? jsonData["data"]
            : jsonData;

    if (data == null) {
      log("DATA IS NULL");
     isDetailsLoading = true;
marketplaceDetails = null;
update();
      return;
    }

    marketplaceDetails =
        MarketplaceDetailsModel.fromJson(data);

    log("DETAIL LOADED => ${marketplaceDetails?.title}");
  } catch (e, st) {
    log("DETAIL PARSE ERROR => $e");
    log("$st");
  }
},

      onServerError: (
        status,
        message,
      ) {
        log(
          "================================",
        );

        log(
          "DETAIL SERVER ERROR",
        );

        log(
          "STATUS => $status",
        );

        log(
          "MESSAGE => $message",
        );

        log(
          "================================",
        );
      },

      onNetworkError: (
        message,
      ) {
        log(
          "================================",
        );

        log(
          "DETAIL NETWORK ERROR",
        );

        log(
          "MESSAGE => $message",
        );

        log(
          "================================",
        );
      },

      onError: (error) {
        log(
          "================================",
        );

        log(
          "DETAIL UNKNOWN ERROR",
        );

        log(
          "ERROR => $error",
        );

        log(
          "================================",
        );
      },
    );
  } catch (e, stackTrace) {
    log(
      "================================",
    );

    log(
      "DETAIL FETCH ERROR => $e",
    );

    log(
      "STACK TRACE => $stackTrace",
    );

    log(
      "================================",
    );
  } finally {
    isDetailsLoading = false;

    update();

    log(
      "DETAIL LOADING FINISHED",
    );
  }
}

/// ================= CLEAR DETAILS =================

void clearMarketplaceDetails() {
  marketplaceDetails = null;
  update();
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