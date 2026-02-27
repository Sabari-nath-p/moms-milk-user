import 'dart:io';

import 'package:get/utils.dart';
import 'package:mommilk_user/Models/AppConfigModel.dart';

String getAppUpdateStatus({
  required int currentVersion,
  required AppConfig config,
  required int lastCheckVersion,
}) {
  final int? minimumVersion =
      Platform.isAndroid
          ? config.minumBuildNoAndroid
          : config.minumBuildNoVerIos;

  final int? latestVersion =
      Platform.isAndroid
          ? config.currentBuildNoAndroid
          : config.currentBuildNoIos;

  // Safety check
  if (minimumVersion == null || latestVersion == null) {
    return "updated".tr;
  }

  // 🚨 Force update
  if (currentVersion < minimumVersion) {
    return "force".tr;
  }

  // 🔄 Optional update available
  if (currentVersion < latestVersion) {
    if (lastCheckVersion >= latestVersion) {
      return "skip".tr;
    }
    return "update".tr;
  }

  // ✅ Already updated
  return "updated";
}
