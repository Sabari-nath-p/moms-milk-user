import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:mommilk_user/Models/UserModel.dart';
import 'package:mommilk_user/Screens/AuthenticationScreen/Controller/AuthController.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/Controller/BabyCreateController.dart';
import 'package:mommilk_user/Screens/CreateBabyScreen/CreateBabyScreen.dart';
import 'package:mommilk_user/Screens/HomeScreen/HomeScreen.dart';
import 'package:mommilk_user/Utils/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserType { donor, buyer }

enum Gender { BOY, GIRL }

enum BloodGroup {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  oPositive,
  oNegative,
  abPositive,
  abNegative,
}

enum DonorQuality {
  organic,
  vegetarian,
  medicationFree,
  smokeFree,
  alcoholFree,
}

class Onboardingcontroller extends GetxController {
  Onboardingcontroller(String email) {
    emailController.text = email;

    print(email);
    update();
  }
  int currentStep = 0;
  int totalStep = 4;
  bool isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final zipCodeController = TextEditingController();
  final facebookLinkController = TextEditingController();
  final instagramLinkController = TextEditingController();
  DateTime? babyDeliveryDate = null;
  String selectedCountryCode = "";
  String selectedLanguage = "English";
  UserType userType = UserType.buyer;

  BloodGroup? seletecBloodGroup;
  List<DonorQuality> selectedQualities = [];
  bool isWillingToShareMedicalReport = false;
  File? profileImageFile;
  String profilePhotoUrl = '';
  bool isUploadingPhoto = false;
  // Whether a donor is currently available to donate — defaults to true,
  // matching the API's expected default for a freshly-onboarded donor.
  bool isAvailableForDonation = true;
  RxString nameError = ''.obs;
  RxString phoneError = ''.obs;
  RxString zipError = ''.obs;

  void previousStep() {
    if (currentStep > 0) {
      currentStep = currentStep - 1;
      update();
    }
  }

  void nextStep() {
    if (currentStep < 3) {
      if (currentStep == 0) {
        if (validateUserDetails()) {
          currentStep = currentStep + 1;
          update();
        }
      } else if (currentStep == 1) {
        if (userType == UserType.donor) {
          currentStep = currentStep + 1;
        } else {
          createUser();
        }
        update();
      } else if (currentStep == 2) {
        if (validateDonorDetails()) {
          createUser();
        }
      }
    }
  }

  addBaby() {}

