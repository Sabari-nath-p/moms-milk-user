import 'package:get/get.dart';
import 'package:mommilk_user/Models/DiaperLogModel.dart';
import 'package:mommilk_user/Models/FeedingLogModel.dart';
import 'package:mommilk_user/Models/SleepLogModel.dart';
import 'package:mommilk_user/Utils/ApiService.dart';

class BabyLogsController extends GetxController {
  final int babyId;

  BabyLogsController({required this.babyId});

  List<FeedingLogModel> feedLogs = [];
  List<DiaperLogModel> diaperLogs = [];
  List<SleepLogModel> sleepLogs = [];

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchAllLogs();
  }

  void fetchAllLogs() {
    fetchFeedLogs();
    fetchDiaperLogs();
    fetchSleepLogs();
  }

  Future<void> fetchFeedLogs() async {
    isLoading = true;
    update();

    await ApiService.request(
      endpoint: "/feed-logs/baby/$babyId",
      method: Api.GET,
      onSuccess: (response) {
        if (response.statusCode == 200 && response.data is List) {
          feedLogs = (response.data as List)
              .map((json) => FeedingLogModel.fromJson(json))
              .toList();
        } else {
          feedLogs.clear();
        }
      },
      onError: (error) {
        Get.snackbar("Error", "Failed to fetch feed logs: $error");
        feedLogs.clear();
      },
    );

    isLoading = false;
    update();
  }

  Future<void> fetchDiaperLogs() async {
    isLoading = true;
    update();

    await ApiService.request(
      endpoint: "/diaper-logs/baby/$babyId",
      method: Api.GET,
      onSuccess: (response) {
        if (response.statusCode == 200 && response.data is List) {
          diaperLogs = (response.data as List)
              .map((json) => DiaperLogModel.fromJson(json))
              .toList();
        } else {
          diaperLogs.clear();
        }
      },
      onError: (error) {
        Get.snackbar("Error", "Failed to fetch diaper logs: $error");
        diaperLogs.clear();
      },
    );

    isLoading = false;
    update();
  }

  Future<void> fetchSleepLogs() async {
    isLoading = true;
    update();

    await ApiService.request(
      endpoint: "/sleep-logs/baby/$babyId",
      method: Api.GET,
      onSuccess: (response) {
        if (response.statusCode == 200 && response.data is List) {
          sleepLogs = (response.data as List)
              .map((json) => SleepLogModel.fromJson(json))
              .toList();
        } else {
          sleepLogs.clear();
        }
      },
      onError: (error) {
        Get.snackbar("Error", "Failed to fetch sleep logs: $error");
        sleepLogs.clear();
      },
    );

    isLoading = false;
    update();
  }
}
