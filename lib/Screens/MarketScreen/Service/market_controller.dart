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
  MarketplaceDetailsModel? marketplaceDetails;
  bool isDetailsLoading = false;
  List<MarketplaceListing> listings = [];

  Future<void> fetchMarketplaceListings({
    String searchText = "",
    String category = "",
    String condition = "",
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
        listings.clear();
      }

      search = searchText;
      selectedCategory = category;
      selectedCondition = condition;

      final queryParams = <String, String>{
        "page": page.toString(),
        "limit": limit.toString(),
      };

      if (searchText.isNotEmpty) queryParams["search"] = searchText;
      if (category.isNotEmpty) queryParams["category"] = category;
      if (condition.isNotEmpty) queryParams["condition"] = condition;

      final endpoint =
          "/marketplace/listings?${Uri(queryParameters: queryParams).query}";

      print("======= ENDPOINT: $endpoint =======");

      await ApiService.request(
        endpoint: endpoint,
        method: Api.GET,
        requiresAuth: true,
        onSuccess: (response) {
          print("======= MARKET API SUCCESS =======");
          print("RAW RESPONSE: ${response.data}");

          try {
            final jsonData = response.data;
            final List<dynamic> data = jsonData["data"] ?? [];

            print("======= DATA LENGTH: ${data.length} =======");

            if (data.isNotEmpty) {
              print("======= FIRST ITEM: ${data[0]} =======");
              print("======= distanceKm: ${data[0]['distanceKm']} =======");
            } else {
              print("======= DATA IS EMPTY =======");
            }

            final fetchedListings = data
                .map((e) => MarketplaceListing.fromJson(e))
                .toList();

            if (fetchedListings.isNotEmpty) {
              print(
                "======= MODEL distanceKm: ${fetchedListings[0].distanceKm} =======",
              );
              print(
                "======= MODEL distanceLabel: ${fetchedListings[0].distanceLabel} =======",
              );
            }

            if (page == 1) {
              listings = fetchedListings;
            } else {
              listings.addAll(fetchedListings);
            }

            final pagination = PaginationModel.fromJson(
              jsonData["pagination"] ?? {},
            );
            currentPage = pagination.currentPage;
            totalPages = pagination.totalPages;
            hasNextPage = pagination.hasNextPage;

            print("======= LISTINGS COUNT: ${listings.length} =======");
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
            print("======= DETAIL RESPONSE: ${response.data} =======");
            final jsonData = response.data;

            final Map<String, dynamic>? data =
                (jsonData is Map<String, dynamic> &&
                    jsonData.containsKey("data"))
                ? jsonData["data"]
                : (jsonData is Map<String, dynamic> ? jsonData : null);

            if (data == null) {
              print("======= DETAIL DATA NULL =======");
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
      print("======= DETAIL FINISHED =======");
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
        page: currentPage + 1,
      );
    }
  }

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
