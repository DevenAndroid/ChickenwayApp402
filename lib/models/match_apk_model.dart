class MatchApkModel {
  bool? matchApk;
  bool? status;
  String? message;

  MatchApkModel({this.matchApk, this.status, this.message});

  MatchApkModel.fromJson(Map<String, dynamic> json) {
    matchApk = json['match_apk'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['match_apk'] = this.matchApk;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
