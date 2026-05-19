class MyListingModel {
  final List<MyListing> data;
  final Pagination pagination;

  MyListingModel({
    required this.data,
    required this.pagination,
  });

  factory MyListingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyListingModel(
      data: (json['data'] as List)
          .map((e) => MyListing.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(
        json['pagination'],
      ),
    );
  }
}

class MyListing {
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
  final String createdAt;
  final String updatedAt;
  final User user;
  final List<ListingImage> images;
  final int savedCount;

  MyListing({
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
    required this.savedCount,
  });

  factory MyListing.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyListing(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      description:
          json['description'] ?? '',
      price: json['price'] ?? 0,
      category:
          json['category'] ?? '',
      condition:
          json['condition'] ?? '',
      zipcode:
          json['zipcode'] ?? '',
      placeName:
          json['placeName'] ?? '',
      status: json['status'] ?? '',
      createdAt:
          json['createdAt'] ?? '',
      updatedAt:
          json['updatedAt'] ?? '',
      user: User.fromJson(
        json['user'] ?? {},
      ),
      images:
          (json['images'] as List?)
              ?.map(
                (e) =>
                    ListingImage.fromJson(
                  e,
                ),
              )
              .toList() ??
          [],
      savedCount:
          json['_count']?['savedBy'] ??
              0,
    );
  }
}

class User {
  final int id;
  final String name;
  final String zipcode;

  User({
    required this.id,
    required this.name,
    required this.zipcode,
  });

  factory User.fromJson(
    Map<String, dynamic> json,
  ) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      zipcode:
          json['zipcode'] ?? '',
    );
  }
}

class ListingImage {
  final int id;
  final int listingId;
  final String url;
  final bool isPrimary;
  final int sortOrder;

  ListingImage({
    required this.id,
    required this.listingId,
    required this.url,
    required this.isPrimary,
    required this.sortOrder,
  });

  factory ListingImage.fromJson(
    Map<String, dynamic> json,
  ) {
    return ListingImage(
      id: json['id'] ?? 0,
      listingId:
          json['listingId'] ?? 0,
      url: json['url'] ?? '',
      isPrimary:
          json['isPrimary'] ?? false,
      sortOrder:
          json['sortOrder'] ?? 0,
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory Pagination.fromJson(
    Map<String, dynamic> json,
  ) {
    return Pagination(
      currentPage:
          json['currentPage'] ?? 1,
      totalPages:
          json['totalPages'] ?? 1,
      totalItems:
          json['totalItems'] ?? 0,
      itemsPerPage:
          json['itemsPerPage'] ?? 20,
    );
  }
}