  // Picks happen before the account exists, so there's no AUTHKEY yet —
  // unlike AddMarketplaceController's uploadImages, the Authorization header
  // is only attached when a token happens to be present.
  Future<void> uploadProfilePhoto(File image) async {
    try {
      isUploadingPhoto = true;
      profileImageFile = image;
      update();

      final mimeType = lookupMimeType(image.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        Fluttertoast.showToast(msg: 'Invalid image skipped'.tr);
        return;
      }

      final token = await ApiService.getAuthToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiService.baseUrl}/uploads/images'),
      );
      request.headers['Accept'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final parts = mimeType.split('/');
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          image.path,
          contentType: http.MediaType(parts[0], parts[1]),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          profilePhotoUrl = data.first['url'].toString();
        } else {
          Fluttertoast.showToast(msg: 'Invalid upload response'.tr);
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Photo upload failed (${response.statusCode})'.tr,
        );
      }
    } catch (e, stackTrace) {
      log('PROFILE PHOTO UPLOAD ERROR: $e');
      log('$stackTrace');
      Fluttertoast.showToast(msg: 'Upload error: $e');
    } finally {
      isUploadingPhoto = false;
      update();
    }
  }

  void toggleDonorQuality(DonorQuality quality) {
    if (selectedQualities.contains(quality)) {
      selectedQualities.remove(quality);
    } else {
      selectedQualities.add(quality);
    }
  }

  final List<Map<String, String>> countryCodes = [
    {"code": "+1", "country": "United States"},
    {"code": "+7", "country": "Russian Federation"},
    {"code": "+20", "country": "Egypt"},
    {"code": "+27", "country": "South Africa"},
    {"code": "+30", "country": "Greece"},
    {"code": "+31", "country": "Netherlands"},
    {"code": "+32", "country": "Belgium"},
    {"code": "+33", "country": "France"},
    {"code": "+34", "country": "Spain"},
    {"code": "+36", "country": "Hungary"},
    {"code": "+39", "country": "Italy"},
    {"code": "+40", "country": "Romania"},
    {"code": "+41", "country": "Switzerland"},
    {"code": "+43", "country": "Austria"},
    {"code": "+44", "country": "United Kingdom"},
    {"code": "+45", "country": "Denmark"},
    {"code": "+46", "country": "Sweden"},
    {"code": "+47", "country": "Norway"},
    {"code": "+48", "country": "Poland"},
    {"code": "+49", "country": "Germany"},
    {"code": "+51", "country": "Peru"},
    {"code": "+52", "country": "Mexico"},
    {"code": "+55", "country": "Brazil"},
    {"code": "+60", "country": "Malaysia"},
    {"code": "+61", "country": "Australia"},
    {"code": "+62", "country": "Indonesia"},
    {"code": "+63", "country": "Philippines"},
    {"code": "+64", "country": "New Zealand"},
    {"code": "+65", "country": "Singapore"},
    {"code": "+66", "country": "Thailand"},
    {"code": "+81", "country": "Japan"},
    {"code": "+82", "country": "Korea, Republic of"},
    {"code": "+84", "country": "Vietnam"},
    {"code": "+86", "country": "China"},
    {"code": "+90", "country": "Turkey"},
    {"code": "+91", "country": "India"},
    {"code": "+92", "country": "Pakistan"},
    {"code": "+94", "country": "Sri Lanka"},
    {"code": "+98", "country": "Iran"},
    {"code": "+211", "country": "South Sudan"},
    {"code": "+212", "country": "Morocco"},
    {"code": "+213", "country": "Algeria"},
    {"code": "+216", "country": "Tunisia"},
    {"code": "+218", "country": "Libya"},
    {"code": "+254", "country": "Kenya"},
    {"code": "+255", "country": "Tanzania"},
    {"code": "+256", "country": "Uganda"},
    {"code": "+260", "country": "Zambia"},
    {"code": "+263", "country": "Zimbabwe"},
    {"code": "+265", "country": "Malawi"},
    {"code": "+266", "country": "Lesotho"},
    {"code": "+267", "country": "Botswana"},
    {"code": "+268", "country": "Eswatini"},
    {"code": "+269", "country": "Comoros"},
  ];

  void createUser() async {
    isLoading = true;
    update();

    print(emailController.text);
    await ApiService.request(
      endpoint: "/auth/complete-profile",
      requiresAuth: false,
      body: {
        'name': nameController.text,
        'email': emailController.text,
        'phone': selectedCountryCode + phoneController.text,
        'zipcode': zipCodeController.text,
        'userType': userType.name.toUpperCase(),
        'description': '',
        'language': selectedLanguage,
        'instagramLink': instagramLinkController.text.trim(),
        'facebookLink': facebookLinkController.text.trim(),
        // FIX: was always sent as '', ignoring the donor's actual selection.
        'bloodGroup': seletecBloodGroup != null
            ? getBloodGroupText(seletecBloodGroup!)
            : '',
        if (userType == UserType.donor)
          'babyDeliveryDate': babyDeliveryDate!.toUtc().toString(),
        if (userType == UserType.donor)
          'ableToShareMedicalRecord': isWillingToShareMedicalReport,
        if (userType == UserType.donor)
          // Sent as a JSON-encoded string (e.g. '["organic","vegetarian"]'),
          // matching the API spec's healthStyle format.
          "healthStyle": jsonEncode(
            selectedQualities.map((e) => getDonorQualityKey(e)).toList(),
          ),
        if (userType == UserType.donor)
          'availableForDonation': isAvailableForDonation,
        // Same lifestyle keys as healthStyle above, as a real array — no
        // separate source of "tags" exists in onboarding, so this reuses
        // the donor's selected qualities. Buyers have none of this data,
        // so they get an empty list rather than a fabricated one.
        'tags': userType == UserType.donor
            ? selectedQualities.map((e) => getDonorQualityKey(e)).toList()
            : <String>[],
        // General account-active flag — always true for a freshly
        // completed profile (both BUYER and DONOR).
        'isAvailable': true,
       // 'profilePhoto': profilePhotoUrl,
      },
      onSuccess: (body) async {
        if (body.statusCode == 201) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("AUTHKEY", body.data["accessToken"]);
          pref.setString("USERKEY", jsonEncode(body.data["user"]));
          user = UserModel.fromJson(body.data["user"]);
          setFcm();

          Get.offAll(                                     
            () => CreateBabyScreen(),
            transition: Transition.rightToLeft,
          );
        } else {
          print(body.data);
        }
      },
      onError: (error) {
        Fluttertoast.showToast(msg: error.toString().tr);
      },
    );
    isLoading = false;
    update();
  }

  setFcm() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        ApiService.request(
          endpoint: "/auth/fcm-token",
          method: Api.PATCH,
          body: {"fcmToken": token},
        );
      }
    } catch (e) {}
  }

  bool validateUserDetails() {
    nameError.value = '';
    phoneError.value = '';
    zipError.value = '';

    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Please enter your full name'.tr;
      isValid = false;
    } else if (nameController.text.trim().length < 2) {
      nameError.value = 'Name must be at least 2 characters long'.tr;
      isValid = false;
    }

    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Please enter your phone number'.tr;
      isValid = false;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(phoneController.text.trim())) {
      phoneError.value = 'Phone number should contain only digits'.tr;
      isValid = false;
    } else if (phoneController.text.trim().length < 10) {
      phoneError.value = 'Phone number must be at least 10 digits long'.tr;
      isValid = false;
    } else if (phoneController.text.trim().length > 10) {
      phoneError.value = 'Phone number cannot exceed 10 digits'.tr;
      isValid = false;
    }

    if (zipCodeController.text.trim().isEmpty) {
      zipError.value = 'Please enter your zip code'.tr;
      isValid = false;
    } else if (!RegExp(
      r'^[0-9A-Za-z\s-]+$',
    ).hasMatch(zipCodeController.text.trim())) {
      zipError.value = 'Please enter a valid zip code'.tr;
      isValid = false;
    } else if (zipCodeController.text.trim().length < 3) {
      zipError.value = 'Zip code must be at least 3 characters long'.tr;
      isValid = false;
    }

    if (selectedCountryCode.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select a country code'.tr);
      isValid = false;
    }

    return isValid;
  }

  bool validateDonorDetails() {
    if (babyDeliveryDate == null) {
      Fluttertoast.showToast(msg: 'Please select your delivery date'.tr);
      return false;
    }

    if (seletecBloodGroup == null) {
      Fluttertoast.showToast(msg: 'Please select your blood group'.tr);
      return false;
    }

    return true;
  }
}

