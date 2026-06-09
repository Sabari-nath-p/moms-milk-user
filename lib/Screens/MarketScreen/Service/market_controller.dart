import 'dart:developer';
import 'package:get/get.dart';
import 'package:mommilk_user/Models/MarketListingModel.dart';
import 'package:mommilk_user/Models/MarketPlaceDetailModel.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class MarketController extends GetxController {
  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  int totalPages = 1;
  bool hasNextPage = false;
  String search = "";
  String selectedCategory = "";
  String selectedCondition = "";
  int minPrice = 0;
  int maxPrice = 0;
  double maxDistance = 0;

  // Sort is applied CLIENT-SIDE — backend returns 0 items when sort params sent
  String sortBy = "";

  MarketplaceDetailsModel? marketplaceDetails;
  bool isDetailsLoading = false;

  // Raw listings from API
  List<MarketplaceListing> _rawListings = [];

  // Sorted view — what the UI reads via controller.listings
  List<MarketplaceListing> get listings => _sortedListings();

  List<MarketplaceListing> _sortedListings() {
    final list = List<MarketplaceListing>.from(_rawListings);

    // FIX #2490: when distance filter active, sort nearest first
    if (maxDistance > 0 && sortBy.isEmpty) {
      list.sort((a, b) {
        final da = a.distanceKm ?? double.infinity;
        final db = b.distanceKm ?? double.infinity;
        return da.compareTo(db);
      });
      return list;
    }
    switch (sortBy) {
      case 'price_asc':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'newest':
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
    return list;
  }

  Future<void> fetchMarketplaceListings({
    String searchText = "",
    String category = "",
    String condition = "",
    int minPriceVal = 0,
    int maxPriceVal = 0,
    double maxDistanceVal = 0,
    String sortByVal = "",
    int page = 1,
    int limit = 20,
    bool isRefresh = false,
  }) async {
    print("======= FETCH MARKETPLACE CALLED =======");
    print("instance: $hashCode | page: $page | category: $category");

    try {
      if (page == 1) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
      update();

      if (isRefresh || page == 1) {
        _rawListings = [];
      }

      search = searchText;
      selectedCategory = category;
      selectedCondition = condition;
      minPrice = minPriceVal;
      maxPrice = maxPriceVal;
      maxDistance = maxDistanceVal;
      sortBy = sortByVal;

      final queryParams = <String, String>{
        "page": page.toString(),
        "limit": limit.toString(),
      };

      if (searchText.isNotEmpty) queryParams["search"] = searchText;
      if (category.isNotEmpty) queryParams["category"] = category;
      if (condition.isNotEmpty) queryParams["condition"] = condition;
      if (minPriceVal > 0) queryParams["minPrice"] = minPriceVal.toString();
      if (maxPriceVal > 0) queryParams["maxPrice"] = maxPriceVal.toString();
      if (maxDistanceVal > 0) {
        queryParams["maxDistance"] = maxDistanceVal.toStringAsFixed(0);
      }

      // ⚠️ Sort NOT sent to backend — handled client-side in _sortedListings()

      final endpoint =
          "/marketplace/listings?${Uri(queryParameters: queryParams).query}";
      print("======= ENDPOINT: $endpoint =======");

      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        requiresAuth: true,
        onSuccess: (response) {
          print("======= MARKET API SUCCESS =======");
          try {
            final jsonData = response.data;
            final List<dynamic> data = jsonData["data"] ?? [];
            print("======= DATA LENGTH: ${data.length} =======");

            final fetchedListings = data
                .map((e) => MarketplaceListing.fromJson(e))
                .toList();

            if (page == 1) {
              _rawListings = fetchedListings;
            } else {
              _rawListings.addAll(fetchedListings);
            }

            final pagination = PaginationModel.fromJson(
              jsonData["pagination"] ?? {},
            );
            currentPage = pagination.currentPage;
            totalPages = pagination.totalPages;
            hasNextPage = pagination.hasNextPage;

            print(
              "======= RAW: ${_rawListings.length} | SORTED: ${listings.length} =======",
            );
          } catch (e, st) {
            print("======= PARSE ERROR: $e =======");
            print("$st");
          }
        },
        onServerError: (status, message) {
          print("======= SERVER ERROR $status: $message =======");
        },
        onError: (error) {
          print("======= MARKET ERROR: $error =======");
        },
      );
    } catch (e, st) {
      print("======= FETCH ERROR: $e =======");
      print("$st");
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
      print("======= FETCH FINISHED =======");
    }
  }

  /// Apply sort instantly without re-fetching
  void applySort(String newSortBy) {
    sortBy = newSortBy;
    update();
  }

  Future<void> fetchMarketplaceDetails(int listingId) async {
    print("======= FETCH DETAIL: $listingId =======");
    try {
      isDetailsLoading = true;
      update();

      await ApiService.request(
        endpoint: "/marketplace/listings/$listingId",
        method: Api.GET,
        requiresAuth: true,
        onSuccess: (response) {
          try {
            final jsonData = response.data;
            final Map<String, dynamic>? data =
                (jsonData is Map<String, dynamic> &&
                    jsonData.containsKey("data"))
                ? jsonData["data"]
                : (jsonData is Map<String, dynamic> ? jsonData : null);

            if (data == null) {
              marketplaceDetails = null;
              return;
            }
            marketplaceDetails = MarketplaceDetailsModel.fromJson(data);
            print(
              "======= DETAIL LOADED: ${marketplaceDetails?.title} =======",
            );
          } catch (e, st) {
            print("======= DETAIL PARSE ERROR: $e =======");
            print("$st");
          }
        },
        onServerError: (status, message) {
          print("======= DETAIL SERVER ERROR $status: $message =======");
        },
        onError: (error) {
          print("======= DETAIL ERROR: $error =======");
        },
      );
    } catch (e, st) {
      print("======= DETAIL FETCH ERROR: $e =======");
      print("$st");
    } finally {
      isDetailsLoading = false;
      update();
    }
  }

  void clearMarketplaceDetails() {
    marketplaceDetails = null;
    update();
  }

  Future<void> loadMore() async {
    if (hasNextPage && !isLoadingMore) {
      await fetchMarketplaceListings(
        searchText: search,
        category: selectedCategory,
        condition: selectedCondition,
        minPriceVal: minPrice,
        maxPriceVal: maxPrice,
        maxDistanceVal: maxDistance,
        sortByVal: sortBy,
        page: currentPage + 1,
      );
    }
  }

  Future<void> refreshMarketplace() async {
    await fetchMarketplaceListings(
      searchText: search,
      category: selectedCategory,
      condition: selectedCondition,
      minPriceVal: minPrice,
      maxPriceVal: maxPrice,
      maxDistanceVal: maxDistance,
      sortByVal: sortBy,
      page: 1,
      isRefresh: true,
    );
  }
}
