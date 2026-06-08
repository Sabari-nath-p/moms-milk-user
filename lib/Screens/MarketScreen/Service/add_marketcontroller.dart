import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mommilk_user/Screens/MarketScreen/Service/market_controller.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:mime/mime.dart';

class AddMarketplaceController extends GetxController {
  bool isLoading = false;
  bool isUploadingImage = false;

  final MarketController marketController = Get.find<MarketController>();

  // ── Core controllers ──────────────────────────────────────────────────────
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final zipcodeController = TextEditingController();
  final placeController = TextEditingController();

  // ── Extra detail controllers ───────────────────────────────────────────────
  final originalPriceController = TextEditingController();
  final brandController = TextEditingController();
  final dimensionsController = TextEditingController();

  // ── Extra detail values ────────────────────────────────────────────────────
  DateTime? purchasedOn;
  List<String> materials = [];
  List<String> colors = [];
  List<String> boxContains = [];

  // ── Filters ───────────────────────────────────────────────────────────────
  String selectedCategory = "CRADLES";
  String selectedCondition = "NEW";

  // ── Images ────────────────────────────────────────────────────────────────
  List<String> imageUrls = [];
  List<File> selectedImages = [];

  // ── Derived helpers ───────────────────────────────────────────────────────

  int? get discountPercent {
    final op = int.tryParse(originalPriceController.text.trim());
    final p = int.tryParse(priceController.text.trim());
    if (op == null || p == null || op <= p) return null;
    return (((op - p) / op) * 100).round();
  }

  int? get savings {
    final op = int.tryParse(originalPriceController.text.trim());
    final p = int.tryParse(priceController.text.trim());
    if (op == null || p == null || op <= p) return null;
    return op - p;
  }

  String? get usedDuration {
    if (purchasedOn == null) return null;
    final months = (DateTime.now().difference(purchasedOn!).inDays / 30)
        .round();
    if (months == 0) return 'less than a month';
    if (months < 12) return '$months month${months == 1 ? '' : 's'}';
    final years = (months / 12).round();
    return '$years year${years == 1 ? '' : 's'}';
  }

  // ── Tag helpers ───────────────────────────────────────────────────────────

  void addMaterial(String val) {
    if (val.isNotEmpty && !materials.contains(val)) {
      materials = [...materials, val];
      update();
    }
  }

  void removeMaterial(String val) {
    materials = materials.where((e) => e != val).toList();
    update();
  }

  void addColor(String val) {
    if (val.isNotEmpty && !colors.contains(val)) {
      colors = [...colors, val];
      update();
    }
  }

  void removeColor(String val) {
    colors = colors.where((e) => e != val).toList();
    update();
  }

  void addBoxItem(String val) {
    if (val.isNotEmpty && !boxContains.contains(val)) {
      boxContains = [...boxContains, val];
      update();
    }
  }

  void removeBoxItem(String val) {
    boxContains = boxContains.where((e) => e != val).toList();
    update();
  }

  void setPurchasedOn(DateTime? date) {
    purchasedOn = date;
    update();
  }

  // ── Images ────────────────────────────────────────────────────────────────

  void setSelectedImages(List<File> files) {
    selectedImages = files;
    update();
  }

