import 'package:get/get.dart';
import 'package:mommilk_user/Models/SellerProfileModel.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class SellerProfileController extends GetxController {
  bool isLoading = false;
  String? errorMessage;
  SellerProfileModel? profile;

  Future<void> fetchProfile(int userId) async {
    try {
      isLoading = true;
      errorMessage = null;
      update();

      await ApiService.request(
        endpoint: "/users/$userId/profile",
        method: Api.GET,
        requiresAuth: true,
        onSuccess: (response) {
          try {
            final jsonData = response.data;
            final Map<String, dynamic>? data =
                (jsonData is Map<String, dynamic> &&
                    jsonData.containsKey("data"))
                ? jsonData["data"]
                : (jsonData is Map<String, dynamic> ? jsonData : null);

            if (data == null) {
              profile = null;
              errorMessage = "Profile not found".tr;
              return;
            }
            profile = SellerProfileModel.fromJson(data);
          } catch (e, st) {
            print("======= SELLER PROFILE PARSE ERROR: $e =======");
            print("$st");
            errorMessage = "Something went wrong".tr;
          }
        },
        onServerError: (status, message) {
          errorMessage = message;
        },
        onNetworkError: (message) {
          errorMessage = message;
        },
        onError: (error) {
          errorMessage = "Something went wrong".tr;
        },
      );
    } catch (e, st) {
      print("======= SELLER PROFILE FETCH ERROR: $e =======");
      print("$st");
      errorMessage = "Something went wrong".tr;
    } finally {
      isLoading = false;
      update();
    }
  }

  void clearProfile() {
    profile = null;
    errorMessage = null;
  }
}
