
class MarketplaceListing {
  final int id;
  final int userId;
  final String title;
  final String description;
  final int price;
  final String category;
  final String condition;
  final String zipcode;
  final String placeName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  final MarketplaceUser user;
  final List<ListingImage> images;
  final ListingCount count;

  MarketplaceListing({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.zipcode,
    required this.placeName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.images,
    required this.count,
  });

  factory MarketplaceListing.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarketplaceListing(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      category: json["category"] ?? "",
      condition: json["condition"] ?? "",
      zipcode: json["zipcode"] ?? "",
      placeName: json["placeName"] ?? "",
      status: json["status"] ?? "",
      createdAt:
          DateTime.tryParse(
            json["createdAt"] ?? "",
          ) ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(
            json["updatedAt"] ?? "",
          ) ??
          DateTime.now(),
      user: MarketplaceUser.fromJson(
        json["user"] ?? {},
      ),
      images:
          (json["images"] as List<dynamic>? ?? [])
              .map(
                (e) => ListingImage.fromJson(e),
              )
              .toList(),
      count: ListingCount.fromJson(
        json["_count"] ?? {},
      ),
    );
  }
}

/// ================= USER =================

class MarketplaceUser {
  final int id;
  final String name;
  final String zipcode;

  MarketplaceUser({
    required this.id,
    required this.name,
    required this.zipcode,
  });

  factory MarketplaceUser.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarketplaceUser(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      zipcode: json["zipcode"] ?? "",
    );
  }
}

/// ================= IMAGE =================

class ListingImage {
  final int id;
  final int listingId;
  final String url;
  final bool isPrimary;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  ListingImage({
    required this.id,
    required this.listingId,
    required this.url,
    required this.isPrimary,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ListingImage.fromJson(
    Map<String, dynamic> json,
  ) {
    return ListingImage(
      id: json["id"] ?? 0,
      listingId: json["listingId"] ?? 0,
      url: json["url"] ?? "",
      isPrimary: json["isPrimary"] ?? false,
      sortOrder: json["sortOrder"] ?? 0,
      createdAt:
          DateTime.tryParse(
            json["createdAt"] ?? "",
          ) ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(
            json["updatedAt"] ?? "",
          ) ??
          DateTime.now(),
    );
  }
}

/// ================= COUNT =================

class ListingCount {
  final int savedBy;

  ListingCount({
    required this.savedBy,
  });

  factory ListingCount.fromJson(
    Map<String, dynamic> json,
  ) {
    return ListingCount(
      savedBy: json["savedBy"] ?? 0,
    );
  }
}

/// ================= PAGINATION =================

class PaginationModel {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PaginationModel(
      currentPage: json["currentPage"] ?? 1,
      totalPages: json["totalPages"] ?? 1,
      totalItems: json["totalItems"] ?? 0,
      itemsPerPage: json["itemsPerPage"] ?? 20,
      hasNextPage: json["hasNextPage"] ?? false,
      hasPreviousPage:
          json["hasPreviousPage"] ?? false,
    );
  }}