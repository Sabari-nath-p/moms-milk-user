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

  final int? originPrice;
  final DateTime? purchasedOn;
  final String? brand;
  final List<String> materials;
  final List<String> colors;
  final String? dimensions;
  final List<String> boxContains;

  // FIX 3: distanceKm from API response — e.g. 14.93
  final double? distanceKm;

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
    this.originPrice,
    this.purchasedOn,
    this.brand,
    this.materials = const [],
    this.colors = const [],
    this.dimensions,
    this.boxContains = const [],
    this.distanceKm, // ← new
    required this.user,
    required this.images,
    required this.count,
  });

  /// "X months" / "X years" from purchasedOn → today
  String? get usedDuration {
    if (purchasedOn == null) return null;
    final months = (DateTime.now().difference(purchasedOn!).inDays / 30)
        .round();
    if (months == 0) return 'less than a month';
    if (months < 12) return '$months month${months == 1 ? '' : 's'}';
    final years = (months / 12).round();
    return '$years year${years == 1 ? '' : 's'}';
  }

  /// Discount % from originPrice vs price
  int? get discountPercent {
    if (originPrice == null || originPrice! <= price) return null;
    return (((originPrice! - price) / originPrice!) * 100).round();
  }

  /// Human-readable distance string, e.g. "1.8 km" or "15 km"
  String? get distanceLabel {
    if (distanceKm == null) return null;
    // show one decimal only when < 10 km, otherwise round
    if (distanceKm! < 10) {
      return '${distanceKm!.toStringAsFixed(1)} km';
    }
    return '${distanceKm!.round()} km';
  }

  factory MarketplaceListing.fromJson(Map<String, dynamic> json) {
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
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
      originPrice: json["originPrice"] as int?,
      purchasedOn: json["purchasedOn"] != null
          ? DateTime.tryParse(json["purchasedOn"])
          : null,
      brand: json["brand"] as String?,
      materials: List<String>.from(json["materials"] ?? []),
      colors: List<String>.from(json["colors"] ?? []),
      dimensions: json["dimensions"] as String?,
      boxContains: List<String>.from(json["boxContains"] ?? []),

      // FIX 3: parse distanceKm — API returns it as a double e.g. 14.93
      distanceKm: json["distanceKm"] != null
          ? (json["distanceKm"] as num).toDouble()
          : null,

      user: MarketplaceUser.fromJson(json["user"] ?? {}),
      images: (json["images"] as List<dynamic>? ?? [])
          .map((e) => ListingImage.fromJson(e))
          .toList(),
      count: ListingCount.fromJson(json["_count"] ?? {}),
    );
  }
}

// ── USER ──────────────────────────────────────────────────────────────────────

class MarketplaceUser {
  final int id;
  final String name;
  final String zipcode;
  final DateTime? lastWsConnectedAt;
  final int totalListingsCount;

  MarketplaceUser({
    required this.id,
    required this.name,
    required this.zipcode,
    this.lastWsConnectedAt,
    this.totalListingsCount = 0,
  });

  String get activeAgo {
    if (lastWsConnectedAt == null) return 'recently';
    final diff = DateTime.now().difference(lastWsConnectedAt!);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${(diff.inDays / 7).round()} weeks ago';
  }

  factory MarketplaceUser.fromJson(Map<String, dynamic> json) {
    return MarketplaceUser(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      zipcode: json["zipcode"] ?? "",
      lastWsConnectedAt: json["lastWsConnectedAt"] != null
          ? DateTime.tryParse(json["lastWsConnectedAt"])
          : null,
      totalListingsCount: json["totalListingsCount"] ?? 0,
    );
  }
}

// ── IMAGE ─────────────────────────────────────────────────────────────────────

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

  factory ListingImage.fromJson(Map<String, dynamic> json) {
    return ListingImage(
      id: json["id"] ?? 0,
      listingId: json["listingId"] ?? 0,
      url: json["url"] ?? "",
      isPrimary: json["isPrimary"] ?? false,
      sortOrder: json["sortOrder"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
    );
  }
}

// ── COUNT ─────────────────────────────────────────────────────────────────────

class ListingCount {
  final int savedBy;
  ListingCount({required this.savedBy});
  factory ListingCount.fromJson(Map<String, dynamic> json) =>
      ListingCount(savedBy: json["savedBy"] ?? 0);
}

// ── PAGINATION ────────────────────────────────────────────────────────────────

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

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json["currentPage"] ?? 1,
      totalPages: json["totalPages"] ?? 1,
      totalItems: json["totalItems"] ?? 0,
      itemsPerPage: json["itemsPerPage"] ?? 20,
      hasNextPage: json["hasNextPage"] ?? false,
      hasPreviousPage: json["hasPreviousPage"] ?? false,
    );
  }
}
