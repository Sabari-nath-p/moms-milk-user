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

  // ── NEW fields ────────────────────────────────────────────────────────────
  final int? originPrice;
  final DateTime? purchasedOn;
  final String? brand;
  final List<String> materials;
  final List<String> colors;
  final String? dimensions;
  final List<String> boxContains;

  final MarketplaceDetailsUser user;
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
    this.originPrice,
    this.purchasedOn,
    this.brand,
    this.materials = const [],
    this.colors = const [],
    this.dimensions,
    this.boxContains = const [],
    required this.user,
    required this.images,
    required this.count,
    required this.savedBy,
  });

  /// Derived: discount % from originPrice
  int? get discountPercent {
    final op = originPrice;
    if (op == null || op <= price) return null;
    return (((op - price) / op) * 100).round();
  }

  /// Derived: "X months" from purchasedOn
  String? get usedDuration {
    if (purchasedOn == null) return null;
    final now = DateTime.now();
    final diff = now.difference(purchasedOn!);
    final months = (diff.inDays / 30).round();
    if (months == 0) return 'less than a month';
    if (months < 12) return '$months month${months == 1 ? '' : 's'}';
    final years = (months / 12).round();
    return '$years year${years == 1 ? '' : 's'}';
  }

  factory MarketplaceDetailsModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceDetailsModel(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: (json["price"] is int)
          ? (json["price"] as int).toDouble()
          : double.tryParse(json["price"].toString()) ?? 0.0,
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
      user: MarketplaceDetailsUser.fromJson(json["user"] ?? {}),
      images: (json["images"] as List? ?? [])
          .map((e) => MarketplaceImage.fromJson(e))
          .toList(),
      count: MarketplaceCount.fromJson(json["_count"] ?? {}),
      savedBy: json["savedBy"] ?? [],
    );
  }
}

// ── USER (details screen has richer user object) ──────────────────────────────

class MarketplaceDetailsUser {
  final int id;
  final String name;
  final String zipcode;
  final DateTime? lastWsConnectedAt;
  final int totalListingsCount;
  final DateTime? createdAt; // joined date

  MarketplaceDetailsUser({
    required this.id,
    required this.name,
    required this.zipcode,
    this.lastWsConnectedAt,
    this.totalListingsCount = 0,
    this.createdAt,
  });

  /// "Active 2 hours ago" / "Active recently"
  String get activeAgo {
    if (lastWsConnectedAt == null) return 'recently';
    final diff = DateTime.now().difference(lastWsConnectedAt!);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${(diff.inDays / 7).round()} weeks ago';
  }

  /// "Joined in Feb 2022"
  String get joinedLabel {
    if (createdAt == null) return 'Joined —';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Joined in ${months[createdAt!.month - 1]} ${createdAt!.year}';
  }

  factory MarketplaceDetailsUser.fromJson(Map<String, dynamic> json) {
    return MarketplaceDetailsUser(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      zipcode: json["zipcode"] ?? "",
      lastWsConnectedAt: json["lastWsConnectedAt"] != null
          ? DateTime.tryParse(json["lastWsConnectedAt"])
          : null,
      totalListingsCount: json["totalListingsCount"] ?? 0,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
    );
  }
}

// ── IMAGE ─────────────────────────────────────────────────────────────────────

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

  factory MarketplaceImage.fromJson(Map<String, dynamic> json) {
    return MarketplaceImage(
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

class MarketplaceCount {
  final int savedBy;

  MarketplaceCount({required this.savedBy});

  factory MarketplaceCount.fromJson(Map<String, dynamic> json) {
    return MarketplaceCount(savedBy: json["savedBy"] ?? 0);
  }
}
