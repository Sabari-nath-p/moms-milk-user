import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mommilk_user/Utils/ApiService.dart';

import 'package:mime/mime.dart';



class AddMarketplaceController extends GetxController {
  bool isLoading = false;
  bool isUploadingImage = false;

  /// Text Controllers
  final titleController = TextEditingController();
  final descriptionController =
      TextEditingController();
  final priceController =
      TextEditingController();
  final zipcodeController =
      TextEditingController();
  final placeController =
      TextEditingController();

  /// Selected values
  String selectedCategory = "CRADLES";
  String selectedCondition = "NEW";

  /// Uploaded image URL
  String imageUrl = "";

  /// Selected image file
  File? selectedImage;

  /// Picked image setter
  void setSelectedImage(File file) {
    selectedImage = file;
    update();
  }
Future<void> uploadImage(File image) async {
  try {
    isUploadingImage = true;
    update();

    final token =
        await ApiService.getAuthToken();

    /// Detect mime type
    final mimeType =
        lookupMimeType(image.path);

    log("SELECTED FILE: ${image.path}");
    log("MIME TYPE: $mimeType");

    if (mimeType == null ||
        !mimeType.startsWith("image/")) {
      Fluttertoast.showToast(
        msg:
            "Please select a valid image",
      );
      return;
    }

    final mimeSplit =
        mimeType.split("/");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "${ApiService.baseUrl}/uploads/images",
      ),
    );

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    /// IMPORTANT: send as multipart image
    request.files.add(
      await http.MultipartFile.fromPath(
        "files", // backend key
        image.path,
        contentType: http.MediaType(
          mimeSplit[0],
          mimeSplit[1],
        ),
      ),
    );

    /// DEBUG REQUEST
    log(
      "========== IMAGE UPLOAD REQUEST ==========",
    );
    log("URL: ${request.url}");
    log("HEADERS: ${request.headers}");
    log("FILE: ${image.path}");
    log("CONTENT TYPE: $mimeType");
    log(
      "==========================================",
    );

    final streamedResponse =
        await request.send();

    final response =
        await http.Response.fromStream(
          streamedResponse,
        );

    /// DEBUG RESPONSE
    log(
      "========== IMAGE UPLOAD RESPONSE ==========",
    );
    log(
      "STATUS CODE: ${response.statusCode}",
    );
    log("BODY: ${response.body}");
    log(
      "===========================================",
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      final data =
          jsonDecode(response.body);

      if (data is List &&
          data.isNotEmpty) {
        imageUrl =
            data[0]["url"] ?? "";

        log(
          "UPLOADED IMAGE URL: $imageUrl",
        );

        Fluttertoast.showToast(
          msg:
              "Image uploaded successfully",
        );

        update();
      }
    } else {
      Fluttertoast.showToast(
        msg:
            "Failed to upload image",
      );
    }
  } catch (e, stackTrace) {
    log("UPLOAD ERROR: $e");
    log("STACKTRACE: $stackTrace");

    Fluttertoast.showToast(
      msg: e.toString(),
    );
  } finally {
    isUploadingImage = false;
    update();
  }
}

  /// Create marketplace listing
Future<void> createListing() async {
  try {
    if (imageUrl.isEmpty) {
      Fluttertoast.showToast(
        msg:
            "Please upload an image",
      );
      return;
    }

    isLoading = true;
    update();

    final body = {
      "title":
          titleController.text.trim(),
      "description":
          descriptionController.text
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
      "images": [
        {
          "url": imageUrl,
          "isPrimary": true,
          "sortOrder": 0,
        }
      ]
    };

    /// DEBUG REQUEST
    log(
      "========== CREATE MARKETPLACE REQUEST ==========",
    );
    log(
      "URL: ${ApiService.baseUrl}/marketplace/listings",
    );
    log("METHOD: POST");
    log("BODY: ${jsonEncode(body)}");
    log(
      "================================================",
    );

    await ApiService.request(
      endpoint:
          "/marketplace/listings",
      method: Api.POST,
      body: body,

      onSuccess: (response) {
        /// DEBUG RESPONSE
        log(
          "========== CREATE MARKETPLACE RESPONSE ==========",
        );
        log(
          "STATUS CODE: ${response.statusCode}",
        );
        log(
          "RESPONSE DATA: ${jsonEncode(response.data)}",
        );
        log(
          "=================================================",
        );

        Fluttertoast.showToast(
          msg:
              response.data["message"] ??
              "Marketplace item added successfully",
        );

        clearFields();

        Get.back(result: true);
      },

      onServerError: (
        statusCode,
        message,
      ) {
        log(
          "SERVER ERROR => STATUS: $statusCode",
        );
        log("MESSAGE: $message");

        Fluttertoast.showToast(
          msg:
              "Server error occurred",
        );
      },

      onError: (error) {
        log("CREATE ERROR => $error");

        Fluttertoast.showToast(
          msg:
              error.toString(),
        );
      },
    );
  } catch (e, stackTrace) {
    log("CREATE ERROR: $e");
    log("STACK TRACE: $stackTrace");

    Fluttertoast.showToast(
      msg: e.toString(),
    );
  } finally {
    isLoading = false;
    update();
  }
}

  /// Clear fields
  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    zipcodeController.clear();
    placeController.clear();

    selectedCategory =
        "CRADLES";
    selectedCondition = "NEW";

    imageUrl = "";
    selectedImage = null;

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