String getBloodGroupText(BloodGroup bloodGroup) {
  switch (bloodGroup) {
    case BloodGroup.aPositive:
      return 'A+';
    case BloodGroup.aNegative:
      return 'A-';
    case BloodGroup.bPositive:
      return 'B+';
    case BloodGroup.bNegative:
      return 'B-';
    case BloodGroup.oPositive:
      return 'O+';
    case BloodGroup.oNegative:
      return 'O-';
    case BloodGroup.abPositive:
      return 'AB+';
    case BloodGroup.abNegative:
      return 'AB-';
  }
}

/// Raw snake_case key for a donor quality — used for healthStyle/tags in the
/// complete-profile payload, as opposed to getDonorQualityText's display label.
String getDonorQualityKey(DonorQuality quality) {
  switch (quality) {
    case DonorQuality.organic:
      return 'organic';
    case DonorQuality.vegetarian:
      return 'vegetarian';
    case DonorQuality.medicationFree:
      return 'medication_free';
    case DonorQuality.smokeFree:
      return 'smoke_free';
    case DonorQuality.alcoholFree:
      return 'alcohol_free';
  }
}

String getDonorQualityText(DonorQuality quality) {
  switch (quality) {
    case DonorQuality.organic:
      return 'Organic Diet'.tr;
    case DonorQuality.vegetarian:
      return 'Vegetarian'.tr;
    case DonorQuality.medicationFree:
      return 'Medication Free'.tr;
    case DonorQuality.smokeFree:
      return 'Smoke Free'.tr;
    case DonorQuality.alcoholFree:
      return 'Alcohol Free'.tr;
  }
}
