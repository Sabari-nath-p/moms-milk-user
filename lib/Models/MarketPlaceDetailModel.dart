class MarketplaceDetailsModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final double price;
  final String category;
  final String condition;
  final String zipcode;
  final String placeName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MarketplaceUser user;
  final List<MarketplaceImage> images;
  final MarketplaceCount count;
  final List<dynamic> savedBy;

  MarketplaceDetailsModel({
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
    required this.savedBy,
  });

  factory MarketplaceDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarketplaceDetailsModel(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",

      price:
          (json["price"] is int)
              ? (json["price"] as int)
                  .toDouble()
              : double.tryParse(
                    json["price"]
                        .toString(),
                  ) ??
                  0.0,

      category:
          json["category"] ?? "",

      condition:
          json["condition"] ?? "",

      zipcode:
          json["zipcode"] ?? "",

      placeName:
          json["placeName"] ?? "",

      status:
          json["status"] ?? "",

      createdAt:
          DateTime.tryParse(
                json["createdAt"] ??
                    "",
              ) ??
              DateTime.now(),

      updatedAt:
          DateTime.tryParse(
                json["updatedAt"] ??
                    "",
              ) ??
              DateTime.now(),

      user: MarketplaceUser.fromJson(
        json["user"] ?? {},
      ),

      images:
          (json["images"]
                      as List? ??
                  [])
              .map(
                (e) =>
                    MarketplaceImage
                        .fromJson(e),
              )
              .toList(),

      count:
          MarketplaceCount.fromJson(
        json["_count"] ?? {},
      ),

      savedBy:
          json["savedBy"] ?? [],
    );
  }
}

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
      zipcode:
          json["zipcode"] ?? "",
    );
  }
}

class MarketplaceImage {
  final int id;
  final int listingId;
  final String url;
  final bool isPrimary;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  MarketplaceImage({
    required this.id,
    required this.listingId,
    required this.url,
    required this.isPrimary,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarketplaceImage.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarketplaceImage(
      id: json["id"] ?? 0,

      listingId:
          json["listingId"] ?? 0,

      url:
          json["url"] ?? "",

      isPrimary:
          json["isPrimary"] ??
              false,

      sortOrder:
          json["sortOrder"] ?? 0,

      createdAt:
          DateTime.tryParse(
                json["createdAt"] ??
                    "",
              ) ??
              DateTime.now(),

      updatedAt:
          DateTime.tryParse(
                json["updatedAt"] ??
                    "",
              ) ??
              DateTime.now(),
    );
  }
}

class MarketplaceCount {
  final int savedBy;

  MarketplaceCount({
    required this.savedBy,
  });

  factory MarketplaceCount.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarketplaceCount(
      savedBy:
          json["savedBy"] ?? 0,
    );
  }
}