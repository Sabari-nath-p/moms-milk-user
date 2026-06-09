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

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final zipcodeController = TextEditingController();
  final placeController = TextEditingController();

  String selectedCategory = "CRADLES";
  String selectedCondition = "NEW";

  /// All images (existing + newly uploaded)
  List<dynamic> editImages = [];

  @override
  void onInit() {
    fetchMyListings();
    super.onInit();
  }

  // ── FETCH MY LISTINGS ────────────────────────────────────────────────────
  Future<void> fetchMyListings({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        listings.clear();
      }
      isLoading = true;
      update();

      await ApiService.request(
        endpoint: "/marketplace/my-listings?page=$currentPage&limit=20",
        method: Api.GET,
        onSuccess: (response) {
          final data = response.data;
          listings = List<dynamic>.from(data["data"] ?? []);
          totalPages = data["pagination"]?["totalPages"] ?? 1;
          update();
        },
        onError: (error) => Fluttertoast.showToast(msg: error.toString()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  // ── GET SINGLE LISTING ───────────────────────────────────────────────────
  Future<void> getListingById(int id) async {
    try {
      isLoading = true;
      update();

      await ApiService.request(
        endpoint: "/marketplace/listings/$id",
        method: Api.GET,
        onSuccess: (response) {
          final data = response.data;
          titleController.text = data["title"] ?? "";
          descriptionController.text = data["description"] ?? "";
          priceController.text = data["price"].toString();
          zipcodeController.text = data["zipcode"] ?? "";
          placeController.text = data["placeName"] ?? "";
          selectedCategory = data["category"] ?? "CRADLES";
          selectedCondition = data["condition"] ?? "NEW";
          editImages = List<dynamic>.from(data["images"] ?? []);
          update();
        },
        onError: (error) => Fluttertoast.showToast(msg: error.toString()),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  // ── UPLOAD EDIT IMAGES ───────────────────────────────────────────────────
  Future<void> uploadEditImages(List<File> images) async {
    try {
      isUploadingImages = true;
      update();

      final token = await ApiService.getAuthToken();

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${ApiService.baseUrl}/uploads/images"),
      );

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      for (File image in images) {
        try {
          final mimeType = lookupMimeType(image.path);
          if (mimeType == null || !mimeType.startsWith("image/")) continue;
          final mimeSplit = mimeType.split("/");
          request.files.add(
            await http.MultipartFile.fromPath(
              "files",
              image.path,
              contentType: MediaType(mimeSplit[0], mimeSplit[1]),
            ),
          );
        } catch (e) {
          log("FILE ERROR => $e");
        }
      }

      if (request.files.isEmpty) {
        Fluttertoast.showToast(msg: "No valid images selected");
        return;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          for (var item in decoded) {
            if (item is String) {
              editImages.add({"url": item, "isNew": true});
            } else if (item is Map<String, dynamic>) {
              editImages.add({
                "id": item["id"],
                "url": item["url"] ?? "",
                "isPrimary": item["isPrimary"] ?? false,
                "sortOrder": item["sortOrder"] ?? 0,
                "isNew": true,
              });
            }
          }
        }
        update();
        Fluttertoast.showToast(msg: "Images uploaded successfully");
      } else {
        Fluttertoast.showToast(msg: "Upload failed (${response.statusCode})");
      }
    } catch (e) {
      log("UPLOAD ERROR => $e");
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isUploadingImages = false;
      update();
    }
  }

  // ── REMOVE IMAGE ─────────────────────────────────────────────────────────
  void removeImage(int index) {
    if (index >= 0 && index < editImages.length) {
      editImages.removeAt(index);
      update();
    }
  }

  // ── UPDATE LISTING ───────────────────────────────────────────────────────
  Future<void> updateListing(int id) async {
    // FIX #2505: Validate at least one image before saving
    final validImages = editImages
        .where((img) => (img["url"]?.toString() ?? "").trim().isNotEmpty)
        .toList();

    if (validImages.isEmpty) {
      // Show error snackbar — do NOT proceed
      Get.snackbar(
        'Image Required',
        'Please add at least one photo before saving.',
        backgroundColor: const Color(0xFFE8453C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        icon: const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.white,
        ),
      );
      return; // STOP — do not call API
    }

    // Validate other required fields
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Item name is required.',
        backgroundColor: const Color(0xFFE8453C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (priceController.text.trim().isEmpty ||
        int.tryParse(priceController.text.trim()) == null) {
      Get.snackbar(
        'Error',
        'Enter a valid price.',
        backgroundColor: const Color(0xFFE8453C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Description is required.',
        backgroundColor: const Color(0xFFE8453C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (zipcodeController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Zipcode is required.',
        backgroundColor: const Color(0xFFE8453C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (placeController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Place name is required.',
        backgroundColor: const Color(0xFFE8453C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isUpdating = true;
      update();

      // Build image payload — first image is primary
      final imagePayload = validImages
          .asMap()
          .entries
          .map(
            (e) => {
              "url": e.value["url"].toString(),
              "isPrimary": e.key == 0,
              "sortOrder": e.key,
            },
          )
          .toList();

      final body = {
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "price": int.tryParse(priceController.text.trim()) ?? 0,
        "category": selectedCategory,
        "condition": selectedCondition,
        "zipcode": zipcodeController.text.trim(),
        "placeName": placeController.text.trim(),
        "images": imagePayload,
      };

      log("UPDATE REQUEST => ${jsonEncode(body)}");

      await ApiService.request(
        endpoint: "/marketplace/listings/$id",
        method: Api.PATCH,
        body: body,
        onSuccess: (response) async {
          log("UPDATE RESPONSE => ${response.data}");
          Fluttertoast.showToast(msg: "Listing updated successfully");
          await fetchMyListings(isRefresh: true);
          Get.back();
        },
        onError: (error) {
          log("UPDATE ERROR => $error");
          Fluttertoast.showToast(msg: error.toString());
        },
      );
    } catch (e) {
      log("UPDATE EXCEPTION => $e");
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isUpdating = false;
      update();
    }
  }

  // ── DELETE LISTING ───────────────────────────────────────────────────────
  Future<void> deleteListing(int id) async {
    try {
      await ApiService.request(
        endpoint: "/marketplace/listings/$id",
        method: Api.DELETE,
        onSuccess: (response) {
          listings.removeWhere((e) => e["id"] == id);
          update();
          Fluttertoast.showToast(msg: "Listing deleted successfully");
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // ── CLEAR EDIT FIELDS ────────────────────────────────────────────────────
  void clearEditFields() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    zipcodeController.clear();
    placeController.clear();
    selectedCategory = "CRADLES";
    selectedCondition = "NEW";
    editImages.clear();
    update();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    zipcodeController.dispose();
    placeController.dispose();
    super.onClose();
  }
}
