import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class MyListingsController extends GetxController {
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isUpdating = false;
  bool isUploadingImages = false;

  List<dynamic> listings = [];

  int currentPage = 1;
  int totalPages = 1;

  /// =========================
  /// TEXT CONTROLLERS
  /// =========================
  final titleController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final zipcodeController =
      TextEditingController();

  final placeController =
      TextEditingController();

  /// =========================
  /// DROPDOWN VALUES
  /// =========================
  String selectedCategory =
      "CRADLES";

  String selectedCondition =
      "NEW";

  /// All images (old + new)
  List<dynamic> editImages = [];

  @override
  void onInit() {
    fetchMyListings();
    super.onInit();
  }

  /// =========================
  /// FETCH MY LISTINGS
  /// =========================
  Future<void> fetchMyListings({
    bool isRefresh = false,
  }) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        listings.clear();
      }

      isLoading = true;
      update();

      await ApiService.request(
        endpoint:
            "/marketplace/my-listings?page=$currentPage&limit=20",
        method: Api.GET,

        onSuccess: (response) {
          final data =
              response.data;

          listings =
              List<dynamic>.from(
                data["data"] ?? [],
              );

          totalPages =
              data["pagination"]
                      ?["totalPages"] ??
                  1;

          update();
        },

        onError: (error) {
          Fluttertoast.showToast(
            msg: error.toString(),
          );
        },
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  /// =========================
  /// GET SINGLE LISTING
  /// =========================
  Future<void> getListingById(
    int id,
  ) async {
    try {
      isLoading = true;
      update();

      await ApiService.request(
        endpoint:
            "/marketplace/listings/$id",
        method: Api.GET,

        onSuccess: (response) {
          final data =
              response.data;

          titleController.text =
              data["title"] ?? "";

          descriptionController
                  .text =
              data["description"] ??
                  "";

          priceController.text =
              data["price"]
                  .toString();

          zipcodeController.text =
              data["zipcode"] ?? "";

          placeController.text =
              data["placeName"] ??
                  "";

          selectedCategory =
              data["category"] ??
                  "CRADLES";

          selectedCondition =
              data["condition"] ??
                  "NEW";

          /// KEEP EXISTING IMAGES
          editImages =
              List<dynamic>.from(
                data["images"] ?? [],
              );

          update();
        },

        onError: (error) {
          Fluttertoast.showToast(
            msg: error.toString(),
          );
        },
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  /// =========================
/// UPLOAD EDIT IMAGES
/// =========================
Future<void> uploadEditImages(
  List<File> images,
) async {
  try {
    isUploadingImages = true;
    update();

    log(
      "========== IMAGE UPLOAD START ==========",
    );

    /// TOKEN
    final token =
        await ApiService.getAuthToken();

    log(
      "TOKEN => $token",
    );

    /// REQUEST
    var request =
        http.MultipartRequest(
          "POST",
          Uri.parse(
            "${ApiService.baseUrl}/uploads/images",
          ),
        );

    request.headers.addAll({
      "Authorization":
          "Bearer $token",
      "Accept":
          "application/json",
    });

    log(
      "REQUEST URL => ${request.url}",
    );

    log(
      "REQUEST HEADERS => ${request.headers}",
    );

    /// ADD FILES
    for (File image in images) {
      try {
        final mimeType =
            lookupMimeType(
              image.path,
            );

        log(
          "FILE PATH => ${image.path}",
        );

        log(
          "MIME TYPE => $mimeType",
        );

        /// VALIDATION
        if (mimeType == null ||
            !mimeType.startsWith(
              "image/",
            )) {
          log(
            "SKIPPED INVALID FILE => ${image.path}",
          );

          continue;
        }

        final mimeSplit =
            mimeType.split("/");

        final multipartFile =
            await http.MultipartFile.fromPath(
              "files",
              image.path,
              contentType:
                  MediaType(
                    mimeSplit[0],
                    mimeSplit[1],
                  ),
            );

        request.files.add(
          multipartFile,
        );

        log(
          "FILE ADDED => ${image.path}",
        );
      } catch (e) {
        log(
          "FILE ERROR => $e",
        );
      }
    }

    log(
      "TOTAL FILES => ${request.files.length}",
    );

    if (request.files.isEmpty) {
      Fluttertoast.showToast(
        msg:
            "No valid images selected",
      );

      return;
    }

    /// SEND REQUEST
    final streamedResponse =
        await request.send();

    final response =
        await http.Response.fromStream(
          streamedResponse,
        );

    log(
      "========== RESPONSE ==========",
    );

    log(
      "STATUS CODE => ${response.statusCode}",
    );

    log(
      "RESPONSE BODY => ${response.body}",
    );

    log(
      "RESPONSE HEADERS => ${response.headers}",
    );

    /// SUCCESS
    if (response.statusCode ==
            200 ||
        response.statusCode ==
            201) {
      final decoded =
          jsonDecode(
            response.body,
          );

      log(
        "PARSED RESPONSE => $decoded",
      );

      /// HANDLE LIST RESPONSE
      if (decoded is List) {
        for (var item
            in decoded) {
          /// CASE 1:
          /// API RETURNS STRING URL
          if (item
              is String) {
            editImages.add({
              "url":
                  item,
              "isNew":
                  true,
            });
          }

          /// CASE 2:
          /// API RETURNS OBJECT
          else if (item
              is Map<
                String,
                dynamic
              >) {
            editImages.add({
              "id":
                  item["id"],

              "url":
                  item["url"] ??
                  "",

              "isPrimary":
                  item["isPrimary"] ??
                  false,

              "sortOrder":
                  item["sortOrder"] ??
                  0,

              "isNew":
                  true,
            });
          }
        }
      }

      log(
        "UPDATED IMAGES => ${jsonEncode(editImages)}",
      );

      update();

      Fluttertoast.showToast(
        msg:
            "Images uploaded successfully",
      );
    } else {
      log(
        "UPLOAD FAILED => ${response.statusCode}",
      );

      Fluttertoast.showToast(
        msg:
            "Upload failed (${response.statusCode})",
      );
    }
  } catch (
    e,
    stackTrace
  ) {
    log(
      "UPLOAD ERROR => $e",
    );

    log(
      "STACK TRACE => $stackTrace",
    );

    Fluttertoast.showToast(
      msg:
          e.toString(),
    );
  } finally {
    isUploadingImages =
        false;

    update();

    log(
      "========== IMAGE UPLOAD END ==========",
    );
  }
}

/// =========================
/// REMOVE IMAGE
/// =========================
void removeImage(
  int index,
) {
  if (index >= 0 &&
      index <
          editImages.length) {
    editImages.removeAt(
      index,
    );

    log(
      "IMAGE REMOVED => $editImages",
    );

    update();
  }
}
Future<void> updateListing(
  int id,
) async {
  try {
    isUpdating = true;
    update();

    /// IMAGE PAYLOAD
    List<Map<String, dynamic>>
        imagePayload = [];

    for (
      int i = 0;
      i < editImages.length;
      i++
    ) {
      final image =
          editImages[i];

      final imageUrl =
          image["url"]
              ?.toString() ??
          "";

      /// SKIP EMPTY URL
      if (imageUrl
          .trim()
          .isEmpty) {
        continue;
      }

      /// DO NOT SEND ID
      imagePayload.add({
        "url":
            imageUrl,

        "isPrimary":
            i == 0,

        "sortOrder":
            i,
      });
    }

    final body = {
      "title":
          titleController.text
              .trim(),

      "description":
          descriptionController
              .text
              .trim(),

      "price":
          int.tryParse(
                priceController.text
                    .trim(),
              ) ??
              0,

      "category":
          selectedCategory,

      "condition":
          selectedCondition,

      "zipcode":
          zipcodeController.text
              .trim(),

      "placeName":
          placeController.text
              .trim(),

      "images":
          imagePayload,
    };

    log(
      "========== UPDATE REQUEST ==========",
    );

    log(
      jsonEncode(body),
    );

    await ApiService.request(
      endpoint:
          "/marketplace/listings/$id",

      method:
          Api.PATCH,

      body: body,

      onSuccess: (
        response,
      ) async {
        log(
          "UPDATE RESPONSE => ${response.data}",
        );

        Fluttertoast.showToast(
          msg:
              "Listing updated successfully",
        );

        /// REFRESH LIST
        await fetchMyListings(
          isRefresh: true,
        );

        Get.back();
      },

      onError: (
        error,
      ) {
        log(
          "UPDATE ERROR => $error",
        );

        Fluttertoast.showToast(
          msg:
              error.toString(),
        );
      },
    );
  } catch (e) {
    log(
      "UPDATE EXCEPTION => $e",
    );

    Fluttertoast.showToast(
      msg:
          e.toString(),
    );
  } finally {
    isUpdating = false;
    update();
  }
}
  /// =========================
  /// DELETE LISTING
  /// =========================
  Future<void> deleteListing(
    int id,
  ) async {
    try {
      await ApiService.request(
        endpoint:
            "/marketplace/listings/$id",

        method:
            Api.DELETE,

        onSuccess: (
          response,
        ) {
          listings.removeWhere(
            (e) =>
                e["id"] ==
                id,
          );

          update();

          Fluttertoast.showToast(
            msg:
                "Listing deleted successfully",
          );
        },
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg:
            e.toString(),
      );
    }
  }

  /// =========================
  /// CLEAR EDIT
  /// =========================
  void clearEditFields() {
    titleController.clear();

    descriptionController
        .clear();

    priceController.clear();

    zipcodeController.clear();

    placeController.clear();

    selectedCategory =
        "CRADLES";

    selectedCondition =
        "NEW";

    editImages.clear();

    update();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController
        .dispose();
    priceController.dispose();
    zipcodeController.dispose();
    placeController.dispose();

    super.onClose();
  }
}