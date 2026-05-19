import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mommilk_user/Screens/MarketScreen/Service/market_controller.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:mime/mime.dart';

class AddMarketplaceController extends GetxController {
  bool isLoading = false;
  bool isUploadingImage = false;

  final MarketController marketController = Get.find<MarketController>();

  // Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final zipcodeController = TextEditingController();
  final placeController = TextEditingController();

  // Filters
  String selectedCategory = "CRADLES";
  String selectedCondition = "NEW";

  // MULTI IMAGES
  List<String> imageUrls = [];
  List<File> selectedImages = [];

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

      for (File image in images) {
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
            contentType: http.MediaType(
              mimeSplit[0],
              mimeSplit[1],
            ),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("UPLOAD RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data is List) {
          imageUrls = data.map<String>((e) => e["url"].toString()).toList();

          Fluttertoast.showToast(msg: "Images uploaded successfully");
        } else {
          Fluttertoast.showToast(msg: "Invalid upload response");
        }
      } else {
        Fluttertoast.showToast(msg: "Upload failed");
      }
    } catch (e) {
      log("UPLOAD ERROR: $e");
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isUploadingImage = false;
      update();
    }
  }

  Future<void> createListing() async {
    try {
      if (imageUrls.isEmpty) {
        Fluttertoast.showToast(msg: "Please upload images");
        return;
      }

      isLoading = true;
      update();

      final body = {
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "price": int.tryParse(priceController.text.trim()) ?? 0,
        "category": selectedCategory,
        "condition": selectedCondition,
        "zipcode": zipcodeController.text.trim(),
        "placeName": placeController.text.trim(),

        
        "images": imageUrls.map((url) {
          return {
            "url": url,
            "isPrimary": url == imageUrls.first,
            "sortOrder": imageUrls.indexOf(url),
          };
        }).toList(),
      };

      log("CREATE LISTING REQUEST: ${jsonEncode(body)}");

      await ApiService.request(
        endpoint: "/marketplace/listings",
        method: Api.POST,
        body: body,
        onSuccess: (response) {
          marketController.fetchMarketplaceListings(isRefresh: true);

          Fluttertoast.showToast(
            msg: response.data["message"] ?? "Listing created",
          );

          clearFields();
          Get.back(result: true);
        },
        onServerError: (code, msg) {
          Fluttertoast.showToast(msg: "Server error");
        },
        onError: (error) {
          Fluttertoast.showToast(msg: error.toString());
        },
      );
    } catch (e) {
      log("CREATE ERROR: $e");
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    zipcodeController.clear();
    placeController.clear();

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
    super.onClose();
  }
}