class AppConfig {
  int? minumBuildNoAndroid;
  int? minumBuildNoVerIos;
  int? currentBuildNoAndroid;
  int? currentBuildNoIos;

  AppConfig({
    this.minumBuildNoAndroid,
    this.minumBuildNoVerIos,
    this.currentBuildNoAndroid,
    this.currentBuildNoIos,
  });

  AppConfig.fromJson(Map<String, dynamic> json) {
    minumBuildNoAndroid = json['minum_build_no_android'];
    minumBuildNoVerIos = json['minum_build_no_ver_ios'];
    currentBuildNoAndroid = json['current_build_no_android'];
    currentBuildNoIos = json['current_build_no_ios'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minum_build_no_android'] = this.minumBuildNoAndroid;
    data['minum_build_no_ver_ios'] = this.minumBuildNoVerIos;
    data['current_build_no_android'] = this.currentBuildNoAndroid;
    data['current_build_no_ios'] = this.currentBuildNoIos;
    return data;
  }
}