  Future<void> uploadImages(List<File> images) async {
    try {
      isUploadingImage = true;
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

      for (final image in images) {
        final mimeType = lookupMimeType(image.path);
        if (mimeType == null || !mimeType.startsWith("image/")) {
          Fluttertoast.showToast(msg: "Invalid image skipped");
          continue;
        }
        final mimeSplit = mimeType.split("/");
        request.files.add(
          await http.MultipartFile.fromPath(
            "files",
            image.path,
            contentType: http.MediaType(mimeSplit[0], mimeSplit[1]),
          ),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      log("UPLOAD RESPONSE STATUS: ${response.statusCode}");
      log("UPLOAD RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List) {
          imageUrls = data.map<String>((e) => e["url"].toString()).toList();
          Fluttertoast.showToast(msg: "Images uploaded successfully");
        } else {
          Fluttertoast.showToast(msg: "Invalid upload response");
        }
      } else {
        Fluttertoast.showToast(msg: "Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      log("UPLOAD ERROR: $e");
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isUploadingImage = false;
      update();
    }
  }

  // ── Create listing ────────────────────────────────────────────────────────

  Future<void> createListing() async {
    log("===== CREATE LISTING CALLED =====");

    try {
      if (imageUrls.isEmpty) {
        Fluttertoast.showToast(msg: "Please upload images");
        return;
      }

      isLoading = true;
      update();

      // ── Build images array ────────────────────────────────────────────
      final imagesPayload = imageUrls
          .map(
            (url) => {
              "url": url,
              "isPrimary": url == imageUrls.first,
              "sortOrder": imageUrls.indexOf(url),
            },
          )
          .toList();

      // ── Parse price fields as integers ────────────────────────────────
      final priceInt = int.tryParse(priceController.text.trim()) ?? 0;
      final originPriceInt = int.tryParse(originalPriceController.text.trim());

      // ── FIX: zipcode must be an int, not a string ─────────────────────
      // The GET response returns  zipcode: 688004  (number)
      // Sending it as "688004" (string) causes a backend 500 error.
      final zipcodeInt = int.tryParse(zipcodeController.text.trim());

      // ── Build payload ─────────────────────────────────────────────────
      final body = <String, dynamic>{
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "price": priceInt,
        "category": selectedCategory,
        "condition": selectedCondition,

        // ✅ FIXED: send as int, fallback to 0 if not parseable
        "zipcode": zipcodeController.text.trim(),

        "placeName": placeController.text.trim(),

        // Optional fields — only included when non-null / non-empty
        if (originPriceInt != null) "originPrice": originPriceInt,

        if (purchasedOn != null)
          // ISO-8601 full datetime — avoids backend date-parse failures
          "purchasedOn": purchasedOn!.toUtc().toIso8601String(),

        if (brandController.text.trim().isNotEmpty)
          "brand": brandController.text.trim(),

        if (materials.isNotEmpty) "materials": materials,

        if (colors.isNotEmpty) "colors": colors,

        if (dimensionsController.text.trim().isNotEmpty)
          "dimensions": dimensionsController.text.trim(),

        if (boxContains.isNotEmpty) "boxContains": boxContains,

        "images": imagesPayload,
      };

      log("CREATE LISTING REQUEST BODY: ${jsonEncode(body)}");

      await ApiService.request(
        endpoint: "/marketplace/listings",
        method: Api.POST,
        body: body,
        onSuccess: (response) {
          log("CREATE LISTING SUCCESS: ${response.data}");
          marketController.fetchMarketplaceListings(isRefresh: true);
          Fluttertoast.showToast(
            msg: response.data["message"] ?? "Listing created successfully",
          );
          clearFields();
          Get.back(result: true);
        },
        onServerError: (code, msg) {
          // msg is now the parsed human-readable message from ApiService
          log("SERVER ERROR $code: $msg");
          Fluttertoast.showToast(msg: "Error: $msg");
        },
        onError: (error) {
          log("CREATE ERROR: $error");
          Fluttertoast.showToast(msg: error.toString());
        },
      );
    } catch (e) {
      log("CREATE LISTING EXCEPTION: $e");
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  // ── Clear ─────────────────────────────────────────────────────────────────

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    zipcodeController.clear();
    placeController.clear();
    originalPriceController.clear();
    brandController.clear();
    dimensionsController.clear();
    purchasedOn = null;
    materials = [];
    colors = [];
    boxContains = [];
    selectedCategory = "CRADLES";
    selectedCondition = "NEW";
    imageUrls.clear();
    selectedImages.clear();
    update();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    zipcodeController.dispose();
    placeController.dispose();
    originalPriceController.dispose();
    brandController.dispose();
    dimensionsController.dispose();
    super.onClose();
  }
}
