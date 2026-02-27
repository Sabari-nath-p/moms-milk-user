import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  UserType userType = UserType.buyer;

  BloodGroup? seletecBloodGroup;
  List<DonorQuality> selectedQualities = [];
  bool isWillingToShareMedicalReport = false;
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
        'instagramLink': instagramLinkController.text.trim(),
        'facebookLink': facebookLinkController.text.trim(),
        'bloodGroup': '', //getBloodGroupText(seletecBloodGroup!!),
        if (userType == UserType.donor)
          'babyDeliveryDate': babyDeliveryDate!.toUtc().toString(),
        if (userType == UserType.donor)
          'ableToShareMedicalRecord': isWillingToShareMedicalReport,
        if (userType == UserType.donor)
          "healthStyle": selectedQualities
              .map((e) => getDonorQualityText(e))
              .toList()
              .join(","),
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
        Get.snackbar("Invalid Operation", error.toString());
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
    // Clear previous errors
    nameError.value = '';
    phoneError.value = '';
    zipError.value = '';

    bool isValid = true;

    // Name validation
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Please enter your full name';
      isValid = false;
    } else if (nameController.text.trim().length < 2) {
      nameError.value = 'Name must be at least 2 characters long';
      isValid = false;
    }

    // Phone validation
    // Phone validation
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Please enter your phone number'.tr;
      isValid = false;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(phoneController.text.trim())) {
      phoneError.value = 'Phone number should contain only digits';
      isValid = false;
    } else if (phoneController.text.trim().length < 10) {
      phoneError.value = 'Phone number must be at least 10 digits long';
      isValid = false;
    } else if (phoneController.text.trim().length > 10) {
      phoneError.value = 'Phone number cannot exceed 10 digits';
      isValid = false;
    }

    // Zip code validation
    if (zipCodeController.text.trim().isEmpty) {
      zipError.value = 'Please enter your zip code';
      isValid = false;
    } else if (!RegExp(
      r'^[0-9A-Za-z\s-]+$',
    ).hasMatch(zipCodeController.text.trim())) {
      zipError.value = 'Please enter a valid zip code';
      isValid = false;
    } else if (zipCodeController.text.trim().length < 3) {
      zipError.value = 'Zip code must be at least 3 characters long';
      isValid = false;
    }

    // Country code validation
    if (selectedCountryCode.isEmpty) {
      Get.snackbar('Validation Error', 'Please select a country code');
      isValid = false;
    }

    return isValid;
  }

  bool validateDonorDetails() {
    if (babyDeliveryDate == null) {
      Get.snackbar('Validation Error', 'Please select your delivery date');
      return false;
    }

    if (seletecBloodGroup == null) {
      Get.snackbar('Validation Error', 'Please select your blood group');
      return false;
    }

    // Validate donor qualities (at least one should be selected)
    // if (selectedQualities.isEmpty) {
    //   Get.snackbar(
    //     'Validation Error',
    //     'Please select at least one donor quality',
    //   );
    //   return false;
    // }

    // All donor validations passed
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
