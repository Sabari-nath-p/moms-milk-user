import 'dart:convert';
import 'package:mommilk_user/Models/MarketListingModel.dart';

/// Response model for `GET /users/:id/profile` — a seller/donor's public
/// profile plus the feed of their ACTIVE marketplace listings.
class SellerProfileModel {
  final int id;
  final String name;
  final String description;
  final String? profilePhoto;
  final bool availableForDonation;
  final String userType;
  final List<SellerListingItem> marketplaceListings;

  SellerProfileModel({
    required this.id,
    required this.name,
    required this.description,
    this.profilePhoto,
    this.availableForDonation = false,
    required this.userType,
    this.marketplaceListings = const [],
  });

  bool get isDonor => userType.toUpperCase() == 'DONOR';

  factory SellerProfileModel.fromJson(Map<String, dynamic> json) {
    return SellerProfileModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      profilePhoto: json["profilePhoto"] as String?,
      availableForDonation: json["availableForDonation"] ?? false,
      userType: json["userType"] ?? "",
      marketplaceListings: (json["marketplaceListings"] as List<dynamic>? ?? [])
          .map((e) => SellerListingItem.fromJson(e))
          .toList(),
    );
  }
}

/// A single listing inside a seller's profile feed. Kept separate from
/// [MarketplaceListing] (the marketplace-search result shape) since this
/// endpoint returns a slightly different — flatter — shape (e.g. materials
/// / colors / boxContains can arrive as JSON-encoded strings here).
class SellerListingItem {
  final int id;
  final int userId;
  final String title;
  final String description;
  final int price;
  final int? quantity;
  final String category;
  final String? condition;
  final String? zipcode;
  final String? placeName;
  final int? originPrice;
  final DateTime? purchasedOn;
  final String? brand;
  final List<String> materials;
  final List<String> colors;
  final String? dimensions;
  final List<String> boxContains;
  final bool isDonation;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ListingImage> images;
  final int savedByCount;

  SellerListingItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    this.quantity,
    required this.category,
    this.condition,
    this.zipcode,
    this.placeName,
    this.originPrice,
    this.purchasedOn,
    this.brand,
    this.materials = const [],
    this.colors = const [],
    this.dimensions,
    this.boxContains = const [],
    this.isDonation = false,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.images = const [],
    this.savedByCount = 0,
  });

  /// Discount % from originPrice vs price — same formula as the other
  /// listing models.
  int? get discountPercent {
    final op = originPrice;
    if (op == null || op <= price) return null;
    return (((op - price) / op) * 100).round();
  }

  /// materials / colors / boxContains sometimes arrive as a real JSON array,
  /// sometimes as a JSON-encoded *string* of an array (e.g. `"[\"red\"]"`) —
  /// this handles both, plus null/empty.
  static List<String> _stringList(dynamic value) {
    if (value == null) return [];
    if (value is List) return List<String>.from(value.map((e) => e.toString()));
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return [];
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is List) {
          return List<String>.from(decoded.map((e) => e.toString()));
        }
      } catch (_) {
        // not JSON — treat the whole string as a single value
      }
      return [trimmed];
    }
    return [];
  }

  factory SellerListingItem.fromJson(Map<String, dynamic> json) {
    return SellerListingItem(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? 0,
      quantity: json["quantity"] as int?,
      category: json["category"] ?? "",
      condition: json["condition"] as String?,
      zipcode: json["zipcode"] as String?,
      placeName: json["placeName"] as String?,
      originPrice: json["originPrice"] as int?,
      purchasedOn: json["purchasedOn"] != null
          ? DateTime.tryParse(json["purchasedOn"])
          : null,
      brand: json["brand"] as String?,
      materials: _stringList(json["materials"]),
      colors: _stringList(json["colors"]),
      dimensions: json["dimensions"] as String?,
      boxContains: _stringList(json["boxContains"]),
      isDonation: json["isDonation"] ?? false,
      status: json["status"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
      images: (json["images"] as List<dynamic>? ?? [])
          .map((e) => ListingImage.fromJson(e))
          .toList(),
      savedByCount: (json["_count"] as Map<String, dynamic>?)?["savedBy"] ?? 0,
    );
  }
}
